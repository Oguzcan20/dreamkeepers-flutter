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
          // Default `leadingWidth` is `kToolbarHeight` (56) — too narrow for
          // the "Close" label + `TextButton` padding, which wrapped it to
          // "Clos\ne" on the landscape layout.
          leadingWidth: 80,
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).commonClose, style: const TextStyle(color: Colors.white)),
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
          Text(AppLocalizations.of(context).fusionProgressTowardStar(_bankedTotal, cost), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final fraction = cost == 0 ? 1.0 : (_bankedTotal / cost).clamp(0, 1).toDouble();
              return ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Stack(
                  children: [
                    Container(height: 8, color: Colors.white.withValues(alpha: 0.08)),
                    Container(height: 8, width: constraints.maxWidth * fraction, color: _willStarUp ? dk_theme.Theme.gold : dk_theme.Theme.violet),
                  ],
                ),
              );
            },
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
          dk_theme.PrimaryButton(
            tint: dk_theme.Theme.gold,
            onPressed: (_selectedIDs.isEmpty || _justFused) ? null : () => _fuse(target),
            child: Text(label),
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
    const portraitSize = 170.0;
    final hasArt = dk_theme.DreamkeeperArt.hasArt(definition.artName);

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Positioned.fill(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(color: Colors.black.withValues(alpha: 0.65)),
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(shape: BoxShape.circle, color: definition.element.color.withValues(alpha: 0.45)),
            ),
            AnimatedBuilder(
              animation: _ringController,
              builder: (context, child) => Transform.rotate(angle: _ringController.value * 6.28318, child: child),
              child: Container(
                width: portraitSize + 30,
                height: portraitSize + 30,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.85), width: 3)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(height: 14),
                Text(AppLocalizations.of(context).fusionStarUpShowcase, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(definition.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                StarRow(stars: data.newStars, size: 20),
                const SizedBox(height: 18),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StatDeltaColumn(label: 'HP', before: data.statsBefore.hp, after: data.statsAfter.hp),
                    const SizedBox(width: 18),
                    _StatDeltaColumn(label: 'ATK', before: data.statsBefore.attack, after: data.statsAfter.attack),
                    const SizedBox(width: 18),
                    _StatDeltaColumn(label: 'DEF', before: data.statsBefore.defense, after: data.statsAfter.defense),
                    const SizedBox(width: 18),
                    _StatDeltaColumn(label: 'SPD', before: data.statsBefore.speed, after: data.statsAfter.speed),
                  ],
                ),
              ],
            ),
          ],
        ),
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
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? dk_theme.Theme.gold.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? dk_theme.Theme.gold : dk_theme.Theme.cardStroke, width: isSelected ? 2 : 1),
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
