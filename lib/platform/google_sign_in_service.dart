import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../state/account_state.dart';

/// Wraps `google_sign_in` and drives the platform-neutral [AccountState] —
/// Android counterpart to how `AccountState.swift`'s Sign in with Apple
/// flow populates the same `userID`/`displayName` fields. `AccountState`
/// itself needed no changes to support this; it was already provider-
/// neutral, just missing a real caller (see `settings_view.dart`'s account
/// card).
class GoogleSignInService {
  GoogleSignInService({GoogleSignIn? googleSignIn}) : _googleSignIn = googleSignIn ?? GoogleSignIn();

  final GoogleSignIn _googleSignIn;

  /// Silent sign-in attempt for app launch — mirrors checking an existing
  /// Apple credential state. Succeeds quietly if a prior Google session
  /// exists; does nothing (no error surfaced) otherwise, since not having
  /// signed in before is the common case, not a failure.
  Future<void> signInSilentlyIfAvailable(AccountState accountState) async {
    final account = await _googleSignIn.signInSilently();
    if (account != null) {
      await accountState.signIn(userID: account.id, displayName: account.displayName);
    }
  }

  /// Interactive sign-in, launched from the Settings screen's "Sign in
  /// with Google" button. Returns whether sign-in succeeded — `false`
  /// covers both the user canceling the system account picker (which
  /// `GoogleSignIn.signIn()` itself already treats as non-fatal) and any
  /// other plugin-level failure (e.g. Play Services unavailable), which
  /// isn't worth surfacing as a crash either.
  Future<bool> signIn(AccountState accountState) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return false;
      await accountState.signIn(userID: account.id, displayName: account.displayName);
      await _linkFirebaseAuth(account);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Upgrades the anonymous Firebase Auth session that `FriendsService`/
  /// `PromoCodeService` run on into one permanently tied to this Google
  /// account, keeping the same `uid` — and therefore the same friend code
  /// and promo-redemption history — so both survive an app reinstall or a
  /// "delete my account and start over" so long as the player signs back
  /// in with this same Google account. If this Google account already has
  /// a *different* Firebase identity (signed in from another device
  /// before), that pre-existing identity — and whatever friend code/
  /// history it carries — takes over instead, which is the correct
  /// behavior: it's what a returning player expects. Best-effort: any
  /// failure here still leaves the Google Sign-In itself (and
  /// `AccountState`) successful, just without this durability guarantee.
  Future<void> _linkFirebaseAuth(GoogleSignInAccount account) async {
    try {
      final googleAuth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final current = FirebaseAuth.instance.currentUser;
      if (current != null && current.isAnonymous) {
        try {
          await current.linkWithCredential(credential);
          return;
        } on FirebaseAuthException catch (e) {
          if (e.code != 'credential-already-in-use') rethrow;
          // Falls through to signInWithCredential below, which swaps to
          // the pre-existing permanent account for this Google identity.
        }
      }
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (_) {
      // Non-fatal — see doc comment above.
    }
  }

  Future<void> signOut(AccountState accountState) async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Best-effort: still clear the local AccountState below even if the
      // Google-side call fails.
    }
    await accountState.signOut();
  }
}
