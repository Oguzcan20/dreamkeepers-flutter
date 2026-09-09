// Exercises `BattlePassView` directly (not through `RootView`) — same shape
// as `bestiary_view_test.dart`/`shop_view_test.dart`. Covers the header's
// tier/XP display, the premium-upsell card's presence gated on
// `battlePassPremiumUnlocked`, claiming a free reward (incl. the every-10th-
// tier ticket bonus), claiming a premium reward (incl. the every-5th-tier
// bonus), premium-locked reward slots becoming claimable once Premium is
// purchased, and the back button.
//
// Every claimable reward slot's tap target carries a
// `Key('battle-pass-claim-<tier>-<free|premium>')` — the on-screen icon's
// own `Semantics(label: 'Claim tier reward')` is identical across every
// claimable slot (fine for VoiceOver, which only ever focuses one at a
// time, but ambiguous for `find.bySemanticsLabel` once more than one tier
// is claimable at once), so tests address a specific slot by its `Key`
// instead.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/progression/battle_pass_system.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/battle_pass/battle_pass_view.dart';

Future<void> _settle(WidgetTester tester, {Duration total = const Duration(milliseconds: 500)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

// This screen has two `Scrollable`s (the outer `SingleChildScrollView` plus
// the tier grid's own `GridView`, which always builds one even with
// `NeverScrollableScrollPhysics`) — `scrollUntilVisible`'s default
// `find.byType(Scrollable)` throws on that ambiguity, same gotcha as the
// Codex/Bestiary screens, so tests scroll the outer one explicitly by key.
final Finder _outerScrollable = find.descendant(of: find.byKey(const Key('battle-pass-scroll')), matching: find.byType(Scrollable));

Future<GameState> _pumpBattlePass(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  void Function(GameState gameState)? seed,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  seed?.call(gameState);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: BattlePassView(gameState: gameState, onNavigate: onNavigate)),
    ),
  );
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the header, tier 0, XP progress, and the premium upsell card on a fresh save', (tester) async {
    await _pumpBattlePass(tester, onNavigate: (_) {});

    expect(find.text('Season Pass'), findsOneWidget);
    expect(find.text('Tier 0/${BattlePassSystem.tierCount}'), findsOneWidget);
    expect(find.text('0/${BattlePassSystem.xpPerTier} XP'), findsOneWidget);
    expect(find.text('Unlock Premium Track'), findsOneWidget);

    // Nothing is unlocked yet — tier 1's free/premium slots aren't
    // claimable, so neither claim key renders.
    expect(find.byKey(const Key('battle-pass-claim-1-free')), findsNothing);
    expect(find.byKey(const Key('battle-pass-claim-1-premium')), findsNothing);
  });

  testWidgets('debugSeedBattlePass reaches tier 3, unlocks Premium, and makes tiers 1-3 claimable but not tier 4',
      (tester) async {
    await _pumpBattlePass(tester, onNavigate: (_) {}, seed: (gs) => gs.debugSeedBattlePass());

    expect(find.text('Tier 3/${BattlePassSystem.tierCount}'), findsOneWidget);
    // Premium is unlocked by the seed, so the upsell card is gone.
    expect(find.text('Unlock Premium Track'), findsNothing);

    expect(find.byKey(const Key('battle-pass-claim-1-free')), findsOneWidget);
    expect(find.byKey(const Key('battle-pass-claim-3-free')), findsOneWidget);
    expect(find.byKey(const Key('battle-pass-claim-1-premium')), findsOneWidget);
    // Tier 4 hasn't been reached yet — locked, no claim key.
    expect(find.byKey(const Key('battle-pass-claim-4-free')), findsNothing);
  });

  testWidgets('claiming a free reward grants its gold and marks the slot claimed', (tester) async {
    final gameState = await _pumpBattlePass(tester, onNavigate: (_) {}, seed: (gs) => gs.debugSeedBattlePass());
    final goldBefore = gameState.save.gold;

    await tester.tap(find.byKey(const Key('battle-pass-claim-1-free')));
    await _settle(tester);

    expect(gameState.save.gold, goldBefore + BattlePassSystem.freeReward(1).gold);
    expect(gameState.isBattlePassRewardClaimed(1, false), isTrue);
    // Claimed now — the claim key no longer renders (a checkmark icon
    // replaces the tappable arrow).
    expect(find.byKey(const Key('battle-pass-claim-1-free')), findsNothing);
  });

  testWidgets("claiming tier 10's free reward also grants the every-10th-tier Arena ticket bonus", (tester) async {
    final gameState = await _pumpBattlePass(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.battlePassXP = BattlePassSystem.xpPerTier * 10,
    );
    final ticketsBefore = gameState.save.arenaBonusTickets;
    final reward = BattlePassSystem.freeReward(10);
    expect(reward.tickets, 3); // Sanity-check the milestone math this test relies on.

    await tester.scrollUntilVisible(find.byKey(const Key('battle-pass-claim-10-free')), 300, scrollable: _outerScrollable);
    await tester.tap(find.byKey(const Key('battle-pass-claim-10-free')));
    await _settle(tester);

    expect(gameState.save.arenaBonusTickets, ticketsBefore + 3);
  });

  testWidgets("claiming a premium reward grants gold, gems, and the every-5th-tier bonus", (tester) async {
    final gameState = await _pumpBattlePass(
      tester,
      onNavigate: (_) {},
      seed: (gs) {
        gs.save.battlePassXP = BattlePassSystem.xpPerTier * 5;
        gs.save.battlePassPremiumUnlocked = true;
      },
    );
    final goldBefore = gameState.save.gold;
    final gemsBefore = gameState.save.dreamGems;
    final ticketsBefore = gameState.save.arenaBonusTickets;
    final reward = BattlePassSystem.premiumReward(5);
    expect(reward.gems, 40); // 10 base + 30 milestone bonus at tier 5.
    expect(reward.tickets, 5);

    await tester.scrollUntilVisible(find.byKey(const Key('battle-pass-claim-5-premium')), 300, scrollable: _outerScrollable);
    await tester.tap(find.byKey(const Key('battle-pass-claim-5-premium')));
    await _settle(tester);

    expect(gameState.save.gold, goldBefore + reward.gold);
    expect(gameState.save.dreamGems, gemsBefore + reward.gems);
    expect(gameState.save.arenaBonusTickets, ticketsBefore + reward.tickets);
  });

  testWidgets('a premium reward stays locked until Premium is purchased; the \$4.99 button unlocks it', (tester) async {
    final gameState = await _pumpBattlePass(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.battlePassXP = BattlePassSystem.xpPerTier * 1,
    );

    // Free is claimable, premium isn't — locked-by-premium, not by tier.
    expect(find.byKey(const Key('battle-pass-claim-1-free')), findsOneWidget);
    expect(find.byKey(const Key('battle-pass-claim-1-premium')), findsNothing);
    expect(gameState.battlePassPremiumUnlocked, isFalse);

    await tester.tap(find.text('\$4.99'));
    await _settle(tester);

    expect(gameState.battlePassPremiumUnlocked, isTrue);
    expect(find.byKey(const Key('battle-pass-claim-1-premium')), findsOneWidget);
    expect(find.text('Unlock Premium Track'), findsNothing);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpBattlePass(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });
}
