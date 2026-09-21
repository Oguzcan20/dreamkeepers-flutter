import 'package:flutter/material.dart';

/// Scales a fixed (non-scrolling) landscape layout so it always fills the
/// real device screen exactly, instead of letting content clip, overflow,
/// or — the previous version's bug — leave black bars on one axis whenever
/// the device's aspect ratio doesn't exactly match `referenceSize`. Mirrors
/// `AdaptiveScale` (UI/Shared/AdaptiveScale.swift) — see its doc comment
/// for the rationale (a few hub-style screens are laid out without a
/// scroll view, tuned against an iPhone 17 Pro-class landscape reference
/// size).
///
/// Width and height are scaled independently so the reference layout
/// always covers the full available box on both axes. A single uniform
/// scale factor (the old approach) can only ever exactly match the
/// *tighter* axis, leaving a visible letterboxed gap on the other one for
/// any device whose aspect ratio differs from `referenceSize`'s — which is
/// every device except the one the reference was tuned against. Landscape
/// phone aspect ratios are all close enough to the reference (~2.17:1)
/// that the resulting stretch between axes is imperceptible.
class AdaptiveScale extends StatelessWidget {
  final Widget child;
  final Size referenceSize;

  const AdaptiveScale({super.key, required this.child, this.referenceSize = const Size(874, 402)});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / referenceSize.width;
        final scaleY = constraints.maxHeight / referenceSize.height;
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
            child: Center(
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
  /// screens so every phone sees the whole layout stretched to exactly
  /// fill the real screen instead of clipped or letterboxed. Leave screens
  /// that already scroll alone; they already handle smaller screens on
  /// their own.
  Widget adaptiveScale({Size reference = const Size(874, 402)}) {
    return AdaptiveScale(referenceSize: reference, child: this);
  }
}
