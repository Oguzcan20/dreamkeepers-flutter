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
        // `constraints.maxHeight` shrinks whenever an ancestor `Scaffold`
        // resizes its body for an open keyboard (the default) — a fixed
        // layout scaled by this widget should hold its size regardless of
        // keyboard state, mirroring AdaptiveScale.swift's
        // `.ignoresSafeArea(.keyboard)` fix. `MediaQuery.of(context)` can't
        // reveal the keyboard's real height here: the `Scaffold` already
        // zeroes `viewInsets` out in the `MediaQuery` it hands to its body
        // once it's accounted for it via the resize. Reading the raw
        // platform inset instead bypasses that consumption entirely. A
        // screen that needs its own content to stay clear of the keyboard
        // handles that itself (see `PlayerNameChoiceView`'s own offset,
        // which uses the same `rawKeyboardInset`).
        final height = constraints.maxHeight + rawKeyboardInset(context);
        final scaleX = constraints.maxWidth / referenceSize.width;
        final scaleY = height / referenceSize.height;
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Transform(
            // Must stay center-anchored, matching the inner `Center` below:
            // this widget scales width/height independently (non-uniform),
            // so the scale anchor and the pre-scale content centering have
            // to agree or content drifts out of the box on any aspect ratio
            // that isn't an exact match for `referenceSize` — which is every
            // real device. With no keyboard (`height == constraints.maxHeight`)
            // this is a no-op vs. the previous behavior; with a keyboard,
            // the extra height grows equally above and below center, which
            // `PlayerNameChoiceView`'s own offset already keeps clear of.
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

/// The keyboard's real on-screen height in logical pixels, read straight
/// from the platform view rather than `MediaQuery.of(context).viewInsets`
/// (which a `Scaffold` further up the tree zeroes out for its body's
/// descendants once it's consumed it for its own resize). `0` when no
/// keyboard is showing.
double rawKeyboardInset(BuildContext context) {
  final view = View.of(context);
  return view.viewInsets.bottom / view.devicePixelRatio;
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
