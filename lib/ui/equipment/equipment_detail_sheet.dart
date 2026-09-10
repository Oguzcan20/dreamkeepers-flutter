import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/equipment.dart';
import '../../platform/platform_service.dart';
import '../../progression/equipment_upgrade.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../shared/star_row.dart';
import 'item_fusion_picker_view.dart';

/// Tap-to-open detail window for an inventory item — mirrors
/// `EquipmentSheet` for Dreamkeepers: stats, fusion, and upgrade all live
/// here instead of being split across separate screens. Mirrors
/// `EquipmentDetailSheet` (UI/Equipment/EquipmentDetailSheet.swift) exactly,
/// pushed as a full-screen route for the same reason as `EquipmentSheet`.
class EquipmentDetailSheet extends StatefulWidget {
  final String itemID;
  final GameState gameState;

  const EquipmentDetailSheet({super.key, required this.itemID, required this.gameState});

  @override
  State<EquipmentDetailSheet> createState() => _EquipmentDetailSheetState();
}

class _EquipmentDetailSheetState extends State<EquipmentDetailSheet> {
  EquipmentItem? get _item {
    final matches = widget.gameState.inventory.where((i) => i.id == widget.itemID);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final item = _item;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: dk_theme.Theme.deepNavy,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(item?.name ?? l.eqItemFallback, style: const TextStyle(color: Colors.white)),
          // Default `leadingWidth` is `kToolbarHeight` (56) — too narrow for
          // the "Done" label + `TextButton` padding, which wrapped it to
          // "Don\ne" on the landscape layout.
          leadingWidth: 80,
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.commonDone, style: const TextStyle(color: Colors.white)),
          ),
        ),
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: dk_theme.Theme.background)),
            if (item != null)
              AnimatedBuilder(
                animation: widget.gameState,
                builder: (context, _) {
                  // Re-read the item on every notification — upgrade and
                  // fusion replace the inventory entry, so the copy captured
                  // in `build()` goes stale and the stats / level would show
                  // the pre-change state until the sheet is reopened.
                  final live = _item;
                  if (live == null) return const SizedBox.shrink();
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 560;
                        final left = _leftColumn(item: live);
                        final right = _rightColumn(item: live);
                        if (narrow) {
                          return Column(
                              children: [left, const SizedBox(height: 20), right]);
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: left),
                            const SizedBox(width: 16),
                            Expanded(child: right),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _leftColumn({required EquipmentItem item}) {
    return Column(
      children: [
        _header(item: item),
        const SizedBox(height: 16),
        _statsGrid(item: item),
      ],
    );
  }

  Widget _rightColumn({required EquipmentItem item}) {
    return Column(
      children: [
        _FusionCard(itemID: item.id, gameState: widget.gameState),
        const SizedBox(height: 16),
        _upgradeCard(item: item),
      ],
    );
  }

  Widget _header({required EquipmentItem item}) {
    final l = AppLocalizations.of(context);
    final hasArt = dk_theme.ItemArt.hasArt(item.name);
    final wearer = widget.gameState.wearer(item);
    final wearerName = wearer == null ? null : widget.gameState.definition(wearer)?.name;
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hasArt ? null : item.rarity.gradient,
            border: hasArt ? Border.fromBorderSide(BorderSide(color: item.rarity.primaryColor, width: 3)) : null,
          ),
          alignment: Alignment.center,
          child: hasArt
              ? ClipOval(child: Image.asset(dk_theme.ItemArt.assetName(item.name), width: 72, height: 72, fit: BoxFit.cover))
              : Icon(sfSymbol(item.slot.symbol), size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          l.invItemSubtitle(item.rarity.displayName, item.level, EquipmentUpgrade.maxLevel),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
        ),
        if (wearerName != null) ...[
          const SizedBox(height: 4),
          Text(l.invItemWornBy(wearerName), style: TextStyle(color: dk_theme.Theme.softBlue, fontSize: 11)),
        ],
      ],
    );
  }

  Widget _statsGrid({required EquipmentItem item}) {
    final bonus = item.effectiveStatBonus;
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Expanded(child: _StatColumn(label: 'HP', value: bonus.hp)),
          Expanded(child: _StatColumn(label: 'ATK', value: bonus.attack)),
          Expanded(child: _StatColumn(label: 'DEF', value: bonus.defense)),
          Expanded(child: _StatColumn(label: 'SPD', value: bonus.speed)),
        ],
      ),
    );
  }

  Widget _upgradeCard({required EquipmentItem item}) {
    final l = AppLocalizations.of(context);
    final isMaxed = !EquipmentUpgrade.canUpgrade(item);
    final cost = EquipmentUpgrade.cost(item);
    final canAfford = widget.gameState.save.gold >= cost;
    return dk_theme.GlassCard(
      child: isMaxed
          ? Text(l.eqMaxLevel, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600))
          : Row(
              children: [
                Expanded(child: Text(l.commonAmountGold(cost), style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12))),
                // See `PrimaryButton`'s doc comment (theme.dart) — it always
                // forces `width: double.infinity`, so a Row placement needs
                // a fixed-width wrapper.
                SizedBox(
                  width: 100,
                  child: dk_theme.PrimaryButton(
                    tint: dk_theme.Theme.gold,
                    onPressed: canAfford
                        ? () {
                            widget.gameState.upgradeEquipment(item);
                            widget.gameState.playHaptic(HapticStyle.light);
                          }
                        : null,
                    child: Text(l.eqUpgrade),
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final double value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10)),
        Text('+${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _FusionCard extends StatelessWidget {
  final String itemID;
  final GameState gameState;

  const _FusionCard({required this.itemID, required this.gameState});

  EquipmentItem? get _currentItem {
    final matches = gameState.inventory.where((i) => i.id == itemID);
    return matches.isEmpty ? null : matches.first;
  }

  void _openPicker(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ItemFusionPickerView(targetID: itemID, gameState: gameState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final current = _currentItem;
    if (current == null) return const SizedBox.shrink();
    final cost = gameState.nextFusionCostForItem(current);
    return dk_theme.GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              StarRow(stars: current.stars, size: 14),
              const Spacer(),
              Icon(sfSymbol('hammer.fill'), color: dk_theme.Theme.gold, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          if (cost == null)
            Text(l.eqMaxStars, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600))
          else
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.eqFusionProgress(current.fusionProgress, cost, gameState.duplicatesOfItem(current).length),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11),
                  ),
                ),
                // See `PrimaryButton`'s doc comment (theme.dart) — it always
                // forces `width: double.infinity`, so a Row placement needs
                // a fixed-width wrapper.
                SizedBox(
                  width: 130,
                  child: dk_theme.PrimaryButton(
                    tint: dk_theme.Theme.gold,
                    onPressed: gameState.duplicatesOfItem(current).isEmpty ? null : () => _openPicker(context),
                    child: Text(l.eqFuseToStar(current.stars + 1)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
