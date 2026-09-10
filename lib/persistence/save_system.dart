import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'game_save.dart';

/// Platform- and backend-independent save contract. `LocalSaveStore` is the
/// only implementation today; `CloudSaveStore` (account sync) drops in
/// behind the same contract. Mirrors Persistence/SaveSystem.swift exactly.
abstract class SaveSystem {
  Future<GameSave?> load();
  Future<void> save(GameSave save);
}

/// Cross-platform local save using `shared_preferences` as the flat
/// key-value store (works identically on iOS and Android, unlike Swift's
/// original file-based `LocalSaveStore`, which had to pick a per-platform
/// storage directory).
class LocalSaveStore implements SaveSystem {
  static const _key = 'dreamkeepers.save.json';

  /// Reads just the persisted `preferredLanguage` from the raw save, without
  /// decoding the whole `GameSave`. `main()` needs the active locale set on
  /// the global `L` *before* it builds `GameState` — the localized catalogs
  /// (`DreamkeeperCatalog.starter` and friends) read `L` the first time they
  /// are touched, which happens inside `GameState.create`. Returns `null`
  /// for a missing or unreadable save, or a save with no stored preference.
  static Future<String?> readPreferredLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return (jsonDecode(raw) as Map<String, dynamic>)['preferredLanguage'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<GameSave?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return GameSave.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(GameSave save) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(save.toJson()));
  }
}
