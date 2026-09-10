// Exercises `SettingsView` directly (not through `RootView`) — same shape
// as `campaign_view_test.dart`. Covers the toggle rows' live state, the
// language switcher, the reset-progress confirmation flow, the signed-out
// vs signed-in account card, and back navigation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/platform/game_services_service.dart';
import 'package:dreamkeepers/platform/google_sign_in_service.dart';
import 'package:dreamkeepers/state/account_state.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/root/app_route.dart';
import 'package:dreamkeepers/ui/settings/settings_view.dart';
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

class _Pumped {
  final GameState gameState;
  final AccountState accountState;
  final GameServicesService gameServicesService;
  _Pumped(this.gameState, this.accountState, this.gameServicesService);
}

Future<_Pumped> _pumpSettings(
  WidgetTester tester, {
  required ValueChanged<AppRoute> onNavigate,
  void Function(GameState gameState)? seed,
  void Function(GameServicesService gameServicesService)? seedGameServices,
}) async {
  SharedPreferences.setMockInitialValues({});
  final gameState = await GameState.create();
  final accountState = AccountState();
  await accountState.load();
  final gameServicesService = GameServicesService();
  seed?.call(gameState);
  // Seed *before* the first pump, same rationale as every other screen's
  // test helper — a post-pump field mutation needs an explicit
  // `notifyListeners()` the widget under test never calls on our behalf.
  seedGameServices?.call(gameServicesService);
  await tester.pumpWidget(
    testApp(Scaffold(
        body: SettingsView(
          gameState: gameState,
          accountState: accountState,
          gameServicesService: gameServicesService,
          googleSignInService: GoogleSignInService(),
          onNavigate: onNavigate,
        ),
      ),
    ),
  );
  await _settle(tester);
  return _Pumped(gameState, accountState, gameServicesService);
}

void main() {
  testWidgets('shows the header and every settings card', (tester) async {
    await _pumpSettings(tester, onNavigate: (_) {});

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Sound Effects'), findsOneWidget);
    expect(find.text('Haptics'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Your Data'), findsOneWidget);
    expect(find.text('Reset Progress'), findsOneWidget);
  });

  testWidgets('the back button navigates to Dream Haven via onNavigate', (tester) async {
    AppRoute? lastRoute;
    await _pumpSettings(tester, onNavigate: (route) => lastRoute = route);

    await tester.tap(find.bySemanticsLabel('Back'));
    await _settle(tester);

    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('the sound toggle flips GameState.soundEnabled live', (tester) async {
    final pumped = await _pumpSettings(tester, onNavigate: (_) {});
    expect(pumped.gameState.soundEnabled, isTrue); // A fresh save defaults sound on.

    await tester.tap(find.byType(Switch).at(0)); // Sound Effects is the first toggle row.
    await _settle(tester);

    expect(pumped.gameState.soundEnabled, isFalse);
  });

  testWidgets('the haptics toggle flips GameState.hapticsEnabled live', (tester) async {
    final pumped = await _pumpSettings(tester, onNavigate: (_) {});
    expect(pumped.gameState.hapticsEnabled, isTrue); // A fresh save defaults haptics on.

    await tester.tap(find.byType(Switch).at(1)); // Haptics is the second toggle row.
    await _settle(tester);

    expect(pumped.gameState.hapticsEnabled, isFalse);
  });

  testWidgets('enabling notifications on a fresh save snaps back off (NoopPlatformService denies)', (tester) async {
    final pumped = await _pumpSettings(tester, onNavigate: (_) {});
    expect(pumped.gameState.notificationsEnabled, isFalse); // A fresh save defaults notifications off.

    await tester.tap(find.byType(Switch).at(2)); // Notifications is the third toggle row.
    await _settle(tester);

    // `NoopPlatformService.requestNotificationAuthorization` always resolves
    // `false` — the switch's own optimistic flip snaps back once that
    // resolves, matching the Swift original's Binding behavior.
    expect(pumped.gameState.notificationsEnabled, isFalse);
  });

  testWidgets('a fresh save defaults to English; picking Deutsch prompts a restart before it persists', (tester) async {
    final pumped = await _pumpSettings(tester, onNavigate: (_) {});
    expect(pumped.gameState.preferredLanguage, isNull);

    // The language card now sits below the default 800×600 test viewport's
    // fold, pushed down by the new Play Games card above it — same fix
    // already used below for "Reset Progress".
    await tester.ensureVisible(find.text('Deutsch'));
    await tester.tap(find.text('Deutsch'));
    await _settle(tester);

    // The switch takes effect on the next launch, so it asks first and
    // doesn't touch the save until confirmed.
    expect(find.text('Restart required'), findsOneWidget);
    expect(pumped.gameState.preferredLanguage, isNull);

    await tester.tap(find.text('Cancel'));
    await _settle(tester);
    expect(pumped.gameState.preferredLanguage, isNull);

    await tester.ensureVisible(find.text('Deutsch'));
    await tester.tap(find.text('Deutsch'));
    await _settle(tester);
    await tester.tap(find.text('Restart Now'));
    await _settle(tester);

    expect(pumped.gameState.preferredLanguage, 'de');
  });

  testWidgets('Reset Progress asks for confirmation, then wipes the save and navigates home', (tester) async {
    AppRoute? lastRoute;
    final pumped = await _pumpSettings(
      tester,
      onNavigate: (route) => lastRoute = route,
      seed: (gs) => gs.setSoundEnabled(false),
    );

    // The reset button sits near the bottom of a `SingleChildScrollView` —
    // below the test surface's default viewport on its own, so it needs an
    // explicit scroll into view before it's tappable (unlike a fixed-height
    // screen, where every control is already on screen).
    await tester.ensureVisible(find.text('Reset Progress'));
    await tester.tap(find.text('Reset Progress'));
    await _settle(tester);

    expect(find.text('Reset all progress?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await _settle(tester);

    // Cancelling leaves the save untouched and doesn't navigate.
    expect(pumped.gameState.soundEnabled, isFalse);
    expect(lastRoute, isNull);

    await tester.ensureVisible(find.text('Reset Progress'));
    await tester.tap(find.text('Reset Progress'));
    await _settle(tester);
    // Two "Reset Progress" texts now exist: the button (still under the
    // dialog) and the dialog's own destructive action.
    await tester.tap(find.text('Reset Progress').last);
    await _settle(tester);

    expect(pumped.gameState.soundEnabled, isTrue); // Back to a fresh save's default.
    expect(lastRoute, isA<DreamHavenRoute>());
  });

  testWidgets('a signed-out account shows a Sign in with Google button', (tester) async {
    await _pumpSettings(tester, onNavigate: (_) {});

    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
  });

  testWidgets('the Google sign-in button drives AccountState via GoogleSignInService', (tester) async {
    final pumped = await _pumpSettings(tester, onNavigate: (_) {});
    expect(pumped.accountState.isSignedIn, isFalse);

    // No real Google account is available in the widget-test environment
    // (no platform channel mocked) — `GoogleSignIn().signIn()` resolves to
    // `null` there, same as a user cancelling the system picker, so
    // `AccountState` stays signed out. This exercises that the tap wires
    // through to the service without throwing, not a full OAuth round trip.
    await tester.tap(find.text('Sign in with Google'));
    await _settle(tester);

    expect(pumped.accountState.isSignedIn, isFalse);
  });

  testWidgets('a signed-out Play Games card shows Not signed in with a Sign In button', (tester) async {
    await _pumpSettings(tester, onNavigate: (_) {});

    expect(find.text('Play Games'), findsOneWidget);
    expect(find.text('Not signed in'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('an authenticated GameServicesService flips the Play Games card to show Leaderboard', (tester) async {
    await _pumpSettings(
      tester,
      onNavigate: (_) {},
      seedGameServices: (services) {
        services.isAuthenticated = true;
        services.displayName = 'TestPlayer';
      },
    );

    expect(find.text('TestPlayer'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Not signed in'), findsNothing);
  });
}
