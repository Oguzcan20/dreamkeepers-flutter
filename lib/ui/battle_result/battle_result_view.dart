// Post-battle summary. Mirrors `BattleResultView`
// (UI/BattleResult/BattleResultView.swift): a header (title varies by
// outcome/boss), the two-column reward layout kept as-is (plain content
// layout with room to spare, not a decorative workaround — see the Shop
// milestone's precedent), and a footer that offers "Next Battle" only while
// there's a next stage to fight.

import 'package:flutter/material.dart';

import '../../combat/battle_engine.dart';
import '../../l10n/l10n.dart';
import '../../models/equipment.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

class BattleResultView extends StatelessWidget {
  final BattleResultSummary summary;
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const BattleResultView({super.key, required this.summary, required this.gameState, required this.onNavigate});

  bool get _isVictory => summary.outcome == BattleOutcome.victory;
  bool get _offersNextBattle => _isVictory && !gameState.isCampaignComplete;

  void _goDreamHaven() => onNavigate(const DreamHavenRoute());
  void _goNextBattle() => onNavigate(const BattleRoute());

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(gradient: dk_theme.Theme.background),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(l),
                    const SizedBox(height: 20),
                    if (_isVictory) _victoryBody(l) else _defeatBody(l),
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
    final title = !_isVictory ? l.brDefeatTitle : (summary.wasBoss ? l.brBossDefeatedTitle : l.brVictoryTitle);
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: _isVictory ? dk_theme.Theme.gold : Colors.red, fontSize: 32, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          l.campaignStageLabel(summary.stage),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _defeatBody(AppLocalizations l) {
    return _StaggeredCard(
      index: 0,
      child: dk_theme.GlassCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            l.brDefeatBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _victoryBody(AppLocalizations l) {
    final leftCards = <Widget>[_rewardsCard(l)];
    if (summary.accountLevelUp != null) leftCards.add(_accountLevelUpCard(l, summary.accountLevelUp!));
    if (summary.droppedEquipment != null) leftCards.add(_droppedEquipmentCard(summary.droppedEquipment!));

    final rightCards = <Widget>[];
    if (summary.levelUps.isNotEmpty) rightCards.add(_levelUpsCard(l));
    if (summary.newRecruit != null) rightCards.add(_newRecruitCard(l, summary.newRecruit!));

    var index = 0;
    Widget stagger(Widget child) => _StaggeredCard(index: index++, child: child);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (summary.isPerfectClear) ...[
          stagger(_perfectClearBanner(l)),
          const SizedBox(height: 14),
        ],
        if (summary.completedWorldNumber != null) ...[
          stagger(_worldCompletedBanner(l, summary.completedWorldNumber!)),
          const SizedBox(height: 14),
        ],
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (final c in leftCards) ...[stagger(c), const SizedBox(height: 14)]],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (final c in rightCards) ...[stagger(c), const SizedBox(height: 14)]],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _perfectClearBanner(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Icon(sfSymbol('star.fill'), color: dk_theme.Theme.gold, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(l.brPerfectClear(summary.perfectClearBonusGold),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _rewardsCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.brRewards, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          _CountUpRow(icon: 'paid', tint: dk_theme.Theme.gold, label: l.resGold, value: summary.goldGained),
          const SizedBox(height: 8),
          _CountUpRow(icon: 'star.circle.fill', tint: dk_theme.Theme.softBlue, label: l.brExp, value: summary.expGained),
          if (summary.gemsGained > 0) ...[
            const SizedBox(height: 8),
            _CountUpRow(icon: 'sparkles', tint: dk_theme.Theme.violet, label: l.resDreamGems, value: summary.gemsGained),
          ],
        ],
      ),
    );
  }

  /// Called out the same way `_perfectClearBanner` is — a whole World just
  /// got cleared for the first time, which is rarer and more significant
  /// than a single stage win, so it gets its own banner above the reward
  /// tiles rather than blending into the gem count alone.
  Widget _worldCompletedBanner(AppLocalizations l, int worldNumber) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Icon(sfSymbol('sparkles'), color: dk_theme.Theme.violet, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.brWorldCompleted(worldNumber),
                    style: TextStyle(color: dk_theme.Theme.violet, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(l.brGemsGained(summary.gemsGained),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountLevelUpCard(AppLocalizations l, AccountLevelUp levelUp) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Icon(sfSymbol('crown.fill'), color: dk_theme.Theme.gold, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(l.brAccountLevel(levelUp.oldLevel, levelUp.newLevel),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _droppedEquipmentCard(EquipmentItem item) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          if (dk_theme.ItemArt.hasArt(item.name))
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: item.rarity.primaryColor, width: 2.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(dk_theme.ItemArt.assetName(item.name), fit: BoxFit.cover),
            )
          else
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: item.rarity.primaryColor.withValues(alpha: 0.3)),
              alignment: Alignment.center,
              child: Icon(sfSymbol(item.slot.symbol), color: item.rarity.primaryColor, size: 20),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(item.rarity.displayName, style: TextStyle(color: item.rarity.primaryColor, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelUpsCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.brLevelUpTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          for (final up in summary.levelUps) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(child: Text(up.name, style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
                  Text(l.brLevelChange(up.oldLevel, up.newLevel),
                      style: TextStyle(color: dk_theme.Theme.gold, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _newRecruitCard(AppLocalizations l, dynamic definition) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          if (dk_theme.DreamkeeperArt.hasArt(definition.name as String))
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: definition.rarity.primaryColor, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.name as String), fit: BoxFit.cover),
            )
          else
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(shape: BoxShape.circle, color: definition.rarity.primaryColor.withValues(alpha: 0.35)),
              alignment: Alignment.center,
              child: Icon(sfSymbol(definition.symbol as String), color: Colors.white, size: 22),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.brNewRecruit, style: const TextStyle(color: Colors.white, fontSize: 11)),
                Text(definition.name as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: _offersNextBattle
          ? Row(
              children: [
                Expanded(
                  child: dk_theme.PrimaryButton(tint: Colors.grey, onPressed: _goDreamHaven, child: Text(l.navDreamHaven)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: dk_theme.PrimaryButton(tint: dk_theme.Theme.violet, onPressed: _goNextBattle, child: Text(l.brNextBattle)),
                ),
              ],
            )
          : dk_theme.PrimaryButton(
              tint: _isVictory ? dk_theme.Theme.violet : Colors.grey,
              onPressed: _goDreamHaven,
              child: Text(_isVictory ? l.brReturnToDreamHaven : l.commonContinue),
            ),
    );
  }
}

/// A simpler, Ticker-free replacement for Swift's `StaggeredEntrance`
/// ViewModifier — flips a local `_visible` flag after `90ms * index` inside
/// `initState`, then drives the reveal with implicit animations rather than
/// a manually-managed `AnimationController`.
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

/// Animates a reward count from 0 up to `value` over ~0.6s, starting after a
/// short delay — a `TweenAnimationBuilder`-based stand-in for Swift's
/// `.contentTransition(.numericText())` + `.delay(0.2)`.
class _CountUpRow extends StatelessWidget {
  final String icon;
  final Color tint;
  final String label;
  final int value;

  const _CountUpRow({required this.icon, required this.tint, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(sfSymbol(icon), color: tint, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13))),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: value),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          builder: (context, v, _) => Text('+$v', style: TextStyle(color: tint, fontWeight: FontWeight.bold, fontSize: 15)),
        ),
      ],
    );
  }
}
