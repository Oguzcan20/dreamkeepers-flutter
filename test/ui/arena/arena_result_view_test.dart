// Exercises `ArenaResultView` directly, given a hand-built
// `ArenaBattleResultSummary` — same shape as `battle_result_view_test.dart`.
// Covers the victory/defeat header, the tower-cleared/milestone/tier-change/
// dropped-equipment cards' presence, and both footer actions' navigation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dreamkeepers/combat/arena_system.dart';
import 'package:dreamkeepers/combat/battle_engine.dart';
import 'package:dreamkeepers/models/equipment.dart';
import 'package:dreamkeepers/models/rarity.dart';
import 'package:dreamkeepers/models/stats.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/arena/arena_result_view.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';

/// Same rationale as every other screen's `_settle`: `_StaggeredCard`'s
/// delayed reveal never lets `pumpAndSettle` converge within a bounded
/// time budget.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 1)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<void> _pumpResult(
  WidgetTester tester, {
  required ArenaBattleResultSummary summary,
  required ValueChanged<AppRoute> onNavigate,
}) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: ArenaResultView(summary: summary, onNavigate: onNavigate))));
  await _settle(tester);
}

void main() {
  testWidgets('a plain victory shows Victory!, gold, and both footer buttons', (tester) async {
    AppRoute? lastRoute;
    const summary = ArenaBattleResultSummary(
      outcome: BattleOutcome.victory,
      floor: 3,
      goldGained: 67,
      newTier: ArenaTier.bronze,
      tierChanged: false,
      isFirstClear: true,
      isMilestoneFloor: false,
      towerCleared: false,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (route) => lastRoute = route);

    expect(find.text('Victory!'), findsOneWidget);
    expect(find.text('Floor 3'), findsOneWidget);
    expect(find.text('+67 Gold'), findsOneWidget);
    expect(find.text('Dream Haven'), findsOneWidget);
    expect(find.text('Fight Again'), findsOneWidget);

    await tester.tap(find.text('Fight Again'));
    await _settle(tester);
    expect(lastRoute, isA<ArenaRoute>());
  });

  testWidgets('a defeat reads "Defeat" (no ellipsis) and has no gold card', (tester) async {
    AppRoute? lastRoute;
    const summary = ArenaBattleResultSummary(
      outcome: BattleOutcome.defeat,
      floor: 4,
      goldGained: 0,
      newTier: ArenaTier.bronze,
      tierChanged: false,
      isFirstClear: false,
      isMilestoneFloor: false,
      towerCleared: false,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (route) => lastRoute = route);

    expect(find.text('Defeat'), findsOneWidget);
    expect(find.textContaining('Gold'), findsNothing);

    await tester.tap(find.text('Dream Haven'));
    await _settle(tester);
    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('a milestone floor clear shows the milestone banner', (tester) async {
    const summary = ArenaBattleResultSummary(
      outcome: BattleOutcome.victory,
      floor: 25,
      goldGained: 265,
      newTier: ArenaTier.bronze,
      tierChanged: false,
      isFirstClear: true,
      isMilestoneFloor: true,
      towerCleared: false,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Milestone Reward!'), findsOneWidget);
  });

  testWidgets('a tier change shows the new-tier card', (tester) async {
    const summary = ArenaBattleResultSummary(
      outcome: BattleOutcome.victory,
      floor: 21,
      goldGained: 229,
      newTier: ArenaTier.silver,
      tierChanged: true,
      isFirstClear: true,
      isMilestoneFloor: false,
      towerCleared: false,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('New Tier!'), findsOneWidget);
    expect(find.text(ArenaTier.silver.displayName), findsOneWidget);
  });

  testWidgets('dropped equipment shows its own card, labeled by first-clear vs standard', (tester) async {
    final summary = ArenaBattleResultSummary(
      outcome: BattleOutcome.victory,
      floor: 1,
      goldGained: 49,
      newTier: ArenaTier.bronze,
      tierChanged: false,
      droppedEquipment: EquipmentItem(
        slot: EquipmentSlot.weapon,
        name: 'Test Arena Blade',
        rarity: Rarity.rare,
        level: 1,
        statBonus: const Stats(hp: 0, attack: 5, defense: 0, speed: 0),
      ),
      isFirstClear: true,
      isMilestoneFloor: false,
      towerCleared: false,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Test Arena Blade'), findsOneWidget);
    expect(find.text('First Clear Reward'), findsOneWidget);
  });

  testWidgets('a replay clear labels its dropped equipment "Standard Reward"', (tester) async {
    final summary = ArenaBattleResultSummary(
      outcome: BattleOutcome.victory,
      floor: 1,
      goldGained: 17,
      newTier: ArenaTier.bronze,
      tierChanged: false,
      droppedEquipment: EquipmentItem(
        slot: EquipmentSlot.weapon,
        name: 'Test Arena Blade',
        rarity: Rarity.rare,
        level: 1,
        statBonus: const Stats(hp: 0, attack: 5, defense: 0, speed: 0),
      ),
      isFirstClear: false,
      isMilestoneFloor: false,
      towerCleared: false,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Standard Reward'), findsOneWidget);
  });

  testWidgets('clearing the tower shows the cleared banner and drops the Fight Again button', (tester) async {
    const summary = ArenaBattleResultSummary(
      outcome: BattleOutcome.victory,
      floor: 100,
      goldGained: 940,
      newTier: ArenaTier.diamond,
      tierChanged: false,
      isFirstClear: true,
      isMilestoneFloor: true,
      towerCleared: true,
    );
    await _pumpResult(tester, summary: summary, onNavigate: (_) {});

    expect(find.text('Tower Cleared!'), findsOneWidget);
    expect(find.text('Fight Again'), findsNothing);
    expect(find.text('Dream Haven'), findsOneWidget);
  });
}
