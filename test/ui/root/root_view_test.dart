// Exercises RootView's own navigation shell: splash -> Main Menu -> Dream
// Haven, the global floating home button's visibility rules (hidden on
// Main Menu/Dream Haven/Summon/… — mirrors `RootView.showsGlobalHomeButton`
// in UI/Root/RootView.swift), and that every one of the real
// `DreamHavenView`'s navigation affordances (team card, battle pass banner,
// building cards, header icons, footer buttons) actually reaches its
// destination.
//
// NOTE: the "Watch Ad" building card is deliberately never tapped here (or
// anywhere else in this suite) — it triggers `RewardedAdSheet`, which calls
// the real ad SDK on device. Automating taps on it, even in a test, risks
// the AdMob account being flagged for invalid traffic.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/models/element.dart';
import 'package:dreamkeepers/platform/game_services_service.dart';
import 'package:dreamkeepers/platform/google_sign_in_service.dart';
import 'package:dreamkeepers/state/account_state.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/root_view.dart';

/// Advances a fixed span of fake time in small steps, instead of
/// `pumpAndSettle`. The Watch Ad building card's ready-pulse
/// (`AnimationController.repeat(reverse: true)`) runs for as long as Dream
/// Haven is on screen — deliberately, it's a permanent "ready" affordance —
/// so `pumpAndSettle` never sees zero scheduled frames and always times
/// out once Dream Haven is mounted. Two seconds of stepped pumping is far
/// more than any transition/appear animation in this screen needs, without
/// ever waiting for "settled".
Future<void> _settle(WidgetTester tester, {Duration total = const Duration(seconds: 2)}) async {
  const step = Duration(milliseconds: 50);
  var elapsed = Duration.zero;
  while (elapsed < total) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<GameState> _bootedToDreamHaven(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  gameState.completeOnboarding(); // Skip the overlay — not under test here.
  // Skip the Olf choice overlay too — not under test here. Deliberately
  // chosen as Ember (rather than some other element) as a regression test:
  // `olfDefinitionID(.ember)` equals `starterOlfDefaultID` itself (the
  // placeholder id *is* "olf_ember"), which used to make choosing Ember a
  // silent no-op that left `needsStarterOlfChoice` true and the overlay
  // mounted, blocking every tap below it. Now backed by
  // `hasChosenStarterElement`, so this correctly resolves regardless of
  // element.
  gameState.chooseStarterOlf(GameElement.ember);
  final accountState = AccountState();
  await accountState.load();

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GameState>.value(value: gameState),
        ChangeNotifierProvider<AccountState>.value(value: accountState),
        // RootView reads/watches these too (Play Games auth + leaderboard
        // submission, and Settings' Google Sign-In button) — see main.dart.
        ChangeNotifierProvider<GameServicesService>(create: (_) => GameServicesService()),
        ChangeNotifierProvider<GameLeaderboardService>(create: (_) => GameLeaderboardService()),
        Provider<GoogleSignInService>(create: (_) => GoogleSignInService()),
      ],
      child: const MaterialApp(home: RootView()),
    ),
  );
  await tester.pump(const Duration(milliseconds: 1900));
  await tester.pump();
  await tester.tap(find.text('Play'));
  await _settle(tester);
  return gameState;
}

/// Navigates from Dream Haven to `title` via `key`, asserts arrival, then
/// returns via the still-present global home button (every route reachable
/// from Dream Haven is a real, ported screen now — no `_ComingSoonScreen`
/// placeholder remains) — leaving the tester back on Dream Haven for the
/// next case in a loop. Shown by the destination's own header text, which
/// can diverge from its route/nav-key name (`InventoryView` says
/// "Inventory" rather than "Team"; `CampaignView` does say "Campaign",
/// matching its route name).
Future<void> _tapAndReturnToRealScreen(WidgetTester tester, Key key, String title) async {
  await tester.tap(find.byKey(key));
  await _settle(tester);
  expect(find.text(title), findsOneWidget, reason: 'navigating via $key');
  await tester.tap(find.byKey(const Key('global-home-button')));
  await _settle(tester);
}

/// Same as `_tapAndReturnToRealScreen`, for a real screen that's *also* on
/// `RootView`'s `showsGlobalHomeButton` exclusion list (Summon, matching
/// Swift) — there's no `global-home-button` to tap, so it returns via the
/// screen's own header Back button instead (the same affordance
/// `SummoningShrineView`/`CampaignView` expose for this purpose).
Future<void> _tapAndReturnToRealScreenViaOwnBackButton(WidgetTester tester, Key key, String title) async {
  await tester.tap(find.byKey(key));
  await _settle(tester);
  expect(find.text(title), findsOneWidget, reason: 'navigating via $key');
  expect(find.byKey(const Key('global-home-button')), findsNothing);
  await tester.tap(find.bySemanticsLabel('Back'));
  await _settle(tester);
}

void main() {
  testWidgets('Main Menu and Dream Haven show no global home button', (tester) async {
    await _bootedToDreamHaven(tester);

    expect(find.text('Dream Haven'), findsOneWidget); // The screen title itself.
    expect(find.byKey(const Key('global-home-button')), findsNothing);
  });

  testWidgets('Summon hides the global home button, matching Swift\'s exclusion list', (tester) async {
    await _bootedToDreamHaven(tester);

    // Codex is also on the exclusion list (exercised separately below, via
    // its real reachable path through Team/Inventory) — this test reaches
    // the same `showsGlobalHomeButton` mechanism via Dream Haven's
    // Summoning Shrine card instead.
    // `SummoningShrineView` is a real screen now (not a `_ComingSoonScreen`),
    // so it has no `placeholder-home-button` — the way back is its own
    // header Back button instead.
    await tester.tap(find.byKey(const Key('dream-haven-building-summon')));
    await _settle(tester);

    expect(find.text('Summoning Shrine'), findsOneWidget);
    expect(find.byKey(const Key('global-home-button')), findsNothing);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(find.text('Dream Haven'), findsOneWidget);
  });

  testWidgets('every Dream Haven navigation affordance reaches its destination', (tester) async {
    await _bootedToDreamHaven(tester);

    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-team-card'), 'Inventory');
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-footer-inventory'), 'Inventory');
    // `BattlePassView` is a real screen now too (not a `_ComingSoonScreen`),
    // and (matching Swift) isn't on the global-home-button exclusion list —
    // its own header reads "Season Pass", not "Battle Pass" (the route/nav
    // key name and the on-screen title diverge here, same pattern as
    // Arena/"Arena Tower" and Bestiary/"Dream Observatory").
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-battlepass-banner'), 'Season Pass');
    // `SummoningShrineView` is a real screen now too, and (matching Swift)
    // stays on the global-home-button exclusion list — returns via its own
    // Back button instead of either placeholder pattern.
    await _tapAndReturnToRealScreenViaOwnBackButton(tester, const Key('dream-haven-building-summon'), 'Summoning Shrine');
    // `BestiaryView` is a real screen now too (not a `_ComingSoonScreen`),
    // and (matching Swift) isn't on the global-home-button exclusion list —
    // its own header reads "Dream Observatory", not "Bestiary".
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-building-observatory'), 'Dream Observatory');
    // `ArenaView` is a real screen now too (not a `_ComingSoonScreen`), and
    // (matching Swift) isn't on the global-home-button exclusion list —
    // its own header reads "The Endless Trial", not "Arena".
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-building-arena'), 'The Endless Trial');
    // `SettingsView` is a real screen now too (not a `_ComingSoonScreen`),
    // and (matching Swift) isn't on the global-home-button exclusion list.
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-header-settings'), 'Settings');
    // `ShopView` is a real screen now too (not a `_ComingSoonScreen`), and
    // (matching Swift) isn't on the global-home-button exclusion list.
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-header-shop'), 'Shop');

    // A brand new save deploys a starter Dreamkeeper (see
    // `GameSave.newGame`), so the Campaign footer button starts enabled.
    // `CampaignView` is a real screen now too (not a `_ComingSoonScreen`).
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-footer-campaign'), 'Campaign');
    // `ProfileView` is a real screen now too (not a `_ComingSoonScreen`),
    // and (matching Swift) isn't on the global-home-button exclusion list.
    await _tapAndReturnToRealScreen(tester, const Key('dream-haven-header-profile'), 'Profile');
  });

  testWidgets('fighting the frontier stage from Campaign reaches Battle, then Battle Result, then Dream Haven',
      (tester) async {
    await _bootedToDreamHaven(tester);

    await tester.tap(find.byKey(const Key('dream-haven-footer-campaign')));
    await _settle(tester);
    expect(find.text('Campaign'), findsOneWidget);

    // A brand new save's frontier is stage 1 — unlocked, not yet cleared, so
    // tapping it fights directly with no Fight-or-Sweep choice, landing on
    // the real `BattleRoute` (`BattleScreen`/`BattleView`) rather than the
    // `_ComingSoonScreen` placeholder.
    await tester.tap(find.bySemanticsLabel('Stage 1'));
    await _settle(tester);

    // Both Battle and Battle Result are on Swift's `showsGlobalHomeButton`
    // exclusion list — unlike every other real screen reached in this
    // suite, neither ever shows the global home button, and Battle itself
    // has no back affordance at all: the only way out is to let the fight
    // resolve.
    expect(find.byKey(const Key('global-home-button')), findsNothing);
    expect(find.textContaining('Whispering Meadow'), findsOneWidget);

    // A fresh starter Dreamkeeper against stage 1's enemy resolves via
    // plain basic attacks alone — no button taps needed. Poll in bounded
    // steps (instead of a fixed sleep) until the outcome overlay's
    // "Continue" button appears, so this stays robust to the real
    // (non-deterministic) damage variance without an indefinite hang.
    var resolved = false;
    for (var i = 0; i < 200 && !resolved; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      resolved = find.text('Continue').evaluate().isNotEmpty;
    }
    expect(resolved, isTrue, reason: 'battle never resolved within the polling budget');

    await tester.tap(find.text('Continue'));
    await _settle(tester);

    // Battle Result is also on the exclusion list.
    expect(find.byKey(const Key('global-home-button')), findsNothing);
    expect(find.textContaining('Stage 1'), findsOneWidget);

    // A win on stage 1 (campaign nowhere near complete) offers both
    // footer buttons; either one leads back to Dream Haven eventually —
    // this exercises the plain "Dream Haven" exit.
    final dreamHavenButton = find.text('Dream Haven');
    final continueButton = find.text('Continue');
    await tester.tap(dreamHavenButton.evaluate().isNotEmpty ? dreamHavenButton : continueButton);
    await _settle(tester);

    expect(find.text('Dream Haven'), findsOneWidget);
    expect(find.byKey(const Key('global-home-button')), findsNothing);
  });

  testWidgets(
      "Team/Inventory's header button reaches the Dreamkeeper Codex, which hides the global home button and returns via its own Back button",
      (tester) async {
    await _bootedToDreamHaven(tester);

    await tester.tap(find.byKey(const Key('dream-haven-team-card')));
    await _settle(tester);
    expect(find.text('Inventory'), findsOneWidget);

    // `DreamkeeperCodexView` isn't reached from Dream Haven directly — it's
    // reached from Team/Inventory's own header icon button (no `Key`, just
    // a `Semantics` label, unlike Dream Haven's building/footer cards).
    await tester.tap(find.bySemanticsLabel('Dreamkeeper Codex'));
    await _settle(tester);

    expect(find.text('Dreamkeeper Codex'), findsOneWidget);
    // `CodexRoute` is on the `showsGlobalHomeButton` exclusion list
    // (matching Swift), same as Summon — no global home button, own Back
    // button instead.
    expect(find.byKey(const Key('global-home-button')), findsNothing);

    // Codex's own header Back button routes straight to `DreamHavenRoute`
    // (not back to Inventory) — same as `SummoningShrineView`'s Back
    // button, regardless of which screen actually linked to it.
    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);
    expect(find.text('Dream Haven'), findsOneWidget);
  });

  testWidgets(
      'fighting floor 1 from the Arena hub reaches Arena Battle, then Arena Result, then Dream Haven',
      (tester) async {
    await _bootedToDreamHaven(tester);

    await tester.tap(find.byKey(const Key('dream-haven-building-arena')));
    await _settle(tester);
    expect(find.text('The Endless Trial'), findsOneWidget);

    // A brand new save starts with a deployed starter and a full ticket
    // allowance, so floor 1 is unlocked and affordable with no dialog.
    await tester.tap(find.bySemanticsLabel('Floor 1'));
    await _settle(tester);

    // Arena Battle reuses the shared `BattleView`, which (like Campaign's
    // `BattleRoute`) sits on the `showsGlobalHomeButton` exclusion list.
    expect(find.byKey(const Key('global-home-button')), findsNothing);
    expect(find.textContaining('Endless Trial'), findsWidgets);

    var resolved = false;
    for (var i = 0; i < 200 && !resolved; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      resolved = find.text('Continue').evaluate().isNotEmpty;
    }
    expect(resolved, isTrue, reason: 'arena battle never resolved within the polling budget');

    await tester.tap(find.text('Continue'));
    await _settle(tester);

    // Arena Result is also on the exclusion list.
    expect(find.byKey(const Key('global-home-button')), findsNothing);
    expect(find.textContaining('Floor 1'), findsOneWidget);

    await tester.tap(find.text('Dream Haven'));
    await _settle(tester);

    expect(find.text('Dream Haven'), findsOneWidget);
    expect(find.byKey(const Key('global-home-button')), findsNothing);
  });

  testWidgets('the missions and daily login bonus sheets open from the header', (tester) async {
    await _bootedToDreamHaven(tester);

    await tester.tap(find.byKey(const Key('dream-haven-header-missions')));
    await _settle(tester);
    expect(find.text('Missions'), findsOneWidget);
    await tester.tapAt(const Offset(20, 20)); // Tap the scrim to dismiss.
    await _settle(tester);

    await tester.tap(find.byKey(const Key('dream-haven-header-loginreward')));
    await _settle(tester);
    expect(find.text('Daily Login Bonus'), findsOneWidget);
  });

  testWidgets('the gold fountain and training garden sheets open from their building cards', (tester) async {
    await _bootedToDreamHaven(tester);

    // Both sheet titles happen to repeat their own building card's name, and
    // the card stays mounted (just obscured) behind the modal sheet, so two
    // matches are expected — one from the card, one from the sheet header.
    await tester.tap(find.byKey(const Key('dream-haven-building-gold')));
    await _settle(tester);
    expect(find.text('Gold Fountain'), findsNWidgets(2));
    await tester.tapAt(const Offset(20, 20));
    await _settle(tester);

    await tester.tap(find.byKey(const Key('dream-haven-building-training')));
    await _settle(tester);
    expect(find.text('Training Garden'), findsNWidgets(2));
  });
}
