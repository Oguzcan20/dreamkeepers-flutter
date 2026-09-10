// Exercises `InventoryView` directly (not through `RootView`) — it takes
// `gameState`/`onNavigate` straight as constructor params rather than
// reading `GameState` off `context`, so no `ChangeNotifierProvider` wrapper
// is needed here, unlike root_view_test.dart's boot-through-Dream-Haven
// flow. Covers the Dreamkeepers/Items tabs, roster sell mode (with its
// confirmation dialog — this port's first use of `AlertDialog`, see the
// screen's own doc comment for why), the empty-items CTA, and that tapping
// a roster card/item row reaches the real `EquipmentSheet`/
// `EquipmentDetailSheet` full-screen routes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/data/dreamkeeper_catalog.dart';
import 'package:dreamkeepers/models/dreamkeeper.dart';
import 'package:dreamkeepers/models/equipment.dart';
import 'package:dreamkeepers/models/rarity.dart';
import 'package:dreamkeepers/models/stats.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/team/inventory_view.dart';
import '../../support/test_app.dart';

/// Same rationale as root_view_test.dart's `_settle`: some card/background
/// animations repeat indefinitely, so `pumpAndSettle` would time out.
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 1)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

/// `InventoryView` has no `Scaffold`/`Material` of its own — like
/// `DreamHavenView`, it relies on `RootView`'s single top-level `Scaffold`
/// (see root_view.dart), so every standalone pump here needs one too, or
/// widgets like `PopupMenuButton` (the sort menu) fail to find a `Material`
/// ancestor.
Widget _wrapped(Widget child) => testApp(Scaffold(body: child));

Future<GameState> _pumpInventory(WidgetTester tester, {required ValueChanged<AppRoute> onNavigate}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  await tester.pumpWidget(_wrapped(InventoryView(gameState: gameState, onNavigate: onNavigate)));
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the deployed starter Dreamkeeper and opens its EquipmentSheet', (tester) async {
    AppRoute? lastRoute;
    await _pumpInventory(tester, onNavigate: (route) => lastRoute = route);

    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Lv 1'), findsOneWidget); // The starter's roster card.

    await tester.tap(find.text('Lv 1'));
    await _settle(tester);

    // EquipmentSheet is a full-screen push, not a route change tracked by
    // `onNavigate` — its own "Done" button pops it, `lastRoute` stays null.
    expect(find.text('Bench'), findsOneWidget); // The starter starts deployed.
    expect(lastRoute, isNull);

    await tester.tap(find.text('Done'));
    await _settle(tester);
    expect(find.text('Inventory'), findsOneWidget);
  });

  testWidgets('the back button and codex icon navigate via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpInventory(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);
    expect(lastRoute, isA<DreamHavenRoute>());

    await tester.tap(find.bySemanticsLabel('Dreamkeeper Codex'));
    await _settle(tester);
    expect(lastRoute, isA<CodexRoute>());
  });

  testWidgets('the empty Items tab shows a CTA that navigates to Campaign', (tester) async {
    AppRoute? lastRoute;
    await _pumpInventory(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.text('Items'));
    await _settle(tester);

    expect(find.text('No Items Yet'), findsOneWidget);
    await tester.tap(find.text('Go to Campaign'));
    await _settle(tester);
    expect(lastRoute, isA<CampaignRoute>());
  });

  testWidgets('an inventory item appears under its slot and opens EquipmentDetailSheet', (tester) async {
    late GameState gameState;
    SharedPreferences.setMockInitialValues({});
    gameState = await GameState.create();
    gameState.save.inventory.add(
      EquipmentItem(
        slot: EquipmentSlot.weapon,
        name: 'Test Blade',
        rarity: Rarity.common,
        level: 1,
        statBonus: const Stats(hp: 0, attack: 5, defense: 0, speed: 0),
      ),
    );
    await tester.pumpWidget(_wrapped(InventoryView(gameState: gameState, onNavigate: (_) {})));
    await _settle(tester);

    await tester.tap(find.text('Items'));
    await _settle(tester);

    expect(find.text('Test Blade'), findsOneWidget);
    expect(find.text('In storage'), findsOneWidget);

    await tester.tap(find.text('Test Blade'));
    await _settle(tester);

    // EquipmentDetailSheet re-shows the item's name in its own AppBar title.
    expect(find.text('Test Blade'), findsWidgets);
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets('sell mode selects a benched duplicate and sells it via the confirmation dialog', (tester) async {
    late GameState gameState;
    SharedPreferences.setMockInitialValues({});
    gameState = await GameState.create();
    // A single Dreamkeeper can never be sold (`canSellDreamkeeper` excludes
    // the last one) — add a second, benched, un-deployed member so it's
    // eligible. Picked as `unlockOrder[4]` ("Star Wolf") specifically
    // because its name alphabetically sorts after the starter Olf's
    // ("Olf") — the default roster sort ties on level and falls back to
    // name, so `find.text('Lv 1').last` must reliably land on this one,
    // not the starter.
    final extra = DreamkeeperInstance(definitionID: DreamkeeperCatalog.unlockOrder[4]);
    gameState.save.roster.add(extra);
    final rosterCountBefore = gameState.save.roster.length;

    await tester.pumpWidget(_wrapped(InventoryView(gameState: gameState, onNavigate: (_) {})));
    await _settle(tester);

    await tester.tap(find.text('Sell'));
    await _settle(tester);

    // The benched extra is selectable; tap its card to mark it for sale.
    await tester.tap(find.text('Lv 1').last);
    await _settle(tester);

    expect(find.text('1 selected'), findsOneWidget);

    await tester.tap(find.text('Sell').last);
    await _settle(tester);

    expect(find.text("This can't be undone. Equipped gear is unequipped, not sold."), findsOneWidget);

    await tester.tap(find.textContaining('Sell for'));
    await _settle(tester);

    expect(gameState.save.roster.length, rosterCountBefore - 1);
    expect(gameState.save.roster.any((r) => r.id == extra.id), isFalse);
  });

  testWidgets('canceling the sell confirmation keeps the Dreamkeeper', (tester) async {
    late GameState gameState;
    SharedPreferences.setMockInitialValues({});
    gameState = await GameState.create();
    final extra = DreamkeeperInstance(definitionID: DreamkeeperCatalog.unlockOrder[1]);
    gameState.save.roster.add(extra);
    final rosterCountBefore = gameState.save.roster.length;

    await tester.pumpWidget(_wrapped(InventoryView(gameState: gameState, onNavigate: (_) {})));
    await _settle(tester);

    await tester.tap(find.text('Sell'));
    await _settle(tester);
    await tester.tap(find.text('Lv 1').last);
    await _settle(tester);
    await tester.tap(find.text('Sell').last);
    await _settle(tester);

    await tester.tap(find.text('Cancel').last);
    await _settle(tester);

    expect(gameState.save.roster.length, rosterCountBefore);
  });
}
