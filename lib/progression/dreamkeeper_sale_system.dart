import '../models/rarity.dart';

/// Selling a roster Dreamkeeper back for currency — a soft-currency sink for
/// duplicates/fodder that didn't get used for fusion. Gold scales with
/// rarity, level and stars; Dream Gems only come back at Legendary/Mythic,
/// matching how those two rarities are the only ones treated as gem-tier
/// drops elsewhere (`SummonSystem`, `EquipmentFactory`). Mirrors
/// GameCore/Progression/DreamkeeperSaleSystem.swift exactly.
class DreamkeeperSaleSystem {
  static int goldValue({required Rarity rarity, required int level, required int stars}) {
    final int base;
    switch (rarity) {
      case Rarity.common:
        base = 15;
      case Rarity.uncommon:
        base = 30;
      case Rarity.rare:
        base = 60;
      case Rarity.epic:
        base = 120;
      case Rarity.legendary:
        base = 250;
      case Rarity.mythic:
        base = 400;
      case Rarity.exclusive:
        base = 1000; // Never actually reachable — selling Igo/Ames is blocked.
    }
    return base + (level - 1) * 3 + stars * 20;
  }

  static int gemValue(Rarity rarity) {
    switch (rarity) {
      case Rarity.legendary:
        return 5;
      case Rarity.mythic:
        return 12;
      case Rarity.exclusive:
        return 25; // Never actually reachable — see goldValue.
      default:
        return 0;
    }
  }
}
