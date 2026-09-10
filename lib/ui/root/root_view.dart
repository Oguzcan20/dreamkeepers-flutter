import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../../platform/consent_manager.dart';
import '../../platform/game_services_service.dart';
import '../../platform/google_sign_in_service.dart';
import '../../progression/achievement_system.dart';
import '../../state/account_state.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../arena/arena_result_view.dart';
import '../arena/arena_view.dart';
import '../battle/battle_view.dart';
import '../battle_pass/battle_pass_view.dart';
import '../battle_result/battle_result_view.dart';
import '../bestiary/bestiary_view.dart';
import '../campaign/campaign_view.dart';
import '../codex/dreamkeeper_codex_view.dart';
import '../dream_haven/dream_haven_view.dart';
import '../dungeon/dungeon_result_view.dart';
import '../dungeon/dungeon_view.dart';
import '../main_menu/loading_view.dart';
import '../main_menu/main_menu_view.dart';
import '../onboarding/onboarding_view.dart';
import '../onboarding/starter_olf_choice_view.dart';
import '../profile/profile_view.dart';
import '../settings/settings_view.dart';
import '../shop/shop_view.dart';
import '../summon/summoning_shrine_view.dart';
import '../team/inventory_view.dart';
import 'app_route.dart';
import 'interstitial_ad_sheet.dart';

/// App root: owns navigation between every top-level screen, the
/// once-per-launch onboarding overlay, achievement toasts, interstitial ad
/// pacing, Play Games Services auth/leaderboard submission, and the GDPR/UMP
/// consent flow. Mirrors `RootView` (UI/Root/RootView.swift), with these
/// deliberate gaps versus the Swift original — each is its own pending
/// task, not an oversight:
/// - App Tracking Transparency (`TrackingPermission`) has no Android
///   analog at all, so unlike `RootView.swift`'s `.onAppear`, nothing runs
///   after the consent flow here — see `platform/consent_manager.dart`.
/// - `RootView` doesn't yet auto-present `LoginRewardSheet` once per launch
///   the way Swift's `maybeOfferLoginReward` does — the sheet itself is
///   ported and reachable from `DreamHavenView`'s gift button, just not
///   auto-popped.
/// - `DK_START_ROUTE`/`DK_SEED_*`/`DK_OPEN_BUILDING` QA env-var seeding — an
///   Xcode-scheme-only dev convenience, not user-facing.
/// - Every screen `currentScreen` switches on is now a real port — the
///   `_ComingSoonScreen` placeholder that used to stand in for unported
///   routes has been removed entirely (Battle Pass was the last one).
class RootView extends StatefulWidget {
  /// Defaults to [NoopConsentService] when omitted — same rationale as
  /// `GameState.create()`'s `Mock*Service` defaults, so widget tests that
  /// pump a bare `RootView()` never touch the real UMP platform channel.
  /// `main.dart` passes the real [UmpConsentService] explicitly.
  final ConsentService? consentService;

  const RootView({super.key, this.consentService});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  bool _isLoading = true;
  AppRoute _route = const MainMenuRoute();
  Achievement? _activeAchievementPopup;
  bool _achievementCheckScheduled = false;
  bool _showInterstitial = false;

  // Play Games Services auth is deferred until the player actually leaves
  // the Main Menu, same as `RootView.swift`'s `gameCenterService.authenticate()`
  // guard — its system "Signed in as..." toast would otherwise visually
  // clash with the Main Menu logo.
  bool _hasRequestedGameServicesAuth = false;
  bool _hasRequestedConsent = false;
  int? _lastSubmittedLeaderboardStage;
  late final ConsentService _consentService;

  @override
  void initState() {
    super.initState();
    _consentService = widget.consentService ?? NoopConsentService();
    // Fire-and-forget, same as the Swift original's one-shot launch Task —
    // runs once, doesn't gate the UI, and (per ConsentService's own doc
    // comment) must happen before any ad request. Silent Google sign-in
    // rides along right after since both are launch-time, non-interactive
    // background checks with nothing else in this app depending on their
    // ordering relative to each other.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _requestConsentAndSilentSignInOnce());
  }

  Future<void> _requestConsentAndSilentSignInOnce() async {
    if (_hasRequestedConsent) return;
    _hasRequestedConsent = true;
    await _consentService.requestConsentIfNeeded();
    if (!mounted) return;
    await context
        .read<GoogleSignInService>()
        .signInSilentlyIfAvailable(context.read<AccountState>());
  }

  void _maybeAuthenticateGameServices() {
    if (_hasRequestedGameServicesAuth || _route is MainMenuRoute) return;
    _hasRequestedGameServicesAuth = true;
    context.read<GameServicesService>().authenticate();
  }

  /// Mirrors `leaderboardService.submitCampaignProgress(stage:)` being
  /// called both on stage-change and re-triggered via
  /// `.onChange(of: gameCenterService.isAuthenticated)` — `stage` is the
  /// single input either trigger ultimately needs, and
  /// `GameLeaderboardService.submitCampaignProgress` already dedupes
  /// identical resubmissions, so one guarded call site covers both cases.
  void _maybeSubmitLeaderboard(
      GameState state, GameServicesService gameServices) {
    if (!gameServices.isAuthenticated) return;
    if (_lastSubmittedLeaderboardStage == state.currentStage) return;
    _lastSubmittedLeaderboardStage = state.currentStage;
    context
        .read<GameLeaderboardService>()
        .submitCampaignProgress(state.currentStage);
  }

  bool get _showsGlobalHomeButton => switch (_route) {
        MainMenuRoute() ||
        BattleRoute() ||
        BattleResultRoute() ||
        DreamHavenRoute() ||
        SummonRoute() ||
        ArenaBattleRoute() ||
        ArenaResultRoute() ||
        DungeonBattleRoute() ||
        DungeonResultRoute() ||
        CodexRoute() =>
          false,
        _ => true,
      };

  // The floating home button lives in the bottom-left corner, so every
  // screen that shows it only needs enough clearance for the button's own
  // footprint (~48px + margin). Swift reserves 165 here for its *scrollable*
  // screens, but Swift does it with `.safeAreaInset(edge: .bottom)`, which
  // leaves the scroll view full height and just adds a bottom content inset
  // so the last card can still scroll clear of the button. Flutter has no
  // direct equivalent — this clearance is applied as an outer `Padding`
  // (see `build`), which *hard-shrinks* the screen's box. At 165 on a
  // Pixel 6-class emulator (411 logical px tall in landscape) that ate a
  // third of the height: it once squeezed `InventoryView`'s roster grid to
  // a 5.4px `Expanded`, and it clipped `CampaignView`/`ArenaView`'s scroll
  // viewport to ~158px (world card cut through the stage nodes, dead space
  // below). Neither of those screens has a bottom-docked action bar, so 56
  // is enough for all of them; each scrolling screen pads its own scroll
  // content at the bottom instead so the last card clears the button.
  double get _homeButtonClearance => 56;

  void _navigate(AppRoute destination) {
    setState(() => _route = destination);
    _maybeAuthenticateGameServices();
  }

  /// Android hardware/gesture back. The Swift original never handles this —
  /// iOS has no system back button — so this whole path is Android-only, and
  /// it deliberately does NOT try to be a real navigation stack (there
  /// isn't one: `_route` is a flat enum and `_navigate` just replaces it).
  /// Instead it maps back to the one destination each screen's own UI would
  /// send the player: sub-screens and battle/result screens to Dream Haven,
  /// Dream Haven to the Main Menu, and only the Main Menu lets the event
  /// through so the OS closes the app. Without this, `PopScope`'s default
  /// (`canPop: true`) means every back press from anywhere exits straight to
  /// the launcher.
  bool get _systemBackClosesApp => _route is MainMenuRoute;

  void _handleSystemBack() {
    final destination = switch (_route) {
      MainMenuRoute() => null,
      DreamHavenRoute() => const MainMenuRoute(),
      _ => const DreamHavenRoute(),
    };
    if (destination != null) _navigate(destination);
  }

  void _maybeShowInterstitial(GameState state) {
    if (!state.shouldShowInterstitial) return;
    setState(() => _showInterstitial = true);
  }

  void _showNextAchievementPopup(GameState state) {
    final next = state.consumeNextPendingAchievement();
    if (next == null) return;
    setState(() => _activeAchievementPopup = next);
  }

  void _dismissAchievementPopup(GameState state) {
    if (_activeAchievementPopup == null) return;
    setState(() => _activeAchievementPopup = null);
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) _showNextAchievementPopup(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    // Watched (not just read) so a change in `isAuthenticated` — e.g. the
    // Play Games sign-in Future completing after `_maybeAuthenticateGameServices`
    // fired it — re-runs this check, mirroring the Swift `.onChange`.
    _maybeSubmitLeaderboard(state, context.watch<GameServicesService>());

    if (!_achievementCheckScheduled &&
        _activeAchievementPopup == null &&
        state.pendingAchievements.isNotEmpty) {
      _achievementCheckScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _achievementCheckScheduled = false;
        if (mounted) _showNextAchievementPopup(state);
      });
    }

    return PopScope(
      canPop: _systemBackClosesApp,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleSystemBack();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                decoration:
                    const BoxDecoration(gradient: dk_theme.Theme.background)),

            if (_isLoading)
              LoadingView(onFinished: () => setState(() => _isLoading = false))
            else
              Padding(
                padding: EdgeInsets.only(
                    bottom: _showsGlobalHomeButton ? _homeButtonClearance : 0),
                child: _currentScreen(state),
              ),

            // Shown once, the first time a new save actually reaches Dream
            // Haven — not on the Main Menu, so it doesn't compete with the
            // Play button, and not before, since `GameSave.newGame` already
            // deploys a starter Dreamkeeper without any tutorial needed to
            // get there.
            if (_route is DreamHavenRoute && !state.hasSeenOnboarding)
              OnboardingView(onFinish: state.completeOnboarding),

            // Right after onboarding finishes — locks in the starter Olf's
            // element (or, via the secret hold-on-Ember gesture, Ultimate
            // Olf). `needsStarterOlfChoice` is naturally false for saves
            // from before this feature existed, so it never appears for them.
            if (_route is DreamHavenRoute &&
                state.hasSeenOnboarding &&
                state.needsStarterOlfChoice)
              StarterOlfChoiceView(onChoose: state.chooseStarterOlf),

            if (_activeAchievementPopup != null)
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _AchievementToast(
                      achievement: _activeAchievementPopup!,
                      onDismiss: () => _dismissAchievementPopup(state),
                    ),
                  ),
                ),
              ),

            if (_showsGlobalHomeButton)
              Align(
                alignment: Alignment.bottomLeft,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 14),
                    child: _homeButton(),
                  ),
                ),
              ),

            if (_showInterstitial)
              Positioned.fill(
                child: InterstitialAdSheet(
                  gameState: state,
                  onFinished: () => setState(() => _showInterstitial = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton() {
    final l = AppLocalizations.of(context);
    return ClipRRect(
      key: const Key('global-home-button'),
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: GestureDetector(
          onTap: () => _navigate(const DreamHavenRoute()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.home, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(l.navDreamHaven,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _currentScreen(GameState state) {
    return switch (_route) {
      MainMenuRoute() => MainMenuView(
          onPlay: () => _navigate(const DreamHavenRoute()),
          onSettings: () => _navigate(const SettingsRoute()),
        ),
      DreamHavenRoute() =>
        DreamHavenView(gameState: state, onNavigate: _navigate),
      // `BattleScreen` owns its own `BattleEngine` (built once in
      // `initState`) — a fresh `BattleScreen` instance is created here every
      // time `_route` becomes `BattleRoute()` again (including "Next
      // Battle" from `BattleResultView`), which naturally gives it a fresh
      // engine, mirroring Swift's `activeEngine = nil` reset without
      // needing to hoist any engine state up into `RootView` itself.
      BattleRoute() => BattleScreen(gameState: state, onNavigate: _navigate),
      BattleResultRoute(:final summary) => BattleResultView(
          summary: summary,
          gameState: state,
          onNavigate: (destination) {
            _navigate(destination);
            // Mirrors `RootView.onContinue`/`onNextBattle` re-checking
            // interstitial pacing right after a battle-result screen is left.
            _maybeShowInterstitial(state);
          },
        ),
      TeamRoute() => InventoryView(gameState: state, onNavigate: _navigate),
      CampaignRoute() => CampaignView(gameState: state, onNavigate: _navigate),
      SummonRoute() =>
        SummoningShrineView(gameState: state, onNavigate: _navigate),
      ShopRoute() => ShopView(gameState: state, onNavigate: _navigate),
      SettingsRoute() => SettingsView(
          gameState: state,
          accountState: context.watch<AccountState>(),
          gameServicesService: context.watch<GameServicesService>(),
          googleSignInService: context.read<GoogleSignInService>(),
          onNavigate: _navigate,
        ),
      ProfileRoute() => ProfileView(gameState: state, onNavigate: _navigate),
      ObservatoryRoute() =>
        BestiaryView(gameState: state, onNavigate: _navigate),
      BattlePassRoute() =>
        BattlePassView(gameState: state, onNavigate: _navigate),
      CodexRoute() =>
        DreamkeeperCodexView(gameState: state, onNavigate: _navigate),
      ArenaRoute() => ArenaView(
          gameState: state,
          onNavigate: _navigate,
          onFight: (floor) => _navigate(ArenaBattleRoute(floor)),
        ),
      ArenaBattleRoute(:final floor) => ArenaBattleScreen(
          gameState: state, floor: floor, onNavigate: _navigate),
      ArenaResultRoute(:final summary) =>
        ArenaResultView(summary: summary, onNavigate: _navigate),
      DungeonRoute() => DungeonView(
          gameState: state,
          onNavigate: _navigate,
          onFight: (dungeon) => _navigate(DungeonBattleRoute(dungeon)),
        ),
      DungeonBattleRoute(:final dungeon) => DungeonBattleScreen(
          gameState: state, dungeon: dungeon, onNavigate: _navigate),
      DungeonResultRoute(:final summary) =>
        DungeonResultView(summary: summary, onNavigate: _navigate),
    };
  }
}

/// A gold-ringed toast banner for a newly-unlocked `Achievement` — slides
/// in from the top over whatever screen is currently showing (achievements
/// can complete mid-play, from a battle win, fusion, or summon) rather than
/// blocking play with a full takeover. Auto-dismisses after a few seconds,
/// or tap to dismiss early. Mirrors `AchievementToast` exactly.
class _AchievementToast extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;
  const _AchievementToast({required this.achievement, required this.onDismiss});

  @override
  State<_AchievementToast> createState() => _AchievementToastState();
}

class _AchievementToastState extends State<_AchievementToast> {
  bool _appeared = false;
  Timer? _autoDismissTimer;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
    _autoDismissTimer = Timer(const Duration(seconds: 3), _dismiss);
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _dismissTimer?.cancel();
    super.dispose();
  }

  void _dismiss() {
    if (!mounted) return;
    setState(() => _appeared = false);
    _dismissTimer = Timer(const Duration(milliseconds: 250), widget.onDismiss);
  }

  @override
  Widget build(BuildContext context) {
    final achievement = widget.achievement;
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: _dismiss,
      child: AnimatedScale(
        scale: _appeared ? 1 : 0.9,
        duration: const Duration(milliseconds: 250),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: dk_theme.Theme.gold.withValues(alpha: 0.6),
                    width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: dk_theme.Theme.gold.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: dk_theme.Theme.gold.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color:
                                    dk_theme.Theme.gold.withValues(alpha: 0.7),
                                blurRadius: 12)
                          ],
                        ),
                      ),
                      Icon(sfSymbol(achievement.icon),
                          color: dk_theme.Theme.gold, size: 22),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l.achievementUnlockedBanner,
                            style: const TextStyle(
                                color: dk_theme.Theme.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        Text(achievement.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(
                          achievement.detail,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
