import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/dreamkeeper.dart';
import '../../models/equipment.dart';
import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../shared/star_row.dart';
import 'fusion_picker_view.dart';

/// Full detail window for a roster Dreamkeeper: stats, deploy/bench, star
/// fusion, skills, and per-slot equipment — all in one place. Mirrors
/// `EquipmentSheet` (UI/Equipment/EquipmentSheet.swift) exactly, pushed as a
/// full-screen route rather than a bottom sheet (unlike Dream Haven's
/// simpler `showModalBottomSheet` sheets, this one is itself a
/// `NavigationStack` with its own toolbar in Swift — a full page reads
/// truer than a bottom sheet for a two-column stats+skills layout).
///
/// Drops Swift's manual `isGerman`/`localized(en:de:)` branching in
/// `skillsSection` — this Dart port has no localization infrastructure yet
/// (English-only throughout), matching every other screen ported so far.
class EquipmentSheet extends StatefulWidget {
  final String instanceID;
  final GameState gameState;

  const EquipmentSheet({super.key, required this.instanceID, required this.gameState});

  @override
  State<EquipmentSheet> createState() => _EquipmentSheetState();
}

class _EquipmentSheetState extends State<EquipmentSheet> {
  DreamkeeperInstance? get _instance {
    final matches = widget.gameState.roster.where((i) => i.id == widget.instanceID);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final instance = _instance;
    final definition = instance == null ? null : widget.gameState.definition(instance);
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: dk_theme.Theme.deepNavy,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(definition?.name ?? l.eqDreamkeeperFallback, style: const TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(sfSymbol('xmark'), color: Colors.white, size: 18),
            tooltip: l.commonDone,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: dk_theme.Theme.background)),
            if (instance != null && definition != null)
              AnimatedBuilder(
                animation: widget.gameState,
                builder: (context, _) {
                  // Re-read the instance on every notification — `equip`,
                  // `unequip`, upgrades and fusion all replace the roster
                  // entry, so the copy captured in `build()` goes stale and
                  // the slot rows / stats would show the pre-change state
                  // until the sheet is reopened.
                  final live = _instance;
                  final liveDefinition =
                      live == null ? null : widget.gameState.definition(live);
                  if (live == null || liveDefinition == null) {
                    return const SizedBox.shrink();
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 560;
                        final left = _leftColumn(
                            instance: live, definition: liveDefinition);
                        final right = _rightColumn(
                            instance: live, definition: liveDefinition);
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

  Widget _leftColumn({required DreamkeeperInstance instance, required DreamkeeperDefinition definition}) {
    return Column(
      children: [
        _header(definition: definition, instance: instance),
        const SizedBox(height: 16),
        _deployButton(instance: instance),
        const SizedBox(height: 16),
        _statsGrid(instance: instance),
        const SizedBox(height: 16),
        _FusionCard(instance: instance, gameState: widget.gameState),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            definition.flavorText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget _rightColumn({required DreamkeeperInstance instance, required DreamkeeperDefinition definition}) {
    return Column(
      children: [
        _skillsSection(definition: definition),
        const SizedBox(height: 12),
        _autoEquipButton(instance: instance),
        const SizedBox(height: 12),
        for (final slot in EquipmentSlot.values) ...[
          _SlotRow(slot: slot, instance: instance, gameState: widget.gameState),
          if (slot != EquipmentSlot.values.last) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _header({required DreamkeeperDefinition definition, required DreamkeeperInstance instance}) {
    final hasArt = dk_theme.DreamkeeperArt.hasArt(definition.artName);
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: hasArt ? null : definition.rarity.gradient),
          alignment: Alignment.center,
          child: hasArt
              ? ClipOval(child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.artName), width: 72, height: 72, fit: BoxFit.cover))
              : Icon(sfSymbol(definition.symbol), size: 30, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context).eqLevelLabel(instance.level), style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
      ],
    );
  }

  Widget _deployButton({required DreamkeeperInstance instance}) {
    final deployed = widget.gameState.isDeployed(instance);
    return SizedBox(
      width: double.infinity,
      child: dk_theme.PrimaryButton(
        tint: deployed ? Colors.grey : dk_theme.Theme.violet,
        onPressed: () {
          widget.gameState.toggleDeployed(instance);
          widget.gameState.playHaptic(HapticStyle.light);
        },
        child: Text(deployed ? AppLocalizations.of(context).eqBench : AppLocalizations.of(context).eqDeploy),
      ),
    );
  }

  Widget _statsGrid({required DreamkeeperInstance instance}) {
    final stats = widget.gameState.currentStats(instance);
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Expanded(child: _StatColumn(label: 'HP', value: stats.hp)),
          Expanded(child: _StatColumn(label: 'ATK', value: stats.attack)),
          Expanded(child: _StatColumn(label: 'DEF', value: stats.defense)),
          Expanded(child: _StatColumn(label: 'SPD', value: stats.speed)),
        ],
      ),
    );
  }

  Widget _skillsSection({required DreamkeeperDefinition definition}) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        _SkillRow(
          icon: 'sparkles',
          tint: dk_theme.Theme.gold,
          name: definition.ultimate.name,
          description: definition.ultimate.description,
          detail: l.eqUltimateDetail(definition.ultimate.attacksToCharge),
        ),
        const SizedBox(height: 10),
        _SkillRow(
          icon: 'bolt.fill',
          tint: dk_theme.Theme.softBlue,
          name: definition.activeSkill.name,
          description: definition.activeSkill.description,
          detail: l.eqActiveSkillDetail(definition.activeSkill.cooldownSeconds.toInt()),
        ),
        const SizedBox(height: 10),
        _SkillRow(
          icon: 'shield.lefthalf.filled',
          tint: Colors.white.withValues(alpha: 0.7),
          name: definition.passive.name,
          description: definition.passive.description,
          detail: l.eqSkillPassive,
        ),
      ],
    );
  }

  /// One tap fills every slot with the best unworn item in storage instead
  /// of picking through four "Change" pickers by hand. Disabled once
  /// nothing in the bag would actually improve on what's already equipped.
  Widget _autoEquipButton({required DreamkeeperInstance instance}) {
    final canAutoEquip = widget.gameState.canAutoEquip(instance);
    return SizedBox(
      width: double.infinity,
      child: dk_theme.PrimaryButton(
        tint: dk_theme.Theme.gold,
        onPressed: canAutoEquip
            ? () {
                widget.gameState.autoEquipBest(instance);
                widget.gameState.playHaptic(HapticStyle.light);
              }
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol('wand.and.stars'), size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(child: Text(AppLocalizations.of(context).eqAutoEquip, overflow: TextOverflow.ellipsis)),
          ],
        ),
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
        Text('${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _FusionCard extends StatelessWidget {
  final DreamkeeperInstance instance;
  final GameState gameState;

  const _FusionCard({required this.instance, required this.gameState});

  DreamkeeperInstance get _currentInstance {
    final matches = gameState.roster.where((i) => i.id == instance.id);
    return matches.isEmpty ? instance : matches.first;
  }

  void _openPicker(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FusionPickerView(targetID: instance.id, gameState: gameState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final current = _currentInstance;
    final cost = gameState.nextFusionCost(current);
    final duplicates = gameState.duplicates(current);
    return dk_theme.GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              StarRow(stars: current.stars, size: 14),
              const Spacer(),
              Icon(sfSymbol('hammer.fill'), color: dk_theme.Theme.gold, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          if (cost == null)
            Text(l.eqMaxStars, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600))
          else ...[
            Text(
              l.eqFusionProgress(current.fusionProgress, cost, duplicates.length),
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
            ),
            const SizedBox(height: 8),
            dk_theme.FusionProgressBar(current: current.fusionProgress, total: cost),
            const SizedBox(height: 12),
            dk_theme.PrimaryButton(
              tint: dk_theme.Theme.gold,
              padding: const EdgeInsets.symmetric(vertical: 9),
              onPressed: duplicates.isEmpty ? null : () => _openPicker(context),
              child: Text(l.eqFuseToStar(current.stars + 1), style: const TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final String icon;
  final Color tint;
  final String name;
  final String description;
  final String detail;

  const _SkillRow({required this.icon, required this.tint, required this.name, required this.description, required this.detail});

  @override
  Widget build(BuildContext context) {
    return dk_theme.GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 22, child: Icon(sfSymbol(icon), color: tint, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(description, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
                const SizedBox(height: 3),
                Text(detail, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  final EquipmentSlot slot;
  final DreamkeeperInstance instance;
  final GameState gameState;

  const _SlotRow({required this.slot, required this.instance, required this.gameState});

  EquipmentItem? get _equippedItem => gameState.equippedItem(slot, instance);

  void _openPicker(BuildContext context) {
    final l = AppLocalizations.of(context);
    final equipped = _equippedItem;
    final available = gameState.availableItems(slot);
    showModalBottomSheet(
      context: context,
      backgroundColor: dk_theme.Theme.deepNavy,
      // Swift presents this as a native `Menu` popover, which scrolls itself
      // and never clips. A default (non-scroll-controlled) bottom sheet is
      // capped near half the screen height — in landscape that hides the
      // lower rows of a long item list with no way to reach them. Cap the
      // height explicitly and let the list scroll inside it instead.
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (equipped != null)
                    ListTile(
                      leading: const Icon(Icons.close, color: Colors.redAccent),
                      title: Text(l.eqUnequip, style: const TextStyle(color: Colors.redAccent)),
                      onTap: () {
                        gameState.unequip(slot, instance);
                        gameState.playHaptic(HapticStyle.light);
                        Navigator.of(context).pop();
                      },
                    ),
                  if (available.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(l.eqNoItems, style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
                    )
                  else
                    ...available.map(
                      (item) => ListTile(
                        title: Text(l.eqItemWithRarity(item.name, item.rarity.displayName), style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          gameState.equip(item, instance);
                          gameState.playHaptic(HapticStyle.light);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final equipped = _equippedItem;
    return dk_theme.GlassCard(
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Icon(sfSymbol(slot.symbol), color: equipped != null ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.4), size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slot.displayName, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
                Text(
                  equipped?.name ?? l.eqEmpty,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _openPicker(context),
            child: Text(l.eqChange, style: TextStyle(color: dk_theme.Theme.softBlue, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
