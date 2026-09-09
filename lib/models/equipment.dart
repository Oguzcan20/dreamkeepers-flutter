import 'package:uuid/uuid.dart';

import 'rarity.dart';
import 'stats.dart';
import '../progression/star_fusion_system.dart';

const _uuid = Uuid();

enum EquipmentSlot {
  weapon,
  charm,
  cloak,
  ring;

  String get displayName {
    final raw = name;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  String get symbol {
    switch (this) {
      case EquipmentSlot.weapon:
        return 'wand.and.rays';
      case EquipmentSlot.charm:
        return 'seal.fill';
      case EquipmentSlot.cloak:
        return 'theatermask.and.paintbrush.fill';
      case EquipmentSlot.ring:
        return 'circle.circle.fill';
    }
  }

  /// Which Stats field this slot primarily boosts (weapons hit, charms
  /// protect life, cloaks defend, rings quicken).
  double primaryStat(Stats s) {
    switch (this) {
      case EquipmentSlot.weapon:
        return s.attack;
      case EquipmentSlot.charm:
        return s.hp;
      case EquipmentSlot.cloak:
        return s.defense;
      case EquipmentSlot.ring:
        return s.speed;
    }
  }
}

/// Mirrors GameCore/Models/Equipment.swift's EquipmentItem exactly.
class EquipmentItem {
  final String id;
  final EquipmentSlot slot;
  final String name;
  final Rarity rarity;
  final int level;
  final Stats statBonus;

  /// 0 (no fusion yet) through StarFusionSystem.maxStars — same manual
  /// duplicate-fusion mechanic as Dreamkeepers.
  final int stars;

  /// Duplicates already banked toward the *next* star tier, same
  /// banked-progress model as DreamkeeperInstance.fusionProgress.
  final int fusionProgress;

  EquipmentItem({
    String? id,
    required this.slot,
    required this.name,
    required this.rarity,
    required this.level,
    required this.statBonus,
    this.stars = 0,
    this.fusionProgress = 0,
  }) : id = id ?? _uuid.v4();

  /// "Same kind" for fusion purposes: identical slot, name, and rarity —
  /// the exact stat magnitude can differ slightly by drop stage, same as
  /// two Dreamkeeper pulls of the same species differing only by nothing.
  bool isSameKind(EquipmentItem other) =>
      slot == other.slot && name == other.name && rarity == other.rarity;

  /// Stat bonus including the star-fusion bonus, same 6%-per-star formula
  /// used for Dreamkeepers.
  Stats get effectiveStatBonus =>
      statBonus * (1 + StarFusionSystem.statBonusPerStar * stars);

  EquipmentItem copyWith({
    int? level,
    Stats? statBonus,
    int? stars,
    int? fusionProgress,
  }) =>
      EquipmentItem(
        id: id,
        slot: slot,
        name: name,
        rarity: rarity,
        level: level ?? this.level,
        statBonus: statBonus ?? this.statBonus,
        stars: stars ?? this.stars,
        fusionProgress: fusionProgress ?? this.fusionProgress,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'slot': slot.name,
        'name': name,
        'rarity': rarity.name,
        'level': level,
        'statBonus': statBonus.toJson(),
        'stars': stars,
        'fusionProgress': fusionProgress,
      };

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => EquipmentItem(
        id: json['id'] as String,
        slot: EquipmentSlot.values.byName(json['slot'] as String),
        name: json['name'] as String,
        rarity: Rarity.values.byName(json['rarity'] as String),
        level: json['level'] as int,
        statBonus: Stats.fromJson(json['statBonus'] as Map<String, dynamic>),
        stars: json['stars'] as int? ?? 0,
        fusionProgress: json['fusionProgress'] as int? ?? 0,
      );
}
