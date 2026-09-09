import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:dreamkeepers/combat/battle_engine.dart';
import 'package:dreamkeepers/combat/combatant.dart';
import 'package:dreamkeepers/models/element.dart';
import 'package:dreamkeepers/models/role.dart';
import 'package:dreamkeepers/models/skill.dart';

const _uuid = Uuid();

Combatant _player({
  double attack = 20,
  double defense = 5,
  double speed = 50,
  double maxHP = 100,
  Role role = Role.damage,
  UltimateSkill? ultimate,
  ActiveSkill? activeSkill,
  double? reviveHPFraction,
  double? lowHPAttackBonus,
}) {
  return Combatant(
    id: _uuid.v4(),
    name: 'Player',
    element: GameElement.ember,
    role: role,
    isPlayer: true,
    isBoss: false,
    maxHP: maxHP,
    currentHP: maxHP,
    attack: attack,
    defense: defense,
    speed: speed,
    ultimate: ultimate,
    activeSkill: activeSkill,
    reviveHPFraction: reviveHPFraction,
    lowHPAttackBonus: lowHPAttackBonus,
  );
}

Combatant _enemy({
  double attack = 10,
  double defense = 3,
  double speed = 50,
  double maxHP = 100,
  bool isBoss = false,
  BossMechanic? mechanic,
  int shieldCharges = 0,
}) {
  return Combatant(
    id: _uuid.v4(),
    name: 'Enemy',
    element: GameElement.bloom,
    role: Role.tank,
    isPlayer: false,
    isBoss: isBoss,
    maxHP: maxHP,
    currentHP: maxHP,
    attack: attack,
    defense: defense,
    speed: speed,
    mechanic: mechanic,
    shieldCharges: shieldCharges,
  );
}

void main() {
  group('BattleEngine basic attacks', () {
    test('a fast attacker lands a basic attack and damages the enemy', () {
      final engine = BattleEngine(
        playerUnits: [_player(speed: 1000)],
        enemy: _enemy(maxHP: 1000),
        stage: 1,
        isBossStage: false,
        varianceProvider: () => 1.0,
      );
      engine.tick(2.0); // plenty of time to fill the attack meter
      expect(engine.combatants.last.currentHP, lessThan(1000));
      expect(engine.log, isNotEmpty);
    });

    test('victory is declared when the enemy HP reaches 0', () {
      final engine = BattleEngine(
        playerUnits: [_player(attack: 1000, speed: 1000)],
        enemy: _enemy(maxHP: 10),
        stage: 1,
        isBossStage: false,
        varianceProvider: () => 1.0,
      );
      engine.tick(2.0);
      expect(engine.outcome, BattleOutcome.victory);
    });

    test('defeat is declared when all player units fall', () {
      final engine = BattleEngine(
        playerUnits: [_player(maxHP: 5, attack: 0, speed: 1000)],
        enemy: _enemy(attack: 1000, speed: 1000, maxHP: 100000),
        stage: 1,
        isBossStage: false,
        varianceProvider: () => 1.0,
      );
      engine.tick(2.0);
      expect(engine.outcome, BattleOutcome.defeat);
    });
  });

  group('Element advantage', () {
    test('ember deals bonus damage against bloom', () {
      expect(GameElement.ember.multiplier(GameElement.bloom), 1.25);
      expect(GameElement.bloom.multiplier(GameElement.ember), 0.8);
      // Triangle is ember > bloom > tide > ember, so tide beats ember: ember
      // is on the *weak* side of this matchup, not neutral.
      expect(GameElement.ember.multiplier(GameElement.tide), 0.8);
      expect(GameElement.tide.multiplier(GameElement.ember), 1.25);
      expect(GameElement.ember.multiplier(GameElement.lunar), 1.0);
    });
  });

  group('Guardian role (Igo/Zwillingsbund kit)', () {
    test('ultimate shields the whole player team', () {
      final ultimate = const UltimateSkill(
          name: 'Flutwand', description: '', damageMultiplier: 1.0, attacksToCharge: 1);
      final guardian = _player(role: Role.guardian, ultimate: ultimate);
      guardian.energy = 1; // ready
      final ally = _player();
      final engine = BattleEngine(
        playerUnits: [guardian, ally],
        enemy: _enemy(),
        stage: 1,
        isBossStage: false,
      );
      final activated = engine.activateUltimate(guardian.id);
      expect(activated, isTrue);
      expect(engine.combatants.firstWhere((c) => c.id == guardian.id).shieldCharges, greaterThan(0));
      expect(engine.combatants.firstWhere((c) => c.id == ally.id).shieldCharges, greaterThan(0));
    });

    test('active skill strikes and slows the enemy', () {
      final skill = const ActiveSkill(
          name: 'Strömungsriss', description: '', effectMultiplier: 1.3, cooldownSeconds: 7);
      final guardian = _player(role: Role.guardian, activeSkill: skill);
      final enemy = _enemy(maxHP: 1000);
      final engine = BattleEngine(
        playerUnits: [guardian],
        enemy: enemy,
        stage: 1,
        isBossStage: false,
        varianceProvider: () => 1.0,
      );
      engine.activateSkill(guardian.id);
      final target = engine.combatants.firstWhere((c) => c.id == enemy.id);
      expect(target.currentHP, lessThan(1000));
      expect(target.stunTicks, 10);
    });
  });

  group('Passive traits (Igo revive / Ames low-HP attack bonus)', () {
    test('reviveHPFraction revives a player once instead of letting them fall', () {
      // Player never acts (speed 0); enemy is tuned to land exactly one
      // lethal hit on the very first tick, so the revive check is isolated.
      final reviver = _player(maxHP: 100, speed: 0, reviveHPFraction: 0.3);
      reviver.currentHP = 5;
      final engine = BattleEngine(
        playerUnits: [reviver],
        enemy: _enemy(attack: 1000, speed: 1000, defense: 0),
        stage: 1,
        isBossStage: false,
        varianceProvider: () => 1.0,
      );
      engine.tick(0.11); // enemy attackProgress = 0.11 * 1000 * 0.01 = 1.1
      final self = engine.combatants.firstWhere((c) => c.id == reviver.id);
      expect(self.hasUsedRevive, isTrue);
      expect(self.currentHP, 30); // maxHP(100) * reviveHPFraction(0.3)

      // A second lethal hit should not revive again.
      engine.tick(0.11);
      final selfAgain = engine.combatants.firstWhere((c) => c.id == reviver.id);
      expect(selfAgain.currentHP, 0);
      expect(engine.outcome, BattleOutcome.defeat);
    });

    test('lowHPAttackBonus scales effective attack up as HP drops', () {
      final low = _player(attack: 100, maxHP: 100, speed: 100000, lowHPAttackBonus: 0.6);
      low.currentHP = 1; // near death -> near-full bonus
      final full = _player(attack: 100, maxHP: 100, speed: 100000, lowHPAttackBonus: 0.6);
      // full HP -> no bonus (left at maxHP by the builder)

      final engineLow = BattleEngine(
        playerUnits: [low],
        enemy: _enemy(maxHP: 100000, defense: 0, speed: 1),
        stage: 1,
        isBossStage: false,
        varianceProvider: () => 1.0,
      );
      final engineFull = BattleEngine(
        playerUnits: [full],
        enemy: _enemy(maxHP: 100000, defense: 0, speed: 1),
        stage: 1,
        isBossStage: false,
        varianceProvider: () => 1.0,
      );
      engineLow.tick(1.0);
      engineFull.tick(1.0);

      final lowEnemyHP = engineLow.combatants.last.currentHP;
      final fullEnemyHP = engineFull.combatants.last.currentHP;
      // The near-death attacker should have dealt strictly more damage.
      expect(lowEnemyHP, lessThan(fullEnemyHP));
    });
  });

  group('Boss mechanics', () {
    test('enrage boosts attack once HP drops to/below 30%', () {
      // Enemy never acts (speed 0) so only the player's single hit matters.
      final boss = _enemy(
          maxHP: 1000, defense: 0, speed: 0, isBoss: true, mechanic: BossMechanic.enrage, attack: 10);
      boss.currentHP = 250; // 25% <= 30%
      final engine = BattleEngine(
        playerUnits: [_player(attack: 1, speed: 1000)],
        enemy: boss,
        stage: 1,
        isBossStage: true,
        varianceProvider: () => 1.0,
      );
      engine.tick(0.11); // player attackProgress = 0.11 * 1000 * 0.01 = 1.1
      final target = engine.combatants.last;
      expect(target.mechanicTriggered, isTrue);
      expect(target.attack, greaterThan(10));
    });
  });
}
