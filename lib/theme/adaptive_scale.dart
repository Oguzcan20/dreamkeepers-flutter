import 'package:flutter/material.dart';

/// Uniformly shrinks a fixed (non-scrolling) landscape layout to fit
/// whatever screen it actually ends up on, instead of letting content clip
/// or overflow on a smaller phone. Mirrors `AdaptiveScale`
/// (UI/Shared/AdaptiveScale.swift) exactly — see its doc comment for the
/// rationale (a few hub-style screens are laid out without a scroll view,
/// tuned against an iPhone 17 Pro-class landscape reference size).
class AdaptiveScale extends StatelessWidget {
  final Widget child;
  final Size referenceSize;

  /// Upper bound on the scale factor. `1` (default) never scales up —
  /// bigger phones just get the reference layout's normal spacing. Pass
  /// something like `1.3` to let it grow on larger screens too; keep it
  /// modest since scaling up blurs content a bit (it stretches the
  /// rasterized layout instead of re-laying it out).
  final double maxScale;

  const AdaptiveScale({
    super.key,
    required this.child,
    this.referenceSize = const Size(874, 402),
    this.maxScale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = [
          maxScale,
          constraints.maxWidth / referenceSize.width,
          constraints.maxHeight / referenceSize.height,
        ].reduce((a, b) => a < b ? a : b);
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: SizedBox(
                width: referenceSize.width,
                height: referenceSize.height,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

extension AdaptiveScaleExtension on Widget {
  /// Applies `AdaptiveScale` — use on fixed, non-scrolling landscape hub
  /// screens so smaller phones see the whole layout shrunk instead of
  /// clipped. Leave screens that already scroll alone; they already handle
  /// smaller screens on their own.
  Widget adaptiveScale({Size reference = const Size(874, 402), double maxScale = 1}) {
    return AdaptiveScale(referenceSize: reference, maxScale: maxScale, child: this);
  }
}
