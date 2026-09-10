import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/adaptive_scale.dart';
import '../../theme/theme.dart' as dk_theme;

class _OnboardingPage {
  final IconData icon;
  final Color tint;
  final String title;
  final String body;
  const _OnboardingPage({required this.icon, required this.tint, required this.title, required this.body});
}

/// First-launch walkthrough covering the four systems a brand-new player
/// can't infer just by looking at Dream Haven: Summoning, Fusion, Team
/// building, and the Campaign. Shown once — `RootView` overlays this atop
/// Dream Haven only while `!gameState.hasSeenOnboarding`, and `onFinish`
/// marks it seen so it never reappears for that save. Mirrors
/// `OnboardingView` (UI/Onboarding/OnboardingView.swift) exactly.
class OnboardingView extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingView({super.key, required this.onFinish});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  static const _pageCount = 4;

  List<_OnboardingPage> _pages(AppLocalizations l) => [
        _OnboardingPage(
          icon: Icons.auto_awesome,
          tint: dk_theme.Theme.violet,
          title: l.onboardingSummoningTitle,
          body: l.onboardingSummoningBody,
        ),
        _OnboardingPage(
          icon: Icons.star,
          tint: dk_theme.Theme.gold,
          title: l.onboardingFusionTitle,
          body: l.onboardingFusionBody,
        ),
        _OnboardingPage(
          icon: Icons.groups,
          tint: dk_theme.Theme.softBlue,
          title: l.onboardingTeamTitle,
          body: l.onboardingTeamBody,
        ),
        _OnboardingPage(
          icon: Icons.map,
          tint: dk_theme.Theme.violet,
          title: l.onboardingCampaignTitle,
          body: l.onboardingCampaignBody,
        ),
      ];

  final _pageController = PageController();
  int _pageIndex = 0;
  bool _appeared = false;
  Timer? _finishTimer;

  bool get _isLastPage => _pageIndex == _pageCount - 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _finish() {
    setState(() => _appeared = false);
    _finishTimer = Timer(const Duration(milliseconds: 200), widget.onFinish);
  }

  void _next() {
    if (_isLastPage) {
      _finish();
    } else {
      _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      container: true,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.72))),
          AnimatedOpacity(
            opacity: _appeared ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: _appeared ? 1 : 0.96,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      // Taller than Swift's 460x260 `TabView` frame — Flutter's
                      // default text metrics run taller line-height than
                      // SwiftUI's at the same point size, so the identical
                      // card content needs more room to avoid clipping.
                      width: 460,
                      height: 300,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) => setState(() => _pageIndex = index),
                        children: _pages(l).map((page) => _OnboardingCard(page: page)).toList(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _pageDots(),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 460,
                      child: Row(
                        children: [
                          if (!_isLastPage)
                            TextButton(
                              onPressed: _finish,
                              child: Text(l.onboardingSkip, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
                            ),
                          const Spacer(),
                          SizedBox(
                            width: 160,
                            child: dk_theme.PrimaryButton(
                              onPressed: _next,
                              tint: dk_theme.Theme.gold,
                              child: Text(_isLastPage ? l.onboardingLetsGo : l.onboardingNext),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).adaptiveScale();
  }

  Widget _pageDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_pageCount, (index) {
        final active = index == _pageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardingPage page;
  const _OnboardingCard({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: dk_theme.GlassCard(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: page.tint.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: page.tint.withValues(alpha: 0.5), blurRadius: 14)],
                    ),
                  ),
                  Icon(page.icon, size: 26, color: Colors.white),
                ],
              ),
              const SizedBox(height: 14),
              Text(page.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                page.body,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
