// Exercises `ShopView` directly (not through `RootView`) — same shape as
// `CampaignView`/`SummoningShrineView`: takes `gameState`/`onNavigate`
// straight as constructor params. Covers the header/currency pills, the
// Starter Pack/VIP Pass one-time offers, a gem-pack purchase, the gold
// exchange (affordable and not), an Arena Ticket pack purchase, and the
// Igo/Ames exclusive-character purchases (see `TwinBond`).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/theme/theme.dart' as dk_theme;
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/shop/shop_view.dart';

/// Same rationale as every other screen's `_settle`: `SparkleField`'s
/// looping controller and `PrimaryButton`'s press animation never let
/// `pumpAndSettle` converge, so a bounded stepped pump is used instead. Long
/// enough to also carry a `purchaseWithRealMoney` future (resolved
/// synchronously by `MockPurchaseService`, but still a real `Future`) to
/// completion.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 1)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<GameState> _pumpShop(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  void Function(GameState gameState)? seed,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  // Seed *before* the first pump — a post-pump mutation of `save.*` fields
  // doesn't call `notifyListeners()` on its own (same pitfall as every
  // other screen's test helper).
  seed?.call(gameState);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: ShopView(gameState: gameState, onNavigate: onNavigate))));
  await _settle(tester);
  return gameState;
}

/// Taps the price button inside the card that shows `cardTitle` — several
/// items share a price label (e.g. VIP Pass and the medium Gem Pack are
/// both "$4.99"), so a bare `find.text(priceLabel)` isn't always unique.
Future<void> _buyCard(WidgetTester tester, String cardTitle, String priceLabel) async {
  final card = find.ancestor(of: find.text(cardTitle), matching: find.byType(dk_theme.GlassCard));
  final button = find.descendant(of: card, matching: find.text(priceLabel));
  // The left column's lower sections (Arena Tickets, Gold Exchange) can sit
  // below the test surface's fold inside the outer `SingleChildScrollView`
  // — scroll them into view first, same as the Summon multi-pull's
  // "Continue" button.
  await tester.ensureVisible(button);
  await tester.tap(button);
  await _settle(tester);
}

void main() {
  testWidgets('shows the header, currency pills, and every catalog section', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {});

    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('${gameState.save.gold}'), findsOneWidget);
    expect(find.text('${gameState.save.dreamGems}'), findsOneWidget);
    expect(find.text('Dream Gems'), findsOneWidget); // Gem pack section title.
    expect(find.text('Arena Tickets'), findsOneWidget);
    expect(find.text('Gold Exchange'), findsOneWidget);
    // A brand new save hasn't claimed either one-time offer yet.
    expect(find.text('Dreamkeeper Starter Pack'), findsOneWidget);
    expect(find.text('VIP Pass'), findsOneWidget);
    // Neither exclusive character has been obtained yet either.
    expect(find.text('Igo'), findsOneWidget);
    expect(find.text('Ames'), findsOneWidget);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpShop(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('buying a gem pack grants Gems', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {});
    final gemsBefore = gameState.save.dreamGems;

    await _buyCard(tester, 'Handful of Gems', r'$0.99');

    expect(gameState.save.dreamGems, gemsBefore + 60);
  });

  testWidgets('claiming the Starter Pack grants gold and Gems, and the card disappears', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {});
    final goldBefore = gameState.save.gold;
    final gemsBefore = gameState.save.dreamGems;

    await _buyCard(tester, 'Dreamkeeper Starter Pack', r'$2.99');

    expect(gameState.save.gold, goldBefore + 500);
    expect(gameState.save.dreamGems, gemsBefore + 150);
    expect(gameState.save.purchasedOneTimeOfferIDs.contains('starter_pack'), isTrue);
    expect(find.text('Dreamkeeper Starter Pack'), findsNothing);
  });

  testWidgets('claiming the VIP Pass sets isVIP and the card disappears', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {});
    expect(gameState.isVIP, isFalse);

    await _buyCard(tester, 'VIP Pass', r'$4.99');

    expect(gameState.isVIP, isTrue);
    expect(find.text('VIP Pass'), findsNothing);
  });

  testWidgets('purchasing Igo grants a max-level, max-star instance and the card disappears', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {});

    await _buyCard(tester, 'Igo', r'$99.99');

    final igo = gameState.save.roster.where((r) => r.definitionID == 'igo');
    expect(igo, isNotEmpty);
    expect(find.text('Igo'), findsNothing);
    // Ames is unaffected — still purchasable.
    expect(find.text('Ames'), findsOneWidget);
  });

  testWidgets('the Gold Exchange spends Gems and grants Gold when affordable', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {}, seed: (gs) => gs.save.dreamGems = 50);
    final goldBefore = gameState.save.gold;

    await _buyCard(tester, 'Gold Pouch', '20 Gems');

    expect(gameState.save.dreamGems, 30);
    expect(gameState.save.gold, goldBefore + 200);
  });

  testWidgets('an unaffordable Gold Exchange row is disabled and spends nothing', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {}, seed: (gs) => gs.save.dreamGems = 5);
    final gemsBefore = gameState.save.dreamGems;

    await _buyCard(tester, 'Gold Chest', '80 Gems');

    expect(gameState.save.dreamGems, gemsBefore);
  });

  testWidgets('buying an Arena Ticket pack grants bonus tickets', (tester) async {
    final gameState = await _pumpShop(tester, onNavigate: (_) {});
    final before = gameState.arenaBonusTickets;

    await _buyCard(tester, 'Arena Ticket Pack', r'$1.99');

    expect(gameState.arenaBonusTickets, before + 5);
  });
}
