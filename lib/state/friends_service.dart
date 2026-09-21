import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Real cross-device friends: an 8-digit code to find each other by, mutual
/// friend lists, and live progress/online status — backed by Firebase
/// (Anonymous Auth for device identity + Firestore for the social graph).
/// Mirrors `State/FriendsService.swift` exactly, using the same
/// `players`/`friendCodes` Firestore collections so an iOS and an Android
/// player can already add each other by code with no server-side change.
///
/// `Firebase.initializeApp` already runs unconditionally in `main()` (it
/// backs Crashlytics/Analytics regardless of this feature), so — unlike the
/// Swift original, which gates everything on `GoogleService-Info.plist`
/// being present — [isConfigured] is always `true` here; kept only so
/// [FriendsView] can mirror the Swift "not set up yet" branch verbatim if a
/// build is ever shipped without Firebase configured.
class FriendsService extends ChangeNotifier {
  static const int _friendCodeDigits = 8;
  static const Duration _heartbeatInterval = Duration(seconds: 60);

  /// How recently `lastActiveAt` must have been touched (by the heartbeat)
  /// for a friend to still read as online.
  static const Duration onlineWindow = Duration(seconds: 120);

  /// Reward for entering a friend's code, granted once ever per redeeming
  /// account (their first successful friend-add) — see `addFriend`'s doc
  /// comment for why this side of the reward is one-time while the
  /// referrer's isn't.
  static const int referralRewardGold = 500;
  static const int referralRewardGems = 25;

  final bool isConfigured = true;
  bool isReady = false;
  String? myFriendCode;
  List<Friend> friends = [];
  String? lastError;
  bool isAddingFriend = false;

  /// Set right after a successful `addFriend` that granted *this* account
  /// its one-time referral bonus — the caller (`FriendsView`) reads it once
  /// to show a "bonus!" message alongside the new friend, then it's
  /// implicit history (no need to clear it back to false).
  bool lastAddGrantedReferralReward = false;

  /// Non-null once this launch's profile load found a reward earned while
  /// this account was the *referrer* on another device/session (someone
  /// entered this player's code while this player wasn't there to be
  /// credited immediately). The caller (`RootView`) grants the currency via
  /// `GameState.grantCurrency` and must call [consumeClaimedReferralReward]
  /// right after so it isn't granted twice.
  int? claimedReferralRewardGold;
  int? claimedReferralRewardGems;

  FirebaseFirestore? _db;
  String? _uid;
  int _lastKnownPlayerLevel = 1;
  int _lastKnownStage = 1;
  Timer? _heartbeatTimer;
  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _myProfileSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _friendsSub;
  List<String> _lastKnownFriendIDs = [];

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    _authSub?.cancel();
    _myProfileSub?.cancel();
    _friendsSub?.cancel();
    super.dispose();
  }

  /// Signs in anonymously (silent, no credentials, no personal data),
  /// ensures a Firestore profile with a stable friend code exists, then
  /// starts the presence heartbeat and live friends listener. Safe to call
  /// repeatedly — a no-op once already ready.
  ///
  /// Also starts watching `FirebaseAuth`'s auth state for the rest of this
  /// launch: if the player later links their anonymous session to a Google
  /// account from Settings (`GoogleSignInService._linkFirebaseAuth`) and
  /// that swaps in a *different* pre-existing `uid` (the
  /// `credential-already-in-use` fallback), everything cached here —
  /// friend code, friend list, listeners — is stale until it's rebuilt
  /// against the new `uid`, which this watch handles automatically.
  Future<void> start({required int playerLevel, required int currentStage}) async {
    if (!isConfigured) return;
    _lastKnownPlayerLevel = playerLevel;
    _lastKnownStage = currentStage;
    if (isReady) return;
    try {
      _db = FirebaseFirestore.instance;
      _authSub ??= FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
      final credential = await FirebaseAuth.instance.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        lastError = 'Anmeldung fehlgeschlagen.';
        notifyListeners();
        return;
      }
      await _bootstrap(user.uid);
    } catch (e) {
      lastError = '$e';
      notifyListeners();
    }
  }

  /// Fires whenever `FirebaseAuth`'s current user changes. The very first
  /// event after `signInAnonymously()` above just reports the uid `start()`
  /// already knows about — a no-op. A later event with a *different* uid
  /// means the account got linked/swapped underneath this service, so it
  /// re-bootstraps against the new identity.
  void _onAuthStateChanged(User? user) {
    if (user == null || user.uid == _uid) return;
    _bootstrap(user.uid);
  }

  Future<void> _bootstrap(String uid) async {
    _heartbeatTimer?.cancel();
    _myProfileSub?.cancel();
    _friendsSub?.cancel();
    _uid = uid;
    myFriendCode = null;
    friends = [];
    _lastKnownFriendIDs = [];
    isReady = false;
    notifyListeners();
    await _ensureProfile(playerLevel: _lastKnownPlayerLevel, currentStage: _lastKnownStage);
    isReady = true;
    _listenToOwnProfile();
    _startHeartbeat();
    notifyListeners();
  }

  /// Called whenever the player's level or campaign stage changes so
  /// friends see current progress, not just what it was at last launch.
  void updateMyProgress({required int playerLevel, required int currentStage}) {
    _lastKnownPlayerLevel = playerLevel;
    _lastKnownStage = currentStage;
    final db = _db;
    final uid = _uid;
    if (!isReady || db == null || uid == null) return;
    db.collection('players').doc(uid).update({
      'playerLevel': playerLevel,
      'currentStage': currentStage,
    });
  }

  /// Looks the code up, then adds each player to the other's friend list in
  /// one atomic batch — mutual by construction, no accept step.
  ///
  /// Referral reward: the *redeemer* (this account, entering someone else's
  /// code) gets a one-time bonus, the first time they ever successfully add
  /// a friend this way — tracked via `referralRewardClaimed` on their own
  /// profile, so creating throwaway accounts to re-enter codes can't farm
  /// repeat bonuses. The *referrer* (whoever's code got entered) gets a
  /// bonus every time, since each is a genuinely new friend they brought
  /// in — but they're very likely not running the app right now, so it
  /// can't be granted locally like the redeemer's; instead it's queued as
  /// `pendingReferralRewardCount` on their profile and paid out next time
  /// their own `start()` runs (see `_ensureProfile`).
  Future<bool> addFriend(String code) async {
    final db = _db;
    final uid = _uid;
    lastAddGrantedReferralReward = false;
    if (!isReady || db == null || uid == null) return false;
    final trimmed = code.trim();
    if (trimmed.length != _friendCodeDigits || !RegExp(r'^\d+$').hasMatch(trimmed)) {
      lastError = 'Freundescode muss aus 8 Ziffern bestehen.';
      notifyListeners();
      return false;
    }
    isAddingFriend = true;
    lastError = null;
    notifyListeners();
    try {
      final codeDoc = await db.collection('friendCodes').doc(trimmed).get();
      final friendID = codeDoc.data()?['playerID'] as String?;
      if (friendID == null) {
        lastError = 'Kein Spieler mit diesem Code gefunden.';
        return false;
      }
      if (friendID == uid) {
        lastError = 'Das ist dein eigener Code.';
        return false;
      }
      if (_lastKnownFriendIDs.contains(friendID)) {
        lastError = 'Ist schon dein Freund.';
        return false;
      }
      final myRef = db.collection('players').doc(uid);
      final mySnapshot = await myRef.get();
      final alreadyClaimedReferral = mySnapshot.data()?['referralRewardClaimed'] as bool? ?? false;
      final grantsReferralReward = !alreadyClaimedReferral;

      final batch = db.batch();
      batch.update(myRef, {
        'friendIDs': FieldValue.arrayUnion([friendID]),
        if (grantsReferralReward) 'referralRewardClaimed': true,
      });
      batch.update(db.collection('players').doc(friendID), {
        'friendIDs': FieldValue.arrayUnion([uid]),
        'pendingReferralRewardCount': FieldValue.increment(1),
      });
      await batch.commit();
      lastAddGrantedReferralReward = grantsReferralReward;
      return true;
    } catch (e) {
      lastError = '$e';
      return false;
    } finally {
      isAddingFriend = false;
      notifyListeners();
    }
  }

  /// The caller must grant `claimedReferralRewardGold`/`Gems` via
  /// `GameState.grantCurrency` before calling this — this only clears the
  /// pending flags so they aren't granted again on the next rebuild.
  void consumeClaimedReferralReward() {
    claimedReferralRewardGold = null;
    claimedReferralRewardGems = null;
  }

  Future<void> _ensureProfile({required int playerLevel, required int currentStage}) async {
    final db = _db;
    final uid = _uid;
    if (db == null || uid == null) return;
    final ref = db.collection('players').doc(uid);
    try {
      final snapshot = await ref.get();
      final existingCode = snapshot.data()?['friendCode'] as String?;
      if (snapshot.exists && existingCode != null) {
        myFriendCode = existingCode;
        await ref.update({
          'playerLevel': playerLevel,
          'currentStage': currentStage,
          'lastActiveAt': FieldValue.serverTimestamp(),
        });
        final pendingCount = snapshot.data()?['pendingReferralRewardCount'] as int? ?? 0;
        if (pendingCount > 0) {
          await ref.update({'pendingReferralRewardCount': 0});
          claimedReferralRewardGold = referralRewardGold * pendingCount;
          claimedReferralRewardGems = referralRewardGems * pendingCount;
        }
      } else {
        final code = await _generateUniqueFriendCode();
        await ref.set({
          'friendCode': code,
          'playerLevel': playerLevel,
          'currentStage': currentStage,
          'friendIDs': <String>[],
          'lastActiveAt': FieldValue.serverTimestamp(),
        });
        await db.collection('friendCodes').doc(code).set({'playerID': uid});
        myFriendCode = code;
      }
    } catch (e) {
      lastError = '$e';
    }
  }

  Future<String> _generateUniqueFriendCode() async {
    final db = _db;
    if (db == null) throw StateError('FriendsService not configured');
    final random = Random.secure();
    final upperBound = pow(10, _friendCodeDigits).toInt();
    for (var i = 0; i < 10; i++) {
      final code = random.nextInt(upperBound).toString().padLeft(_friendCodeDigits, '0');
      final doc = await db.collection('friendCodes').doc(code).get();
      if (!doc.exists) return code;
    }
    throw StateError('Could not generate a unique friend code');
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _sendHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) => _sendHeartbeat());
  }

  Future<void> _sendHeartbeat() async {
    final db = _db;
    final uid = _uid;
    if (db == null || uid == null) return;
    try {
      await db.collection('players').doc(uid).update({
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Non-fatal — a missed heartbeat just leaves this player reading as
      // offline to friends a little sooner than usual.
    }
  }

  void _listenToOwnProfile() {
    final db = _db;
    final uid = _uid;
    if (db == null || uid == null) return;
    _myProfileSub?.cancel();
    _myProfileSub = db.collection('players').doc(uid).snapshots().listen((snapshot) {
      final data = snapshot.data();
      if (data == null) return;
      final ids = (data['friendIDs'] as List<dynamic>?)?.cast<String>() ?? const [];
      if (!listEquals(ids, _lastKnownFriendIDs)) {
        _lastKnownFriendIDs = ids;
        _listenToFriends(ids);
      }
    });
  }

  void _listenToFriends(List<String> ids) {
    _friendsSub?.cancel();
    final db = _db;
    if (db == null || ids.isEmpty) {
      friends = [];
      notifyListeners();
      return;
    }
    // Firestore `whereIn` queries cap at 30 values — a mobile gacha game's
    // friend list realistically never gets close, but chunk defensively.
    final chunk = ids.take(30).toList();
    _friendsSub = db
        .collection('players')
        .where(FieldPath.documentId, whereIn: chunk)
        .snapshots()
        .listen((snapshot) {
      final loaded = snapshot.docs.map((doc) {
        final data = doc.data();
        final lastActive = (data['lastActiveAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
        return Friend(
          id: doc.id,
          friendCode: data['friendCode'] as String? ?? '--------',
          playerLevel: data['playerLevel'] as int? ?? 1,
          currentStage: data['currentStage'] as int? ?? 1,
          lastActiveAt: lastActive,
        );
      }).toList()
        ..sort((a, b) => b.playerLevel.compareTo(a.playerLevel));
      friends = loaded;
      notifyListeners();
    });
  }
}

class Friend {
  final String id;
  final String friendCode;
  final int playerLevel;
  final int currentStage;
  final DateTime lastActiveAt;

  Friend({
    required this.id,
    required this.friendCode,
    required this.playerLevel,
    required this.currentStage,
    required this.lastActiveAt,
  });

  /// Re-evaluated against [DateTime.now] on every access — callers that
  /// want this to visibly tick over time (e.g. a friend going idle) should
  /// re-read it from a periodically-refreshing widget rather than caching
  /// the value.
  bool get isOnline => DateTime.now().difference(lastActiveAt) < FriendsService.onlineWindow;
}
