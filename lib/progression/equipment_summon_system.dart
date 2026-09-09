import '../models/equipment.dart';
import '../models/rarity.dart';
import 'equipment_factory.dart';
import 'summon_system.dart';

/// Equipment Summon: same 30-gem single / 300-gem "10+1" pricing as
/// `SummonSystem`, and the exact same rarity odds (`SummonSystem.rollRarity`)
/// so the two gacha currencies feel equally (un)lucky — only the payout
/// differs: an `EquipmentItem` sized for the player's current stage instead
/// of a `DreamkeeperDefinition`. Mirrors
/// GameCore/Progression/EquipmentSummonSystem.swift exactly.
class EquipmentSummonSystem {
  static const cost = 30;

  static const multiPullPaidCount = 10;
  static const multiPullBonusCount = 1;
  static int get multiPullTotalCount => multiPullPaidCount + multiPullBonusCount;
  static int get multiPullCost => cost * multiPullPaidCount;

  /// `.exclusive` is Igo/Ames only — a character rarity with no equipment
  /// equivalent — so a rarity landing there is treated as `.mythic` here,
  /// same top-tier payout as everywhere else in the equipment loot table.
  /// Applied in this single rarity-taking overload (rather than only in the
  /// roll-based one below) so the pity-aware caller — which resolves its
  /// own rarity and calls straight into this overload — can't slip an
  /// `.exclusive`-rarity item into the inventory.
  static EquipmentItem rollItemForRarity({required int stage, required Rarity rarity}) {
    final resolved = rarity == Rarity.exclusive ? Rarity.mythic : rarity;
    return EquipmentFactory.item(stage: stage, rarity: resolved);
  }

  static EquipmentItem rollItem({required int stage, double? roll}) =>
      rollItemForRarity(stage: stage, rarity: SummonSystem.rollRarity(roll: roll));
}
