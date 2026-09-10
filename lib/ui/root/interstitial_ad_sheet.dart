import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../state/game_state.dart';
import '../../theme/theme.dart' as dk_theme;

/// Full-screen automatic interstitial — see `GameState.shouldShowInterstitial`.
/// No reward, no user choice: it loads, presents (the ad SDK takes over the
/// screen itself), and this dismisses the instant that's done. Mirrors
/// `InterstitialAdSheet` (UI/Root/InterstitialAdSheet.swift), except the
/// caller passes an explicit `onFinished` instead of this popping a
/// `Navigator` route itself — `RootView` renders this directly inside its
/// own `Stack` (matching how little else about presentation modality is
/// settled this early in the port) rather than pushing it as a route.
class InterstitialAdSheet extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onFinished;
  const InterstitialAdSheet({super.key, required this.gameState, required this.onFinished});

  @override
  State<InterstitialAdSheet> createState() => _InterstitialAdSheetState();
}

class _InterstitialAdSheetState extends State<InterstitialAdSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.gameState.showInterstitialAd();
      if (mounted) widget.onFinished();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(gradient: dk_theme.Theme.background),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            ),
            const SizedBox(height: 16),
            Text(l.loadingAdTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
