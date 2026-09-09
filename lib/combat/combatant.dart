import 'package:flutter/material.dart';

import '../models/element.dart';
import '../models/role.dart';
import '../models/skill.dart';

/// A world boss's signature twist — see `BattleEngine.triggerBossMechanicIfNeeded`
/// and `applyDamage` for where each one actually fires.
/// Mirrors GameCore/Combat/Combatant.swift's `BossMechanic` exactly.
enum BossMechanic {
  /// Heals for 25% max HP once, the first time HP drops to/below 50%.
  selfHeal,
  /// +50% attack once, the first time HP drops to/below 30%.
  enrage,
  /// Reduces incoming damage by 60% for its first 3 hits taken; purely
  /// data-driven via `shieldCharges`, so this case is mostly a content tag.
  shield,
  /// Resets every player unit's ultimate energy to 0 once, the first time
  /// HP drops to/below 50% (Morvane: "entzieht Dreamkeepern Energie").
  drain,
  /// Grants 3 fresh shield charges once, the first time HP drops to/below
  /// 50% — a mid-fight shield rather than one active from the start
  /// (Verdantor: "Regenerationsschild").
  regenShield,
  /// +35% attack and 3 fresh shield charges together once, the first time
  /// HP drops to/below 50% — the light/shadow turn (Noctyra: "wechselt
  /// zwischen Licht- und Schattenphase").
  phaseShift,
  /// Heals for 20% max HP, +50% attack, and 3 fresh shield charges all at
  /// once, the first time HP drops to/below 40% — the final boss's one
  /// big turn (Elyndor: "mehrere Phasen... finale Ultimate-Phase").
  sovereign;

  /// Short banner text for the mechanic-trigger flash — kept on the enum so
  /// the label/icon pairing lives in one data-driven place instead of a
  /// switch buried in the view layer.
  String get triggerLabel {
    switch (this) {
      case BossMechanic.selfHeal:
        return 'Healed!';
      case BossMechanic.enrage:
        return 'Enraged!';
      case BossMechanic.shield:
        return 'Shielded!';
      case BossMechanic.drain:
        return 'Drained!';
      case BossMechanic.regenShield:
        return 'Shielded!';
      case BossMechanic.phaseShift:
        return 'Phase Shift!';
      case BossMechanic.sovereign:
        return 'Awakened!';
    }
  }

  String get triggerSymbol {
    switch (this) {
      case BossMechanic.selfHeal:
        return 'cross.case.fill';
      case BossMechanic.enrage:
        return 'flame.fill';
      case BossMechanic.shield:
        return 'shield.fill';
      case BossMechanic.drain:
        return 'bolt.slash.fill';
      case BossMechanic.regenShield:
        return 'shield.lefthalf.filled';
      case BossMechanic.phaseShift:
        return 'circle.lefthalf.filled';
      case BossMechanic.sovereign:
        return 'crown.fill';
    }
  }

  Color get triggerColor {
    switch (this) {
      case BossMechanic.selfHeal:
        return Colors.green;
      case BossMechanic.enrage:
        return Colors.red;
      case BossMechanic.shield:
        return const Color.fromRGBO(120, 170, 230, 1); // Theme.softBlue
      case BossMechanic.drain:
        return Colors.purple;
      case BossMechanic.regenShield:
        return const Color.fromRGBO(120, 170, 230, 1);
      case BossMechanic.phaseShift:
        return const Color.fromRGBO(150, 110, 220, 1); // Theme.violet
      case BossMechanic.sovereign:
        return const Color.fromRGBO(212, 175, 55, 1); // Theme.gold
    }
  }
}

/// One participant inside a live battle — player Dreamkeeper or enemy.
/// Distinct from `DreamkeeperInstance`: this is transient combat state, not
/// something that gets saved. Mirrors GameCore/Combat/Combatant.swift
/// exactly. A mutable class (not a Dart `class` with `final` fields) because
/// Swift's `struct` + `var` fields translate to plain mutable fields here —
/// `BattleEngine` mutates combatants in place by list index, same as Swift's
/// `combatants[index].field = ...` on a `[Combatant]` array.
class Combatant {
  final String id;
  final String name;
  final GameElement element;
  final Role role;
  final bool isPlayer;
  final bool isBoss;

  /// Species id for player units (`DreamkeeperInstance.definitionID`), used
  /// only by the UI to render the Zwillingsbund badge — `BattleEngine`
  /// itself never dispatches on this, only on `role`/passive data.
  String? definitionID;

  final double maxHP;
  double currentHP;

  /// Mutable: buffs (Ultimate/Active Skill/boss enrage) modify this in
  /// place.
  double attack;

  final double defense;
  final double speed;
  final UltimateSkill? ultimate;

  /// Player units only — see `ActiveSkill` doc comment for the tactical
  /// role it plays alongside the Ultimate.
  ActiveSkill? activeSkill;

  /// Overrides the default element/role icon for named enemy variety.
  /// `null` falls back to today's behavior (element symbol, or role symbol
  /// for players).
  String? symbol;

  /// Overrides `name` for portrait art lookup only (display name stays
  /// `name`). Used by the Arena Tower: a rival's displayed identity is a
  /// flavor team name, which never matches an imageset — but the rival's
  /// combat stats are borrowed wholesale from a real `DreamkeeperDefinition`,
  /// which already has real portrait art. Setting this to that definition's
  /// `name` lets the Arena banner show that real portrait while still
  /// displaying the flavor team name. `null` everywhere else preserves
  /// today's `name`-based lookup.
  String? portraitOverrideName;

  /// Boss units only.
  BossMechanic? mechanic;

  /// Guards `.selfHeal`/`.enrage` so they fire exactly once per battle.
  bool mechanicTriggered;

  /// While > 0, incoming damage is reduced; decrements per hit taken.
  int shieldCharges;

  /// Fraction of max HP to revive at, once per battle, the instant this
  /// combatant would otherwise fall — see `PassiveTrait.reviveHPFraction`.
  double? reviveHPFraction;

  /// Guards `reviveHPFraction` so it fires exactly once per battle.
  bool hasUsedRevive;

  /// Extra attack multiplier at 0 HP, scaling linearly down to 0 at full
  /// HP — see `PassiveTrait.lowHPAttackBonus` and `BattleEngine.effectiveAttack`.
  double? lowHPAttackBonus;

  /// 0...1 progress toward the next basic attack.
  double attackProgress;

  /// 0...attacksToCharge basic attacks landed since last ultimate.
  int energy;

  /// Ticks remaining where this combatant cannot act (Control ultimate).
  int stunTicks;

  /// Seconds remaining before the Active Skill can be used again.
  double skillCooldownRemaining;

  Combatant({
    required this.id,
    required this.name,
    required this.element,
    required this.role,
    required this.isPlayer,
    required this.isBoss,
    this.definitionID,
    required this.maxHP,
    required this.currentHP,
    required this.attack,
    required this.defense,
    required this.speed,
    this.ultimate,
    this.activeSkill,
    this.symbol,
    this.portraitOverrideName,
    this.mechanic,
    this.mechanicTriggered = false,
    this.shieldCharges = 0,
    this.reviveHPFraction,
    this.hasUsedRevive = false,
    this.lowHPAttackBonus,
    this.attackProgress = 0,
    this.energy = 0,
    this.stunTicks = 0,
    this.skillCooldownRemaining = 0,
  });

  bool get isAlive => currentHP > 0;

  bool get ultimateReady {
    final u = ultimate;
    if (u == null) return false;
    return energy >= u.attacksToCharge;
  }

  bool get skillReady {
    if (activeSkill == null) return false;
    return skillCooldownRemaining <= 0;
  }

  double get hpFraction => maxHP > 0 ? (currentHP / maxHP).clamp(0, double.infinity) : 0;
}
