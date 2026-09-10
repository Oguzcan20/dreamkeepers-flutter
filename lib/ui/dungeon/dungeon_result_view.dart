// Result screen for one Dungeon run. A Flutter-only screen with no
// Swift-original counterpart. Mirrors `ArenaResultView`'s reward-card visual
// language — a win here grants the same kind of loot, sized by the dungeon's
// loot stage. "Fight Again" returns to the Dungeon hub (not straight into
// another run) so the player can pick which dungeon to enter next, and only
// when a key is still available.

import 'package:flutter/material.dart';

import '../../combat/battle_engine.dart';
import '../../combat/dungeon_system.dart';
import '../../l10n/l10n.dart';
import '../../models/equipment.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

class DungeonResultView extends StatelessWidget {
  final DungeonBattleResultSummary summary;
  final ValueChanged<AppRoute> onNavigate;

  const DungeonResultView({super.key, required this.summary, required this.onNavigate});

  bool get _won => summary.outcome == BattleOutcome.victory;

  void _goDungeons() => onNavigate(const DungeonRoute());
  void _goDreamHaven() => onNavigate(const DreamHavenRoute());

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    var index = 0;
    Widget stagger(Widget child) => _StaggeredCard(index: index++, child: child);

    return Container(
      decoration: const BoxDecoration(gradient: dk_theme.Theme.background),
      child: SafeArea(
        child: Column(
          children: [
            _header(l),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_won && summary.isFirstClear) ...[stagger(_firstClearBanner(l)), const SizedBox(height: 12)],
                    if (_won) ...[stagger(_rewardCard(l)), const SizedBox(height: 12)],
                    if (summary.droppedEquipment != null) ...[
                      stagger(_droppedEquipmentCard(l, summary.droppedEquipment!)),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
            _footer(l),
          ],
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 6),
      child: Column(
        children: [
          Text(
            _won ? l.brVictoryTitle : l.dungeonResultDefeat,
            style: TextStyle(color: _won ? dk_theme.Theme.gold : Colors.red, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(DungeonSystem.displayName(summary.dungeon),
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _firstClearBanner(AppLocalizations l) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.6), width: 1.5),
      ),
      child: dk_theme.GlassCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: dk_theme.Theme.gold.withValues(alpha: 0.35),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.7), blurRadius: 12)],
              ),
              child: Icon(sfSymbol('checkmark.seal.fill'), size: 20, color: dk_theme.Theme.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.dungeonFirstClearTitle, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(l.dungeonFirstClearBody, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rewardCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(sfSymbol('circle.hexagongrid.fill'), color: dk_theme.Theme.gold, size: 20),
          const SizedBox(width: 6),
          Text(l.havenPlusGold(summary.goldGained),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          if (summary.gemsGained > 0) ...[
            const SizedBox(width: 16),
            Icon(sfSymbol('sparkles'), color: dk_theme.Theme.violet, size: 20),
            const SizedBox(width: 6),
            Text('+${summary.gemsGained}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ],
      ),
    );
  }

  Widget _droppedEquipmentCard(AppLocalizations l, EquipmentItem item) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.isFirstClear ? l.dungeonFirstClearReward : l.dungeonFarmReward,
            style: TextStyle(
              color: summary.isFirstClear ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.55),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (dk_theme.ItemArt.hasArt(item.name))
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: item.rarity.primaryColor, width: 2.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(dk_theme.ItemArt.assetName(item.name), fit: BoxFit.cover),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: item.rarity.primaryColor.withValues(alpha: 0.3)),
                  alignment: Alignment.center,
                  child: Icon(sfSymbol(item.slot.symbol), color: item.rarity.primaryColor, size: 20),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(
                      '${item.rarity.displayName} · ${item.slot.displayName}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footer(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: dk_theme.PrimaryButton(tint: Colors.grey, onPressed: _goDreamHaven, child: Text(l.navDreamHaven)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: dk_theme.PrimaryButton(tint: dk_theme.Theme.violet, onPressed: _goDungeons, child: Text(l.dungeonBackToHub)),
          ),
        ],
      ),
    );
  }
}

/// Same staggered-reveal helper as the other result screens — duplicated
/// locally per this codebase's per-screen-file convention.
class _StaggeredCard extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredCard({required this.index, required this.child});

  @override
  State<_StaggeredCard> createState() => _StaggeredCardState();
}

class _StaggeredCardState extends State<_StaggeredCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 90 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
      offset: _visible ? Offset.zero : const Offset(0, 0.12),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 320),
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
