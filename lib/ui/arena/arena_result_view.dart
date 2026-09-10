// Result screen for one Arena Tower floor fight. Mirrors `ArenaResultView`
// (UI/Arena/ArenaResultView.swift) — reuses `BattleResultView`'s reward-card
// visual language (equipment drop) since a win here can grant the same kind
// of loot, just scaled by floor instead of by campaign stage. "Fight Again"
// returns to the Arena hub (not straight back into another fight) so the
// player can pick the next floor, matching Swift's own `onFightAgain`
// wiring in `RootView`.

import 'package:flutter/material.dart';

import '../../combat/battle_engine.dart';
import '../../l10n/l10n.dart';
import '../../models/equipment.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

class ArenaResultView extends StatelessWidget {
  final ArenaBattleResultSummary summary;
  final ValueChanged<AppRoute> onNavigate;

  const ArenaResultView({super.key, required this.summary, required this.onNavigate});

  bool get _won => summary.outcome == BattleOutcome.victory;

  void _goArena() => onNavigate(const ArenaRoute());
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
                    if (summary.towerCleared) ...[stagger(_towerClearedBanner(l)), const SizedBox(height: 12)],
                    if (!summary.towerCleared && _won && summary.isMilestoneFloor) ...[
                      stagger(_milestoneBanner(l)),
                      const SizedBox(height: 12),
                    ],
                    if (_won) ...[stagger(_goldCard(l)), const SizedBox(height: 12)],
                    if (summary.tierChanged) ...[stagger(_tierChangeCard(l)), const SizedBox(height: 12)],
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
            _won ? l.brVictoryTitle : l.arenaResultDefeat,
            style: TextStyle(color: _won ? dk_theme.Theme.gold : Colors.red, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(l.arenaFloorLabel(summary.floor), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _towerClearedBanner(AppLocalizations l) {
    return _glowCard(
      icon: 'crown.fill',
      title: l.arenaTowerCleared,
      subtitle: l.arenaTowerClearedResultBody,
    );
  }

  Widget _milestoneBanner(AppLocalizations l) {
    return _glowCard(
      icon: 'sparkles',
      title: l.arenaMilestoneReward,
      subtitle: l.arenaMilestoneBody,
    );
  }

  Widget _glowCard({required String icon, required String title, required String subtitle}) {
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
              child: Icon(sfSymbol(icon), size: 20, color: dk_theme.Theme.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goldCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(sfSymbol('circle.hexagongrid.fill'), color: dk_theme.Theme.gold, size: 20),
          const SizedBox(width: 6),
          Text(l.havenPlusGold(summary.goldGained), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _tierChangeCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: dk_theme.Theme.gold.withValues(alpha: 0.35),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.6), blurRadius: 10)],
            ),
            child: Icon(sfSymbol(summary.newTier.symbol), size: 20, color: dk_theme.Theme.gold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.arenaNewTier, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(summary.newTier.displayName, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
              ],
            ),
          ),
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
            summary.isFirstClear ? l.arenaFirstClearReward : l.arenaStandardReward,
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
          if (!summary.towerCleared) ...[
            const SizedBox(width: 12),
            Expanded(
              child: dk_theme.PrimaryButton(tint: dk_theme.Theme.gold, onPressed: _goArena, child: Text(l.arenaFightAgain)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Same Ticker-free staggered-reveal helper as `BattleResultView`'s private
/// `_StaggeredCard` — duplicated locally rather than shared, matching this
/// codebase's existing per-screen-file convention for these small private
/// widgets.
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
