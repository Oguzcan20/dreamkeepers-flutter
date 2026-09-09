import 'package:uuid/uuid.dart';

import 'element.dart';
import 'equipment.dart';
import 'role.dart';
import 'rarity.dart';
import 'skill.dart';
import 'stats.dart';
import '../progression/star_fusion_system.dart';

const _uuid = Uuid();

/// Static, data-driven description of a Dreamkeeper species. New characters
/// are added by appending to the catalog — combat and progression code
/// never switches on identity. Mirrors DreamkeeperDefinition in
/// GameCore/Models/Dreamkeeper.swift exactly.
class DreamkeeperDefinition {
  final String id;
  final String name;
  final GameElement element;
  final Role role;
  final Rarity rarity;
  final Stats baseStats;

  /// Stat gained per level beyond 1.
  final Stats growthPerLevel;
  final UltimateSkill ultimate;
  final ActiveSkill activeSkill;
  final PassiveTrait passive;
  final String symbol;
  final String flavorText;

  /// Groups definitions that are "the same character" for fusion purposes
  /// even though they have distinct `id`s — currently only Olf's six
  /// entries (`family: 'olf'`), so any element variant pulled later from
  /// Summoning can be fused into whichever one the player is actually
  /// raising. `null` (the default) means fusion stays strict-`id` for
  /// every other Dreamkeeper. See `GameState.duplicates`. Mirrors
  /// `DreamkeeperDefinition.family` in GameCore/Models/Dreamkeeper.swift.
  final String? family;

  /// Whether this definition can ever be the result of a Summon roll.
  /// `false` only for Ultimate Olf, who is granted solely through the
  /// post-onboarding secret gesture and must never turn up in the gacha
  /// pool at any rarity. Mirrors `DreamkeeperDefinition.isSummonable`.
  final bool isSummonable;

  const DreamkeeperDefinition({
    required this.id,
    required this.name,
    required this.element,
    required this.role,
    required this.rarity,
    required this.baseStats,
    required this.growthPerLevel,
    required this.ultimate,
    required this.activeSkill,
    required this.passive,
    required this.symbol,
    required this.flavorText,
    this.family,
    this.isSummonable = true,
  });
}

/// A specific Dreamkeeper owned by the player: a definition plus
/// progression. Mirrors DreamkeeperInstance in
/// GameCore/Models/Dreamkeeper.swift exactly.
class DreamkeeperInstance {
  final String id;
  final String definitionID;
  final int level;
  final int exp;

  /// 0 (no fusion yet) through StarFusionSystem.maxStars.
  final int stars;

  /// Duplicates already banked toward the *next* star tier.
  final int fusionProgress;

  /// EquipmentSlot.name -> equipped EquipmentItem.id. At most one item per
  /// slot.
  final Map<String, String> equipped;

  DreamkeeperInstance({
    String? id,
    required this.definitionID,
    this.level = 1,
    this.exp = 0,
    this.stars = 0,
    this.fusionProgress = 0,
    Map<String, String>? equipped,
  })  : id = id ?? _uuid.v4(),
        equipped = equipped ?? {};

  DreamkeeperInstance copyWith({
    int? level,
    int? exp,
    int? stars,
    int? fusionProgress,
    Map<String, String>? equipped,
  }) =>
      DreamkeeperInstance(
        id: id,
        definitionID: definitionID,
        level: level ?? this.level,
        exp: exp ?? this.exp,
        stars: stars ?? this.stars,
        fusionProgress: fusionProgress ?? this.fusionProgress,
        equipped: equipped ?? this.equipped,
      );

  /// Stats at the current level, including passive bonus, star bonus, and
  /// whatever is equipped (looked up from the player's shared inventory).
  Stats currentStats({
    required DreamkeeperDefinition? definition,
    List<EquipmentItem> inventory = const [],
  }) {
    if (definition == null) return Stats.zero;
    final levelGrowth = definition.growthPerLevel * (level - 1).toDouble();
    final starBonus =
        definition.baseStats * (StarFusionSystem.statBonusPerStar * stars);
    var equipmentBonus = Stats.zero;
    for (final itemID in equipped.values) {
      final match = inventory.where((i) => i.id == itemID);
      if (match.isNotEmpty) {
        equipmentBonus = equipmentBonus + match.first.effectiveStatBonus;
      }
    }
    return (definition.baseStats +
            levelGrowth +
            starBonus +
            definition.passive.statBonus +
            equipmentBonus)
        .rounded;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'definitionID': definitionID,
        'level': level,
        'exp': exp,
        'stars': stars,
        'fusionProgress': fusionProgress,
        'equipped': equipped,
      };

  factory DreamkeeperInstance.fromJson(Map<String, dynamic> json) =>
      DreamkeeperInstance(
        id: json['id'] as String,
        definitionID: json['definitionID'] as String,
        level: json['level'] as int,
        exp: json['exp'] as int,
        stars: json['stars'] as int? ?? 0,
        fusionProgress: json['fusionProgress'] as int? ?? 0,
        equipped: (json['equipped'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {},
      );
}
