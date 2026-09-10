import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/element.dart';
import '../models/role.dart';
import 'combatant.dart';
import '../l10n/l10n.dart';

const _uuid = Uuid();

enum BattleOutcome { victory, defeat }

class BattleLogEntry {
  final String id = _uuid.v4();
  final String text;
  BattleLogEntry(this.text);
}

/// Fired whenever damage lands, so the UI can trigger a purely visual
/// impact (no text) without polling combatant HP every frame.
/// `attackerElement` lets the UI tint the impact effect to match, and
/// `attackerID` lets the attacker's own portrait play a lunge/strike
/// animation distinct from the target's hit-react. `isElementAdvantage`
/// mirrors the same rock-paper-scissors triangle (`GameElement.multiplier`)
/// so the UI can make a super-effective hit look bigger without recomputing
/// it from raw element values.
class HitEvent {
  final String id = _uuid.v4();
  final String attackerID;
  final String targetID;
  final int amount;
  final GameElement attackerElement;
  final bool isElementAdvantage;
  HitEvent({
    required this.attackerID,
    required this.targetID,
    required this.amount,
    required this.attackerElement,
    required this.isElementAdvantage,
  });
}

/// Fired whenever a boss mechanic actually triggers, so the UI can flash a
/// distinct cue (ring pulse + label) beyond the plain log line — otherwise
/// drain/shield/enrage etc. are easy to miss mid-battle.
class MechanicEvent {
  final String id = _uuid.v4();
  final String targetID;
  final BossMechanic mechanic;
  MechanicEvent({required this.targetID, required this.mechanic});
}

/// Fired whenever an ultimate is cast, so the UI can trigger a screen shake
/// and glow burst — rarer and more dramatic than a regular hit. `casterID`
/// additionally lets the caster's own party tile pop with a matching burst,
/// the same way `SkillEvent` does for the lighter Active Skill.
class UltimateEvent {
  final String id = _uuid.v4();
  final String casterID;
  UltimateEvent({required this.casterID});
}

/// Fired whenever an Active Skill is cast, so the UI can give the caster's
/// own tile a quick highlight — lighter than the Ultimate's screen-wide glow.
class SkillEvent {
  final String id = _uuid.v4();
  final String casterID;
  SkillEvent({required this.casterID});
}

/// Tick-driven auto-battle simulation. The UI calls `tick(dt:)` on a timer and
/// `activateUltimate(for:)` in response to taps; everything else — targeting,
/// damage, energy, win/loss — happens here so it stays unit-testable without
/// widgets. `ChangeNotifier` stands in for Swift's `@Observable`.
/// Mirrors GameCore/Combat/BattleEngine.swift exactly.
class BattleEngine extends ChangeNotifier {
  List<Combatant> combatants;
  final List<BattleLogEntry> _log = [];
  List<BattleLogEntry> get log => List.unmodifiable(_log);

  BattleOutcome? outcome;
  double elapsedTime = 0;
  HitEvent? lastHit;
  UltimateEvent? lastUltimate;
  SkillEvent? lastSkillUse;
  MechanicEvent? lastMechanicTrigger;

  final int stage;
  final bool isBossStage;

  /// Account-wide multiplier applied to every player unit's outgoing damage
  /// — fed by the Rebirth "Schaden" Soul upgrade (`GameState.soulDamageMult`).
  /// `1.0` for battles built without one (tests, older call sites).
  final double playerDamageMultiplier;

  /// Dungeon runs only — enemies fought one after another in this same
  /// battle once the current one falls, with player HP/energy carried over
  /// (no heal between waves). Empty for every ordinary single-enemy fight.
  final List<Combatant> _pendingWaves;

  /// 1-based index of the wave currently being fought, and the run's total
  /// wave count. Both are `1` for an ordinary single-enemy battle.
  int _currentWave = 1;
  int get currentWave => _currentWave;
  int get totalWaves => _currentWave + _pendingWaves.length;

  /// The enemy the player is currently up against — the first still-alive
  /// enemy (dungeon runs keep felled earlier-wave bodies in [combatants]).
  Combatant? get activeEnemy {
    for (final c in combatants) {
      if (!c.isPlayer && c.isAlive) return c;
    }
    return enemyUnits.isEmpty ? null : enemyUnits.last;
  }

  /// Injected so tests can make damage deterministic; defaults to a small
  /// +/-10% swing for UI "liveliness".
  double Function() varianceProvider;

  /// Base rate at which attack meters fill, tuned so a 1.0 speed unit
  /// attacks roughly once per second.
  static const double _attackRateScale = 1.0 / 100.0;

  static double _defaultVariance() {
    final r = Random();
    return 0.9 + r.nextDouble() * 0.2;
  }

  BattleEngine({
    required List<Combatant> playerUnits,
    required Combatant enemy,
    required this.stage,
    required this.isBossStage,
    this.playerDamageMultiplier = 1.0,
    List<Combatant> reinforcements = const [],
    double Function()? varianceProvider,
  })  : combatants = [...playerUnits, enemy],
        _pendingWaves = [...reinforcements],
        varianceProvider = varianceProvider ?? _defaultVariance;

  List<Combatant> get playerUnits => combatants.where((c) => c.isPlayer).toList();
  List<Combatant> get enemyUnits => combatants.where((c) => !c.isPlayer).toList();

  void tick(double dt) {
    if (outcome != null) return;
    elapsedTime += dt;

    for (var index = 0; index < combatants.length; index++) {
      if (!combatants[index].isAlive) continue;

      if (combatants[index].skillCooldownRemaining > 0) {
        combatants[index].skillCooldownRemaining =
            max(0, combatants[index].skillCooldownRemaining - dt);
      }

      if (combatants[index].stunTicks > 0) {
        combatants[index].stunTicks -= 1;
        continue;
      }

      combatants[index].attackProgress += dt * combatants[index].speed * _attackRateScale;
      if (combatants[index].attackProgress < 1.0) continue;
      combatants[index].attackProgress = 0;

      _performBasicAttack(index);
      if (outcome != null) {
        notifyListeners();
        return;
      }
    }
    notifyListeners();
  }

  // MARK: - Basic attacks

  void _performBasicAttack(int attackerIndex) {
    final attacker = combatants[attackerIndex];
    final targetIndex = _pickTarget(attacker);
    if (targetIndex == null) return;

    final damage = _resolveDamage(attacker: attacker, defender: combatants[targetIndex]);
    _applyDamage(damage,
        index: targetIndex,
        attackerID: attacker.id,
        attackerName: attacker.name,
        attackerElement: attacker.element);

    final ultimate = attacker.ultimate;
    if (ultimate != null) {
      combatants[attackerIndex].energy =
          min(ultimate.attacksToCharge, combatants[attackerIndex].energy + 1);
    }

    _resolveOutcomeIfNeeded();
  }

  int? _pickTarget(Combatant attacker) {
    final candidates = [
      for (var i = 0; i < combatants.length; i++)
        if (combatants[i].isPlayer != attacker.isPlayer && combatants[i].isAlive) i
    ];
    if (candidates.isEmpty) return null;
    if (attacker.isPlayer) {
      // Players focus the (single) enemy.
      return candidates.first;
    }
    // Enemy picks the lowest-HP-fraction ally — mildly punishes a glassy team.
    return candidates.reduce(
        (a, b) => combatants[a].hpFraction < combatants[b].hpFraction ? a : b);
  }

  double _resolveDamage({
    required Combatant attacker,
    required Combatant defender,
    double multiplier = 1.0,
  }) {
    final elementMultiplier = attacker.element.multiplier(defender.element);
    final playerBonus = attacker.isPlayer ? playerDamageMultiplier : 1.0;
    final raw = _effectiveAttack(attacker) * elementMultiplier * multiplier * playerBonus -
        defender.defense * 0.5;
    final variance = varianceProvider();
    return max(1, raw * variance);
  }

  /// Layers `lowHPAttackBonus` on top of the (possibly already-buffed)
  /// stored `attack` at the moment damage is computed, rather than
  /// mutating `attack` itself — the bonus tracks current HP live instead
  /// of being baked in once.
  double _effectiveAttack(Combatant combatant) {
    final bonus = combatant.lowHPAttackBonus;
    if (bonus == null) return combatant.attack;
    return combatant.attack * (1 + bonus * (1 - combatant.hpFraction));
  }

  void _applyDamage(
    double damage, {
    required int index,
    required String attackerID,
    required String attackerName,
    required GameElement attackerElement,
  }) {
    var dmg = damage;
    if (combatants[index].shieldCharges > 0) {
      dmg *= 0.4;
      combatants[index].shieldCharges -= 1;
      if (combatants[index].shieldCharges == 0) {
        _appendLog(L.blShieldShatters(combatants[index].name));
      }
    }

    final amount = dmg.round();
    final newHP = combatants[index].currentHP - dmg;
    final reviveFraction = combatants[index].reviveHPFraction;
    if (newHP <= 0 &&
        combatants[index].isPlayer &&
        reviveFraction != null &&
        !combatants[index].hasUsedRevive) {
      combatants[index].currentHP = combatants[index].maxHP * reviveFraction;
      combatants[index].hasUsedRevive = true;
      _appendLog(L.blRefusesToFall(combatants[index].name));
    } else {
      combatants[index].currentHP = max(0, newHP);
    }
    final isAdvantage = attackerElement.multiplier(combatants[index].element) > 1.0;
    lastHit = HitEvent(
      attackerID: attackerID,
      targetID: combatants[index].id,
      amount: amount,
      attackerElement: attackerElement,
      isElementAdvantage: isAdvantage,
    );
    _appendLog(L.blHits(attackerName, combatants[index].name, amount));
    if (!combatants[index].isAlive) {
      _appendLog(L.blFalls(combatants[index].name));
    }
    _triggerBossMechanicIfNeeded(index);
  }

  // MARK: - Ultimates

  bool activateUltimate(String id) {
    if (outcome != null) return false;
    final index = combatants.indexWhere((c) => c.id == id);
    if (index == -1 ||
        !combatants[index].isAlive ||
        !combatants[index].ultimateReady ||
        combatants[index].ultimate == null) {
      return false;
    }
    final ultimate = combatants[index].ultimate!;

    combatants[index].energy = 0;
    lastUltimate = UltimateEvent(casterID: combatants[index].id);
    _appendLog(L.blUnleashesUltimate(combatants[index].name, ultimate.name));

    switch (combatants[index].role) {
      case Role.healer:
        _healAllies(caster: combatants[index], multiplier: ultimate.damageMultiplier);
        break;
      case Role.support:
        _buffAllies(caster: combatants[index], multiplier: ultimate.damageMultiplier);
        break;
      case Role.control:
        _strikeEnemyAndStun(index, multiplier: ultimate.damageMultiplier);
        break;
      case Role.tank:
      case Role.damage:
        _strikeEnemy(index, multiplier: ultimate.damageMultiplier);
        break;
      case Role.guardian:
        _shieldAllies(caster: combatants[index], multiplier: ultimate.damageMultiplier);
        break;
    }

    _resolveOutcomeIfNeeded();
    notifyListeners();
    return true;
  }

  void _strikeEnemy(int index, {required double multiplier}) {
    final targetIndex = _pickTarget(combatants[index]);
    if (targetIndex == null) return;
    final damage = _resolveDamage(
        attacker: combatants[index], defender: combatants[targetIndex], multiplier: multiplier);
    _applyDamage(damage,
        index: targetIndex,
        attackerID: combatants[index].id,
        attackerName: combatants[index].name,
        attackerElement: combatants[index].element);
  }

  void _strikeEnemyAndStun(int index, {required double multiplier}) {
    final targetIndex = _pickTarget(combatants[index]);
    if (targetIndex == null) return;
    final damage = _resolveDamage(
        attacker: combatants[index], defender: combatants[targetIndex], multiplier: multiplier);
    _applyDamage(damage,
        index: targetIndex,
        attackerID: combatants[index].id,
        attackerName: combatants[index].name,
        attackerElement: combatants[index].element);
    if (combatants[targetIndex].isAlive) {
      combatants[targetIndex].stunTicks = 20;
      _appendLog(L.blFrozenStill(combatants[targetIndex].name));
    }
  }

  void _healAllies({required Combatant caster, required double multiplier}) {
    final healAmount = caster.attack * multiplier;
    for (var index = 0; index < combatants.length; index++) {
      if (combatants[index].isPlayer && combatants[index].isAlive) {
        combatants[index].currentHP =
            min(combatants[index].maxHP, combatants[index].currentHP + healAmount);
      }
    }
    _appendLog(L.blMoonlightHeal(healAmount.round()));
  }

  void _buffAllies({required Combatant caster, required double multiplier}) {
    for (var index = 0; index < combatants.length; index++) {
      if (combatants[index].isPlayer && combatants[index].isAlive) {
        combatants[index].attack *= (1 + (multiplier - 1) * 0.5);
      }
    }
    _appendLog(L.blEmpowersTeam(caster.name));
  }

  void _shieldAllies({required Combatant caster, required double multiplier}) {
    final charges = max(1, (3 * multiplier).round());
    for (var index = 0; index < combatants.length; index++) {
      if (combatants[index].isPlayer && combatants[index].isAlive) {
        combatants[index].shieldCharges = charges;
      }
    }
    _appendLog(L.blWallOfWater(caster.name));
  }

  // MARK: - Active Skill

  /// Player-only, quick tactical action on a short real-time cooldown —
  /// independent of the Ultimate's attack-count energy meter so the two
  /// buttons feel distinct (frequent tap vs. saved-up payoff).
  bool activateSkill(String id) {
    if (outcome != null) return false;
    final index = combatants.indexWhere((c) => c.id == id);
    if (index == -1 ||
        !combatants[index].isPlayer ||
        !combatants[index].isAlive ||
        !combatants[index].skillReady ||
        combatants[index].activeSkill == null) {
      return false;
    }
    final skill = combatants[index].activeSkill!;

    combatants[index].skillCooldownRemaining = skill.cooldownSeconds;
    lastSkillUse = SkillEvent(casterID: combatants[index].id);
    _appendLog(L.blUsesSkill(combatants[index].name, skill.name));

    switch (combatants[index].role) {
      case Role.healer:
        _healLowestAlly(caster: combatants[index], multiplier: skill.effectMultiplier);
        break;
      case Role.support:
        _buffSelf(index, multiplier: skill.effectMultiplier);
        break;
      case Role.tank:
      case Role.damage:
      case Role.control:
        _quickStrike(index, multiplier: skill.effectMultiplier);
        break;
      case Role.guardian:
        _quickStrikeAndSlow(index, multiplier: skill.effectMultiplier);
        break;
    }

    _resolveOutcomeIfNeeded();
    notifyListeners();
    return true;
  }

  void _quickStrike(int index, {required double multiplier}) {
    final targetIndex = _pickTarget(combatants[index]);
    if (targetIndex == null) return;
    final damage = _resolveDamage(
        attacker: combatants[index], defender: combatants[targetIndex], multiplier: multiplier);
    _applyDamage(damage,
        index: targetIndex,
        attackerID: combatants[index].id,
        attackerName: combatants[index].name,
        attackerElement: combatants[index].element);
  }

  void _healLowestAlly({required Combatant caster, required double multiplier}) {
    final allies = [
      for (var i = 0; i < combatants.length; i++)
        if (combatants[i].isPlayer && combatants[i].isAlive) i
    ];
    if (allies.isEmpty) return;
    final targetIndex =
        allies.reduce((a, b) => combatants[a].hpFraction < combatants[b].hpFraction ? a : b);
    final healAmount = caster.attack * multiplier;
    combatants[targetIndex].currentHP =
        min(combatants[targetIndex].maxHP, combatants[targetIndex].currentHP + healAmount);
    _appendLog(L.blSoothed(combatants[targetIndex].name, healAmount.round()));
  }

  void _buffSelf(int index, {required double multiplier}) {
    combatants[index].attack *= (1 + (multiplier - 1) * 0.5);
    _appendLog(L.blSteelsThemself(combatants[index].name));
  }

  void _quickStrikeAndSlow(int index, {required double multiplier}) {
    final targetIndex = _pickTarget(combatants[index]);
    if (targetIndex == null) return;
    final damage = _resolveDamage(
        attacker: combatants[index], defender: combatants[targetIndex], multiplier: multiplier);
    _applyDamage(damage,
        index: targetIndex,
        attackerID: combatants[index].id,
        attackerName: combatants[index].name,
        attackerElement: combatants[index].element);
    if (combatants[targetIndex].isAlive) {
      combatants[targetIndex].stunTicks = 10;
      _appendLog(L.blCaughtInCurrent(combatants[targetIndex].name));
    }
  }

  // MARK: - Boss mechanics

  /// Checked after every hit lands on a boss — `.selfHeal`/`.enrage` are
  /// one-shot HP-threshold triggers; `.shield` is handled entirely in
  /// `_applyDamage` and needs no per-hit check here.
  void _triggerBossMechanicIfNeeded(int index) {
    if (!combatants[index].isBoss ||
        !combatants[index].isAlive ||
        combatants[index].mechanicTriggered ||
        combatants[index].mechanic == null) {
      return;
    }
    final mechanic = combatants[index].mechanic!;

    switch (mechanic) {
      case BossMechanic.selfHeal:
        if (combatants[index].hpFraction > 0.5) return;
        final healAmount = combatants[index].maxHP * 0.25;
        combatants[index].currentHP =
            min(combatants[index].maxHP, combatants[index].currentHP + healAmount);
        combatants[index].mechanicTriggered = true;
        _appendLog(L.blHiddenReserves(combatants[index].name, healAmount.round()));
        break;
      case BossMechanic.enrage:
        if (combatants[index].hpFraction > 0.3) return;
        combatants[index].attack *= 1.5;
        combatants[index].mechanicTriggered = true;
        _appendLog(L.blRage(combatants[index].name));
        break;
      case BossMechanic.shield:
        break;
      case BossMechanic.drain:
        if (combatants[index].hpFraction > 0.5) return;
        for (var i = 0; i < combatants.length; i++) {
          if (combatants[i].isPlayer) combatants[i].energy = 0;
        }
        combatants[index].mechanicTriggered = true;
        _appendLog(L.blDrainsResolve(combatants[index].name));
        break;
      case BossMechanic.regenShield:
        if (combatants[index].hpFraction > 0.5) return;
        combatants[index].shieldCharges = 3;
        combatants[index].mechanicTriggered = true;
        _appendLog(L.blFreshShieldRoots(combatants[index].name));
        break;
      case BossMechanic.phaseShift:
        if (combatants[index].hpFraction > 0.5) return;
        combatants[index].attack *= 1.35;
        combatants[index].shieldCharges = 3;
        combatants[index].mechanicTriggered = true;
        _appendLog(L.blLightToShadow(combatants[index].name));
        break;
      case BossMechanic.sovereign:
        if (combatants[index].hpFraction > 0.4) return;
        final healAmount = combatants[index].maxHP * 0.2;
        combatants[index].currentHP =
            min(combatants[index].maxHP, combatants[index].currentHP + healAmount);
        combatants[index].attack *= 1.5;
        combatants[index].shieldCharges = 3;
        combatants[index].mechanicTriggered = true;
        _appendLog(L.blSovereignForm(combatants[index].name));
        break;
    }

    // Every case above either returns early (not yet triggered) or falls
    // through here having just set `mechanicTriggered` — except `.shield`,
    // which has no distinct "trigger moment" to flash.
    if (mechanic != BossMechanic.shield) {
      lastMechanicTrigger = MechanicEvent(targetID: combatants[index].id, mechanic: mechanic);
    }
  }

  // MARK: - Outcome

  void _resolveOutcomeIfNeeded() {
    if (outcome != null) return;
    if (enemyUnits.every((c) => !c.isAlive)) {
      // Dungeon run: send in the next wave instead of ending the battle.
      // Player HP/energy/cooldowns carry over untouched.
      if (_pendingWaves.isNotEmpty) {
        final next = _pendingWaves.removeAt(0);
        combatants.add(next);
        _currentWave += 1;
        _appendLog(L.blNextWave(next.name));
        return;
      }
      outcome = BattleOutcome.victory;
      _appendLog(L.blVictory);
    } else if (playerUnits.every((c) => !c.isAlive)) {
      outcome = BattleOutcome.defeat;
      _appendLog(L.blDefeat);
    }
  }

  void _appendLog(String text) {
    _log.add(BattleLogEntry(text));
    if (_log.length > 40) {
      _log.removeRange(0, _log.length - 40);
    }
  }
}
