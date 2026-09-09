import 'package:uuid/uuid.dart';

import '../data/dreamkeeper_catalog.dart';
import '../models/equipment.dart';
import '../models/rarity.dart';
import '../progression/equipment_factory.dart';
import '../progression/level_system.dart';
import 'combatant.dart';

const _uuid = Uuid();

/// A small, deterministic pseudo-random source (splitmix64-style) so
/// `ArenaSystem.opponentForFloor` produces the *same* rival for a given
/// floor every time it's called — the Arena hub re-reads the current
/// opponent on every rebuild, and a retry after a loss should face the
/// exact same rival, not a reshuffled one. Mirrors
/// GameCore/Combat/ArenaSystem.swift's `SeededGenerator` exactly.
class SeededGenerator {
  int _state;

  SeededGenerator(int seed) : _state = _wrap(seed + 0x9E3779B97F4A7C15);

  static int _wrap(int v) => v & 0xFFFFFFFFFFFFFFFF;

  int next() {
    _state = _wrap(_state + 0x9E3779B97F4A7C15);
    var z = _state;
    z = _wrap((z ^ (z >> 30)) * 0xBF58476D1CE4E5B9);
    z = _wrap((z ^ (z >> 27)) * 0x94D049BB133111EB);
    return _wrap(z ^ (z >> 31));
  }

  /// Deterministically picks one element of `list` using this generator —
  /// Dart equivalent of Swift's `Collection.randomElement(using:)`.
  T pick<T>(List<T> list) => list[next() % list.length];
}

/// Arena Tower tiers — purely a labeled banding of the save's arena floor
/// for the hub/result UI, same idea as `Rarity` bands a raw drop-weight.
/// Mirrors GameCore/Combat/ArenaSystem.swift's `ArenaTier` exactly.
enum ArenaTier implements Comparable<ArenaTier> {
  bronze,
  silver,
  gold,
  platinum,
  diamond;

  @override
  int compareTo(ArenaTier other) => index.compareTo(other.index);

  static ArenaTier tier(int floor) {
    if (floor < 21) return ArenaTier.bronze;
    if (floor < 41) return ArenaTier.silver;
    if (floor < 61) return ArenaTier.gold;
    if (floor < 81) return ArenaTier.platinum;
    return ArenaTier.diamond;
  }

  String get displayName {
    switch (this) {
      case ArenaTier.bronze:
        return 'Bronze';
      case ArenaTier.silver:
        return 'Silver';
      case ArenaTier.gold:
        return 'Gold';
      case ArenaTier.platinum:
        return 'Platinum';
      case ArenaTier.diamond:
        return 'Diamond';
    }
  }

  String get symbol {
    switch (this) {
      case ArenaTier.bronze:
        return 'shield.fill';
      case ArenaTier.silver:
        return 'shield.lefthalf.filled';
      case ArenaTier.gold:
        return 'shield.checkered';
      case ArenaTier.platinum:
        return 'star.circle.fill';
      case ArenaTier.diamond:
        return 'crown.fill';
    }
  }

  /// Inclusive floor range this tier spans — five equal 20-floor bands
  /// covering `ArenaSystem.maxFloor` exactly (kept in sync with `tier`'s
  /// thresholds above).
  (int, int) get floorRange {
    switch (this) {
      case ArenaTier.bronze:
        return (1, 20);
      case ArenaTier.silver:
        return (21, 40);
      case ArenaTier.gold:
        return (41, 60);
      case ArenaTier.platinum:
        return (61, 80);
      case ArenaTier.diamond:
        return (81, ArenaSystem.maxFloor);
    }
  }

  /// Flavor name for this tier's section of the Arena Tower structure —
  /// distinct from `displayName` (the compact badge elsewhere), used only
  /// by the tower-zone banner between floor blocks.
  String get zoneName {
    switch (this) {
      case ArenaTier.bronze:
        return 'Bronze Halls';
      case ArenaTier.silver:
        return 'Silver Vault';
      case ArenaTier.gold:
        return 'Gold Sanctum';
      case ArenaTier.platinum:
        return 'Platinum Ascent';
      case ArenaTier.diamond:
        return 'Diamond Summit';
    }
  }
}

/// The AI-controlled rival guarding one Arena Tower floor. There is no real
/// backend or matchmaking — so "PvP" here means fighting a freshly-
/// synthesized, fair stand-in for another player's team, not a live
/// opponent. Freshly generated, never persisted; see
/// `ArenaSystem.opponentForFloor`. `floor` alone identifies it, since the
/// same floor always deterministically generates the same rival. Mirrors
/// GameCore/Combat/ArenaSystem.swift's `ArenaOpponent` exactly.
class ArenaOpponent {
  final int floor;
  final String name;
  final String definitionID;
  final int level;

  const ArenaOpponent({
    required this.floor,
    required this.name,
    required this.definitionID,
    required this.level,
  });

  @override
  bool operator ==(Object other) =>
      other is ArenaOpponent &&
      floor == other.floor &&
      name == other.name &&
      definitionID == other.definitionID &&
      level == other.level;

  @override
  int get hashCode => Object.hash(floor, name, definitionID, level);
}

/// Opponent generation, floor-scaling math, and the single-rival combat
/// stand-in the Arena Tower fights against. Deliberately reuses the
/// existing single-enemy `BattleEngine`/battle UI pipeline unchanged — a
/// floor's rival "team" is represented as one elevated-stat `Combatant` (a
/// rival captain), the same way a stage boss already stands in for its
/// whole encounter, rather than requiring a second multi-enemy battle UI.
/// Mirrors GameCore/Combat/ArenaSystem.swift exactly.
class ArenaSystem {
  /// Highest climbable floor — reaching `maxFloor + 1` means the tower is
  /// fully cleared.
  static const maxFloor = 100;

  /// Daily attempts, refilled at local midnight — deliberately its own
  /// economy instead of spending shared energy, so climbing the tower
  /// never competes with Campaign stages for the same stamina bar.
  static const maxTicketsPerDay = 5;

  /// Every Nth floor guarantees a legendary+ bonus reward on top of the
  /// normal floor payout.
  static const milestoneInterval = 25;

  static bool isMilestoneFloor(int floor) => floor % milestoneInterval == 0;

  static const List<String> _rivalNames = [
    'Team Nachtklinge',
    'Team Sternenschatten',
    'Team Glutmähne',
    'Team Flussgeist',
    'Team Wurzelbund',
    'Team Mondsichel',
    'Team Aschekrone',
    'Team Tiefenruf',
    'Team Lichtbrecher',
    'Team Sturmauge',
  ];

  /// The rival guarding `floor` — deterministic per floor (see
  /// `SeededGenerator`'s doc comment for why), so it holds steady across
  /// every read and stays the same on a retry after a loss.
  static ArenaOpponent opponentForFloor(int floor, DreamkeeperCatalog catalog) {
    final pool = catalog.definitions;
    final rng = SeededGenerator(floor);
    final def = pool.isEmpty ? null : rng.pick(pool);
    final name = rng.pick(_rivalNames);
    final level = (1 + floor ~/ 2).clamp(1, LevelSystem.maxLevel);
    return ArenaOpponent(
      floor: floor,
      name: name,
      definitionID: def?.id ?? '',
      level: level,
    );
  }

  /// Per-floor stat multiplier — floor 1 opens at roughly a fresh
  /// Dreamkeeper's own strength and climbs steadily past the campaign's
  /// own hardest boss well before floor 100, so the tower stays a genuine
  /// long-term goal even for a maxed-out roster.
  static double scale(int floor) => 1.0 + (floor - 1) * 0.528;

  /// Synthesizes the rival's combat stand-in directly from base stats ×
  /// `scale`, the same way `EnemyFactory.enemy` does for campaign enemies,
  /// so difficulty has real room to climb across all 100 floors.
  static Combatant? makeCombatant(ArenaOpponent opponent, DreamkeeperCatalog catalog) {
    final def = catalog.definition(opponent.definitionID);
    if (def == null) return null;
    final totalScale = scale(opponent.floor);
    return Combatant(
      id: _uuid.v4(),
      name: opponent.name,
      element: def.element,
      role: def.role,
      isPlayer: false,
      isBoss: false,
      maxHP: (70 * totalScale).roundToDouble(),
      currentHP: (70 * totalScale).roundToDouble(),
      attack: (13 * totalScale).roundToDouble(),
      defense: (6 * totalScale).roundToDouble(),
      speed: (40 + opponent.floor * 0.6).roundToDouble(),
      ultimate: def.ultimate,
      symbol: def.symbol,
      // Show the real Dreamkeeper portrait this rival's stats/kit are
      // borrowed from, instead of the flavor team name never matching any
      // imageset — see `Combatant.portraitOverrideName`.
      portraitOverrideName: def.name,
    );
  }

  /// Gold payout for clearing a floor — climbs steadily so a deliberate
  /// grind up the tower stays worth it the whole way.
  static int goldReward(int floor) => 40 + floor * 9;

  static int firstClearGoldReward(int floor) => goldReward(floor);

  /// Rarity floor a floor's FIRST-clear equipment reward is guaranteed to
  /// hit — rises with `ArenaTier`, and any milestone floor is bumped
  /// straight to Legendary regardless of tier.
  static Rarity firstClearRarity(int floor) {
    if (isMilestoneFloor(floor)) return Rarity.legendary;
    switch (ArenaTier.tier(floor)) {
      case ArenaTier.bronze:
        return Rarity.common;
      case ArenaTier.silver:
        return Rarity.uncommon;
      case ArenaTier.gold:
        return Rarity.rare;
      case ArenaTier.platinum:
        return Rarity.epic;
      case ArenaTier.diamond:
        return Rarity.legendary;
    }
  }

  /// The exact item a floor's first clear grants — seeded by the floor
  /// number alone (offset so it never lands on the same "random" slot the
  /// opponent roll picked), so it's fully deterministic and can be shown
  /// in the floor-list UI before the fight, not just after.
  static EquipmentItem firstClearEquipment(int floor) {
    final rng = SeededGenerator(floor + 0x1000003);
    final slot = rng.pick(EquipmentSlot.values);
    return EquipmentFactory.item(
      stage: floor,
      rarity: firstClearRarity(floor),
      slot: slot,
    );
  }

  /// Smaller, RNG-based reward for replaying an already-cleared floor —
  /// the repeatable farm loop players use once they know which floor
  /// drops the gear they're after. Deliberately not previewable/fixed
  /// like the first-clear reward, since it's meant to be replayed many
  /// times rather than shown once.
  static int standardGoldReward(int floor) => 15 + floor * 2;

  static EquipmentItem? standardEquipmentDrop(int floor) {
    if (!EquipmentFactory.shouldDrop(isBoss: false)) return null;
    return EquipmentFactory.randomItem(stage: floor, isBoss: false);
  }
}
