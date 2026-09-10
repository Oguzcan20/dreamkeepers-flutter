// Exercises `DreamkeeperCodexView` directly (not through `RootView`) — same
// shape as `bestiary_view_test.dart`/`profile_view_test.dart`. Covers the
// header's collected count, an owned entry's detail overlay (ability names,
// ownership card, element matchups), an unowned entry's "Not Owned Yet"
// state, the element/role filters actually narrowing the grid, and the
// header's own Back button. `GridView.builder` is lazily built, so any
// entry beyond the first screenful needs `scrollUntilVisible` against the
// grid's own `Scrollable` (there are two on this screen — the horizontal
// element-chip row is also one — hence addressing it via the grid's key).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/codex/dreamkeeper_codex_view.dart';
import 'package:dreamkeepers/ui/codex/dreamkeeper_codex_detail_view.dart';
import '../../support/test_app.dart';

Future<void> _settle(WidgetTester tester, {Duration total = const Duration(milliseconds: 500)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

final Finder _gridScrollable = find.descendant(of: find.byKey(const Key('codex-grid')), matching: find.byType(Scrollable));

Future<GameState> _pumpCodex(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  await tester.pumpWidget(
    testApp(Scaffold(body: DreamkeeperCodexView(gameState: gameState, onNavigate: onNavigate)),
    ),
  );
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the header and the starter Dreamkeeper (Olf) as owned', (tester) async {
    final gameState = await _pumpCodex(tester, onNavigate: (_) {});

    expect(find.text('Dreamkeeper Codex'), findsOneWidget);
    // A brand new save owns exactly the starter
    // (`DreamkeeperCatalog.starterOlfDefaultID`, "Olf") —
    // `ownedSpeciesCount` is the source of truth, not a hardcoded `1`,
    // matching the Bestiary test's dynamic-count lesson.
    expect(
      find.text('${gameState.ownedSpeciesCount}/${gameState.catalog.definitions.length} Collected'),
      findsOneWidget,
    );
    expect(gameState.ownedSpeciesCount, 1);

    // Five other catalog entries also display "Olf" (the element variants
    // plus Ultimate Olf share the same name) — the owned starter is keyed
    // by its unique definition id, not found by text.
    final ownedOlfCard = find.byKey(const Key('codex-card-olf_ember'));
    await tester.scrollUntilVisible(ownedOlfCard, 200, scrollable: _gridScrollable);
    expect(ownedOlfCard, findsOneWidget);
  });

  testWidgets('tapping an owned entry opens its detail overlay with abilities and matchups; Close returns to the grid',
      (tester) async {
    await _pumpCodex(tester, onNavigate: (_) {});

    final ownedOlfCard = find.byKey(const Key('codex-card-olf_ember'));
    await tester.scrollUntilVisible(ownedOlfCard, 200, scrollable: _gridScrollable);
    await tester.tap(ownedOlfCard);
    await _settle(tester);

    expect(find.text('In Your Collection'), findsOneWidget);
    expect(find.text('Owned ×1'), findsOneWidget);
    expect(find.text('Wobbly Flame Lunge'), findsOneWidget); // Ultimate
    expect(find.text('Hot-Headed Jab'), findsOneWidget); // Active Skill
    expect(find.text('Too Dumb to Be Scared'), findsOneWidget); // Passive
    // Ember beats Bloom, loses to Tide (see `GameElement.multiplier`). The
    // still-mounted filter bar behind the overlay also renders "Bloom"/
    // "Tide" as element-chip labels, so these need scoping to the detail
    // overlay itself rather than a bare `find.text`.
    final detailOverlay = find.byType(DreamkeeperCodexDetailView);
    expect(find.text('Strong Against'), findsOneWidget);
    expect(find.text('Weak Against'), findsOneWidget);
    expect(find.descendant(of: detailOverlay, matching: find.text('Bloom')), findsOneWidget);
    expect(find.descendant(of: detailOverlay, matching: find.text('Tide')), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Close'));
    await _settle(tester);

    expect(find.text('In Your Collection'), findsNothing);
    expect(find.text('Dreamkeeper Codex'), findsOneWidget);
  });

  testWidgets('an unowned entry shows "Not Owned Yet" in its detail overlay', (tester) async {
    await _pumpCodex(tester, onNavigate: (_) {});

    await tester.scrollUntilVisible(find.text('Moon Hare'), 200, scrollable: _gridScrollable);
    await tester.tap(find.text('Moon Hare'));
    await _settle(tester);

    expect(find.text('Not Owned Yet'), findsOneWidget);
    expect(find.text('Find this Dreamkeeper at the Summoning Shrine.'), findsOneWidget);
  });

  testWidgets('filtering by the Ember element hides non-Ember entries', (tester) async {
    await _pumpCodex(tester, onNavigate: (_) {});

    // "Ember" also appears as the element pill's own label; the filter
    // chip is the first (and, before filtering, only) match.
    await tester.tap(find.text('Ember').first);
    await _settle(tester);

    await tester.scrollUntilVisible(find.text('Ember Fox'), 200, scrollable: _gridScrollable);
    expect(find.text('Ember Fox'), findsOneWidget);
    expect(find.text('Moon Hare'), findsNothing); // Lunar, filtered out.
  });

  testWidgets('filtering by the Healer role hides non-Healer entries', (tester) async {
    await _pumpCodex(tester, onNavigate: (_) {});

    // The button's own semantics label merges in its current selection
    // ("Filter by Role\nAll Roles"), so match it as a substring.
    await tester.tap(find.bySemanticsLabel(RegExp('Filter by Role')));
    await _settle(tester);
    await tester.tap(find.text('Healer'));
    await _settle(tester);

    await tester.scrollUntilVisible(find.text('Moon Hare'), 200, scrollable: _gridScrollable);
    expect(find.text('Moon Hare'), findsOneWidget); // Healer.
    expect(find.text('Ember Fox'), findsNothing); // Damage, filtered out.
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpCodex(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });
}
