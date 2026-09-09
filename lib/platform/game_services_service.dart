import 'package:flutter/foundation.dart';
import 'package:games_services/games_services.dart';

/// Google Play Games Services authentication state — Android counterpart
/// to `State/GameCenterService.swift`. Sign-in itself is handled entirely
/// by the platform's own UI (same as Game Center), so this just tracks the
/// resulting session the rest of the app reads.
///
/// Unlike Game Center's `GKLocalPlayer.loadFriends()`, the `games_services`
/// package has no friend-count API at all, so [friendCount] stays `null`
/// forever on Android — `SettingsView`'s account card already renders a
/// `null` friend count gracefully (falls back to showing just the display
/// name), so this requires no UI-side special-casing.
class GameServicesService extends ChangeNotifier {
  bool isAuthenticated = false;
  String? displayName;
  final int? friendCount = null;
  String? authError;

  /// Mirrors `GameCenterService.authenticate()`: attempt sign-in, then
  /// silently accept whatever the platform returns — the player may cancel
  /// the system sign-in sheet, which isn't an error worth surfacing loudly.
  Future<void> authenticate() async {
    try {
      await GameAuth.signIn();
      final signedIn = await GameAuth.isSignedIn;
      isAuthenticated = signedIn;
      authError = null;
      if (signedIn) {
        try {
          displayName = await Player.getPlayerName();
        } catch (_) {
          // Non-fatal, same as GameCenterService's friend-count load —
          // the card just shows a fallback label if this fails.
          displayName = null;
        }
      } else {
        displayName = null;
      }
    } catch (e) {
      isAuthenticated = false;
      displayName = null;
      authError = e.toString();
    }
    notifyListeners();
  }

  /// Opens the platform's own leaderboard screen — mirrors the "Leaderboard"
  /// button in `SettingsView.swift`'s `gameCenterCard` opening
  /// `GameCenterOverlay`. Android has no in-app overlay equivalent; this
  /// hands off to Play Games' own system UI instead.
  Future<void> showLeaderboard(String leaderboardID) async {
    try {
      await Leaderboards.showLeaderboards(androidLeaderboardID: leaderboardID);
    } catch (_) {
      // Best-effort UI hand-off — nothing to recover from here.
    }
  }
}

/// Android counterpart to `State/LeaderboardService.swift`: submits campaign
/// progress to the Play Games leaderboard, deduplicating identical
/// resubmissions the same way the Swift original does.
class GameLeaderboardService extends ChangeNotifier {
  /// Matches the leaderboard ID that must be created in Play Console under
  /// this app's Play Games Services configuration — see
  /// COMPLIANCE_CHECKLIST.md for the placeholder-App-ID note this pairs
  /// with. Kept as a distinct constant (not literally reused from iOS,
  /// which uses its own Game Center leaderboard ID namespace) since Play
  /// Console leaderboard IDs are opaque strings assigned per-console, not
  /// reverse-DNS like Game Center's.
  static const campaignProgressID = 'CgkI_dreamkeepers_campaign_stage';

  String? lastSubmissionError;
  int? _lastSubmittedStage;

  Future<void> submitCampaignProgress(int stage) async {
    if (_lastSubmittedStage == stage) return;
    try {
      final error = await Leaderboards.submitScore(
        score: Score(androidLeaderboardID: campaignProgressID, value: stage),
      );
      lastSubmissionError = error;
      if (error == null) _lastSubmittedStage = stage;
    } catch (e) {
      lastSubmissionError = e.toString();
    }
    notifyListeners();
  }
}
