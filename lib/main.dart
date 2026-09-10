import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'platform/ad_reward_service.dart';
import 'platform/consent_manager.dart';
import 'platform/flutter_platform_service.dart';
import 'platform/game_services_service.dart';
import 'platform/google_sign_in_service.dart';
import 'platform/interstitial_ad_service.dart';
import 'platform/purchase_service.dart';
import 'state/account_state.dart';
import 'state/game_state.dart';
import 'theme/theme.dart' as dk_theme;
import 'ui/root/root_view.dart';

/// `SaveSystem.load()` (and therefore `GameState.create`) is genuinely
/// async — see `lib/persistence/save_system.dart` — so app start has to
/// await it before `runApp`, unlike Swift's synchronous `GameState()`
/// (`RootView.init`). `WidgetsFlutterBinding.ensureInitialized()` is
/// required before any async work runs ahead of `runApp`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Landscape-only, matching the iOS original (Resources/Info.plist ships
  // just LandscapeLeft/LandscapeRight). Every screen is laid out against a
  // wide, short reference size; portrait overflows.
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Real AdMob/Play Billing services, not the Mock* ones — see
  // `AdMobRewardService`/`AdMobInterstitialAdService`/
  // `GooglePlayPurchaseService`'s doc comments for the test-ad-unit and
  // Play-Console-product caveats until real Android IDs replace them.
  await MobileAds.instance.initialize();
  final gameState = await GameState.create(
    platform: FlutterPlatformService(),
    adService: AdMobRewardService(),
    interstitialAdService: AdMobInterstitialAdService(),
    purchaseService: GooglePlayPurchaseService(),
  );
  final accountState = AccountState();
  await accountState.load();
  runApp(DreamkeepersApp(gameState: gameState, accountState: accountState));
}

class DreamkeepersApp extends StatelessWidget {
  final GameState gameState;
  final AccountState accountState;
  const DreamkeepersApp({super.key, required this.gameState, required this.accountState});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GameState>.value(value: gameState),
        ChangeNotifierProvider<AccountState>.value(value: accountState),
        // Android counterparts to Game Center / Sign in with Apple — see
        // `platform/game_services_service.dart` and
        // `platform/google_sign_in_service.dart`. Constructed here (not in
        // `create()`-style factories like GameState) since neither needs
        // async setup before the widget tree exists.
        ChangeNotifierProvider<GameServicesService>(create: (_) => GameServicesService()),
        ChangeNotifierProvider<GameLeaderboardService>(create: (_) => GameLeaderboardService()),
        Provider<GoogleSignInService>(create: (_) => GoogleSignInService()),
      ],
      child: MaterialApp(
        title: 'Dreamkeepers',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: dk_theme.Theme.deepNavy,
          useMaterial3: true,
        ),
        // Real UMP consent flow — see `platform/consent_manager.dart`'s
        // doc comment for why this is passed explicitly instead of
        // relying on RootView's NoopConsentService default.
        home: RootView(consentService: UmpConsentService()),
      ),
    );
  }
}
