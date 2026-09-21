import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/dreamkeeper_catalog.dart';
import '../../l10n/l10n.dart';
import '../../models/dreamkeeper.dart';
import '../../models/element.dart';
import '../../theme/adaptive_scale.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

/// Shown once, right after [OnboardingView] finishes — lets the player pick
/// an element for their starter Olf. Holding the Ember option for 5 full
/// seconds instead of tapping it is a deliberately undocumented shortcut to
/// "Ultimate Olf"; nothing on screen spells that out. `RootView` overlays
/// this atop Dream Haven while `gameState.needsStarterOlfChoice` is true,
/// and `onChoose` — wired to `GameState.chooseStarterOlf` — passes `null`
/// for the Ultimate Olf case and a real [GameElement] for every normal tap.
///
/// This is the player's first real look at Olf, so the whole screen — not
/// a small floating card — is given over to the moment: a circular "portal"
/// wipe opens the scene instead of a plain fade, a short piece of lore
/// explains why this choice exists at all, and the reveal cascades in
/// (hero → title → lore → tiles) rather than appearing all at once. Once a
/// choice lands, [_OlfRecruitRevealView] takes over as a proper "you've
/// recruited someone" second act instead of handing off to Dream Haven
/// immediately. Mirrors `StarterOlfChoiceView`
/// (UI/Onboarding/StarterOlfChoiceView.swift) — a full-screen two-column
/// cinematic rather than the earlier minimal glass-card version.
class StarterOlfChoiceView extends StatefulWidget {
  final void Function(GameElement?) onChoose;
  const StarterOlfChoiceView({super.key, required this.onChoose});

  @override
  State<StarterOlfChoiceView> createState() => _StarterOlfChoiceViewState();
}

class _StarterOlfChoiceViewState extends State<StarterOlfChoiceView>
    with TickerProviderStateMixin {
  static const _holdDuration = Duration(seconds: 5);
  static const _confirmDelay = Duration(milliseconds: 450);
  static const _revealStageDelays = [280, 500, 720, 940];

  bool _resolved = false;
  GameElement? _pressedElement;
  bool _flashActive = false;
  int _revealStage = 0;
  GameElement? _committedElement;
  DreamkeeperDefinition? _committedDefinition;
  bool _showRecruitReveal = false;

  late final AnimationController _portalController;
  late final AnimationController _shockController;

  /// A single continuously-looping "clock" that every ambient/idle effect
  /// (hero breathing, ray/sparkle ring spin, dust drift) derives its phase
  /// from via `sin`/modulo — one ticking `Listenable` powering many
  /// independently-timed effects, mirroring the Swift original's own
  /// economical pattern of a few shared toggles driving many
  /// `.animation(value:)` modifiers instead of one controller per effect.
  late final AnimationController _clockController;
  late final AnimationController _emberHoldController;

  static final List<_AmbientMote> _ambientMotes = List.generate(26, (i) {
    final rnd = math.Random(7919 * (i + 1) + 401);
    return _AmbientMote(
      x: rnd.nextDouble(),
      y: rnd.nextDouble(),
      size: 1.5 + rnd.nextDouble() * 3.5,
      duration: 4 + rnd.nextDouble() * 5,
      delay: rnd.nextDouble() * 3.5,
    );
  });

  @override
  void initState() {
    super.initState();
    _portalController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1050))
      ..forward();
    _shockController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 850))
      ..forward();
    _clockController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3600))
      ..repeat();
    _emberHoldController =
        AnimationController(vsync: this, duration: _holdDuration)
          ..addStatusListener(_onEmberHoldStatus);
    for (final entry in _revealStageDelays.asMap().entries) {
      Future.delayed(Duration(milliseconds: entry.value), () {
        if (mounted) setState(() => _revealStage = entry.key + 1);
      });
    }
  }

  @override
  void dispose() {
    _portalController.dispose();
    _shockController.dispose();
    _clockController.dispose();
    _emberHoldController.dispose();
    super.dispose();
  }

  void _onEmberHoldStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_resolved) {
      setState(() => _resolved = true);
      _confirm(null);
    }
  }

  void _choose(GameElement element) {
    if (_resolved) return;
    setState(() {
      _resolved = true;
      _pressedElement = element;
    });
    _confirm(element);
  }

  /// Plays the confirmation flash, then — instead of handing off to
  /// `onChoose` right away — brings up [_OlfRecruitRevealView]. `onChoose`
  /// only fires once the player dismisses that screen.
  void _confirm(GameElement? element) {
    _committedElement = element;
    final definitionID = element != null
        ? DreamkeeperCatalog.olfDefinitionID(element)
        : DreamkeeperCatalog.ultimateOlfID;
    _committedDefinition = DreamkeeperCatalog.starter.definition(definitionID);
    setState(() => _flashActive = true);
    Future.delayed(_confirmDelay, () {
      if (mounted) setState(() => _showRecruitReveal = true);
    });
  }

  void _emberDown() {
    if (_resolved) return;
    setState(() => _pressedElement = GameElement.ember);
    _emberHoldController.forward(from: 0);
  }

  void _emberUp({required bool asTap}) {
    if (_resolved) return;
    final wasMidHold = _emberHoldController.status == AnimationStatus.forward &&
        _emberHoldController.value < 1;
    _emberHoldController.reverse();
    setState(() => _pressedElement = null);
    if (asTap && wasMidHold) {
      _choose(GameElement.ember);
    }
  }

  void _hoverElement(GameElement? element) {
    if (_resolved) return;
    setState(() => _pressedElement = element);
  }

  Color get _heroGlowColor => _pressedElement?.color ?? dk_theme.Theme.gold;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Semantics(
      container: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black),
          AnimatedBuilder(
            animation: _portalController,
            builder: (context, child) {
              final t = Curves.easeOut.transform(_portalController.value);
              return ClipPath(clipper: _PortalClipper(t), child: child);
            },
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                fit: StackFit.expand,
                children: [
                  _backdrop(),
                  _ambientField(
                      Size(constraints.maxWidth, constraints.maxHeight)),
                  SafeArea(child: _content(l)),
                ],
              ),
            ),
          ),
          _shockwaveRing(),
          if (_showRecruitReveal && _committedDefinition != null)
            _OlfRecruitRevealView(
              definition: _committedDefinition!,
              element: _committedElement,
              onContinue: () => widget.onChoose(_committedElement),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Backdrop & ambience
  // ---------------------------------------------------------------------

  Widget _backdrop() {
    return AnimatedBuilder(
      animation: _clockController,
      builder: (context, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dk_theme.Theme.midnightPurple,
                    dk_theme.Theme.deepNavy,
                    Colors.black
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    _heroGlowColor.withValues(alpha: 0.28),
                    Colors.transparent
                  ],
                  radius: 0.9,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _ambientField(Size size) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _clockController,
          builder: (context, _) {
            final seconds = _clockController.value * 3600;
            return CustomPaint(
              size: size,
              painter: _AmbientDustPainter(
                  motes: _ambientMotes, elapsedSeconds: seconds),
            );
          },
        ),
      ),
    );
  }

  /// The energy ring that rides just ahead of the portal wipe — unmasked,
  /// so it's visible against the still-black screen for the instant before
  /// the mask itself catches up and reveals everything behind it.
  Widget _shockwaveRing() {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Center(
          child: AnimatedBuilder(
            animation: _shockController,
            builder: (context, _) {
              final t = Curves.easeOut.transform(_shockController.value);
              final scale = 0.4 + (16 - 0.4) * t;
              final opacity = (0.95 * (1 - t)).clamp(0.0, 1.0);
              if (opacity <= 0) return const SizedBox.shrink();
              return Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: CustomPaint(
                    size: const Size(46, 46),
                    painter: _AngularRingPainter(
                      colors: const [
                        dk_theme.Theme.gold,
                        Colors.white,
                        dk_theme.Theme.gold,
                        Colors.white
                      ],
                      strokeWidth: 3,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------

  Widget _content(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _heroColumn(l)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Container(
                width: 1, color: Colors.white.withValues(alpha: 0.12)),
          ),
          Expanded(child: _choiceColumn(l)),
        ],
      ),
    ).adaptiveScale(reference: const Size(874, 402));
  }

  Widget _heroColumn(AppLocalizations l) {
    // Wrapped in a scroll view as a safety net, not the primary layout —
    // German copy (and any other locale longer than English) can push this
    // fixed 402px-tall reference layout (see AdaptiveScale) past its
    // budget; scrolling avoids a hard RenderFlex overflow without
    // redesigning the whole staggered-reveal sequence around exact string
    // lengths per locale.
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _StaggerReveal(
            active: _revealStage >= 2,
            child: Text(
              l.starterElementEyebrow,
              style: TextStyle(
                color: dk_theme.Theme.gold.withValues(alpha: 0.85),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          _StaggerReveal(
            active: _revealStage >= 2,
            delay: const Duration(milliseconds: 50),
            child: Text(
              l.starterElementHeroTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 10),
          _StaggerReveal(
            active: _revealStage >= 1,
            scaleFrom: 0.7,
            curve: Curves.easeOutBack,
            child: _heroPortrait(),
          ),
          const SizedBox(height: 10),
          _StaggerReveal(
            active: _revealStage >= 3,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text(
                l.starterElementSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 12,
                    height: 1.35),
              ),
            ),
          ),
          const SizedBox(height: 6),
          _StaggerReveal(
            active: _revealStage >= 4,
            child: Text(
              l.starterElementPermanentNote,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _choiceColumn(AppLocalizations l) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _StaggerReveal(
          active: _revealStage >= 3,
          child: Text(
            l.starterElementTitle,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: GameElement.values.asMap().entries.map((entry) {
              final index = entry.key;
              final element = entry.value;
              return _StaggerReveal(
                active: _revealStage >= 4,
                delay: Duration(milliseconds: index * 70),
                child: element == GameElement.ember
                    ? _emberTile()
                    : _elementTile(element),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Hero portrait
  // ---------------------------------------------------------------------

  Widget _heroPortrait() {
    return ExcludeSemantics(
      child: SizedBox(
        height: 172,
        child: AnimatedBuilder(
          animation: Listenable.merge([_clockController, _emberHoldController]),
          builder: (context, _) {
            final seconds = _clockController.value * 3600;
            final breathe =
                (math.sin(seconds / 2.4 * 2 * math.pi - math.pi / 2) + 1) / 2;
            final glowScale = 0.92 + 0.22 * breathe;
            final glowOpacity = 0.55 + 0.35 * breathe;
            final portraitScale = 1 + 0.03 * breathe;
            final rayAngle = (seconds / 16) * 2 * math.pi;
            final sparkleAngle = -(seconds / 10) * 2 * math.pi;
            final holdProgress = _emberHoldController.value;

            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: glowScale,
                  child: Opacity(
                    opacity: glowOpacity,
                    child: Container(
                      width: 172,
                      height: 172,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _heroGlowColor.withValues(alpha: 0.4),
                        boxShadow: [
                          BoxShadow(
                              color: _heroGlowColor.withValues(alpha: 0.5),
                              blurRadius: 32,
                              spreadRadius: 10)
                        ],
                      ),
                    ),
                  ),
                ),
                for (var i = 0; i < 10; i++)
                  _radialItem(
                    angle: (i / 10) * 2 * math.pi + rayAngle,
                    radius: 92,
                    child: Container(
                      width: 3,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _heroGlowColor.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                for (var i = 0; i < 6; i++)
                  _radialItem(
                    angle: (i / 6) * 2 * math.pi + sparkleAngle,
                    radius: 82,
                    child: Icon(sfSymbol('sparkle'),
                        size: 9, color: Colors.white.withValues(alpha: 0.85)),
                  ),
                Transform.scale(
                  scale: portraitScale,
                  child: Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: _heroGlowColor.withValues(alpha: 0.7),
                            blurRadius: 20)
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(child: _heroPortraitImage()),
                        CustomPaint(
                          size: const Size(118, 118),
                          painter: _AngularRingPainter(
                            colors: [
                              _heroGlowColor,
                              Colors.white.withValues(alpha: 0.85),
                              _heroGlowColor
                            ],
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (holdProgress > 0)
                  Opacity(
                    opacity: holdProgress,
                    child: Transform.scale(
                      scale: 1 + holdProgress * 0.4,
                      child: Container(
                        width: 118,
                        height: 118,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.9),
                              width: 4),
                        ),
                      ),
                    ),
                  ),
                if (_flashActive)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.35, end: 1.3),
                    duration: _confirmDelay,
                    curve: Curves.easeOut,
                    builder: (context, scale, _) {
                      final opacity = 1 - ((scale - 0.35) / (1.3 - 0.35));
                      return Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 210,
                            height: 210,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                Colors.white.withValues(alpha: 0.95),
                                Colors.transparent
                              ]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _heroPortraitImage() {
    if (dk_theme.DreamkeeperArt.hasArt('Olf')) {
      return Image.asset(dk_theme.DreamkeeperArt.assetName('Olf'),
          fit: BoxFit.cover, width: 118, height: 118);
    }
    return Container(
      color: dk_theme.Theme.gold.withValues(alpha: 0.3),
      alignment: Alignment.center,
      child: Icon(sfSymbol('pawprint.fill'), size: 40, color: Colors.white),
    );
  }

  // ---------------------------------------------------------------------
  // Element tiles
  // ---------------------------------------------------------------------

  Widget _elementTile(GameElement element) {
    return GestureDetector(
      onTapDown: (_) => _hoverElement(element),
      onTapCancel: () => _hoverElement(null),
      onTap: _resolved ? null : () => _choose(element),
      child: _elementTileLabel(element),
    );
  }

  Widget _emberTile() {
    return AnimatedBuilder(
      animation: _emberHoldController,
      builder: (context, _) {
        final progress = _emberHoldController.value;
        final isPressed = _pressedElement == GameElement.ember && !_resolved;
        return GestureDetector(
          onTapDown: (_) => _emberDown(),
          onTapUp: (_) => _emberUp(asTap: true),
          onTapCancel: () => _emberUp(asTap: false),
          child: Transform.scale(
            scale: isPressed ? 0.93 : 1,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(child: _elementTileLabel(GameElement.ember)),
                if (progress > 0)
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 6, left: 10, right: 10),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 3,
                          width: constraints.maxWidth * progress,
                          decoration: BoxDecoration(
                            color:
                                GameElement.ember.color.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _elementTileLabel(GameElement element) {
    final isPressed = _pressedElement == element;
    return Semantics(
      label: element.displayName,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              element.color.withValues(alpha: isPressed ? 0.28 : 0.14),
              Colors.white.withValues(alpha: 0.05)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: element.color.withValues(alpha: isPressed ? 0.55 : 0.18),
              width: isPressed ? 1.5 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isPressed ? 1.08 : 1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          element.color.withValues(alpha: 0.55),
                          element.color.withValues(alpha: 0.18)
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: element.color
                                .withValues(alpha: isPressed ? 0.85 : 0.5),
                            blurRadius: isPressed ? 16 : 10),
                      ],
                      border: Border.all(
                          color: element.color
                              .withValues(alpha: isPressed ? 0.9 : 0.35),
                          width: isPressed ? 2.5 : 1.5),
                    ),
                  ),
                  Icon(sfSymbol(element.symbol), size: 22, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              element.displayName,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// One entry in the fixed, deterministically-generated field of dust motes
/// drifting behind the choice screen — deterministic (fixed RNG seed per
/// index) so the scattering is stable across rebuilds instead of
/// reshuffling itself.
class _AmbientMote {
  final double x;
  final double y;
  final double size;
  final double duration;
  final double delay;
  const _AmbientMote(
      {required this.x,
      required this.y,
      required this.size,
      required this.duration,
      required this.delay});
}

class _AmbientDustPainter extends CustomPainter {
  final List<_AmbientMote> motes;
  final double elapsedSeconds;
  const _AmbientDustPainter(
      {required this.motes, required this.elapsedSeconds});

  @override
  void paint(Canvas canvas, Size size) {
    for (final mote in motes) {
      final phase = (elapsedSeconds - mote.delay) / mote.duration;
      final s = (math.sin(phase * 2 * math.pi - math.pi / 2) + 1) / 2;
      final offsetY = -16 * s + 8 * (1 - s);
      final opacity = 0.12 + (0.75 - 0.12) * s;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawCircle(
          Offset(mote.x * size.width, mote.y * size.height + offsetY),
          mote.size / 2,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientDustPainter oldDelegate) =>
      oldDelegate.elapsedSeconds != elapsedSeconds;
}

/// The "portal" the whole scene opens through — a circle clip growing from
/// a pinprick at the center out past the corners, so the screen reads as
/// something *opening* rather than merely fading in. `t` is 0 (closed) to
/// 1 (fully covers the box, guaranteed via the box's own diagonal).
class _PortalClipper extends CustomClipper<Path> {
  final double t;
  const _PortalClipper(this.t);

  @override
  Path getClip(Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.longestSide; // comfortably covers every corner
    final radius = (t * maxRadius).clamp(0.5, maxRadius);
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant _PortalClipper oldClipper) => oldClipper.t != t;
}

/// Draws a circle stroked with a sweeping rainbow-style gradient — Flutter
/// has no `BoxDecoration` gradient-border support, so this is the
/// equivalent of SwiftUI's `Circle().strokeBorder(AngularGradient(...))`.
class _AngularRingPainter extends CustomPainter {
  final List<Color> colors;
  final double strokeWidth;
  const _AngularRingPainter({required this.colors, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(colors: colors).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _AngularRingPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.strokeWidth != strokeWidth;
}

/// Draws a rotating ring of short dashes — the equivalent of the native
/// app's `RevealRing` shape, used behind the recruit-reveal portrait.
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final double lineWidth;
  final int dashCount;
  final double rotation;
  const _DashedRingPainter({
    required this.color,
    required this.opacity,
    required this.lineWidth,
    required this.dashCount,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - lineWidth) / 2;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;
    final dashAngle = (2 * math.pi) / dashCount;
    const gapFraction = 0.45;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    for (var i = 0; i < dashCount; i++) {
      final start = i * dashAngle;
      final sweep = dashAngle * (1 - gapFraction);
      canvas.drawArc(Rect.fromCircle(center: Offset.zero, radius: radius),
          start, sweep, false, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) => true;
}

/// Positions [child] at `radius` from the center of a square box, rotated
/// by `angle` — the standard Flutter idiom for a radial "spoke" that swings
/// around a fixed pivot (the enclosing `Stack`'s center), matching
/// SwiftUI's `.offset(y:).rotationEffect(angle)` idiom used throughout the
/// native original for its ray/sparkle rings.
Widget _radialItem(
    {required double angle, required double radius, required Widget child}) {
  final size = radius * 2;
  return SizedBox(
    width: size,
    height: size,
    child: Transform.rotate(
        angle: angle,
        child: Align(alignment: Alignment.topCenter, child: child)),
  );
}

/// Fades + slides [child] in once [active] flips true, after an optional
/// per-item [delay] — the shared building block behind every cascading
/// reveal on this screen (hero column stages, tile grid stagger, recruit
/// info column stages), mirroring the Swift original's repeated
/// `.opacity(revealStage >= n ? 1 : 0).offset(...).animation(...)` pattern
/// without re-deriving it at every call site.
class _StaggerReveal extends StatefulWidget {
  final bool active;
  final Duration delay;
  final Offset slideFrom;
  final double scaleFrom;
  final Curve curve;
  final Widget child;
  const _StaggerReveal({
    required this.active,
    required this.child,
    this.delay = Duration.zero,
    this.slideFrom = const Offset(0, 0.12),
    this.scaleFrom = 1,
    this.curve = Curves.easeOut,
  });

  @override
  State<_StaggerReveal> createState() => _StaggerRevealState();
}

class _StaggerRevealState extends State<_StaggerReveal> {
  bool _shown = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant _StaggerReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.active && !_shown) {
      _timer?.cancel();
      _timer = Timer(widget.delay, () {
        if (mounted) setState(() => _shown = true);
      });
    } else if (!widget.active && _shown) {
      _timer?.cancel();
      _shown = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _shown ? 1 : 0,
      duration: const Duration(milliseconds: 450),
      curve: widget.curve,
      child: AnimatedSlide(
        offset: _shown ? Offset.zero : widget.slideFrom,
        duration: const Duration(milliseconds: 450),
        curve: widget.curve,
        child: AnimatedScale(
          scale: _shown ? 1 : widget.scaleFrom,
          duration: const Duration(milliseconds: 450),
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );
  }
}

/// The second act of the starter-choice moment: a full-screen "you've just
/// recruited someone" takeover — flashbang, expanding shockwave, a rotating
/// dashed ring and a burst of rays around the real Olf portrait, followed
/// by an actual readout of who this Olf is (element, Ultimate, Active
/// Skill, Passive, flavor text) — instead of fading straight into Dream
/// Haven the instant a tile is tapped. Tapping anywhere (or the Continue
/// button) fires `onContinue`. Mirrors the private `OlfRecruitRevealView`
/// in the native original.
class _OlfRecruitRevealView extends StatefulWidget {
  final DreamkeeperDefinition definition;

  /// `null` marks the secret Ultimate Olf.
  final GameElement? element;
  final VoidCallback onContinue;
  const _OlfRecruitRevealView(
      {required this.definition,
      required this.element,
      required this.onContinue});

  @override
  State<_OlfRecruitRevealView> createState() => _OlfRecruitRevealViewState();
}

class _OlfRecruitRevealViewState extends State<_OlfRecruitRevealView>
    with TickerProviderStateMixin {
  static const _infoStageDelays = [220, 400, 620, 850];

  bool get _isUltimate => widget.element == null;
  Color get _accentColor => widget.element?.color ?? dk_theme.Theme.gold;
  bool get _hasArt => dk_theme.DreamkeeperArt.hasArt(widget.definition.artName);

  bool _flashOn = false;
  int _infoStage = 0;

  late final AnimationController _shockController;
  late final AnimationController _popController;
  late final AnimationController _rayController;
  late final AnimationController _ringSpinController;

  @override
  void initState() {
    super.initState();
    _shockController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _popController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _rayController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550))
      ..forward();
    _ringSpinController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();

    setState(() => _flashOn = true);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _flashOn = false);
    });
    for (final entry in _infoStageDelays.asMap().entries) {
      Future.delayed(Duration(milliseconds: entry.value), () {
        if (mounted) setState(() => _infoStage = entry.key + 1);
      });
    }
  }

  @override
  void dispose() {
    _shockController.dispose();
    _popController.dispose();
    _rayController.dispose();
    _ringSpinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: widget.onContinue,
      child: Semantics(
        container: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: Colors.black.withValues(alpha: 0.95)),
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _popController,
                builder: (context, _) {
                  final glowOpacity =
                      Curves.easeOut.transform(_popController.value);
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [
                        _accentColor.withValues(alpha: 0.28 * glowOpacity),
                        Colors.transparent
                      ]),
                    ),
                  );
                },
              ),
            ),
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _flashOn ? (_isUltimate ? 0.75 : 0.55) : 0,
                duration: Duration(milliseconds: _flashOn ? 100 : 450),
                child: const ColoredBox(color: Colors.white),
              ),
            ),
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _portraitColumn(l)),
                    const SizedBox(width: 32),
                    Expanded(child: _infoColumn(l)),
                  ],
                ).adaptiveScale(reference: const Size(874, 402)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _portraitFX() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _shockController,
        _popController,
        _rayController,
        _ringSpinController
      ]),
      builder: (context, _) {
        final glowOpacity = Curves.easeOut.transform(_popController.value);
        final rayOpacity = _rayController.value > 0 ? 1.0 : 0.0;
        final rayProgress = Curves.easeOut.transform(_rayController.value);
        final shockT = Curves.easeOut.transform(_shockController.value);
        final shockScale = 0.4 + ((_isUltimate ? 3.2 : 2.6) - 0.4) * shockT;
        final shockOpacity = 0.9 * (1 - shockT);
        final ringRotation = _ringSpinController.value * 2 * math.pi;

        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: glowOpacity,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      _accentColor.withValues(alpha: 0.55),
                      Colors.transparent
                    ]),
                  ),
                ),
              ),
              for (var i = 0; i < 18; i++)
                Opacity(
                  opacity: rayOpacity,
                  child: _radialItem(
                    angle: (i / 18) * 2 * math.pi,
                    radius: 62 * rayProgress,
                    child: Container(
                      width: 3,
                      height: 125 * rayProgress,
                      color: _accentColor.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              CustomPaint(
                size: const Size(155, 155),
                painter: _DashedRingPainter(
                  color: _accentColor,
                  opacity: glowOpacity,
                  lineWidth: 2,
                  dashCount: 34,
                  rotation: ringRotation,
                ),
              ),
              if (shockOpacity > 0)
                Opacity(
                  opacity: shockOpacity,
                  child: Transform.scale(
                    scale: shockScale,
                    child: Container(
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _accentColor, width: 4)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _portraitColumn(AppLocalizations l) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _StaggerReveal(
          active: _infoStage >= 1,
          child: Text(
            _isUltimate
                ? l.starterRevealSecretUnlocked
                : l.starterRevealBondSealed,
            style: TextStyle(
                color: _accentColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5),
          ),
        ),
        const SizedBox(height: 14),
        AnimatedBuilder(
          animation: _popController,
          builder: (context, _) {
            final t = Curves.easeOutBack.transform(_popController.value);
            return Opacity(
              opacity: t.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.4 + 0.6 * t,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _portraitFX(),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _accentColor, width: 4),
                        boxShadow: [
                          BoxShadow(
                              color: _accentColor.withValues(alpha: 0.8),
                              blurRadius: 28)
                        ],
                      ),
                      child: ClipOval(child: _portraitImage()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        _StaggerReveal(
          active: _infoStage >= 1,
          child: Text(
            _isUltimate
                ? l.starterRevealUltimateTitle
                : l.starterRevealNormalTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        if (!_isUltimate && widget.element != null) ...[
          const SizedBox(height: 10),
          _StaggerReveal(
            active: _infoStage >= 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: _accentColor.withValues(alpha: 0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(sfSymbol(widget.element!.symbol),
                      size: 13, color: Colors.white.withValues(alpha: 0.9)),
                  const SizedBox(width: 6),
                  Text(
                    widget.element!.displayName,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _portraitImage() {
    if (_hasArt) {
      return Image.asset(
          dk_theme.DreamkeeperArt.assetName(widget.definition.artName),
          fit: BoxFit.cover,
          width: 130,
          height: 130);
    }
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [_accentColor, _accentColor.withValues(alpha: 0.6)])),
      alignment: Alignment.center,
      child: Icon(sfSymbol(widget.definition.symbol),
          size: 50, color: Colors.white),
    );
  }

  Widget _infoColumn(AppLocalizations l) {
    final definition = widget.definition;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _StaggerReveal(
            active: _infoStage >= 3,
            child: dk_theme.GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RevealAbilityRow(
                    icon: 'sparkles',
                    tint: dk_theme.Theme.gold,
                    category: l.codexAbilityUltimate,
                    name: definition.ultimate.name,
                    description: definition.ultimate.description,
                  ),
                  const SizedBox(height: 12),
                  _RevealAbilityRow(
                    icon: 'bolt.fill',
                    tint: dk_theme.Theme.softBlue,
                    category: l.codexAbilityActiveSkill,
                    name: definition.activeSkill.name,
                    description: definition.activeSkill.description,
                  ),
                  const SizedBox(height: 12),
                  _RevealAbilityRow(
                    icon: 'shield.lefthalf.filled',
                    tint: Colors.white.withValues(alpha: 0.75),
                    category: l.codexAbilityPassive,
                    name: definition.passive.name,
                    description: definition.passive.description,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _StaggerReveal(
            active: _infoStage >= 3,
            child: Text(
              definition.flavorText,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 16),
          _StaggerReveal(
            active: _infoStage >= 4,
            child: dk_theme.PrimaryButton(
                onPressed: widget.onContinue, child: Text(l.commonContinue)),
          ),
          const SizedBox(height: 8),
          _StaggerReveal(
            active: _infoStage >= 4,
            child: Center(
              child: Text(l.starterRevealTapToContinue,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevealAbilityRow extends StatelessWidget {
  final String icon;
  final Color tint;
  final String category;
  final String name;
  final String description;
  const _RevealAbilityRow({
    required this.icon,
    required this.tint,
    required this.category,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SizedBox(
              width: 22, child: Icon(sfSymbol(icon), size: 15, color: tint)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category,
                  style: TextStyle(
                      color: tint, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text(description,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
