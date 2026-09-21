import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/dreamkeeper.dart';
import '../../models/stats.dart';
import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../shared/star_row.dart';

/// Manual fusion flow (spec: player-driven, not automatic) for a
/// Dreamkeeper — shows every owned duplicate of the target species so the
/// player picks exactly which copies to feed in, previews the stat gain,
/// then confirms. Mirrors `FusionPickerView`
/// (UI/Equipment/FusionPickerView.swift) exactly, pushed as a full-screen
/// route instead of a `.sheet` (Flutter has no direct nested-modal-sheet
/// idiom as clean as SwiftUI's `.sheet` on top of another `.sheet`).
class FusionPickerView extends StatefulWidget {
  final String targetID;
  final GameState gameState;

  const FusionPickerView({super.key, required this.targetID, required this.gameState});

  @override
  State<FusionPickerView> createState() => _FusionPickerViewState();
}

class _FusionPickerViewState extends State<FusionPickerView> {
  final Set<String> _selectedIDs = {};
  bool _justFused = false;
  bool _lastFuseGrantedStar = false;
  _StarUpShowcaseData? _showcase;
  Timer? _fuseResetTimer;
  bool _showBurst = false;
  int _burstKey = 0;
  Timer? _burstResetTimer;

  DreamkeeperInstance? get _target {
    final matches = widget.gameState.roster.where((i) => i.id == widget.targetID);
    return matches.isEmpty ? null : matches.first;
  }

  List<DreamkeeperInstance> get _duplicates {
    final target = _target;
    return target == null ? [] : widget.gameState.duplicates(target);
  }

  int? get _cost {
    final target = _target;
    return target == null ? null : widget.gameState.nextFusionCost(target);
  }

  /// Banked progress plus whatever's selected right now — the number a fuse
  /// would actually consume if pressed this instant.
  int get _bankedTotal => (_target?.fusionProgress ?? 0) + _selectedIDs.length;

  /// Whether fusing right now would actually cross into the next star, as
  /// opposed to just banking progress toward it.
  bool get _willStarUp {
    final cost = _cost;
    if (cost == null) return false;
    return _bankedTotal >= cost;
  }

  @override
  void dispose() {
    _fuseResetTimer?.cancel();
    _burstResetTimer?.cancel();
    super.dispose();
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIDs.contains(id)) {
        _selectedIDs.remove(id);
      } else {
        _selectedIDs.add(id);
      }
    });
    widget.gameState.playHaptic(HapticStyle.light);
  }

  void _fuse(DreamkeeperInstance target) {
    final selected = _duplicates.where((d) => _selectedIDs.contains(d.id)).toList();
    final grantsStar = _willStarUp;
    if (!widget.gameState.fuseDreamkeeper(target, selected)) return;
    // Swift fires the sound and haptic as two separate calls; this port's
    // `GameState.playHaptic` already fires `.levelUp`'s paired sound
    // effect internally (see its doc comment), so calling `playSound`
    // here too would double the chime.
    widget.gameState.playHaptic(HapticStyle.levelUp);
    setState(() {
      _lastFuseGrantedStar = grantsStar;
      _justFused = true;
      _selectedIDs.clear();
      _showBurst = true;
      _burstKey++;
    });
    _burstResetTimer?.cancel();
    _burstResetTimer = Timer(const Duration(milliseconds: 650), () {
      if (mounted) setState(() => _showBurst = false);
    });

    if (grantsStar) {
      final definition = widget.gameState.definition(target);
      final updatedMatches = widget.gameState.roster.where((r) => r.id == target.id);
      if (definition != null && updatedMatches.isNotEmpty) {
        final updated = updatedMatches.first;
        final statsBefore = widget.gameState.currentStats(target);
        Timer(const Duration(milliseconds: 150), () {
          if (!mounted) return;
          final statsAfter = widget.gameState.currentStats(updated);
          setState(() {
            _showcase = _StarUpShowcaseData(
              definition: definition,
              newStars: updated.stars,
              statsBefore: statsBefore,
              statsAfter: statsAfter,
            );
          });
        });
      }
    }

    _fuseResetTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _justFused = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final target = _target;
    final definition = target == null ? null : widget.gameState.definition(target);
    final cost = _cost;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: dk_theme.Theme.deepNavy,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(AppLocalizations.of(context).fusionTitle, style: const TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(sfSymbol('xmark'), color: Colors.white, size: 18),
            tooltip: AppLocalizations.of(context).commonClose,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: dk_theme.Theme.background)),
            if (target != null && definition != null)
              cost != null ? _content(target: target, definition: definition, cost: cost) : _maxedState(definition: definition),
            if (_showcase != null)
              _StarUpShowcase(
                data: _showcase!,
                onDismiss: () => setState(() => _showcase = null),
              ),
          ],
        ),
      ),
    );
  }

  Widget _content({required DreamkeeperInstance target, required DreamkeeperDefinition definition, required int cost}) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _header(target: target, definition: definition),
                const SizedBox(height: 20),
                _progressCard(cost: cost),
                if (_willStarUp) ...[const SizedBox(height: 20), _statsPreviewCard(target: target)],
                const SizedBox(height: 20),
                if (_duplicates.isEmpty)
                  dk_theme.GlassCard(
                    child: Text(
                      l.fusionNoDuplicatesDreamkeeper(definition.name),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.fusionSelectDuplicates, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 90,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _duplicates.length,
                        itemBuilder: (context, index) {
                          final duplicate = _duplicates[index];
                          return _DuplicatePickerCard(
                            definition: definition,
                            instance: duplicate,
                            isSelected: _selectedIDs.contains(duplicate.id),
                            onTap: () => _toggle(duplicate.id),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        _footer(target: target, cost: cost),
      ],
    );
  }

  /// Always-visible banked-progress readout — the whole point of banking is
  /// that the player can fuse whatever they have right now and see exactly
  /// how close that gets them, instead of the button just staying disabled
  /// with no explanation until they happen to have the full cost.
  Widget _progressCard({required int cost}) {
    return dk_theme.GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Icon(sfSymbol('hammer.fill'), size: 14, color: _willStarUp ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).fusionProgressTowardStar(_bankedTotal, cost),
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          dk_theme.FusionProgressBar(
            current: _bankedTotal,
            total: cost,
            color: _willStarUp ? dk_theme.Theme.gold : dk_theme.Theme.violet,
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget _header({required DreamkeeperInstance target, required DreamkeeperDefinition definition}) {
    final hasArt = dk_theme.DreamkeeperArt.hasArt(definition.artName);
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: hasArt ? null : definition.rarity.gradient),
          alignment: Alignment.center,
          child: hasArt
              ? ClipOval(child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.artName), width: 64, height: 64, fit: BoxFit.cover))
              : Icon(sfSymbol(definition.symbol), size: 26, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(definition.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        StarRow(stars: target.stars, size: 14),
      ],
    );
  }

  Widget _statsPreviewCard({required DreamkeeperInstance target}) {
    final before = widget.gameState.currentStats(target);
    var preview = target.copyWith(stars: target.stars + 1);
    final def = widget.gameState.definition(preview);
    final after = preview.currentStats(definition: def, inventory: widget.gameState.inventory);
    return dk_theme.GlassCard(
      child: Column(
        children: [
          Text(AppLocalizations.of(context).fusionToStarGrants(target.stars + 1),
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _StatDeltaColumn(label: 'HP', before: before.hp, after: after.hp)),
              Expanded(child: _StatDeltaColumn(label: 'ATK', before: before.attack, after: after.attack)),
              Expanded(child: _StatDeltaColumn(label: 'DEF', before: before.defense, after: after.defense)),
              Expanded(child: _StatDeltaColumn(label: 'SPD', before: before.speed, after: after.speed)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footer({required DreamkeeperInstance target, required int cost}) {
    final l = AppLocalizations.of(context);
    final label = _justFused ? (_lastFuseGrantedStar ? l.fusionStarUp : l.fusionFused) : l.fusionAction;
    return Container(
      color: dk_theme.Theme.deepNavy,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.invSelectedCount(_selectedIDs.length), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              dk_theme.PrimaryButton(
                tint: dk_theme.Theme.gold,
                onPressed: (_selectedIDs.isEmpty || _justFused) ? null : () => _fuse(target),
                child: Text(label),
              ),
              if (_showBurst) dk_theme.BurstParticles(key: ValueKey(_burstKey), color: dk_theme.Theme.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _maxedState({required DreamkeeperDefinition definition}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 40, color: dk_theme.Theme.gold),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).fusionAtMaxStars(definition.name), style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StarUpShowcaseData {
  final DreamkeeperDefinition definition;
  final int newStars;
  final Stats statsBefore;
  final Stats statsAfter;

  const _StarUpShowcaseData({required this.definition, required this.newStars, required this.statsBefore, required this.statsAfter});
}

/// Full-screen cutscene for an actual star-up (not just banked progress) —
/// dimmed background, a spinning gold ring around the portrait, the new star
/// row, and the stat gains. Tap anywhere to dismiss early. Mirrors
/// `StarUpShowcase` exactly, minus the staggered spring-in choreography
/// (Flutter's animation primitives don't compose `DispatchQueue.main
/// .asyncAfter`-style staggering as tersely) — everything simply appears
/// together instead.
class _StarUpShowcase extends StatefulWidget {
  final _StarUpShowcaseData data;
  final VoidCallback onDismiss;

  const _StarUpShowcase({required this.data, required this.onDismiss});

  @override
  State<_StarUpShowcase> createState() => _StarUpShowcaseState();
}

class _StarUpShowcaseState extends State<_StarUpShowcase> with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final definition = data.definition;
    const portraitSize = 128.0;
    const haloSize = 200.0;
    final hasArt = dk_theme.DreamkeeperArt.hasArt(definition.artName);

    // `Positioned` must be a direct child of the outer `Stack` in `build()` —
    // wrapping it in `GestureDetector` first (as this used to) inserts a
    // RenderObject between them, which crashes with "Incorrect use of
    // ParentDataWidget" the moment this widget actually mounts (i.e. on a
    // real star-up, not just when banking progress).
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Stack(
          children: [
            Container(color: Colors.black.withValues(alpha: 0.65)),
            // The device this runs on is landscape-locked, which leaves very
            // little vertical room — stacking portrait, text, and the stat
            // list all in one column pushed the stat card below the visible
            // area (a `Stack` clips overflow by default). Laying the stat
            // list out to the right of the portrait instead, wrapped in a
            // scroll view as a safety net, keeps it on screen either way.
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Halo, ring, and portrait are centered on this inner
                    // `Stack` alone — not on the surrounding `Row`/`Column` —
                    // so all three stay perfectly concentric.
                    SizedBox(
                      width: haloSize,
                      height: haloSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: haloSize,
                            height: haloSize,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: definition.element.color.withValues(alpha: 0.45)),
                          ),
                          AnimatedBuilder(
                            animation: _ringController,
                            builder: (context, child) => Transform.rotate(angle: _ringController.value * 6.28318, child: child),
                            child: Container(
                              width: portraitSize + 26,
                              height: portraitSize + 26,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.85), width: 3)),
                            ),
                          ),
                          Container(
                            width: portraitSize,
                            height: portraitSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: hasArt ? null : definition.rarity.gradient,
                              border: Border.all(color: dk_theme.Theme.gold, width: 5),
                              boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.85), blurRadius: 30)],
                            ),
                            alignment: Alignment.center,
                            child: hasArt
                                ? ClipOval(child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.artName), width: portraitSize, height: portraitSize, fit: BoxFit.cover))
                                : Icon(sfSymbol(definition.symbol), size: portraitSize * 0.4, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).fusionStarUpShowcase, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 26, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(definition.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        StarRow(stars: data.newStars, size: 18),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.4)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _StatDeltaRow(label: 'HP', before: data.statsBefore.hp, after: data.statsAfter.hp),
                              _StatDeltaRow(label: 'ATK', before: data.statsBefore.attack, after: data.statsAfter.attack),
                              _StatDeltaRow(label: 'DEF', before: data.statsBefore.defense, after: data.statsAfter.defense),
                              _StatDeltaRow(label: 'SPD', before: data.statsBefore.speed, after: data.statsAfter.speed),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDeltaRow extends StatelessWidget {
  final String label;
  final double before;
  final double after;

  const _StatDeltaRow({required this.label, required this.before, required this.after});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          Text('${before.toInt()}', style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward, size: 12, color: Colors.white.withValues(alpha: 0.4)),
          const SizedBox(width: 6),
          Text('+${(after - before).toInt()}', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatDeltaColumn extends StatelessWidget {
  final String label;
  final double before;
  final double after;

  const _StatDeltaColumn({required this.label, required this.before, required this.after});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10)),
        Text('${before.toInt()}', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
        Text('+${(after - before).toInt()}', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _DuplicatePickerCard extends StatelessWidget {
  final DreamkeeperDefinition definition;
  final DreamkeeperInstance instance;
  final bool isSelected;
  final VoidCallback onTap;

  const _DuplicatePickerCard({required this.definition, required this.instance, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasArt = dk_theme.DreamkeeperArt.hasArt(definition.artName);
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        selected: isSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? dk_theme.Theme.gold.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? dk_theme.Theme.gold : dk_theme.Theme.cardStroke, width: isSelected ? 2 : 1),
            boxShadow: isSelected
                ? [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.35), blurRadius: 12, spreadRadius: 1)]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: hasArt ? null : definition.rarity.gradient),
                    alignment: Alignment.center,
                    child: hasArt
                        ? ClipOval(child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.artName), width: 48, height: 48, fit: BoxFit.cover))
                        : Icon(sfSymbol(definition.symbol), size: 20, color: Colors.white),
                  ),
                  if (isSelected)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.45)),
                      alignment: Alignment.center,
                      child: Icon(Icons.check_circle, size: 20, color: dk_theme.Theme.gold),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Lv ${instance.level}', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
