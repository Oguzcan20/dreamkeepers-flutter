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
      return true;
    } catch (_) {
      return false;
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
