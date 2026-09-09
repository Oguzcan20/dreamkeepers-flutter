import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The player's account identity — separate from `GameState`/`SaveSystem`.
/// Save sync itself would ride on a cloud account automatically via
/// `CloudSaveStore` regardless of this; signing in here is about having a
/// recognizable account (display name, future leaderboards/friends) rather
/// than gating storage. Mirrors State/AccountState.swift, generalized from
/// Sign in with Apple to a platform-neutral identity (Sign in with Apple on
/// iOS, Google Sign-In on Android would both populate the same fields).
class AccountState extends ChangeNotifier {
  static const _userIDKey = 'dreamkeepers.account.userID';
  static const _displayNameKey = 'dreamkeepers.account.displayName';

  bool _isSignedIn = false;
  String? _displayName;
  String? _userID;
  bool _loaded = false;

  bool get isSignedIn => _isSignedIn;
  String? get displayName => _displayName;
  String? get userID => _userID;

  /// Must be called once before reading state (e.g. right after
  /// construction) — Flutter has no synchronous UserDefaults-style storage,
  /// so the initial load is async unlike the Swift original's `init`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _userID = prefs.getString(_userIDKey);
    _displayName = prefs.getString(_displayNameKey);
    _isSignedIn = _userID != null;
    _loaded = true;
    notifyListeners();
  }

  bool get isLoaded => _loaded;

  /// The platform only hands back a display name the very first time a
  /// user authorizes this app, so `displayName` is optional here and, once
  /// captured, is kept even if a later sign-in omits it.
  Future<void> signIn({required String userID, String? displayName}) async {
    final prefs = await SharedPreferences.getInstance();
    _userID = userID;
    await prefs.setString(_userIDKey, userID);
    if (displayName != null && displayName.isNotEmpty) {
      _displayName = displayName;
      await prefs.setString(_displayNameKey, displayName);
    }
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    _isSignedIn = false;
    _userID = null;
    _displayName = null;
    await prefs.remove(_userIDKey);
    await prefs.remove(_displayNameKey);
    notifyListeners();
  }
}
