import '../models/equipment.dart';
import '../models/rarity.dart';

/// Gold-cost equipment upgrades, applied from the Inventory item detail
/// sheet. Each level compounds the item's stat bonus by a flat percentage;
/// cost scales with rarity and current level so late-game upgrades stay a
/// meaningful sink. Mirrors GameCore/Progression/EquipmentUpgrade.swift
/// exactly.
class EquipmentUpgrade {
  static const maxLevel = 10;
  static const growthPerLevel = 0.12;

  static bool canUpgrade(EquipmentItem item) => item.level < maxLevel;

  static int cost(EquipmentItem item) {
    final double rarityMultiplier;
    switch (item.rarity) {
      case Rarity.common:
        rarityMultiplier = 1.0;
      case Rarity.uncommon:
        rarityMultiplier = 1.3;
      case Rarity.rare:
        rarityMultiplier = 1.7;
      case Rarity.epic:
        rarityMultiplier = 2.2;
      case Rarity.legendary:
        rarityMultiplier = 2.8;
      case Rarity.mythic:
        rarityMultiplier = 3.6;
      case Rarity.exclusive:
        rarityMultiplier = 3.6; // Equipment never actually rolls .exclusive; kept for switch exhaustiveness.
    }
    final base = 25 + item.level * 20;
    return (base * rarityMultiplier).round();
  }

  /// Returns the item at its next level with a compounded stat bonus.
  /// No-op (returns the same item) once `maxLevel` is reached.
  static EquipmentItem upgraded(EquipmentItem item) {
    if (!canUpgrade(item)) return item;
    return item.copyWith(
      level: item.level + 1,
      statBonus: (item.statBonus * (1 + growthPerLevel)).rounded,
    );
  }
}
