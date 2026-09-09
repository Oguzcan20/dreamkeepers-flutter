// Smoke test: the app boots end to end through `GameState.create()` and
// `RootView`'s real navigation shell — splash, Main Menu, Play, the
// once-per-save onboarding overlay, then Dream Haven showing live save
// data. Replaces the default Flutter counter-demo test now that
// `main.dart` is wired to the real app.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/main.dart';
import 'package:dreamkeepers/state/account_state.dart';
import 'package:dreamkeepers/state/game_state.dart';

/// Advances a fixed span of fake time in small steps, instead of
/// `pumpAndSettle`. Dream Haven's Watch Ad building card runs a permanent
/// ready-pulse animation, so once Dream Haven is on screen `pumpAndSettle`
/// never sees zero scheduled frames and always times out.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 2)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app boots through the splash into the Main Menu', (WidgetTester tester) async {
    final gameState = await GameState.create();
    final accountState = AccountState();
    await accountState.load();
    await tester.pumpWidget(DreamkeepersApp(gameState: gameState, accountState: accountState));
    await tester.pump();

    expect(find.text('LOADING…'), findsOneWidget);

    // LoadingView fires `onFinished` 1.85s after appearing.
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pump();

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Play navigates to Dream Haven and shows the onboarding overlay on a new save', (WidgetTester tester) async {
    final gameState = await GameState.create();
    final accountState = AccountState();
    await accountState.load();
    await tester.pumpWidget(DreamkeepersApp(gameState: gameState, accountState: accountState));
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pump();

    await tester.tap(find.text('Play'));
    await _settle(tester);

    expect(find.text('Dream Haven'), findsOneWidget);
    expect(find.text('${gameState.save.gold}'), findsOneWidget);
    expect(find.text('${gameState.save.dreamGems}'), findsOneWidget);
    // A fresh save has never seen onboarding, so `RootView` overlays it. Its
    // first page and Dream Haven's own Summoning Shrine building card share
    // the "Summoning Shrine" title, so two matches are expected here.
    expect(find.text('Summoning Shrine'), findsNWidgets(2));

    await tester.tap(find.text('Skip'));
    await _settle(tester);

    // Only Dream Haven's building card remains once the overlay is gone.
    expect(find.text('Summoning Shrine'), findsOneWidget);
    expect(gameState.hasSeenOnboarding, isTrue);
  });
}
