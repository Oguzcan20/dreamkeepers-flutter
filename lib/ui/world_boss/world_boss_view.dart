// World Boss hub ("Voidmaw, the Devouring Dream") — status/countdown,
// attacks remaining, the Attack button, and the live weekly leaderboard.
// Mirrors `WorldBossView` (UI/WorldBoss/WorldBossView.swift): one shared
// status card instead of a scrollable list, same shape as `DungeonView`'s
// hub at boss-fight scale.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../progression/world_boss_system.dart';
import '../../state/game_state.dart';
import '../../state/world_boss_leaderboard_service.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';
import 'world_boss_rewards_sheet.dart';

class WorldBossView extends StatefulWidget {
  final GameState gameState;
  final WorldBossLeaderboardService leaderboardService;
  final ValueChanged<AppRoute> onNavigate;
  final VoidCallback onFight;

  const WorldBossView({
    super.key,
    required this.gameState,
    required this.leaderboardService,
    required this.onNavigate,
    required this.onFight,
  });

  @override
  State<WorldBossView> createState() => _WorldBossViewState();
}

class _WorldBossViewState extends State<WorldBossView> {
  bool _appeared = false;
  bool get _hasBossArt => dk_theme.MonsterArt.hasArt(WorldBossSystem.bossName);
  // Ticked every second so the countdown actually counts down instead of
  // freezing at the value read on appear — Dart has no direct analog of
  // SwiftUI's `TimelineView(.periodic(...))`.
  DateTime _now = DateTime.now();
  Timer? _clockTimer;

  GameState get _gameState => widget.gameState;
  WorldBossLeaderboardService get _leaderboardService => widget.leaderboardService;

  String get _weekID => WorldBossSystem.weekID(_now);
  bool get _isActive => WorldBossSystem.isActive(_now);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
    widget.leaderboardService.listen(weekID: _weekID);
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _attemptFight() {
    final l = AppLocalizations.of(context);
    if (_gameState.deployedTeam.isEmpty) {
      _showAlert(l.worldBossNoTeamTitle, l.worldBossNoTeamMessage);
      return;
    }
    widget.onFight();
  }

  Future<void> _showAlert(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context).commonOk),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Stack(
      children: [
        const dk_theme.AmbientBackground(topTint: Colors.red, bottomTint: dk_theme.Theme.violet),
        SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_gameState, _leaderboardService]),
            builder: (context, _) => Column(
              children: [
                AnimatedOpacity(
                  opacity: _appeared ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: _header(l),
                ),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _appeared ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _statusCard(l),
                          if (_gameState.hasUnclaimedWorldBossReward) ...[
                            const SizedBox(height: 12),
                            _claimCard(l),
                          ],
                          const SizedBox(height: 12),
                          _leaderboardCard(l),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Semantics(
            label: l.commonBack,
            button: true,
            child: GestureDetector(
              onTap: () => widget.onNavigate(const DreamHavenRoute()),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: Icon(sfSymbol('chevron.left'), size: 16, color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
          Text(l.navWorldBoss, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          Semantics(
            label: l.worldBossRewardsTitle,
            button: true,
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withValues(alpha: 0.55),
                builder: (_) => const WorldBossRewardsSheet(),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: Icon(sfSymbol('gift.fill'), size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _hasBossArt ? null : Colors.red.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  image: _hasBossArt
                      ? DecorationImage(image: AssetImage(dk_theme.MonsterArt.assetName(WorldBossSystem.bossName)), fit: BoxFit.cover)
                      : null,
                  border: _hasBossArt ? Border.all(color: Colors.red.withValues(alpha: 0.7), width: 2) : null,
                  boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.6), blurRadius: 12)],
                ),
                child: _hasBossArt ? null : Icon(sfSymbol('eye.trianglebadge.exclamationmark.fill'), size: 22, color: Colors.red),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.worldBossName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                      _countdownText(l),
                      style: TextStyle(color: _isActive ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _statPill(l.worldBossAttacksLeftLabel, '${_gameState.worldBossAttacksRemaining}/${WorldBossSystem.attacksPerWeek}'),
              _statPill(l.worldBossDamageThisWeekLabel, '${_gameState.worldBossDamageDealtThisWeek}'),
            ],
          ),
          const SizedBox(height: 12),
          dk_theme.PrimaryButton(
            tint: Colors.red,
            onPressed: (!_isActive || _gameState.worldBossAttacksRemaining <= 0 || _gameState.deployedTeam.isEmpty)
                ? null
                : _attemptFight,
            child: Text(l.worldBossAttackButton),
          ),
        ],
      ),
    );
  }

  Widget _statPill(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _claimCard(AppLocalizations l) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: dk_theme.GlassCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: dk_theme.Theme.gold.withValues(alpha: 0.35),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.7), blurRadius: 12)],
              ),
              child: Icon(sfSymbol('gift.fill'), size: 20, color: dk_theme.Theme.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.worldBossClaimTitle, style: TextStyle(color: dk_theme.Theme.gold, fontWeight: FontWeight.bold, fontSize: 14)),
                  if (_leaderboardService.myRank != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      l.worldBossClaimRank(_leaderboardService.myRank!),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: dk_theme.PrimaryButton(
                tint: dk_theme.Theme.gold,
                // An unranked player (outside the leaderboard entirely) falls
                // through to a rank far past 200 — `claimWorldBossReward`
                // still marks the week claimed, it just pays nothing.
                onPressed: () => _gameState.claimWorldBossReward(_leaderboardService.myRank ?? 999999),
                child: Text(l.worldBossClaimButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leaderboardCard(AppLocalizations l) {
    final top = _leaderboardService.top.take(20).toList();
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l.worldBossLeaderboardTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const Spacer(),
              if (_leaderboardService.myRank != null)
                Text(
                  l.worldBossYourRank(_leaderboardService.myRank!),
                  style: TextStyle(color: dk_theme.Theme.gold, fontWeight: FontWeight.w600, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (!_leaderboardService.isConfigured)
            Text(l.worldBossLeaderboardUnavailable, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12))
          else if (top.isEmpty)
            Text(l.worldBossLeaderboardEmpty, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12))
          else
            Column(children: [for (var i = 0; i < top.length; i++) _leaderboardRow(l, i + 1, top[i])]),
        ],
      ),
    );
  }

  Widget _leaderboardRow(AppLocalizations l, int rank, WorldBossEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#$rank',
              style: TextStyle(color: rank <= 3 ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Text(l.worldBossLevelLabel(entry.playerLevel), style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
          const Spacer(),
          Text(
            '${entry.damage}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ],
      ),
    );
  }

  String _countdownText(AppLocalizations l) {
    final w = WorldBossSystem.window(_now);
    if (_now.isBefore(w.start)) {
      return l.worldBossAppearsIn(_format(w.start.difference(_now)));
    } else if (_now.isBefore(w.end)) {
      return l.worldBossEndsIn(_format(w.end.difference(_now)));
    } else {
      // `w.start` is the most recently *started* cycle (weekStart biases
      // backward through the whole dormant gap between last Sunday 19:00
      // and next Friday 19:00 — see `WorldBossSystem.weekStart`), so the
      // next appearance is always exactly 7 days after it. Re-deriving via
      // `window(_now + 1s)` looked equivalent but resolves to that same
      // already-closed window for the entire dormant week, not just the
      // instant before it flips — producing a negative interval that
      // `_format` clamped to "00m 00s".
      final nextStart = w.start.add(const Duration(days: 7));
      return l.worldBossNextBoss(_format(nextStart.difference(_now)));
    }
  }

  static String _format(Duration interval) {
    final totalSeconds = interval.inSeconds < 0 ? 0 : interval.inSeconds;
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (days > 0) return '${days}d ${hours.toString().padLeft(2, '0')}h';
    if (hours > 0) return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
    return '${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }
}
