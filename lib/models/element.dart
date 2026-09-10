import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// Mirrors GameCore/Models/Element.swift exactly — keep both in sync. Named
/// `GameElement` (not `Element`) to avoid colliding with Flutter's own
/// widgets-framework `Element` class.
enum GameElement {
  ember,
  tide,
  bloom,
  lunar,
  astral;

  String get displayName {
    switch (this) {
      case GameElement.ember:
        return L.elementEmber;
      case GameElement.tide:
        return L.elementTide;
      case GameElement.bloom:
        return L.elementBloom;
      case GameElement.lunar:
        return L.elementLunar;
      case GameElement.astral:
        return L.elementAstral;
    }
  }

  /// SF Symbol name kept for parity with the iOS catalog data; the Flutter
  /// UI layer maps these to Material icons (see ui/shared/sf_symbols.dart).
  String get symbol {
    switch (this) {
      case GameElement.ember:
        return 'flame.fill';
      case GameElement.tide:
        return 'drop.fill';
      case GameElement.bloom:
        return 'leaf.fill';
      case GameElement.lunar:
        return 'moon.stars.fill';
      case GameElement.astral:
        return 'sparkles';
    }
  }

  Color get color {
    switch (this) {
      case GameElement.ember:
        return const Color.fromRGBO(242, 107, 82, 1);
      case GameElement.tide:
        return const Color.fromRGBO(82, 158, 242, 1);
      case GameElement.bloom:
        return const Color.fromRGBO(115, 199, 102, 1);
      case GameElement.lunar:
        return const Color.fromRGBO(166, 153, 242, 1);
      case GameElement.astral:
        return const Color.fromRGBO(222, 191, 89, 1);
    }
  }

  /// Damage multiplier this element deals against [other].
  double multiplier(GameElement other) {
    const advantage = {
      GameElement.ember: GameElement.bloom,
      GameElement.bloom: GameElement.tide,
      GameElement.tide: GameElement.ember,
    };
    if (advantage[this] == other) return 1.25;
    if (advantage[other] == this) return 0.8;
    return 1.0;
  }
}
