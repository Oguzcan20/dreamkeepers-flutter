import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../combat/arena_system.dart';
import '../l10n/l10n.dart';
import 'art_manifest.dart';

/// Looks up hand-supplied monster/boss/Dreamkeeper/item/tier art bundled as
/// Flutter assets (`assets/art/<prefix><NameWithoutSpaces>.jpg`) so screens
/// can show real artwork where it exists and fall back to the icon-badge
/// treatment everywhere else — no per-entry wiring needed as more art is
/// added over time. Mirrors Swift's `MonsterArt`/`DreamkeeperArt`/`ItemArt`/
/// `ArenaArt` (UI/Shared/Theme.swift), which look up `UIImage(named:)` from
/// the asset catalog. Flutter has no synchronous equivalent of
/// `UIImage(named:) != nil`, so `hasArt` checks against `kAvailableArtNames`
/// (`art_manifest.dart`) instead — a generated const `Set<String>` mirroring
/// exactly what's bundled under `assets/art/`, kept in sync by re-running the
/// art import whenever assets are added or removed.
///
/// JPEG, not PNG: every per-entry image this lookup serves is a fully opaque
/// painted portrait/backdrop with no alpha channel, so converting all 186 of
/// them from PNG to quality-85 JPEG (2026-09) shrank `assets/art/` from
/// 145MB to ~30MB with no visible quality loss — see
/// `scripts/convert_art_to_jpeg.sh`. The only files that ever needed
/// transparency (`ChestClosed`/`ChestOpen`, in [SingletonArt] below) stayed
/// PNG for exactly that reason.
class _ArtLookup {
  final String prefix;
  const _ArtLookup(this.prefix);

  String _key(String name) => '$prefix${name.replaceAll(' ', '')}';

  String assetName(String name) => 'assets/art/${_key(name)}.jpg';

  bool hasArt(String name) => kAvailableArtNames.contains(_key(name));
}

class MonsterArt {
  static const _lookup = _ArtLookup('Monster_');
  static String assetName(String name) => _lookup.assetName(name);
  static bool hasArt(String name) => _lookup.hasArt(name);
}

class DreamkeeperArt {
  static const _lookup = _ArtLookup('Dreamkeeper_');
  static String assetName(String name) => _lookup.assetName(name);
  static bool hasArt(String name) => _lookup.hasArt(name);
}

class ItemArt {
  static const _lookup = _ArtLookup('Item_');
  static String assetName(String name) => _lookup.assetName(name);
  static bool hasArt(String name) => _lookup.hasArt(name);
}

/// Per-tier Arena Tower backdrop art (`ArenaTower_<TierName>`). `hasArt`
/// gates a graceful gradient fallback (see `_TowerZoneBanner` in
/// `arena_view.dart`) so the Arena screen looks intentional even for a tier
/// missing art.
class ArenaArt {
  static const _lookup = _ArtLookup('ArenaTower_');
  static String assetName(ArenaTier tier) => _lookup.assetName(tier.artName);
  static bool hasArt(ArenaTier tier) => _lookup.hasArt(tier.artName);
}

/// The app's singleton banner/icon images — not per-entry like the lookups
/// above, always assumed present (mirrors Swift's direct `Image("...")`
/// calls in `BattleView`/`CampaignView`/`SummoningShrineView`/etc., which
/// carry no `hasArt` gating of their own).
class SingletonArt {
  static const String battleBanner = 'assets/art/BattleBanner.jpg';
  static const String bossBattleBanner = 'assets/art/BossBattleBanner.jpg';
  static const String campaignBanner = 'assets/art/CampaignBanner.jpg';
  static const String chestClosed = 'assets/art/ChestClosed.png';
  static const String chestOpen = 'assets/art/ChestOpen.png';
  static const String dreamHavenBanner = 'assets/art/DreamHavenBanner.jpg';
  static const String loadingBanner = 'assets/art/LoadingBanner.jpg';
}

/// Per-world Campaign card backdrop art (`WorldBanner_<n>`). Only worlds
/// 1-10 have their own painting — worlds 11-30 are the same 10 locations
/// "dreamed again" with the same monster rosters (see `WorldCatalog`'s doc
/// comment), so they reuse the same 10 backgrounds on a repeating cycle
/// instead of needing 30 unique paintings.
class WorldArt {
  static String assetName(int worldID) {
    final base = ((worldID - 1) % 10) + 1;
    return 'assets/art/WorldBanner_$base.jpg';
  }
}

/// App-wide palette and shared visual language. Mirrors UI/Shared/Theme.swift
/// exactly.
class Theme {
  Theme._();

  static const deepNavy = Color.fromRGBO(13, 15, 33, 1);
  static const midnightPurple = Color.fromRGBO(33, 23, 61, 1);
  static const softBlue = Color.fromRGBO(115, 158, 242, 1);
  static const violet = Color.fromRGBO(140, 102, 230, 1);
  static const gold = Color.fromRGBO(245, 199, 89, 1);
  static const cream = Color.fromRGBO(245, 245, 245, 1);

  static const background = LinearGradient(
    colors: [deepNavy, midnightPurple],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final cardBackground = Colors.white.withValues(alpha: 0.06);
  static final cardStroke = Colors.white.withValues(alpha: 0.12);

  static const cornerRadius = 18.0;
}

/// Real frosted-glass material with a top sheen and a bevel-rim border plus
/// a grounding drop shadow — the same language as the Main Menu's CTA panel
/// and play button, applied once here so every card in the app shares it.
/// Mirrors `GlassCard` exactly (Flutter has no native `.ultraThinMaterial`;
/// `BackdropFilter` + a translucent fill reproduces the same frosted look).
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Theme.cornerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withValues(alpha: 0.09), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            color: Theme.cardBackground,
            borderRadius: BorderRadius.circular(Theme.cornerRadius),
            border: Border.all(color: Theme.cardStroke, width: 1),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A filled, gradient-backed call-to-action button matching the app's
/// primary button language. Mirrors `PrimaryButtonStyle` exactly (Flutter
/// has no direct `ButtonStyle`-as-object equivalent that composes as
/// cleanly, so this is a standalone widget wrapping a `GestureDetector`
/// rather than a `ButtonStyle` — every call site swaps `Button { }.
/// buttonStyle(PrimaryButtonStyle())` for `PrimaryButton(onPressed: ...)`).
///
/// Internally always sizes to `width: double.infinity` — fine as a `Column`
/// child (bounded by that column's own ancestor) or wrapped in `Expanded`,
/// but placed directly inside a `Row` it hits Flutter's "BoxConstraints
/// forces an infinite width" layout error, since a `Row` gives non-flex
/// children unbounded main-axis constraints. Wrap it in a fixed-width
/// `SizedBox` (or `Expanded`) at any Row call site.
class PrimaryButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color tint;
  final EdgeInsetsGeometry padding;

  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.tint = Theme.violet,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: disabled ? 0.4 : (_pressed ? 0.9 : 1),
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: double.infinity,
            padding: widget.padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.tint.withValues(alpha: 0.85), widget.tint.withValues(alpha: 0.55)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.25),
              boxShadow: [
                BoxShadow(
                  color: widget.tint.withValues(alpha: _pressed ? 0.15 : 0.4),
                  blurRadius: _pressed ? 4 : 10,
                  offset: Offset(0, _pressed ? 2 : 5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A pill-shaped currency/resource readout (Gold, Dream Gems, Energy, …).
/// Mirrors `ResourcePill` exactly.
class ResourcePill extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color tint;
  final String semanticLabel;

  const ResourcePill({
    super.key,
    required this.icon,
    required this.value,
    required this.tint,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$value $semanticLabel',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: tint, size: 16),
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable ambient backdrop — the flat two-tone `Theme.background` plus a
/// couple of soft blurred glow blobs and a handful of slowly-twinkling
/// motes. Used behind every major screen. Mirrors `AmbientBackground`
/// exactly.
class AmbientBackground extends StatelessWidget {
  final Color topTint;
  final Color bottomTint;
  final Offset topOffset;
  final Offset bottomOffset;
  final bool showsSparkles;

  const AmbientBackground({
    super.key,
    this.topTint = Theme.violet,
    this.bottomTint = Theme.gold,
    this.topOffset = const Offset(-150, -170),
    this.bottomOffset = const Offset(170, 140),
    this.showsSparkles = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(gradient: Theme.background),
        child: Stack(
          children: [
            Positioned(
              left: topOffset.dx,
              top: topOffset.dy,
              child: _glowCircle(topTint.withValues(alpha: 0.28), 260, 80),
            ),
            Positioned(
              left: bottomOffset.dx,
              top: bottomOffset.dy,
              child: _glowCircle(bottomTint.withValues(alpha: 0.16), 220, 90),
            ),
            if (showsSparkles) const Positioned.fill(child: SparkleField()),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(Color color, double size, double blur) => ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      );
}

/// A handful of tiny, slowly-twinkling dots drifting behind a screen —
/// shared by `AmbientBackground`. Mirrors `SparkleField` exactly.
class SparkleField extends StatefulWidget {
  const SparkleField({super.key});

  @override
  State<SparkleField> createState() => _SparkleFieldState();
}

class _Mote {
  final double x, y, size, delay;
  const _Mote(this.x, this.y, this.size, this.delay);
}

class _SparkleFieldState extends State<SparkleField> with SingleTickerProviderStateMixin {
  static const _motes = [
    _Mote(0.08, 0.12, 3, 0),
    _Mote(0.24, 0.58, 2, 0.5),
    _Mote(0.42, 0.22, 2.5, 1.1),
    _Mote(0.63, 0.7, 2, 0.25),
    _Mote(0.8, 0.32, 3, 0.85),
    _Mote(0.92, 0.62, 2, 1.4),
    _Mote(0.52, 0.88, 2.5, 0.65),
  ];

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
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
                  // Approximates SwiftUI's per-mote delayed repeatForever by
                  // phase-shifting each mote's opacity along the shared
                  // controller instead of running 7 separate controllers.
                  final phase = (_controller.value + mote.delay / 1.8) % 1.0;
                  final opacity = 0.15 + 0.7 * (1 - (2 * phase - 1).abs());
                  return Positioned(
                    left: constraints.maxWidth * mote.x - mote.size / 2,
                    top: constraints.maxHeight * mote.y - mote.size / 2,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: mote.size,
                        height: mote.size,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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

/// A slim rounded "banked toward next star" progress bar — shared by the
/// compact `_FusionCard` variants and the full-screen fusion pickers so all
/// four places read as one consistent visual language.
class FusionProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final Color color;
  final double height;

  const FusionProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.color = Theme.gold,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 1.0 : (current / total).clamp(0, 1).toDouble();
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Stack(
            children: [
              Container(height: height, color: Colors.white.withValues(alpha: 0.08)),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                height: height,
                width: constraints.maxWidth * fraction,
                color: color,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A handful of small dots radiating outward from the center and fading —
/// a lightweight one-shot flourish for confirm-style moments (mirrors the
/// summoning shrine's private burst effect, generalized for reuse). Plays
/// once on mount; give it a fresh `key` to replay it.
class BurstParticles extends StatefulWidget {
  final Color color;
  final int count;
  final double spread;
  final Duration duration;

  const BurstParticles({
    super.key,
    required this.color,
    this.count = 14,
    this.spread = 60,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  State<BurstParticles> createState() => _BurstParticlesState();
}

class _BurstParticlesState extends State<BurstParticles> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<double> _angles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..forward();
    _angles = List.generate(widget.count, (i) => (2 * math.pi * i) / widget.count);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeOut.transform(_controller.value);
          final distance = widget.spread * t;
          final opacity = (1 - t).clamp(0.0, 1.0);
          return Stack(
            alignment: Alignment.center,
            children: [
              for (final angle in _angles)
                Transform.translate(
                  offset: Offset(math.cos(angle) * distance, math.sin(angle) * distance),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Brief full-cover checkmark confirmation shown right before a sheet
/// auto-dismisses after a reward collect. Mirrors `CollectConfirmation`
/// exactly.
class CollectConfirmation extends StatelessWidget {
  final String text;
  final Color tint;

  const CollectConfirmation({super.key, required this.text, required this.tint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tint.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: tint, size: 40),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context).commonCollected, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
        ],
      ),
    );
  }
}
