import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../progression/world_boss_system.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

class _Bracket {
  final int rank;
  final String Function(AppLocalizations) label;
  final WorldBossReward reward;
  const _Bracket({required this.rank, required this.label, required this.reward});
}

/// Read-only reward-table sheet, opened from the header gift button in
/// `WorldBossView`. Mirrors `WorldBossRewardsSheet` (Swift) exactly — same
/// five brackets, same footer note.
class WorldBossRewardsSheet extends StatelessWidget {
  const WorldBossRewardsSheet({super.key});

  List<_Bracket> _brackets(AppLocalizations l) {
    const ranks = [1, 2, 11, 51, 101];
    final labels = <int, String Function(AppLocalizations)>{
      1: (l) => l.worldBossRewardsRank1,
      2: (l) => l.worldBossRewardsRank2to10,
      11: (l) => l.worldBossRewardsRank11to50,
      51: (l) => l.worldBossRewardsRank51to100,
      101: (l) => l.worldBossRewardsRank101to200,
    };
    return ranks
        .map((rank) {
          final reward = WorldBossSystem.reward(rank);
          if (reward == null) return null;
          return _Bracket(rank: rank, label: labels[rank]!, reward: reward);
        })
        .whereType<_Bracket>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(gradient: dk_theme.Theme.background),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 14),
              Text(l.worldBossRewardsTitle, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  l.worldBossRewardsSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Column(
                    children: [
                      for (final bracket in _brackets(l)) Padding(padding: const EdgeInsets.only(top: 10), child: _rewardRow(l, bracket)),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          l.worldBossRewardsNoneAfterRank200,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rewardRow(AppLocalizations l, _Bracket bracket) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Text(bracket.label(l), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const Spacer(),
          Icon(sfSymbol('circle.hexagongrid.fill'), size: 14, color: dk_theme.Theme.gold),
          const SizedBox(width: 4),
          Text(
            '${bracket.reward.gold}',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()]),
          ),
          const SizedBox(width: 14),
          Icon(sfSymbol('star.fill'), size: 14, color: dk_theme.Theme.violet),
          const SizedBox(width: 4),
          Text(
            '${bracket.reward.gems}',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ],
      ),
    );
  }
}
