import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// The cross-player side of the World Boss event: every player fights the
/// boss alone (see `WorldBossSystem`'s doc comment), and this is what ties
/// those solo fights into one weekly leaderboard — a Firestore doc per
/// player per week, holding just their running total damage. Mirrors
/// `friends_service.dart`'s shape (Anonymous Auth for device identity,
/// `isConfigured` always `true` since `Firebase.initializeApp()` already
/// runs unconditionally in `main()`) and `State/WorldBossLeaderboardService.swift`
/// exactly, including being safe to call `start()` a second time
/// independently — both services resolve to the same device-cached Firebase
/// uid.
class WorldBossLeaderboardService extends ChangeNotifier {
  final bool isConfigured = true;
  bool isReady = false;
  List<WorldBossEntry> top = [];

  /// This player's own standing for the currently-listened week — `null`
  /// until the first successful fetch, or if they haven't dealt any damage
  /// yet this week.
  int? myRank;
  int myDamage = 0;
  String? lastError;

  FirebaseFirestore? _db;
  String? _uid;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _topSub;

  /// The week this instance is currently listening/submitting for — guards
  /// against a stale listener callback (from a just-replaced week) writing
  /// into `top`/`myRank` after `listen(weekID:)` has already moved on.
  String? _listenedWeekID;

  @override
  void dispose() {
    _topSub?.cancel();
    super.dispose();
  }

  /// Signs in anonymously (idempotent — safe alongside `FriendsService`'s
  /// own sign-in, both resolve to the same cached uid) so writes/reads
  /// below can run. Safe to call repeatedly.
  Future<void> start() async {
    if (!isConfigured || isReady) return;
    try {
      _db = FirebaseFirestore.instance;
      final credential = await FirebaseAuth.instance.signInAnonymously();
      final user = credential.user;
      if (user == null) {
        lastError = 'Anmeldung fehlgeschlagen.';
        notifyListeners();
        return;
      }
      _uid = user.uid;
      isReady = true;
      notifyListeners();
    } catch (e) {
      lastError = '$e';
      notifyListeners();
    }
  }

  /// Writes this player's running total for `weekID`, then refreshes
  /// `myRank` — called once per attack from the World Boss battle flow
  /// right after `GameState.applyWorldBossBattleResult`.
  Future<void> submitDamage({
    required String weekID,
    required int totalDamage,
    required int playerLevel,
  }) async {
    final db = _db;
    final uid = _uid;
    if (!isReady || db == null || uid == null) return;
    myDamage = totalDamage;
    notifyListeners();
    try {
      await db
          .collection('worldBossLeaderboard')
          .doc(weekID)
          .collection('entries')
          .doc(uid)
          .set({
        'damage': totalDamage,
        'playerLevel': playerLevel,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _refreshMyRank(weekID: weekID, totalDamage: totalDamage);
    } catch (e) {
      lastError = '$e';
      notifyListeners();
    }
  }

  /// Starts (or moves) the live top-N listener for `weekID` — call once
  /// when the World Boss screen appears. A no-op if already listening to
  /// the same week.
  void listen({required String weekID, int limit = 200}) {
    final db = _db;
    if (!isReady || db == null) return;
    if (_listenedWeekID == weekID) return;
    _listenedWeekID = weekID;
    _topSub?.cancel();
    _topSub = db
        .collection('worldBossLeaderboard')
        .doc(weekID)
        .collection('entries')
        .orderBy('damage', descending: true)
        .limit(limit)
        .snapshots()
        .listen((snapshot) {
      top = snapshot.docs.map((doc) {
        final data = doc.data();
        return WorldBossEntry(
          id: doc.id,
          damage: data['damage'] as int? ?? 0,
          playerLevel: data['playerLevel'] as int? ?? 1,
        );
      }).toList();
      final uid = _uid;
      if (uid != null) {
        final mine = top.indexWhere((e) => e.id == uid);
        if (mine != -1) myRank = mine + 1;
      }
      notifyListeners();
    });
  }

  /// A player past the top-N listener's window (`limit`) needs their exact
  /// rank computed separately — an aggregate `count()` query of everyone
  /// who out-damaged them, rather than downloading the whole collection.
  Future<void> _refreshMyRank({required String weekID, required int totalDamage}) async {
    final db = _db;
    final uid = _uid;
    if (db == null || uid == null || totalDamage <= 0) return;
    final mine = top.indexWhere((e) => e.id == uid);
    if (mine != -1) {
      myRank = mine + 1;
      notifyListeners();
      return;
    }
    try {
      final query = db
          .collection('worldBossLeaderboard')
          .doc(weekID)
          .collection('entries')
          .where('damage', isGreaterThan: totalDamage);
      final aggregate = await query.count().get();
      myRank = (aggregate.count ?? 0) + 1;
      notifyListeners();
    } catch (_) {
      // Non-fatal — the top-N list still shows even if the exact rank
      // beyond it can't be resolved right now.
    }
  }

  void stopListening() {
    _topSub?.cancel();
    _topSub = null;
    _listenedWeekID = null;
  }
}

class WorldBossEntry {
  final String id;
  final int damage;
  final int playerLevel;

  const WorldBossEntry({required this.id, required this.damage, required this.playerLevel});
}
