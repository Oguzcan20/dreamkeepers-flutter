import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// One seam for automatic (non-rewarded) interstitial ads — same shape as
/// `AdRewardService`, kept as a separate abstract class because it's a
/// distinct concern (paced automatically by `GameState`, not
/// player-initiated, and never grants a currency reward). Mirrors
/// Platform/InterstitialAdService.swift exactly.
abstract class InterstitialAdService {
  /// Loads and presents an interstitial, completing once it's been
  /// dismissed (or failed to load/present — the caller doesn't need to
  /// distinguish those; unlike a rewarded ad there's no reward to
  /// withhold either way).
  Future<void> showInterstitialAd();
}

/// Placeholder: simulates the brief load a real interstitial takes, shows
/// nothing. No ad network wired in yet on the Flutter side — see the port
/// plan's "Platform integration" phase.
class MockInterstitialAdService implements InterstitialAdService {
  @override
  Future<void> showInterstitialAd() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}

/// Real Google Mobile Ads (AdMob) interstitial, same shape as the iOS
/// side's `InterstitialAdService.swift`. Loads a fresh `InterstitialAd` for
/// every presentation, same one-shot rationale as `AdMobRewardService`.
///
/// [adUnitId] defaults to Google's publicly published Android interstitial
/// **test unit** (`ca-app-pub-3940256099942544/1033173712`, documented at
/// https://developers.google.com/admob/android/test-ads). Mirrors how
/// `InterstitialAdService.swift` initially shipped on Google's public test
/// ID before the user supplied their own real AdMob unit
/// (`ca-app-pub-6011422497566268/4756154109`) — pass that same App ID's
/// Android counterpart here (create a matching Android ad unit in the same
/// AdMob app, or a new Android app entry — Google requires one AdMob "app"
/// per platform) at the `GameState.create()` call site in `main.dart` once
/// it exists.
class AdMobInterstitialAdService implements InterstitialAdService {
  AdMobInterstitialAdService({this.adUnitId = _testAdUnitId});

  static const _testAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  final String adUnitId;

  @override
  Future<void> showInterstitialAd() async {
    final completer = Completer<void>();

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    return completer.future;
  }
}
