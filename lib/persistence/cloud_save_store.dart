import 'game_save.dart';
import 'save_system.dart';

/// Would sync the save across the player's devices via a cloud account —
/// iCloud on iOS (see the Swift original), and a Google-account-backed
/// store (Play Games Saved Games / Drive appdata) would be the Android
/// equivalent. No cross-platform Flutter plugin for either is wired in yet,
/// so today every cloud operation is a harmless no-op and the app runs
/// local-only, exactly like `LocalSaveStore` — same fallback behavior the
/// Swift original has when iCloud itself is signed out or unavailable.
/// Mirrors Persistence/CloudSaveStore.swift's shape (and its "always write
/// local first" safety net) so a real cloud backend can drop in later
/// behind this same `SaveSystem` contract without touching any call site.
class CloudSaveStore implements SaveSystem {
  final LocalSaveStore _local = LocalSaveStore();

  /// Prefers the cloud copy when both exist, since it may reflect progress
  /// made on another device — falls back to the local copy otherwise.
  @override
  Future<GameSave?> load() async {
    final cloud = await _loadFromCloud();
    if (cloud != null) return cloud;
    return _local.load();
  }

  @override
  Future<void> save(GameSave save) async {
    await _local.save(save);
    await _saveToCloud(save);
  }

  /// TODO(cloud-sync): wire up a real per-platform backend. Returns null
  /// (never available) until then.
  Future<GameSave?> _loadFromCloud() async => null;

  /// TODO(cloud-sync): wire up a real per-platform backend. No-op until
  /// then — local already has the authoritative copy via `save()` above.
  Future<void> _saveToCloud(GameSave save) async {}
}
