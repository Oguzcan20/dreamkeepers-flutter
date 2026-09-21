// A "step through a dream portal" transition used for every top-level
// navigation in `RootView` — the leaving screen collapses into a glowing
// point at the center of the display while the arriving screen expands back
// out of that same point, with a violet/gold energy ring riding the edge of
// the growing/shrinking circle. Pure Flutter (`AnimatedSwitcher` + a custom
// clip/paint), no new dependency, since the effect is just a circular
// iris-wipe rather than a literal portal asset.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/theme.dart' as dk_theme;

class PortalSwitcher extends StatelessWidget {
  /// Changes on every navigation (even to the same route type again, e.g.
  /// "Next Battle") so the transition always plays.
  final Object routeKey;
  final Widget child;

  const PortalSwitcher({super.key, required this.routeKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 480),
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear,
      transitionBuilder: _buildTransition,
      child: KeyedSubtree(key: ValueKey(routeKey), child: child),
    );
  }

  static Widget _buildTransition(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = Curves.easeInOutCubic.transform(animation.value);
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipPath(
              clipper: _PortalClipper(t),
              child: Opacity(
                opacity: (0.25 + 0.75 * t).clamp(0.0, 1.0),
                child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                painter: _PortalRingPainter(t, innerColor: dk_theme.Theme.violet, outerColor: dk_theme.Theme.gold),
              ),
            ),
          ],
        );
      },
    );
  }
}

double _maxRadiusFromCenter(Size size, Offset center) {
  final corners = [
    Offset.zero,
    Offset(size.width, 0),
    Offset(0, size.height),
    Offset(size.width, size.height),
  ];
  return corners.map((c) => (c - center).distance).reduce(math.max);
}

class _PortalClipper extends CustomClipper<Path> {
  final double progress;
  const _PortalClipper(this.progress);

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = progress * _maxRadiusFromCenter(size, center);
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant _PortalClipper oldClipper) => oldClipper.progress != progress;
}

/// The glowing rim traveling along the iris's edge — only visible mid-flight
/// (faded out at rest, when `progress` is at either end) so the portal reads
/// as a fleeting energy ring rather than a permanent circle outline.
class _PortalRingPainter extends CustomPainter {
  final double progress;
  final Color innerColor;
  final Color outerColor;
  const _PortalRingPainter(this.progress, {required this.innerColor, required this.outerColor});

  @override
  void paint(Canvas canvas, Size size) {
    final ringOpacity = (1 - (progress - 0.5).abs() * 2.2).clamp(0.0, 1.0);
    if (ringOpacity <= 0.01) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = progress * _maxRadiusFromCenter(size, center);
    final rect = Rect.fromCircle(center: center, radius: math.max(radius, 1));
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 + 14 * (1 - progress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
      ..shader = SweepGradient(colors: [
        innerColor.withValues(alpha: ringOpacity),
        outerColor.withValues(alpha: ringOpacity * 0.8),
        innerColor.withValues(alpha: ringOpacity),
      ]).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _PortalRingPainter oldDelegate) => oldDelegate.progress != progress;
}
