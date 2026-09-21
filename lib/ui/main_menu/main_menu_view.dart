import 'dart:math';

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/theme.dart' as dk_theme;

/// The title screen: the `DreamHavenBanner` key-art image full-bleed behind
/// the CTA panel, under a dark gradient scrim for legibility.
/// `MenuSparkleField` (a busier, upward-drifting sibling of
/// `AmbientBackground`'s own `SparkleField`) sits on top of the scrim.
class MainMenuView extends StatefulWidget {
  final VoidCallback onPlay;
  final VoidCallback onSettings;

  const MainMenuView({super.key, required this.onPlay, required this.onSettings});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> with TickerProviderStateMixin {
  bool _appeared = false;
  late final AnimationController _glowPulse;
  late final AnimationController _breathing;

  @override
  void initState() {
    super.initState();
    _glowPulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _breathing = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  @override
  void dispose() {
    _glowPulse.dispose();
    _breathing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(dk_theme.SingletonArt.dreamHavenBanner, fit: BoxFit.cover, alignment: const Alignment(0, -0.6)),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  dk_theme.Theme.deepNavy.withValues(alpha: 0.55),
                  dk_theme.Theme.midnightPurple.withValues(alpha: 0.78),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        const Positioned.fill(child: _MenuSparkleField()),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedOpacity(
            opacity: _appeared ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            child: AnimatedSlide(
              offset: _appeared ? Offset.zero : const Offset(0.03, 0),
              duration: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: _ctaPanel(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ctaPanel() {
    final l = AppLocalizations.of(context);
    return Container(
      width: 236,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        gradient: LinearGradient(
          colors: [dk_theme.Theme.violet.withValues(alpha: 0.16), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l.mainMenuTagline,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: Listenable.merge([_glowPulse, _breathing]),
            builder: (context, _) {
              final glow = _glowPulse.value;
              final breath = 1.0 + 0.02 * _breathing.value;
              return Transform.scale(
                scale: breath,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.15 + 0.35 * glow), blurRadius: 8 + 12 * glow),
                      BoxShadow(color: dk_theme.Theme.violet.withValues(alpha: 0.3 + 0.35 * glow), blurRadius: 6 + 10 * glow),
                    ],
                  ),
                  child: _GlossyPlayButton(onPressed: widget.onPlay),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: widget.onSettings,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
              ),
            ),
            icon: Icon(Icons.settings, size: 14, color: Colors.white.withValues(alpha: 0.7)),
            label: Text(l.mainMenuSettings, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

/// Compact, embossed jewel-toned primary button. Mirrors
/// `GlossyPlayButtonStyle` exactly.
class _GlossyPlayButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _GlossyPlayButton({required this.onPressed});

  @override
  State<_GlossyPlayButton> createState() => _GlossyPlayButtonState();
}

class _GlossyPlayButtonState extends State<_GlossyPlayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(184, 128, 250, 1),
                dk_theme.Theme.violet,
                Color.fromRGBO(92, 51, 153, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: _pressed ? 0.5 : 0.8), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _pressed ? 0.2 : 0.45),
                blurRadius: _pressed ? 4 : 12,
                offset: Offset(0, _pressed ? 2 : 8),
              ),
            ],
          ),
          child: Opacity(
            opacity: _pressed ? 0.94 : 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.play_arrow, color: Colors.white),
                const SizedBox(width: 8),
                Text(l.mainMenuPlay, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ambient dream-motes drifting slowly upward and fading over the scene.
/// Mirrors `MenuSparkleField` exactly.
class _MenuSparkleField extends StatefulWidget {
  const _MenuSparkleField();

  @override
  State<_MenuSparkleField> createState() => _MenuSparkleFieldState();
}

class _MenuMote {
  final double x, startY, scale, duration, delay;
  final bool warm;
  const _MenuMote(this.x, this.startY, this.scale, this.duration, this.delay, this.warm);
}

class _MenuSparkleFieldState extends State<_MenuSparkleField> with SingleTickerProviderStateMixin {
  late final List<_MenuMote> _motes;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _motes = List.generate(16, (index) {
      return _MenuMote(
        0.05 + random.nextDouble() * 0.9,
        0.2 + random.nextDouble() * 0.85,
        0.4 + random.nextDouble() * 0.9,
        5 + random.nextDouble() * 4,
        index * 0.28,
        index.isEven,
      );
    });
    // One shared controller drives every mote's upward rise+fade, looped —
    // approximates SwiftUI's per-mote independently-delayed repeatForever
    // by phase-shifting each mote's own cycle position within it.
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 9))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: _motes.map((mote) {
                  final cycleSeconds = 9.0;
                  final elapsed = (_controller.value * cycleSeconds + mote.delay) % mote.duration;
                  final phase = (elapsed / mote.duration).clamp(0.0, 1.0);
                  return Positioned(
                    left: constraints.maxWidth * mote.x,
                    top: constraints.maxHeight * mote.startY - constraints.maxHeight * 0.55 * phase,
                    child: Opacity(
                      opacity: (1 - phase) * 0.9,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 9 * mote.scale,
                        color: mote.warm ? dk_theme.Theme.gold.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
