import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/theme.dart' as dk_theme;

/// App-launch splash — a simulated progress bar and a random gameplay tip,
/// shown once before the Main Menu appears. There's nothing slow to
/// actually wait on (save load is local/instant), so the progress is a
/// fixed-duration animation purely for pacing/branding, same as most
/// mobile games do. Mirrors `LoadingView` (UI/MainMenu/LoadingView.swift)
/// exactly, including the `DreamHavenBanner` key-art image behind the
/// `Theme.background` gradient scrim.
class LoadingView extends StatefulWidget {
  final VoidCallback onFinished;
  const LoadingView({super.key, required this.onFinished});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with SingleTickerProviderStateMixin {
  // The six gameplay tips now live in the ARB files — pick one index here
  // and resolve the localized string at build time.
  final int _tipIndex = Random().nextInt(6);

  String _tipText(AppLocalizations l) => switch (_tipIndex) {
        0 => l.loadingTip1,
        1 => l.loadingTip2,
        2 => l.loadingTip3,
        3 => l.loadingTip4,
        4 => l.loadingTip5,
        _ => l.loadingTip6,
      };
  late final AnimationController _progress;
  bool _appeared = false;
  Timer? _finishTimer;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _appeared = true);
      _progress.forward();
    });
    _finishTimer = Timer(const Duration(milliseconds: 1850), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(dk_theme.SingletonArt.loadingBanner, fit: BoxFit.cover, alignment: const Alignment(0, -0.6)),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  dk_theme.Theme.deepNavy.withValues(alpha: 0.72),
                  dk_theme.Theme.midnightPurple.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              AnimatedOpacity(
                opacity: _appeared ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(56, 0, 56, 22),
                  child: _footer(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    final l = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        final progress = _progress.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l.loadingHeader,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: dk_theme.Theme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _progressBar(progress),
            const SizedBox(height: 12),
            _tipRow(l),
          ],
        );
      },
    );
  }

  Widget _progressBar(double progress) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: max(10, constraints.maxWidth * progress),
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      dk_theme.Theme.violet,
                      const Color.fromRGBO(204, 107, 235, 1),
                      dk_theme.Theme.gold,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.6), width: 1.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tipRow(AppLocalizations l) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.16), shape: BoxShape.circle),
            ),
            const Icon(Icons.star, color: dk_theme.Theme.gold, size: 9),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(fontSize: 13),
              children: [
                TextSpan(text: l.loadingTipLabel, style: const TextStyle(color: dk_theme.Theme.gold, fontWeight: FontWeight.bold)),
                TextSpan(text: _tipText(l), style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
