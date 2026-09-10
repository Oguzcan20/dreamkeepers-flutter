import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../shared/star_row.dart';

/// Manual fusion flow for Equipment — mirrors `FusionPickerView` for
/// Dreamkeepers. Shows every owned duplicate of the same item kind (slot +
/// name + rarity) so the player picks exactly which copies to feed in.
/// Mirrors `ItemFusionPickerView` (UI/Equipment/ItemFusionPickerView.swift)
/// exactly, pushed as a full-screen route instead of a `.sheet`.
class ItemFusionPickerView extends StatefulWidget {
  final String targetID;
  final GameState gameState;

  const ItemFusionPickerView({super.key, required this.targetID, required this.gameState});

  @override
  State<ItemFusionPickerView> createState() => _ItemFusionPickerViewState();
}

class _ItemFusionPickerViewState extends State<ItemFusionPickerView> {
  final Set<String> _selectedIDs = {};
  bool _justFused = false;
  bool _lastFuseGrantedStar = false;
  Timer? _fuseResetTimer;

  EquipmentItem? get _target {
    final matches = widget.gameState.inventory.where((i) => i.id == widget.targetID);
    return matches.isEmpty ? null : matches.first;
  }

  List<EquipmentItem> get _duplicates {
    final target = _target;
    return target == null ? [] : widget.gameState.duplicatesOfItem(target);
  }

  int? get _cost {
    final target = _target;
    return target == null ? null : widget.gameState.nextFusionCostForItem(target);
  }

  int get _bankedTotal => (_target?.fusionProgress ?? 0) + _selectedIDs.length;

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

  void _fuse(EquipmentItem target) {
    final selected = _duplicates.where((d) => _selectedIDs.contains(d.id)).toList();
    final grantsStar = _willStarUp;
    if (!widget.gameState.fuseItem(target, selected)) return;
    // `playHaptic(.levelUp)` already fires the paired `.levelUp` sound —
    // see `fusion_picker_view.dart`'s identical note.
    widget.gameState.playHaptic(HapticStyle.levelUp);
    setState(() {
      _lastFuseGrantedStar = grantsStar;
      _justFused = true;
      _selectedIDs.clear();
    });
    _fuseResetTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _justFused = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final target = _target;
    final cost = _cost;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: dk_theme.Theme.deepNavy,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('Fuse', style: TextStyle(color: Colors.white)),
          // Default `leadingWidth` is `kToolbarHeight` (56) — too narrow for
          // the "Close" label + `TextButton` padding, which wrapped it to
          // "Clos\ne" on the landscape layout.
          leadingWidth: 80,
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ),
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: dk_theme.Theme.background)),
            if (target != null) (cost != null ? _content(target: target, cost: cost) : _maxedState(target: target)),
          ],
        ),
      ),
    );
  }

  Widget _content({required EquipmentItem target, required int cost}) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _header(target: target),
                const SizedBox(height: 20),
                _progressCard(cost: cost),
                if (_willStarUp) ...[const SizedBox(height: 20), _statsPreviewCard(target: target)],
                const SizedBox(height: 20),
                if (_duplicates.isEmpty)
                  dk_theme.GlassCard(
                    child: Text(
                      'No duplicate ${target.name}s yet. Clear more stages to find fusion fodder.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select duplicates to fuse', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
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
                          return _ItemDuplicatePickerCard(
                            item: duplicate,
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

  Widget _progressCard({required int cost}) {
    return dk_theme.GlassCard(
      child: Column(
        children: [
          Text('$_bankedTotal/$cost toward next star', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
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

  Widget _header({required EquipmentItem target}) {
    final hasArt = dk_theme.ItemArt.hasArt(target.name);
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hasArt ? null : target.rarity.gradient,
            border: hasArt ? Border.fromBorderSide(BorderSide(color: target.rarity.primaryColor, width: 3)) : null,
          ),
          alignment: Alignment.center,
          child: hasArt
              ? ClipOval(child: Image.asset(dk_theme.ItemArt.assetName(target.name), width: 64, height: 64, fit: BoxFit.cover))
              : Icon(sfSymbol(target.slot.symbol), size: 26, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(target.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        StarRow(stars: target.stars, size: 14),
      ],
    );
  }

  Widget _statsPreviewCard({required EquipmentItem target}) {
    final preview = target.copyWith(stars: target.stars + 1);
    final before = target.effectiveStatBonus;
    final after = preview.effectiveStatBonus;
    return dk_theme.GlassCard(
      child: Column(
        children: [
          Text('Fusing to ★${target.stars + 1} grants',
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

  Widget _footer({required EquipmentItem target, required int cost}) {
    final label = _justFused ? (_lastFuseGrantedStar ? 'Star Up!' : 'Fused!') : 'Fuse';
    return Container(
      color: dk_theme.Theme.deepNavy,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${_selectedIDs.length} selected', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w600)),
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

  Widget _maxedState({required EquipmentItem target}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 40, color: dk_theme.Theme.gold),
          const SizedBox(height: 12),
          Text('${target.name} is at max stars', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
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

class _ItemDuplicatePickerCard extends StatelessWidget {
  final EquipmentItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _ItemDuplicatePickerCard({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasArt = dk_theme.ItemArt.hasArt(item.name);
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasArt ? null : item.rarity.gradient,
                      border: hasArt ? Border.fromBorderSide(BorderSide(color: item.rarity.primaryColor, width: 2.5)) : null,
                    ),
                    alignment: Alignment.center,
                    child: hasArt
                        ? ClipOval(child: Image.asset(dk_theme.ItemArt.assetName(item.name), width: 48, height: 48, fit: BoxFit.cover))
                        : Icon(sfSymbol(item.slot.symbol), size: 20, color: Colors.white),
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
              Text('Lv ${item.level}', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
