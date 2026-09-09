import 'package:flutter/material.dart';

import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

enum _Phase { playing, rewarded, declined }

/// Rewarded-ad wrapper — see `AdRewardService`. The "playing" phase below is
/// only the loading/transition state; the real ad SDK presents the actual
/// ad video full-screen on top of this sheet on iOS, and this view resumes
/// once that's dismissed, landing on rewarded/declined. Mirrors
/// `RewardedAdSheet` (UI/DreamHaven/RewardedAdSheet.swift) exactly.
///
/// NOTE: never script or automate taps that reach this sheet's real
/// building-card trigger in the Simulator/device or in an automated test —
/// repeated non-human traffic against the live AdMob ad unit risks the
/// account being flagged. Exercise `GameState.watchRewardedAd()` (and this
/// widget's phase transitions) against a mock `AdRewardService` instead.
class RewardedAdSheet extends StatefulWidget {
  final GameState gameState;
  const RewardedAdSheet({super.key, required this.gameState});

  @override
  State<RewardedAdSheet> createState() => _RewardedAdSheetState();
}

class _RewardedAdSheetState extends State<RewardedAdSheet> {
  _Phase _phase = _Phase.playing;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rewarded = await widget.gameState.watchRewardedAd();
      if (!mounted) return;
      setState(() => _phase = rewarded ? _Phase.rewarded : _Phase.declined);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Mirrors Swift's `.interactiveDismissDisabled()` — the ad is either
      // in flight or just resolved; swiping it away mid-flight would strand
      // `watchRewardedAd()`'s pending reward decision.
      canPop: false,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: dk_theme.Theme.background),
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: SafeArea(top: false, child: Center(child: _content(context))),
      ),
    );
  }

  Widget _content(BuildContext context) {
    switch (_phase) {
      case _Phase.playing:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 36, height: 36, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)),
            SizedBox(height: 16),
            Text('Loading Ad…', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        );
      case _Phase.rewarded:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.25), shape: BoxShape.circle),
                ),
                Icon(sfSymbol('gift.fill'), size: 26, color: dk_theme.Theme.gold),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Reward Claimed!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(sfSymbol('circle.hexagongrid.fill'), color: dk_theme.Theme.gold, size: 18),
                const SizedBox(width: 4),
                Text('+${GameState.rewardedAdGold}', style: const TextStyle(color: dk_theme.Theme.gold, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Icon(sfSymbol('sparkles'), color: dk_theme.Theme.violet, size: 18),
                const SizedBox(width: 4),
                Text('+${GameState.rewardedAdGems}', style: const TextStyle(color: dk_theme.Theme.violet, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: dk_theme.PrimaryButton(
                tint: dk_theme.Theme.gold,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Nice!'),
              ),
            ),
          ],
        );
      case _Phase.declined:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ad Unavailable', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: dk_theme.PrimaryButton(
                tint: Colors.white.withValues(alpha: 0.15),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        );
    }
  }
}
