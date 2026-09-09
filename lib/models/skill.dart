import 'stats.dart';

/// A Dreamkeeper's manually-triggered Ultimate. Basic attacks are automatic
/// and not modeled as a Skill — see combat/battle_engine.dart.
/// Mirrors GameCore/Models/Skill.swift exactly.
class UltimateSkill {
  final String name;
  final String description;

  /// Multiplier applied to the unit's attack stat when the ultimate lands.
  final double damageMultiplier;

  /// Basic attacks required to fill the energy meter before the ultimate is
  /// ready.
  final int attacksToCharge;

  const UltimateSkill({
    required this.name,
    required this.description,
    required this.damageMultiplier,
    required this.attacksToCharge,
  });
}

/// An always-on trait applied at battle start (kept simple for the MVP: a
/// flat stat modifier rather than a full effect system).
class PassiveTrait {
  final String name;
  final String description;
  final Stats statBonus;

  /// Fraction of max HP to revive at, once per battle, the instant this
  /// combatant would otherwise fall. `null` for every Dreamkeeper without
  /// this passive (Igo's Gezeitenwache is the only user today).
  final double? reviveHPFraction;

  /// Extra attack multiplier at 0 HP, scaling linearly down to 0 at full
  /// HP. `null` for every Dreamkeeper without this passive (Ames' Feuertaufe
  /// is the only user today).
  final double? lowHPAttackBonus;

  const PassiveTrait({
    required this.name,
    required this.description,
    required this.statBonus,
    this.reviveHPFraction,
    this.lowHPAttackBonus,
  });
}

/// A Dreamkeeper's manually-triggered mid-tier skill — quicker and weaker
/// than the Ultimate, on a short real-time cooldown instead of an
/// attack-count energy meter, so it reads as a distinct tactical button.
/// Player units only. `effectMultiplier` is applied to the caster's attack
/// stat and is reinterpreted per role exactly like
/// UltimateSkill.damageMultiplier is (see BattleEngine.activateSkill): a
/// strike multiplier for damage/tank/control, a heal multiplier for healer,
/// an attack-growth factor for support.
class ActiveSkill {
  final String name;
  final String description;
  final double effectMultiplier;
  final double cooldownSeconds;

  const ActiveSkill({
    required this.name,
    required this.description,
    required this.effectMultiplier,
    required this.cooldownSeconds,
  });
}
