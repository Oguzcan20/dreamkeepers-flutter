// Exercises `BattleResultView` directly, given a hand-built
// `BattleResultSummary` — same "take the dependency straight as a
// constructor param" shape as every other screen's `_view_test.dart`. Covers
// the header per outcome, the reward cards' presence/absence, the
// "Next Battle" footer's conditional appearance, and both footer actions'
// navigation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/combat/battle_engine.dart';
import 'package:dreamkeepers/data/dreamkeeper_catalog.dart';
import 'package:dreamkeepers/data/world_catalog.dart';
import 'package:dreamkeepers/models/equipment.dart';
import 'package:dreamkeepers/models/rarity.dart';
import 'package:dreamkeepers/models/stats.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/battle_result/battle_result_view.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';

/// Same rationale as every other screen's `_settle`: `_StaggeredCard`'s
/// delayed reveal and the gold/EXP `TweenAnimationBuilder` count-up never
/// let `pumpAndSettle` converge cleanly within a bounded time budget.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 1)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<GameState> _pumpResult(
  WidgetTester tester, {
  required BattleResultSummary summary,
  required ValueChanged<AppRoute> onNavigate,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: BattleResultView(summary: summary, gameState: gameState, onNavigate: onNavigate))),
  );
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('a plain victory shows Victory!, rewards, and both footer buttons', (tester) async {
    AppRoute? lastRoute;
    const summary = BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: 1,
      wasBoss: false,
      goldGained: 120,
      expGained: 40,
      levelUps: [],
    );
    await _pumpResult(tester, summary: summary, onNavigate: (route) => lastRoute = route);

    expect(find.text('Victory!'), findsOneWidget);
    expect(find.text('Stage 1'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('+120'), findsOneWidget);
    expect(find.text('+40'), findsOneWidget);
    expect(find.text('Dream Haven'), findsOneWidget);
    expect(find.text('Next Battle'), findsOneWidget);

    await tester.tap(find.text('Next Battle'));
    await _settle(tester);
    expect(lastRoute, isA<BattleRoute>());
  });

  testWidgets('a boss victory reads "Boss Defeated!"', (tester) async {
    const summary = BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: 5,
      wasBoss: true,
      goldGained: 500,
      expGained: 200,
      levelUps: [],
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Boss Defeated!'), findsOneWidget);
  });

  testWidgets('the last stage\'s victory has no Next Battle button', (tester) async {
    AppRoute? lastRoute;
    final summary = BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: WorldCatalog.totalStages,
      wasBoss: true,
      goldGained: 1000,
      expGained: 500,
      levelUps: const [],
    );
    // A fresh save's `currentStage` starts at 1, so `isCampaignComplete`
    // needs to be forced true the same way a real campaign-clearing win
    // would leave it, for `BattleResultView` to read `isCampaignComplete`
    // as true and drop the "Next Battle" option.
    final gameState = await () async {
      SharedPreferences.setMockInitialValues({});
      final gs = await GameState.create();
      gs.save.currentStage = WorldCatalog.totalStages + 1;
      return gs;
    }();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: BattleResultView(summary: summary, gameState: gameState, onNavigate: (route) => lastRoute = route)),
      ),
    );
    await _settle(tester);

    expect(find.text('Next Battle'), findsNothing);
    expect(find.text('Return to Dream Haven'), findsOneWidget);

    await tester.tap(find.text('Return to Dream Haven'));
    await _settle(tester);
    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('a defeat shows Defeat..., a message card, and a single Continue button', (tester) async {
    AppRoute? lastRoute;
    const summary = BattleResultSummary(
      outcome: BattleOutcome.defeat,
      stage: 3,
      wasBoss: false,
      goldGained: 0,
      expGained: 0,
      levelUps: [],
    );
    await _pumpResult(tester, summary: summary, onNavigate: (route) => lastRoute = route);

    expect(find.text('Defeat...'), findsOneWidget);
    expect(find.text('Next Battle'), findsNothing);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await _settle(tester);
    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('a perfect clear shows the bonus-gold banner', (tester) async {
    const summary = BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: 1,
      wasBoss: false,
      goldGained: 100,
      expGained: 30,
      levelUps: [],
      isPerfectClear: true,
      perfectClearBonusGold: 25,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.textContaining('Perfect Clear'), findsOneWidget);
    expect(find.textContaining('+25'), findsOneWidget);
  });

  testWidgets('an account level-up shows its own card', (tester) async {
    const summary = BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: 1,
      wasBoss: false,
      goldGained: 100,
      expGained: 30,
      levelUps: [],
      accountLevelUp: AccountLevelUp(oldLevel: 4, newLevel: 5),
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Account Level 4 → 5'), findsOneWidget);
  });

  testWidgets('dropped equipment shows its own card', (tester) async {
    final summary = BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: 1,
      wasBoss: false,
      goldGained: 100,
      expGained: 30,
      levelUps: const [],
      droppedEquipment: EquipmentItem(
        slot: EquipmentSlot.weapon,
        name: 'Test Blade',
        rarity: Rarity.rare,
        level: 1,
        statBonus: const Stats(hp: 0, attack: 5, defense: 0, speed: 0),
      ),
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Test Blade'), findsOneWidget);
    expect(find.text('Rare'), findsOneWidget);
  });

  testWidgets('level-ups and a new recruit each show their own card', (tester) async {
    final recruit = DreamkeeperCatalog.starter.definitions.first;
    final summary = BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: 1,
      wasBoss: false,
      goldGained: 100,
      expGained: 30,
      levelUps: const [
        LevelUpSummary(
          name: 'Test Dreamkeeper',
          oldLevel: 2,
          newLevel: 3,
          statsBefore: Stats(hp: 100, attack: 10, defense: 5, speed: 10),
          statsAfter: Stats(hp: 110, attack: 12, defense: 6, speed: 10),
        ),
      ],
      newRecruit: recruit,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Level Up!'), findsOneWidget);
    expect(find.text('Lv.2 → 3'), findsOneWidget);
    expect(find.text('New Recruit!'), findsOneWidget);
    expect(find.text(recruit.name), findsOneWidget);
  });
}
