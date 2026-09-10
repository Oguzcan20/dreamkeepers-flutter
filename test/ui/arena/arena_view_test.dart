// Exercises `ArenaView` directly (not through `RootView`) — same shape as
// `campaign_view_test.dart`. Covers the header/progress card, floor-list
// rendering, the frontier floor's direct-fight path, a locked floor staying
// untappable, the no-team and no-tickets alert dialogs, and back navigation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/combat/arena_system.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/arena/arena_view.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import '../../support/test_app.dart';

/// Same rationale as `campaign_view_test.dart`'s `_settle`: the frontier
/// floor's glow/pulse styling and the auto-scroll-to-frontier animation
/// never let `pumpAndSettle` see zero scheduled frames.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 1)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<GameState> _pumpArena(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  ValueChanged<int>? onFight,
  void Function(GameState gameState)? seed,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  // Seed *before* the first pump — same rationale as `campaign_view_test.dart`.
  seed?.call(gameState);
  await tester.pumpWidget(
    testApp(Scaffold(
        body: ArenaView(gameState: gameState, onNavigate: onNavigate, onFight: onFight ?? (_) {}),
      ),
    ),
  );
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the header, progress card, and floor list', (tester) async {
    final gameState = await _pumpArena(tester, onNavigate: (_) {});

    expect(find.text('The Endless Trial'), findsOneWidget);
    expect(find.text(gameState.arenaTier.displayName), findsOneWidget);
    expect(find.textContaining('Floor 1'), findsWidgets);
    // All 100 floors are always rendered, not just the unlocked ones (see
    // `ArenaView`'s doc comment: "ALLE 100 stufen sollen zu sehen sein").
    expect(find.textContaining('Floor 100'), findsOneWidget);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpArena(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('tapping the frontier floor calls onFight with that floor', (tester) async {
    int? foughtFloor;
    await _pumpArena(tester, onNavigate: (_) {}, onFight: (floor) => foughtFloor = floor);

    // A brand new save's frontier is floor 1 — unlocked, deployed team, full
    // tickets, so tapping it fights directly with no alert.
    await tester.tap(find.bySemanticsLabel('Floor 1'));
    await _settle(tester);

    expect(foughtFloor, 1);
  });

  testWidgets('a locked floor stays untappable', (tester) async {
    int? foughtFloor;
    await _pumpArena(tester, onNavigate: (_) {}, onFight: (floor) => foughtFloor = floor);

    // Floor 2 is still locked on a brand new save (frontier is floor 1).
    await tester.tap(find.bySemanticsLabel('Floor 2'));
    await _settle(tester);

    expect(foughtFloor, isNull);
  });

  testWidgets('no deployed team shows an alert instead of fighting', (tester) async {
    int? foughtFloor;
    await _pumpArena(
      tester,
      onNavigate: (_) {},
      onFight: (floor) => foughtFloor = floor,
      seed: (gs) => gs.toggleDeployed(gs.roster.first),
    );

    await tester.tap(find.bySemanticsLabel('Floor 1'));
    await _settle(tester);

    expect(find.text('No team deployed'), findsOneWidget);
    expect(foughtFloor, isNull);

    await tester.tap(find.text('OK'));
    await _settle(tester);
    expect(find.text('No team deployed'), findsNothing);
  });

  testWidgets('no Arena tickets left shows an alert instead of fighting', (tester) async {
    int? foughtFloor;
    await _pumpArena(
      tester,
      onNavigate: (_) {},
      onFight: (floor) => foughtFloor = floor,
      // `arenaTicketsRemainingToday` resets to the daily max the moment it
      // notices `arenaTicketDay` isn't today (a fresh save starts it at the
      // distant past) — mark today's refill as already spent so the seeded
      // zero survives the first build's read of that getter.
      seed: (gs) {
        gs.save.arenaTicketDay = DateTime.now();
        gs.save.arenaTickets = 0;
      },
    );

    await tester.tap(find.bySemanticsLabel('Floor 1'));
    await _settle(tester);

    expect(find.text('No Trial Tickets Left'), findsOneWidget);
    expect(foughtFloor, isNull);
  });

  testWidgets('an already-cleared floor shows Farm instead of Fight', (tester) async {
    await _pumpArena(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.arenaFloor = 2, // Floor 1 cleared, floor 2 is now the frontier.
    );

    expect(find.descendant(of: find.bySemanticsLabel('Floor 1'), matching: find.text('Farm')), findsOneWidget);
    expect(find.descendant(of: find.bySemanticsLabel('Floor 2'), matching: find.text('Fight')), findsOneWidget);
  });

  testWidgets('tower cleared shows the cleared banner', (tester) async {
    await _pumpArena(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.arenaFloor = ArenaSystem.maxFloor + 1,
    );

    expect(find.text('Tower Cleared!'), findsOneWidget);
  });
}
