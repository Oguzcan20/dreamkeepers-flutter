import 'package:flutter/material.dart';

/// Mirrors GameCore/Models/Rarity.swift exactly — keep both in sync.
enum Rarity implements Comparable<Rarity> {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic,

  /// The top tier, permanently capped at exactly two catalog entries (Igo
  /// and Ames) — see TwinBond and DreamkeeperCatalog. Not a normal power
  /// step above Mythic so much as a distinct, one-of-a-kind class.
  exclusive;

  int get _sortOrder {
    switch (this) {
      case Rarity.common:
        return 0;
      case Rarity.uncommon:
        return 1;
      case Rarity.rare:
        return 2;
      case Rarity.epic:
        return 3;
      case Rarity.legendary:
        return 4;
      case Rarity.mythic:
        return 5;
      case Rarity.exclusive:
        return 6;
    }
  }

  @override
  int compareTo(Rarity other) => _sortOrder.compareTo(other._sortOrder);

  bool operator <(Rarity other) => _sortOrder < other._sortOrder;
  bool operator <=(Rarity other) => _sortOrder <= other._sortOrder;
  bool operator >(Rarity other) => _sortOrder > other._sortOrder;
  bool operator >=(Rarity other) => _sortOrder >= other._sortOrder;

  String get displayName {
    final raw = name;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  /// The two-stop palette this rarity draws from — brighter and richer as
  /// rarity climbs. [gradient] and [primaryColor] both derive from this so
  /// every rarity-tinted effect stays visually consistent with one source
  /// of truth.
  List<Color> get _gradientColors {
    switch (this) {
      case Rarity.common:
        return [const Color.fromRGBO(140, 140, 140, 1), const Color.fromRGBO(102, 102, 102, 1)];
      case Rarity.uncommon:
        return [const Color.fromRGBO(102, 191, 128, 1), const Color.fromRGBO(64, 140, 89, 1)];
      case Rarity.rare:
        return [const Color.fromRGBO(89, 153, 242, 1), const Color.fromRGBO(51, 102, 204, 1)];
      case Rarity.epic:
        return [const Color.fromRGBO(179, 102, 242, 1), const Color.fromRGBO(128, 51, 204, 1)];
      case Rarity.legendary:
        return [const Color.fromRGBO(250, 191, 64, 1), const Color.fromRGBO(230, 128, 38, 1)];
      case Rarity.mythic:
        return [const Color.fromRGBO(255, 102, 179, 1), const Color.fromRGBO(153, 76, 242, 1)];
      case Rarity.exclusive:
        return [const Color.fromRGBO(255, 219, 102, 1), const Color.fromRGBO(20, 20, 26, 1)];
    }
  }

  LinearGradient get gradient => LinearGradient(
        colors: _gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// A single representative color for this rarity — used where a flat
  /// tint reads better than a gradient (glows, particle bursts).
  Color get primaryColor => _gradientColors[0];

  bool get glows => this >= Rarity.epic;

  /// How many burst particles a summon reveal should spawn for this
  /// rarity — a bigger, busier flourish the rarer the pull.
  int get summonBurstParticleCount {
    switch (this) {
      case Rarity.common:
        return 0;
      case Rarity.uncommon:
        return 4;
      case Rarity.rare:
        return 6;
      case Rarity.epic:
        return 9;
      case Rarity.legendary:
        return 13;
      case Rarity.mythic:
        return 18;
      case Rarity.exclusive:
        return 24;
    }
  }
}
