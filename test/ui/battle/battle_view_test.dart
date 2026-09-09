// Exercises `BattleView` directly, given a hand-built `BattleEngine` — same
// "take the dependency straight as a constructor param" shape as every
// other screen's `_view_test.dart`, but here it buys determinism: a fixed
// `varianceProvider` and hand-picked stats mean the fight's outcome and
// tick count are predictable, unlike a real `GameState.makeBattleEngine()`
// engine (default random variance, real roster/enemy stats).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/combat/battle_engine.dart';
import 'package:dreamkeepers/combat/combatant.dart';
import 'package:dreamkeepers/models/element.dart';
import 'package:dreamkeepers/models/role.dart';
import 'package:dreamkeepers/models/skill.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/battle/battle_view.dart';

/// `TweenAnimationBuilder`/`AnimatedContainer` effects and the shake
/// controller never let `pumpAndSettle` converge (same rationale as every
/// other screen's `_settle`), so a bounded stepped pump is used throughout.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(milliseconds: 900)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Combatant _player({
  String id = 'p1',
  String name = 'Test Dreamkeeper',
  GameElement element = GameElement.ember,
  Role role = Role.damage,
  double maxHP = 100,
  double attack = 500, // Overwhelming — the enemy dies in ~1 basic attack.
  double defense = 10,
  double speed = 100,
  UltimateSkill? ultimate,
  ActiveSkill? activeSkill,
}) {
  return Combatant(
    id: id,
    name: name,
    element: element,
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
  );
}

Combatant _enemy({double maxHP = 40, double attack = 1, double defense = 0, double speed = 1}) {
  return Combatant(
    id: 'enemy',
    name: 'Test Foe',
    element: GameElement.tide,
    role: Role.tank,
    isPlayer: false,
    isBoss: false,
    maxHP: maxHP,
    currentHP: maxHP,
    attack: attack,
    defense: defense,
    speed: speed,
  );
}

Future<GameState> _pumpBattle(
  WidgetTester tester, {
  required BattleEngine engine,
  required ValueChanged<BattleEngine> onFinished,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: BattleView(engine: engine, gameState: gameState, onFinished: onFinished))),
  );
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the stage banner, enemy banner, and the party tile', (tester) async {
    final engine = BattleEngine(
      playerUnits: [_player()],
      enemy: _enemy(),
      stage: 1,
      isBossStage: false,
      varianceProvider: () => 1.0,
    );
    await _pumpBattle(tester, engine: engine, onFinished: (_) {});

    expect(find.textContaining('Whispering Meadow'), findsOneWidget);
    expect(find.text('Test Foe'), findsOneWidget);
    expect(find.text('Test Dreamkeeper'), findsOneWidget);
  });

  testWidgets('a boss stage banner reads "Boss"', (tester) async {
    final engine = BattleEngine(
      playerUnits: [_player()],
      enemy: _enemy(),
      stage: 5,
      isBossStage: true,
      varianceProvider: () => 1.0,
    );
    await _pumpBattle(tester, engine: engine, onFinished: (_) {});

    expect(find.textContaining('Boss'), findsWidgets);
  });

  testWidgets('ticking to victory shows the outcome overlay, and Continue calls onFinished', (tester) async {
    BattleEngine? finishedEngine;
    final engine = BattleEngine(
      playerUnits: [_player()],
      enemy: _enemy(),
      stage: 1,
      isBossStage: false,
      varianceProvider: () => 1.0,
    );
    await _pumpBattle(tester, engine: engine, onFinished: (e) => finishedEngine = e);

    // The overwhelming player attack (500) vs. the enemy's thin HP (40)
    // resolves on the very first basic attack — a couple of ticks is
    // already enough, but pump generously to stay robust to timing.
    await _settle(tester, total: const Duration(seconds: 3));

    expect(find.text('Victory!'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await _settle(tester);

    expect(finishedEngine, same(engine));
    expect(engine.outcome, BattleOutcome.victory);
  });

  testWidgets('ticking to defeat shows "Defeat..." in the outcome overlay', (tester) async {
    final engine = BattleEngine(
      playerUnits: [_player(maxHP: 1, attack: 1, defense: 0)],
      enemy: _enemy(maxHP: 999999, attack: 500, defense: 0, speed: 100),
      stage: 1,
      isBossStage: false,
      varianceProvider: () => 1.0,
    );
    await _pumpBattle(tester, engine: engine, onFinished: (_) {});

    await _settle(tester, total: const Duration(seconds: 3));

    expect(find.text('Defeat...'), findsOneWidget);
  });

  testWidgets('tapping a ready Ultimate button activates it', (tester) async {
    final ultimate = const UltimateSkill(name: 'Test Ultimate', description: '', damageMultiplier: 2, attacksToCharge: 1);
    final player = _player(ultimate: ultimate);
    player.energy = 1; // Already charged, so the button is enabled immediately.
    final engine = BattleEngine(
      playerUnits: [player],
      enemy: _enemy(maxHP: 999999), // Survives the ultimate so the battle doesn't end mid-assertion.
      stage: 1,
      isBossStage: false,
      varianceProvider: () => 1.0,
    );
    await _pumpBattle(tester, engine: engine, onFinished: (_) {});

    await tester.tap(find.bySemanticsLabel('Ultimate'));
    // Checked immediately, before any further ticking: a basic attack
    // landing afterward can recharge `energy` right back up (independent
    // of the ultimate cast just made), which would make a post-settle
    // assertion flaky.
    expect(player.energy, 0); // Spent by activateUltimate.
    expect(engine.lastUltimate, isNotNull);
    await _settle(tester);
  });

  testWidgets('tapping a ready Active Skill button activates it', (tester) async {
    final skill = const ActiveSkill(name: 'Test Skill', description: '', effectMultiplier: 1.5, cooldownSeconds: 5);
    final player = _player(activeSkill: skill);
    final engine = BattleEngine(
      playerUnits: [player],
      enemy: _enemy(maxHP: 999999),
      stage: 1,
      isBossStage: false,
      varianceProvider: () => 1.0,
    );
    await _pumpBattle(tester, engine: engine, onFinished: (_) {});

    await tester.tap(find.bySemanticsLabel('Active Skill'));
    await _settle(tester);

    expect(player.skillCooldownRemaining, greaterThan(0));
    expect(engine.lastSkillUse, isNotNull);
  });

  testWidgets('the speed and auto-battle controls toggle GameState', (tester) async {
    final engine = BattleEngine(
      playerUnits: [_player(attack: 1)],
      enemy: _enemy(maxHP: 999999),
      stage: 1,
      isBossStage: false,
      varianceProvider: () => 1.0,
    );
    final gameState = await _pumpBattle(tester, engine: engine, onFinished: (_) {});

    expect(gameState.battleSpeedMultiplier, 1.0);
    await tester.tap(find.bySemanticsLabel(RegExp('Battle speed')));
    await _settle(tester);
    expect(gameState.battleSpeedMultiplier, 2.0);

    expect(gameState.autoBattleEnabled, isFalse);
    await tester.tap(find.bySemanticsLabel(RegExp('Auto-Battle')));
    await _settle(tester);
    expect(gameState.autoBattleEnabled, isTrue);
  });
}
