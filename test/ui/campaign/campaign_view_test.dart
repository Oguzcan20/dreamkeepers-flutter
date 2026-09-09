// Exercises `CampaignView` directly (not through `RootView`) — it takes
// `gameState`/`onNavigate` straight as constructor params, same shape as
// `InventoryView`. Covers the header/energy pill, the frontier stage's
// direct-fight path, a locked stage staying untappable, an already-cleared
// stage's Fight-or-Sweep choice dialog (with the sweep toast it produces),
// and the insufficient-Energy dialog's gem-refill action.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/progression/energy_system.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/campaign/campaign_view.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';

/// Same rationale as `inventory_view_test.dart`'s `_settle`: the stage
/// pulse (`AnimationController.repeat(reverse: true)`) on the frontier
/// stage never reaches zero scheduled frames, so `pumpAndSettle` would
/// time out.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 1)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<GameState> _pumpCampaign(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  void Function(GameState gameState)? seed,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  // Seed *before* the first pump, not after — `selectStage()` and directly
  // mutating `save.currentStage` don't call `notifyListeners()`, so a
  // post-pump mutation would never reach `CampaignView`'s
  // `AnimatedBuilder(animation: gameState, ...)` without a real
  // notification. Same rationale as `inventory_view_test.dart`'s
  // roster-seeding, which happens before `pumpWidget` too.
  seed?.call(gameState);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: CampaignView(gameState: gameState, onNavigate: onNavigate))));
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the header, energy pill, and the first world', (tester) async {
    final gameState = await _pumpCampaign(tester, onNavigate: (_) {});

    expect(find.text('Campaign'), findsOneWidget);
    expect(find.text('${gameState.energy}/${gameState.maxEnergy}'), findsOneWidget);
    expect(find.text('Whispering Meadow'), findsOneWidget);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpCampaign(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('tapping the frontier stage spends Energy and navigates to Battle', (tester) async {
    AppRoute? lastRoute;
    final gameState = await _pumpCampaign(tester, onNavigate: (route) => lastRoute = route);
    final energyBefore = gameState.energy;

    // A brand new save's frontier is stage 1 — unlocked, not yet cleared, so
    // tapping it fights directly with no Fight-or-Sweep choice.
    await tester.tap(find.bySemanticsLabel('Stage 1'));
    await _settle(tester);

    expect(lastRoute, isA<BattleRoute>());
    expect(gameState.energy, energyBefore - EnergySystem.normalStageCost);
  });

  testWidgets('a locked stage stays untappable', (tester) async {
    AppRoute? lastRoute;
    final gameState = await _pumpCampaign(tester, onNavigate: (route) => lastRoute = route);
    final energyBefore = gameState.energy;

    // Stage 3 is still locked on a brand new save (frontier is stage 1).
    await tester.tap(find.bySemanticsLabel('Stage 3, locked'));
    await _settle(tester);

    expect(lastRoute, isNull);
    expect(gameState.energy, energyBefore);
  });

  testWidgets('an already-cleared stage offers Fight or Sweep; Sweep shows the payout toast', (tester) async {
    AppRoute? lastRoute;
    await _pumpCampaign(
      tester,
      onNavigate: (route) => lastRoute = route,
      seed: (gs) {
        gs.save.currentStage = 2;
        gs.selectStage(2); // Keeps `selectedStage` consistent, same as a real battle win would.
      },
    );

    await tester.tap(find.bySemanticsLabel('Stage 1, cleared'));
    await _settle(tester);

    expect(find.text('Stage 1 — already cleared'), findsOneWidget);

    await tester.tap(find.textContaining('Sweep — Instant Clear'));
    await _settle(tester);

    expect(lastRoute, isNull); // A sweep flashes a toast, it never navigates.
    expect(find.textContaining('Stage 1 swept'), findsOneWidget);
  });

  testWidgets('canceling the stage choice dialog does nothing', (tester) async {
    AppRoute? lastRoute;
    await _pumpCampaign(
      tester,
      onNavigate: (route) => lastRoute = route,
      seed: (gs) {
        gs.save.currentStage = 2;
        gs.selectStage(2);
      },
    );

    await tester.tap(find.bySemanticsLabel('Stage 1, cleared'));
    await _settle(tester);
    await tester.tap(find.text('Cancel'));
    await _settle(tester);

    expect(lastRoute, isNull);
    expect(find.textContaining('Stage 1 swept'), findsNothing);
  });

  testWidgets('choosing Fight from the stage choice dialog navigates to Battle', (tester) async {
    AppRoute? lastRoute;
    await _pumpCampaign(
      tester,
      onNavigate: (route) => lastRoute = route,
      seed: (gs) {
        gs.save.currentStage = 2;
        gs.selectStage(2);
      },
    );

    await tester.tap(find.bySemanticsLabel('Stage 1, cleared'));
    await _settle(tester);
    await tester.tap(find.textContaining('Fight ('));
    await _settle(tester);

    expect(lastRoute, isA<BattleRoute>());
  });

  testWidgets('insufficient Energy shows a dialog, and refilling with Gems works', (tester) async {
    final gameState = await _pumpCampaign(tester, onNavigate: (_) {}, seed: (gs) => gs.save.energy = 0);

    await tester.tap(find.bySemanticsLabel('Stage 1'));
    await _settle(tester);

    expect(find.text('Not Enough Energy'), findsOneWidget);
    expect(find.textContaining('Refill for'), findsOneWidget); // Starter save has enough Gems for one.

    await tester.tap(find.textContaining('Refill for'));
    await _settle(tester);

    expect(gameState.energy, EnergySystem.energyPerRefill);
  });
}
