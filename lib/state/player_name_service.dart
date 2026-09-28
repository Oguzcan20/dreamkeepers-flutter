import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Claims a globally-unique player name after onboarding — backed by
/// Firebase (the same Anonymous Auth session `FriendsService` establishes +
/// Firestore for the reservation). Mirrors `State/PlayerNameService.swift`
/// exactly, using the same `playerNames` Firestore collection so an iOS and
/// an Android player can never both claim the same name.
///
/// A human-chosen value has far higher collision risk than
/// `FriendsService`'s random 8-digit friend codes, so a simple get-then-set
/// check isn't safe here: a Firestore transaction is used instead, so two
/// players racing for the same popular name can never both win it.
class PlayerNameService extends ChangeNotifier {
  static const int minLength = 3;
  static const int maxLength = 16;
  static final RegExp _allowedCharacters = RegExp(r'^[A-Za-z0-9_]+$');

  /// `Firebase.initializeApp` already runs unconditionally in `main()`, so —
  /// unlike the Swift original, which gates everything on
  /// `GoogleService-Info.plist` being present — this is always `true` here;
  /// kept only so callers can mirror the Swift "not configured" branch
  /// verbatim if a build is ever shipped without Firebase configured.
  final bool isConfigured = true;

  bool isClaiming = false;

  // Deliberately NOT resolved in the constructor — `RootView` constructs
  // this service eagerly (it needs `needsPlayerName` available right away),
  // and `FirebaseFirestore.instance` throws if `Firebase.initializeApp()`
  // hasn't run yet, which widget tests never do. Resolving it lazily here
  // (same deferred pattern as `FriendsService.start()`) means the mere
  // existence of this service never requires Firebase to be configured.
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  /// Syntactic validation only — no network call. Used for inline
  /// as-you-type feedback before the player submits. Returns a
  /// human-readable (German) error, or `null` when valid.
  static String? validate(String rawName) {
    final trimmed = rawName.trim();
    if (trimmed.length < minLength) {
      return 'Name muss mindestens $minLength Zeichen lang sein.';
    }
    if (trimmed.length > maxLength) {
      return 'Name darf höchstens $maxLength Zeichen lang sein.';
    }
    if (!_allowedCharacters.hasMatch(trimmed)) {
      return 'Nur Buchstaben, Zahlen und Unterstriche erlaubt.';
    }
    return null;
  }

  /// Atomically claims [rawName] for this device's Firebase user (signing
  /// in anonymously first if no session exists yet — idempotent, shares the
  /// same Firebase Auth session `FriendsService` uses). Uniqueness is
  /// case-insensitive (`playerNames/{lowercased}`), but the exact casing the
  /// player typed is preserved as the stored/displayed name. Safe to retry:
  /// re-claiming a name this same user already owns succeeds again rather
  /// than reporting it taken.
  ///
  /// Returns the claimed display name on success, or a human-readable
  /// (German) error message on failure.
  Future<PlayerNameClaimResult> claim(String rawName) async {
    final trimmed = rawName.trim();
    final validationError = validate(trimmed);
    if (validationError != null) {
      return PlayerNameClaimResult.failure(validationError);
    }

    final normalized = trimmed.toLowerCase();
    isClaiming = true;
    notifyListeners();
    try {
      final db = _db;
      final uid = await _ensureSignedIn();
      final nameRef = db.collection('playerNames').doc(normalized);
      await db.runTransaction((transaction) async {
        final snapshot = await transaction.get(nameRef);
        if (snapshot.exists && snapshot.data()?['playerID'] != uid) {
          throw const PlayerNameAlreadyTakenException();
        }
        transaction.set(nameRef, {
          'playerID': uid,
          'displayName': trimmed,
          'claimedAt': FieldValue.serverTimestamp(),
        });
      });
      return PlayerNameClaimResult.success(trimmed);
    } on PlayerNameAlreadyTakenException {
      return const PlayerNameClaimResult.failure('Dieser Name ist schon vergeben.');
    } catch (e) {
      return PlayerNameClaimResult.failure('$e');
    } finally {
      isClaiming = false;
      notifyListeners();
    }
  }

  Future<String> _ensureSignedIn() async {
    final existing = FirebaseAuth.instance.currentUser;
    if (existing != null) return existing.uid;
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final user = credential.user;
    if (user == null) throw StateError('Anmeldung fehlgeschlagen.');
    return user.uid;
  }
}

class PlayerNameAlreadyTakenException implements Exception {
  const PlayerNameAlreadyTakenException();
}

class PlayerNameClaimResult {
  final String? name;
  final String? error;

  const PlayerNameClaimResult.success(this.name) : error = null;

  const PlayerNameClaimResult.failure(this.error) : name = null;

  bool get isSuccess => name != null;
}
