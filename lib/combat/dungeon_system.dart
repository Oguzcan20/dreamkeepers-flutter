import 'package:uuid/uuid.dart';

import '../l10n/l10n.dart';
import '../models/element.dart';
import '../models/rarity.dart';
import '../models/role.dart';
import 'combatant.dart';

const _uuid = Uuid();

/// Dungeons ("Schlünde") — a Flutter-only feature with **no Swift-original
/// counterpart**; it deliberately diverges from the `GameCore/...` Swift-
/// parity convention.
///
/// Each dungeon is a single [waveCount]-wave run fought back-to-back in one
/// [BattleView] with no healing between waves (two regular waves, then a
/// boss). Entry costs one Dungeon Key ([DungeonSystem.maxKeysPerDay] per
/// day, refilled at local midnight). The first clear pays a big fixed
/// reward — gold, Dream Gems, and a guaranteed high-rarity item; later
/// clears pay a smaller repeatable farm reward.
enum DungeonId {
  whisperwood,
  gloomvault,
  starspire;

  /// Stable key for `GameSave.clearedDungeonIDs` — never localized.
  String get storageKey => name;
}

/// Static per-dungeon configuration and combat/reward math.
class DungeonSystem {
  DungeonSystem._();

  /// Dungeon Keys handed out per calendar day.
  static const int maxKeysPerDay = 3;

  /// Waves per run — two regular encounters and a boss finale.
  static const int waveCount = 3;

  static const List<DungeonId> all = DungeonId.values;

  static String displayName(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return L.dungeonWhisperwoodName;
      case DungeonId.gloomvault:
        return L.dungeonGloomvaultName;
      case DungeonId.starspire:
        return L.dungeonStarspireName;
    }
  }

  static String blurb(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return L.dungeonWhisperwoodBlurb;
      case DungeonId.gloomvault:
        return L.dungeonGloomvaultBlurb;
      case DungeonId.starspire:
        return L.dungeonStarspireBlurb;
    }
  }

  static String icon(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return 'leaf.fill';
      case DungeonId.gloomvault:
        return 'moon.stars.fill';
      case DungeonId.starspire:
        return 'sparkles';
    }
  }

  /// Rough team level a run is tuned for — shown in the hub as guidance.
  static int recommendedLevel(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return 12;
      case DungeonId.gloomvault:
        return 28;
      case DungeonId.starspire:
        return 45;
    }
  }

  /// Overall enemy-strength multiplier over a fresh Dreamkeeper's own stats
  /// — the three dungeons form a clear low/mid/high ladder.
  static double _powerScale(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return 2.0;
      case DungeonId.gloomvault:
        return 5.0;
      case DungeonId.starspire:
        return 10.0;
    }
  }

  static GameElement _theme(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return GameElement.bloom;
      case DungeonId.gloomvault:
        return GameElement.lunar;
      case DungeonId.starspire:
        return GameElement.astral;
    }
  }

  static BossMechanic _bossMechanic(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return BossMechanic.regenShield;
      case DungeonId.gloomvault:
        return BossMechanic.enrage;
      case DungeonId.starspire:
        return BossMechanic.sovereign;
    }
  }

  /// The [waveCount] enemies of a run, in order — index 0 is fought first,
  /// the last is the boss. Built from flat base stats × [_powerScale] the
  /// same way `ArenaSystem.makeCombatant` synthesises its rival, so no
  /// catalog lookup is needed.
  static List<Combatant> waves(DungeonId id) {
    final scale = _powerScale(id);
    final element = _theme(id);
    final result = <Combatant>[];
    for (var wave = 0; wave < waveCount; wave++) {
      final isBoss = wave == waveCount - 1;
      // Each successive wave is a little tougher; the boss then jumps again.
      final waveScale = scale * (1.0 + wave * 0.15) * (isBoss ? 1.6 : 1.0);
      result.add(Combatant(
        id: _uuid.v4(),
        name: isBoss ? L.dungeonBossName(displayName(id)) : L.dungeonWaveEnemyName(wave + 1),
        element: element,
        role: isBoss ? Role.tank : Role.damage,
        isPlayer: false,
        isBoss: isBoss,
        maxHP: (64 * waveScale).roundToDouble(),
        currentHP: (64 * waveScale).roundToDouble(),
        attack: (12 * waveScale).roundToDouble(),
        defense: (5 * waveScale).roundToDouble(),
        speed: (44 + wave * 3).roundToDouble(),
        symbol: isBoss ? 'crown.fill' : element.symbol,
        mechanic: isBoss ? _bossMechanic(id) : null,
      ));
    }
    return result;
  }

  // -- Rewards ---------------------------------------------------------------

  /// Campaign-stage-equivalent used to size an item drop's stat magnitude
  /// (see `EquipmentFactory.item`).
  static int _lootStage(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return 20;
      case DungeonId.gloomvault:
        return 45;
      case DungeonId.starspire:
        return 80;
    }
  }

  static int firstClearGold(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return 400;
      case DungeonId.gloomvault:
        return 1200;
      case DungeonId.starspire:
        return 3000;
    }
  }

  static int firstClearGems(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return 15;
      case DungeonId.gloomvault:
        return 30;
      case DungeonId.starspire:
        return 60;
    }
  }

  /// Guaranteed rarity of the first-clear item reward.
  static Rarity firstClearRarity(DungeonId id) {
    switch (id) {
      case DungeonId.whisperwood:
        return Rarity.epic;
      case DungeonId.gloomvault:
        return Rarity.legendary;
      case DungeonId.starspire:
        return Rarity.legendary;
    }
  }

  /// Repeatable farm gold for an already-cleared dungeon — a fraction of the
  /// one-off first-clear payout.
  static int repeatGold(DungeonId id) => (firstClearGold(id) * 0.4).round();

  /// Campaign-stage-equivalent for sizing any item drop's stat magnitude.
  static int lootStage(DungeonId id) => _lootStage(id);
}
