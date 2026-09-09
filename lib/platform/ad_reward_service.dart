import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// One seam for rewarded-video ads, mirroring how `PlatformService` isolates
/// the rest of the OS. `GameState` and every other call site are written
/// against this seam, so swapping implementations is a one-line change at
/// the `GameState.create` call site. Mirrors Platform/AdRewardService.swift
/// exactly.
abstract class AdRewardService {
  /// Presents a rewarded-video ad and returns whether the viewer watched it
  /// through to the reward. A real implementation would also return
  /// `false` when no ad is available to fill.
  Future<bool> showRewardedAd();
}

/// Development placeholder: simulates the few seconds a real rewarded ad
/// takes to play, then always reports success. Lets the entire reward-grant
/// flow (cooldown, currency grant, VIP gating) be built and tested end to
/// end today, with no ad network dependency and no real ad content shown.
class MockAdRewardService implements AdRewardService {
  @override
  Future<bool> showRewardedAd() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    return true;
  }
}

/// Real Google Mobile Ads (AdMob) rewarded video, same shape as the iOS
/// side's rewarded implementation (Platform/AdRewardService.swift). Loads a
/// fresh `RewardedAd` for every presentation — AdMob rewarded ads are
/// single-use, the SDK has no "reset" call, only reload — and resolves
/// `true` only if the reward callback actually fires before the ad is
/// dismissed.
///
/// [adUnitId] defaults to Google's publicly published Android rewarded-ad
/// **test unit** (`ca-app-pub-3940256099942544/5224354917`, documented at
/// https://developers.google.com/admob/android/test-ads) so the whole
/// reward-grant flow works end to end today with real ad content, no AdMob
/// console account required. This mirrors exactly how
/// `InterstitialAdService.swift` initially shipped pointed at Google's
/// public test ID before the user supplied AdMob's real
/// `ca-app-pub-6011422497566268/...` unit — pass a real unit ID at the
/// `GameState.create()` call site in `main.dart` once an Android rewarded
/// ad unit exists in the AdMob console (same App ID as the interstitial,
/// new ad unit, "Rewarded" format).
class AdMobRewardService implements AdRewardService {
  AdMobRewardService({this.adUnitId = _testAdUnitId});

  static const _testAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  final String adUnitId;

  @override
  Future<bool> showRewardedAd() async {
    final completer = Completer<bool>();
    var rewardEarned = false;

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(rewardEarned);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(false);
            },
          );
          ad.show(
            onUserEarnedReward: (ad, reward) {
              rewardEarned = true;
            },
          );
        },
        onAdFailedToLoad: (error) {
          // No fill / network error — same "no reward" outcome the mock's
          // caller already handles via the returned `false`.
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }
}
