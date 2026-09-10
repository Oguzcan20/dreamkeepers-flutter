// Exercises `BestiaryView` directly (not through `RootView`) — same shape as
// `settings_view_test.dart`/`profile_view_test.dart`. Covers the header's
// discovered count, the discovered-vs-undiscovered entry rendering (name +
// lore hidden until met in battle), and the back button. Doesn't walk every
// one of the catalog's 30 worlds — `AchievementSystem.all`-style exhaustive
// coverage doesn't fit a catalog this large, so tests spot-check World 1
// (reachable without scrolling) plus one seeded discovery.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/bestiary/bestiary_view.dart';
import '../../support/test_app.dart';

/// Same rationale as every other screen's `_settle`: `GlassCard`'s
/// `BackdropFilter` blur never lets `pumpAndSettle` see zero scheduled
/// frames on some platforms' test rendering path.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(milliseconds: 500)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<GameState> _pumpBestiary(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  void Function(GameState gameState)? seed,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  seed?.call(gameState);
  await tester.pumpWidget(
    testApp(Scaffold(body: BestiaryView(gameState: gameState, onNavigate: onNavigate)),
    ),
  );
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the header, discovered count, and World 1 with everything hidden on a fresh save', (tester) async {
    final gameState = await _pumpBestiary(tester, onNavigate: (_) {});

    expect(find.text('Dream Observatory'), findsOneWidget);
    expect(find.text('0/${gameState.bestiaryTotalCount} Discovered'), findsOneWidget);
    expect(find.text('Whispering Meadow'), findsOneWidget);
    // Nothing discovered yet — every World 1 entry (4 regulars + 1 boss)
    // renders as "???" instead of its real name.
    expect(find.text('Bramble Stalker'), findsNothing);
    expect(find.text('???'), findsWidgets);
    expect(find.text('Not yet encountered.'), findsWidgets);
  });

  testWidgets('a discovered monster shows its real name and lore; siblings stay hidden', (tester) async {
    final gameState = await _pumpBestiary(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.discoveredMonsters.add('Bramble Stalker'),
    );

    // "Discovering" a species counts it wherever its roster is reused —
    // World 1's regulars are also the source for worlds 11 and 21 (the
    // second/third "dreaming"), so one discovery counts 3 entries, not 1.
    expect(
      find.text('${gameState.bestiaryDiscoveredCount}/${gameState.bestiaryTotalCount} Discovered'),
      findsOneWidget,
    );
    expect(gameState.bestiaryDiscoveredCount, 3);
    expect(find.text('Bramble Stalker'), findsWidgets);
    expect(
      find.text('Creeps through the tall grass, thorns bristling at the first sign of a footstep.'),
      findsWidgets,
    );
    // Its World 1 neighbors are still undiscovered.
    expect(find.text('Dust Wisp'), findsNothing);
    expect(find.text('???'), findsWidgets);
  });

  testWidgets('a discovered boss shows its world boss name', (tester) async {
    await _pumpBestiary(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.discoveredMonsters.add('The Unraveling'),
    );

    expect(find.text('The Unraveling'), findsWidgets);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpBestiary(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });
}
