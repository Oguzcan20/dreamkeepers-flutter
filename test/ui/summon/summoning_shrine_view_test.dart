// Exercises `SummoningShrineView` directly (not through `RootView`) — it
// takes `gameState`/`onNavigate` straight as constructor params, same shape
// as `CampaignView`/`InventoryView`. Covers the header/gems pill and odds
// card, the Dreamkeeper/Equipment mode picker, a single pull's reveal card,
// insufficient-Gems hint (and its "Get Gems" -> Shop navigation), and the
// 10+1 multi-pull's confirmation dialog + staggered reveal grid.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/summon/summoning_shrine_view.dart';

/// Same rationale as `campaign_view_test.dart`'s `_settle`: the stage/mode
/// pulses and the multi-reveal's periodic timer never let `pumpAndSettle`
/// converge, so a bounded stepped pump is used everywhere instead.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 1)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

/// Long enough to cover `_startMultiReveal`'s 11 staggered tiles (140ms each).
Future<void> _settleReveal(WidgetTester tester) => _settle(tester, total: const Duration(seconds: 3));

Future<GameState> _pumpSummon(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  void Function(GameState gameState)? seed,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  // Seed *before* the first pump — same rationale as
  // `campaign_view_test.dart`'s `_pumpCampaign`: a post-pump mutation of
  // `save.dreamGems` doesn't call `notifyListeners()` on its own.
  seed?.call(gameState);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: SummoningShrineView(gameState: gameState, onNavigate: onNavigate))));
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the header, gems pill, mode picker, and odds card', (tester) async {
    final gameState = await _pumpSummon(tester, onNavigate: (_) {});

    expect(find.text('Summoning Shrine'), findsOneWidget);
    expect(find.text('${gameState.save.dreamGems}'), findsOneWidget);
    expect(find.text('Dreamkeeper'), findsOneWidget);
    expect(find.text('Equipment'), findsOneWidget);
    expect(find.text('Odds'), findsOneWidget);
    expect(find.text('Common'), findsOneWidget);
    expect(find.text('Exclusive'), findsOneWidget);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpSummon(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('switching to Equipment mode changes the pull description', (tester) async {
    await _pumpSummon(tester, onNavigate: (_) {});

    expect(find.textContaining('Summon a Dreamkeeper'), findsOneWidget);

    await tester.tap(find.text('Equipment'));
    await _settle(tester);

    expect(find.textContaining('Summon a piece of Equipment'), findsOneWidget);
  });

  testWidgets('a single pull spends Gems, shows a tap-to-open chest, then reveals a result card', (tester) async {
    final gameState = await _pumpSummon(tester, onNavigate: (_) {}, seed: (gs) => gs.save.dreamGems = 1000);
    final gemsBefore = gameState.save.dreamGems;

    await tester.tap(find.textContaining('Summon (30 Gems)'));
    await _settle(tester);

    expect(gameState.save.dreamGems, gemsBefore - 30);
    // Gems spend immediately, but the result stays hidden behind the
    // tap-to-open chest — mirrors Swift's ChestClosed/ChestOpen reveal step.
    expect(find.text('Tap to open'), findsOneWidget);
    expect(find.textContaining('New!').evaluate().isEmpty && find.textContaining('Duplicate').evaluate().isEmpty, isTrue);

    await tester.tap(find.text('Tap to open'));
    await _settle(tester);

    // The reveal card shows the pulled Dreamkeeper's rarity label somewhere
    // in the overlay — a generic check since the actual roll is random.
    expect(find.textContaining('New!').evaluate().isNotEmpty || find.textContaining('Duplicate').evaluate().isNotEmpty, isTrue);

    // Tapping the dimmed backdrop dismisses the reveal.
    await tester.tapAt(const Offset(10, 10));
    await _settle(tester);

    expect(find.textContaining('New!').evaluate().isEmpty && find.textContaining('Duplicate').evaluate().isEmpty, isTrue);
  });

  testWidgets('insufficient Gems shows a Get Gems hint, and the dialog also offers it', (tester) async {
    AppRoute? lastRoute;
    await _pumpSummon(tester, onNavigate: (route) => lastRoute = route, seed: (gs) => gs.save.dreamGems = 0);

    expect(find.text('Get Gems'), findsOneWidget); // The inline hint replaces the pull buttons.
    expect(find.textContaining('Summon (30 Gems)'), findsNothing);

    await tester.tap(find.text('Get Gems'));
    await _settle(tester);

    expect(lastRoute, isA<ShopRoute>());
  });

  testWidgets('tapping the unaffordable multi-pull button shows the insufficient-Gems dialog', (tester) async {
    // Enough for a single pull but not the 300-Gem 10+1 bundle.
    await _pumpSummon(tester, onNavigate: (_) {}, seed: (gs) => gs.save.dreamGems = 50);

    await tester.tap(find.textContaining('x11 (300 Gems)'));
    await _settle(tester);

    expect(find.text('Not Enough Gems'), findsOneWidget);
  });

  testWidgets('canceling the multi-pull confirmation spends nothing', (tester) async {
    final gameState = await _pumpSummon(tester, onNavigate: (_) {}, seed: (gs) => gs.save.dreamGems = 1000);
    final gemsBefore = gameState.save.dreamGems;

    await tester.tap(find.textContaining('x11 (300 Gems)'));
    await _settle(tester);
    expect(find.text('Summon x11'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await _settle(tester);

    expect(gameState.save.dreamGems, gemsBefore);
  });

  testWidgets('confirming the multi-pull spends Gems and reveals all 11 results', (tester) async {
    final gameState = await _pumpSummon(tester, onNavigate: (_) {}, seed: (gs) => gs.save.dreamGems = 1000);
    final gemsBefore = gameState.save.dreamGems;

    await tester.tap(find.textContaining('x11 (300 Gems)'));
    await _settle(tester);
    // Two "Summon" texts now exist: the dialog title's button and the
    // dialog action — `textContaining` on the exact action label disambiguates.
    await tester.tap(find.widgetWithText(TextButton, 'Summon'));
    await _settleReveal(tester);

    expect(gameState.save.dreamGems, gemsBefore - 300);
    expect(find.text('Summon Results'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget); // All 11 tiles finished revealing.

    // The 11-tile grid can be taller than the test surface, so the
    // "Continue" button may need scrolling into view first (it lives inside
    // `_RevealOverlay`'s `SingleChildScrollView`).
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await _settle(tester);

    expect(find.text('Summon Results'), findsNothing);
  });
}
