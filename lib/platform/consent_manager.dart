import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// GDPR/UMP consent flow — Android counterpart to
/// `Platform/ConsentManager.swift`. Abstracted the same way
/// `AdRewardService`/`InterstitialAdService`/`PurchaseService` are (a real
/// implementation backed by the platform SDK, a [NoopConsentService]
/// default) rather than a bare static call, so widget tests that pump
/// `RootView` never touch a real platform channel unless a test explicitly
/// opts in — same rationale as `MockAdRewardService`.
abstract class ConsentService {
  Future<void> requestConsentIfNeeded();
}

/// Uses the UMP APIs Google's Mobile Ads SDK already bundles
/// (`google_mobile_ads`'s `lib/src/ump/`), so no separate consent package
/// was needed — mirrors the Swift original calling Google's native
/// `UserMessagingPlatform` framework directly.
///
/// Must run before any ad request, same ordering `RootView.swift` enforces.
/// There is no Android equivalent of `TrackingPermission`/ATT (that's an
/// iOS-only concept), so unlike the Swift `RootView.onAppear` sequence,
/// nothing else needs to run after this.
class UmpConsentService implements ConsentService {
  /// Requests a consent info update, then loads and shows a consent form
  /// only if the user's region/status actually requires one (the SDK
  /// itself decides that — most non-EEA users see nothing here at all).
  @override
  Future<void> requestConsentIfNeeded() async {
    final updated = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(tagForUnderAgeOfConsent: false),
      () => updated.complete(),
      (error) {
        // Non-fatal: same as the Swift original, a failed consent-info
        // update just means no form is shown this launch — never blocks
        // the rest of app startup.
        if (!updated.isCompleted) updated.complete();
      },
    );
    await updated.future;

    // Already returns a Future that completes once the (possibly
    // nonexistent) form has been shown and dismissed — no extra
    // Completer wrapping needed, unlike requestConsentInfoUpdate above.
    await ConsentForm.loadAndShowConsentFormIfRequired((formError) {});
  }
}

/// Default/test stand-in — does nothing. Keeps `RootView`'s widget tests
/// from ever touching the real UMP platform channel, same as
/// `MockAdRewardService`/`NoopPlatformService` elsewhere in this app.
class NoopConsentService implements ConsentService {
  @override
  Future<void> requestConsentIfNeeded() async {}
}
