// Exercises `ProfileView` directly (not through `RootView`) — same shape as
// `settings_view_test.dart`. Covers the level card's EXP/max-level states,
// the stats grid's live values, and the Achievements sheet it opens.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/progression/achievement_system.dart';
import 'package:dreamkeepers/progression/level_system.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/profile/profile_view.dart';
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

Future<GameState> _pumpProfile(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  void Function(GameState gameState)? seed,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  seed?.call(gameState);
  await tester.pumpWidget(
    testApp(Scaffold(body: ProfileView(gameState: gameState, onNavigate: onNavigate)),
    ),
  );
  await _settle(tester);
  return gameState;
}

void main() {
  testWidgets('shows the header, player level, and journey stats', (tester) async {
    final gameState = await _pumpProfile(tester, onNavigate: (_) {});

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Player Level 1'), findsOneWidget);
    expect(find.text('Journey So Far'), findsOneWidget);
    expect(find.text('${gameState.save.gold}'), findsOneWidget);
    expect(find.text('${gameState.save.dreamGems}'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
  });

  testWidgets('a fresh save shows EXP progress, not "Max level reached"', (tester) async {
    await _pumpProfile(tester, onNavigate: (_) {});

    expect(find.text('Max level reached'), findsNothing);
    expect(find.textContaining('EXP to next level'), findsOneWidget);
  });

  testWidgets('a max-level save shows "Max level reached" instead of an EXP bar', (tester) async {
    await _pumpProfile(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.playerLevel = LevelSystem.maxLevel,
    );

    expect(find.text('Max level reached'), findsOneWidget);
    expect(find.textContaining('EXP to next level'), findsNothing);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpProfile(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('tapping Achievements opens the sheet showing every milestone, locked or not', (tester) async {
    await _pumpProfile(tester, onNavigate: (_) {});

    await tester.tap(find.text('Achievements'));
    await _settle(tester);

    expect(find.text('0/${AchievementSystem.all.length} unlocked'), findsOneWidget);
    // Every achievement's title renders, whether locked or unlocked — the
    // grid is lazily built (`GridView.builder`), so later entries need
    // scrolling into view first, same as any other scrollable list here.
    for (final achievement in AchievementSystem.all) {
      await tester.scrollUntilVisible(find.text(achievement.title), 200);
      expect(find.text(achievement.title), findsOneWidget, reason: achievement.id);
    }
  });

  testWidgets('an unlocked achievement shows its own icon and an "Unlocked" badge', (tester) async {
    final firstID = AchievementSystem.all.first.id;
    await _pumpProfile(
      tester,
      onNavigate: (_) {},
      seed: (gs) => gs.save.unlockedAchievementIDs.add(firstID),
    );

    await tester.tap(find.text('Achievements'));
    await _settle(tester);

    expect(find.text('1/${AchievementSystem.all.length} unlocked'), findsOneWidget);
    expect(find.bySemanticsLabel('Unlocked'), findsOneWidget);
  });
}
