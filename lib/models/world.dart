import 'package:flutter/material.dart';

import 'element.dart';

/// A campaign chapter: a fixed run of stages ending in a boss. Global stage
/// numbers stay contiguous across worlds (world 2 starts where world 1 ends)
/// so existing boss-detection (`stage % stagesPerWorld == 0`) keeps working.
/// Mirrors GameCore/Models/World.swift exactly.
class World {
  static const stagesPerWorld = 5;

  final int id;
  final String name;
  final String description;
  final Color accentColor;
  final List<GameElement> elementBias;
  final String bossName;

  /// Locale-invariant English counterpart of [bossName], for `MonsterArt`
  /// lookups (via `Combatant.portraitOverrideName`) — see `LEn` in
  /// `l10n.dart`. `Monster_<Name>.jpg` art is authored once in English, so
  /// looking it up with the localized [bossName] silently fails outside
  /// English.
  final String artBossName;

  /// Extra stat multiplier stacked on top of the linear per-stage curve —
  /// creates a felt jump between difficulty tiers instead of pure smooth
  /// growth.
  final double difficultyMultiplier;

  const World({
    required this.id,
    required this.name,
    required this.description,
    required this.accentColor,
    required this.elementBias,
    required this.bossName,
    required this.artBossName,
    this.difficultyMultiplier = 1.0,
  });

  int get firstStage => (id - 1) * World.stagesPerWorld + 1;
  int get lastStage => id * World.stagesPerWorld;

  /// Inclusive stage range this world spans.
  RangeInclusive get stages => RangeInclusive(firstStage, lastStage);
}

/// Minimal stand-in for Swift's `ClosedRange<Int>` where only containment
/// and bounds are needed.
class RangeInclusive {
  final int start;
  final int end;
  const RangeInclusive(this.start, this.end);
  bool contains(int value) => value >= start && value <= end;
}
