import 'dart:math';

import '../models/equipment.dart';
import '../models/rarity.dart';
import '../models/stats.dart';

final _random = Random();

/// Procedural equipment drops for the MVP loot loop. Hand-authored sets can
/// replace or extend this later without touching GameState/UI — both just
/// deal in `EquipmentItem`. Mirrors GameCore/Progression/EquipmentFactory.swift
/// exactly.
class EquipmentFactory {
  static const Map<EquipmentSlot, List<String>> _namesBySlot = {
    EquipmentSlot.weapon: [
      'Ember Dagger',
      'Bramble Wand',
      'Tidecaller Blade',
      'Lunar Piercer',
      'Astral Spear',
      'Crystal Cleaver',
    ],
    EquipmentSlot.charm: [
      'Moonstone Charm',
      'Warding Sigil',
      'Dream Locket',
      'Ember Talisman',
      'Tideheart Pendant',
      'Bloomseed Charm',
    ],
    EquipmentSlot.cloak: [
      'Woven Nightcloak',
      'Starlit Mantle',
      'Bark Shroud',
      'Emberweave Cloak',
      'Tidewoven Cape',
      'Crystalline Veil',
    ],
    EquipmentSlot.ring: [
      'Whisper Ring',
      'Bloomband',
      'Rift Loop',
      'Emberband',
      'Tideloop Ring',
      'Duskbrand Ring',
    ],
  };

  /// Chance a victory drops an item at all; boss stages always drop.
  static bool shouldDrop({required bool isBoss}) =>
      isBoss || _random.nextDouble() < 0.35;

  static EquipmentItem randomItem({required int stage, required bool isBoss}) =>
      item(stage: stage, rarity: _rollRarity(isBoss: isBoss));

  /// Builds an item of an already-decided rarity and (optionally) slot — the
  /// shared stat-magnitude math behind [randomItem] above (which rolls its
  /// own loot-table rarity for battle drops) and Equipment Summoning
  /// (`EquipmentSummonSystem`, which rolls rarity from the gacha odds in
  /// `SummonSystem` instead). Keeping the magnitude formula in one place
  /// means a battle-dropped and a summoned item of the same slot/rarity/
  /// stage are worth exactly the same.
  static EquipmentItem item({
    required int stage,
    required Rarity rarity,
    EquipmentSlot? slot,
  }) {
    final resolvedSlot =
        slot ?? EquipmentSlot.values[_random.nextInt(EquipmentSlot.values.length)];
    final names = _namesBySlot[resolvedSlot] ?? const ['Dream Relic'];
    final name = names[_random.nextInt(names.length)];

    final double rarityMultiplier;
    switch (rarity) {
      case Rarity.common:
        rarityMultiplier = 1.0;
      case Rarity.uncommon:
        rarityMultiplier = 1.4;
      case Rarity.rare:
        rarityMultiplier = 1.9;
      case Rarity.epic:
        rarityMultiplier = 2.6;
      case Rarity.legendary:
        rarityMultiplier = 3.5;
      case Rarity.mythic:
        rarityMultiplier = 4.6;
      case Rarity.exclusive:
        rarityMultiplier = 4.6; // Equipment never actually rolls .exclusive; kept for switch exhaustiveness — see EquipmentSummonSystem.rollItem.
    }

    final magnitude = (4 + stage * 1.1) * rarityMultiplier;
    final rounded = magnitude.roundToDouble();
    Stats bonus;
    switch (resolvedSlot) {
      case EquipmentSlot.weapon:
        bonus = Stats(hp: 0, attack: rounded, defense: 0, speed: 0);
      case EquipmentSlot.charm:
        bonus = Stats(hp: rounded, attack: 0, defense: 0, speed: 0);
      case EquipmentSlot.cloak:
        bonus = Stats(hp: 0, attack: 0, defense: rounded, speed: 0);
      case EquipmentSlot.ring:
        bonus = Stats(hp: 0, attack: 0, defense: 0, speed: rounded);
    }

    return EquipmentItem(
      slot: resolvedSlot,
      name: name,
      rarity: rarity,
      level: 1,
      statBonus: bonus,
    );
  }

  static Rarity _rollRarity({required bool isBoss}) {
    final roll = _random.nextDouble();
    final table = isBoss
        ? const [
            (0.30, Rarity.rare),
            (0.60, Rarity.epic),
            (0.85, Rarity.legendary),
            (1.0, Rarity.mythic),
          ]
        : const [
            (0.55, Rarity.common),
            (0.82, Rarity.uncommon),
            (0.96, Rarity.rare),
            (1.0, Rarity.epic),
          ];

    for (final (threshold, rarity) in table) {
      if (roll <= threshold) return rarity;
    }
    return table.last.$2;
  }
}
