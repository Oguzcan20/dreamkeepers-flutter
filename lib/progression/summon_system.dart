import 'dart:math';

import '../data/dreamkeeper_catalog.dart';
import '../models/dreamkeeper.dart';
import '../models/rarity.dart';

final _random = Random();

class SummonResult {
  final DreamkeeperDefinition definition;

  /// `false` for the very first copy of a species; every pull after that —
  /// including this one when `false` — lands in the roster as its own real
  /// instance, ready to feed into a manual fusion later.
  final bool isNew;

  const SummonResult({required this.definition, required this.isNew});
}

/// Standard Summon: odds are fixed and shown to the player up front (spec:
/// no hidden mechanics). Pulls draw a rarity first, then a random catalog
/// entry of that rarity — this stays correct as the catalog grows, it just
/// needs every new rarity tier represented in `rarityOdds`. Mirrors
/// GameCore/Progression/SummonSystem.swift exactly.
class SummonSystem {
  static const cost = 30;

  /// Bulk pull: pay for `multiPullPaidCount` and get `multiPullBonusCount`
  /// extra for free — the classic "10+1" gacha bundle, priced as exactly
  /// 10 single pulls with no separate discount math to keep straight.
  static const multiPullPaidCount = 10;
  static const multiPullBonusCount = 1;
  static int get multiPullTotalCount => multiPullPaidCount + multiPullBonusCount;
  static int get multiPullCost => cost * multiPullPaidCount;

  /// Rarity -> probability. Must sum to 1.0 and cover every rarity actually
  /// present in the catalog, or those entries become unreachable.
  ///
  /// `.exclusive` (Igo/Ames) sits at 0.01% per character, 0.02% combined —
  /// taken out of `.common` so the table still sums to 1.0. It never
  /// participates in pity (see `rollRarityWithPity`, which only ever raises
  /// a roll to `.epic`/`.legendary`) and the caller re-rolls it to
  /// `.mythic` once both exclusive characters are owned.
  static const List<(Rarity, double)> rarityOdds = [
    (Rarity.common, 0.2498),
    (Rarity.uncommon, 0.335),
    (Rarity.rare, 0.27),
    (Rarity.epic, 0.13),
    (Rarity.legendary, 0.01),
    (Rarity.mythic, 0.005),
    (Rarity.exclusive, 0.0002),
  ];

  /// Draws a rarity from `rarityOdds` alone — the shared building block
  /// behind `rollDefinition` below and `EquipmentSummonSystem.rollItem`, so
  /// both summon types roll off the exact same cumulative-threshold logic
  /// instead of two copies that could quietly drift apart.
  static Rarity rollRarity({double? roll}) {
    final r = roll ?? _random.nextDouble();
    var cumulative = 0.0;
    for (final (rarity, weight) in rarityOdds) {
      cumulative += weight;
      if (r < cumulative) return rarity;
    }
    return rarityOdds.last.$1;
  }

  /// Pity floors so a long stretch of bad luck always has a ceiling: an
  /// Epic+ is guaranteed within `epicPityThreshold` pulls of the last one,
  /// and a Legendary+ within `legendaryPityThreshold`. Both counters live
  /// in the save (shared by Dreamkeeper and Equipment Summoning) and are
  /// the caller's job to update from the returned rarity; this function
  /// only reads them to decide whether to raise the floor on this one roll.
  static const epicPityThreshold = 10;
  static const legendaryPityThreshold = 75;

  /// Rolls a rarity the normal way, then raises it to the pity floor (if
  /// any) that this pull would otherwise miss. A roll that's already at or
  /// above a floor is left alone — pity only ever helps, never hurts.
  static Rarity rollRarityWithPity({
    required int pullsSinceEpic,
    required int pullsSinceLegendary,
    double? roll,
  }) {
    var rarity = rollRarity(roll: roll);
    if (pullsSinceLegendary + 1 >= legendaryPityThreshold && rarity < Rarity.legendary) {
      rarity = Rarity.legendary;
    } else if (pullsSinceEpic + 1 >= epicPityThreshold && rarity < Rarity.epic) {
      rarity = Rarity.epic;
    }
    return rarity;
  }

  static DreamkeeperDefinition rollDefinitionForRarity(DreamkeeperCatalog catalog, Rarity rarity) {
    final candidates = catalog.definitions
        .where((d) => d.rarity == rarity && d.isSummonable)
        .toList();
    if (candidates.isNotEmpty) {
      return candidates[_random.nextInt(candidates.length)];
    }
    // Ultimate Olf (isSummonable: false) must never be handed out by the
    // gacha at any rarity, even as this rarity-band-empty fallback — so the
    // fallback pool is filtered the same way. Mirrors
    // `SummonSystem.rollDefinition(from:rarity:)` in
    // GameCore/Progression/SummonSystem.swift.
    final summonable = catalog.definitions.where((d) => d.isSummonable).toList();
    final pool = summonable.isNotEmpty ? summonable : catalog.definitions;
    return pool[_random.nextInt(pool.length)];
  }

  static DreamkeeperDefinition rollDefinition(DreamkeeperCatalog catalog, {double? roll}) =>
      rollDefinitionForRarity(catalog, rollRarity(roll: roll));
}
