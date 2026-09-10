import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/element.dart';
import '../../theme/adaptive_scale.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

/// Shown once, right after [OnboardingView] finishes — lets the player pick
/// an element for their starter Olf. Holding the Ember option for 5 full
/// seconds instead of tapping it is a deliberately undocumented shortcut to
/// "Ultimate Olf" (+10% to every stat over a normal Olf); nothing on screen
/// spells that out, matching the request for an actual secret rather than a
/// hinted one. `RootView`-equivalent overlays this atop Dream Haven while
/// `gameState.needsStarterOlfChoice` is true, and `onChoose` — wired to
/// `GameState.chooseStarterOlf` — passes `null` for the Ultimate Olf case
/// and a real `GameElement` for every normal tap. Mirrors
/// `StarterOlfChoiceView` (UI/Onboarding/StarterOlfChoiceView.swift) exactly.
class StarterOlfChoiceView extends StatefulWidget {
  final void Function(GameElement?) onChoose;
  const StarterOlfChoiceView({super.key, required this.onChoose});

  @override
  State<StarterOlfChoiceView> createState() => _StarterOlfChoiceViewState();
}

class _StarterOlfChoiceViewState extends State<StarterOlfChoiceView> {
  static const _holdDuration = Duration(seconds: 5);

  bool _appeared = false;
  bool _resolved = false;
  double _emberHoldProgress = 0;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _choose(GameElement element) {
    if (_resolved) return;
    _resolved = true;
    widget.onChoose(element);
  }

  /// The Ember tile carries the secret: a quick tap still picks Ember
  /// normally (`onTapUp` cancels the still-running hold timer before it can
  /// fire), while holding it down for `_holdDuration` fires the Ultimate Olf
  /// grant instead — `_resolved` then blocks the `onTapUp` that follows the
  /// hold's release from also registering as a normal Ember pick.
  void _emberDown() {
    if (_resolved) return;
    setState(() => _emberHoldProgress = 1);
    _holdTimer = Timer(_holdDuration, () {
      if (_resolved || !mounted) return;
      setState(() => _resolved = true);
      widget.onChoose(null);
    });
  }

  void _emberRelease({required bool completedAsTap}) {
    final firedHold = _holdTimer == null || !(_holdTimer?.isActive ?? false);
    _holdTimer?.cancel();
    if (_resolved) return;
    if (completedAsTap && !firedHold) {
      setState(() => _emberHoldProgress = 0);
      _choose(GameElement.ember);
    } else {
      setState(() => _emberHoldProgress = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      container: true,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.78))),
          AnimatedOpacity(
            opacity: _appeared ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: _appeared ? 1 : 0.96,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: SizedBox(
                  width: 420,
                  child: dk_theme.GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.starterElementTitle,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.starterElementSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                        ),
                        const SizedBox(height: 18),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.95,
                          children: GameElement.values.map((element) {
                            return element == GameElement.ember ? _emberTile() : _elementTile(element);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // The default (874×402) reference is tuned for wide, short landscape
      // hub screens (see `AdaptiveScale`'s doc comment) — this card is
      // taller/narrower than that (title + subtitle + a 3x2 element grid),
      // so the default squeezes it into too little height and overflows on
      // shorter landscape screens. A taller custom reference gives the
      // Column comfortable room in its own coordinate space before the
      // whole card gets uniformly scaled down to fit the real device.
    ).adaptiveScale(reference: const Size(480, 620));
  }

  Widget _elementTile(GameElement element) {
    return GestureDetector(
      onTap: _resolved ? null : () => _choose(element),
      child: _elementTileLabel(element),
    );
  }

  Widget _emberTile() {
    return GestureDetector(
      onTapDown: (_) => _emberDown(),
      onTapUp: (_) => _emberRelease(completedAsTap: true),
      onTapCancel: () => _emberRelease(completedAsTap: false),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _elementTileLabel(GameElement.ember),
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 10, right: 10),
            child: AnimatedOpacity(
              opacity: _emberHoldProgress > 0 ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _emberHoldProgress),
                      duration: _emberHoldProgress > 0 ? _holdDuration : const Duration(milliseconds: 200),
                      curve: Curves.linear,
                      builder: (context, value, _) => Container(
                        height: 3,
                        width: constraints.maxWidth * value,
                        decoration: BoxDecoration(
                          color: GameElement.ember.color.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _elementTileLabel(GameElement element) {
    return Semantics(
      label: element.displayName,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: element.color.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: element.color.withValues(alpha: 0.5), blurRadius: 10)],
                  ),
                ),
                Icon(sfSymbol(element.symbol), size: 20, color: Colors.white),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              element.displayName,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
