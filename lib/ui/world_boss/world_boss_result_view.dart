// World Boss attempt result — damage-dealt framing rather than
// Victory/Defeat, since a single attack on the boss is never really "won"
// or "lost." Mirrors `WorldBossResultView` (UI/WorldBoss/WorldBossResultView.swift)
// and reuses `ArenaResultView`'s staggered-card layout shape at the
// hero-moment scale `BattleResultView` uses.

import 'package:flutter/material.dart';

import '../../combat/battle_engine.dart';
import '../../l10n/l10n.dart';
import '../../progression/world_boss_system.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

class WorldBossResultView extends StatefulWidget {
  final WorldBossBattleResultSummary summary;
  final ValueChanged<AppRoute> onNavigate;

  const WorldBossResultView({super.key, required this.summary, required this.onNavigate});

  @override
  State<WorldBossResultView> createState() => _WorldBossResultViewState();
}

class _WorldBossResultViewState extends State<WorldBossResultView> {
  bool _appeared = false;

  WorldBossBattleResultSummary get _summary => widget.summary;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  void _goAttackAgain() => widget.onNavigate(const WorldBossBattleRoute());
  void _goDreamHaven() => widget.onNavigate(const DreamHavenRoute());

  String _headline(AppLocalizations l) {
    switch (_summary.outcome) {
      case BattleOutcome.victory:
        return l.worldBossVictoryTitle;
      case BattleOutcome.timeout:
        return l.blTimesUp;
      case BattleOutcome.defeat:
        return l.worldBossDefeatTitle;
    }
  }

  Color get _tint {
    switch (_summary.outcome) {
      case BattleOutcome.victory:
        return dk_theme.Theme.gold;
      case BattleOutcome.timeout:
        return dk_theme.Theme.violet;
      case BattleOutcome.defeat:
        return Colors.red;
    }
  }

  String _subheadline(AppLocalizations l) {
    switch (_summary.outcome) {
      case BattleOutcome.victory:
        return l.worldBossVictorySubtitle;
      case BattleOutcome.timeout:
        return l.worldBossTimeoutSubtitle;
      case BattleOutcome.defeat:
        return l.worldBossDefeatSubtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tint = _tint;
    return Stack(
      children: [
        dk_theme.AmbientBackground(topTint: tint, bottomTint: dk_theme.Theme.violet),
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              AnimatedScale(
                scale: _appeared ? 1 : 0.85,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _appeared ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: Column(
                    children: [
                      dk_theme.MonsterArt.hasArt(WorldBossSystem.bossName)
                          ? Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(dk_theme.MonsterArt.assetName(WorldBossSystem.bossName)),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(color: tint.withValues(alpha: 0.7), width: 2),
                                boxShadow: [BoxShadow(color: tint.withValues(alpha: 0.6), blurRadius: 16)],
                              ),
                            )
                          : Icon(
                              sfSymbol('eye.trianglebadge.exclamationmark.fill'),
                              size: 44,
                              color: tint,
                              shadows: [Shadow(color: tint.withValues(alpha: 0.6), blurRadius: 16)],
                            ),
                      const SizedBox(height: 8),
                      Text(
                        _headline(l),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _subheadline(l),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _appeared ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: dk_theme.GlassCard(
                    child: Column(
                      children: [
                        _resultRow(l.worldBossDamageThisAttempt, '${_summary.damageDealtThisAttempt}'),
                        Divider(color: Colors.white.withValues(alpha: 0.1), height: 24),
                        _resultRow(l.worldBossTotalDamageThisWeek, '${_summary.totalDamageThisWeek}'),
                        Divider(color: Colors.white.withValues(alpha: 0.1), height: 24),
                        _resultRow(
                          l.worldBossAttacksRemainingLabel,
                          '${_summary.attacksRemaining}/${WorldBossSystem.attacksPerWeek}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _appeared ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                  child: Column(
                    children: [
                      if (_summary.attacksRemaining > 0) ...[
                        dk_theme.PrimaryButton(tint: Colors.red, onPressed: _goAttackAgain, child: Text(l.worldBossAttackAgain)),
                        const SizedBox(height: 12),
                      ],
                      GestureDetector(
                        onTap: _goDreamHaven,
                        child: Text(
                          l.navDreamHaven,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _resultRow(String title, String value) {
    return Row(
      children: [
        Expanded(child: Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14))),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
