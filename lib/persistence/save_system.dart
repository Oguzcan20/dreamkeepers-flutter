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
