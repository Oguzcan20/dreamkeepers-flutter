import 'package:flutter/material.dart';

import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

/// Daily/weekly mission tracker sheet. Mirrors `MissionsSheet`
/// (UI/Buildings/MissionsSheet.swift) exactly.
class MissionsSheet extends StatelessWidget {
  final GameState gameState;
  const MissionsSheet({super.key, required this.gameState});

  List<MissionStatus> get _dailyMissions => gameState.dailyMissions.where((m) => !m.definition.isPremiumOnly).toList();
  List<MissionStatus> get _bonusMissions => gameState.dailyMissions.where((m) => m.definition.isPremiumOnly).toList();

  @override
  Widget build(BuildContext context) {
    // `MissionsSheet` is shown via `showModalBottomSheet`, outside the
    // widget subtree `context.watch<GameState>()` normally covers, so claims
    // made in here (which call `GameState.persist()` -> `notifyListeners()`)
    // need their own listener to actually redraw the sheet's claim buttons.
    return AnimatedBuilder(
      animation: gameState,
      builder: (context, _) => _buildSheet(context),
    );
  }

  Widget _buildSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            gradient: dk_theme.Theme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(width: 36, height: 5, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 12),
              const Text('Missions', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'Daily resets every day · Weekly resets every Monday',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    _sectionHeader('Daily Missions', 'sun.max.fill'),
                    const SizedBox(height: 10),
                    _missionGrid(_dailyMissions),
                    const SizedBox(height: 18),
                    _sectionHeader('Battle Pass Bonus', 'rosette'),
                    const SizedBox(height: 10),
                    _missionGrid(_bonusMissions),
                    const SizedBox(height: 18),
                    _sectionHeader('Weekly Challenge', 'calendar'),
                    const SizedBox(height: 10),
                    if (gameState.battlePassPremiumUnlocked) _weeklyMissionGrid() else _weeklyLockedCard(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title, String icon) {
    return Row(
      children: [
        Icon(sfSymbol(icon), size: 16, color: Colors.white.withValues(alpha: 0.85)),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _missionGrid(List<MissionStatus> missions) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        for (final status in missions)
          _MissionRow(
            status: status,
            onClaim: () {
              if (gameState.claimMission(status.id)) gameState.playHaptic(HapticStyle.levelUp);
            },
          ),
      ],
    );
  }

  Widget _weeklyMissionGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        for (final status in gameState.weeklyMissions)
          _WeeklyMissionRow(
            status: status,
            onClaim: () {
              if (gameState.claimWeeklyMission(status.id)) gameState.playHaptic(HapticStyle.levelUp);
            },
          ),
      ],
    );
  }

  Widget _weeklyLockedCard() {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Icon(sfSymbol('lock.fill'), color: dk_theme.Theme.gold.withValues(alpha: 0.7)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Unlock Battle Pass Premium to access harder weekly challenges with bigger rewards.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionRow extends StatelessWidget {
  final MissionStatus status;
  final VoidCallback onClaim;
  const _MissionRow({required this.status, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: status.isLocked ? 0.6 : 1,
      child: dk_theme.GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              status.isLocked ? sfSymbol('lock.fill') : sfSymbol(status.definition.icon),
              size: 20,
              color: status.isLocked ? Colors.white.withValues(alpha: 0.3) : (status.isComplete ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.4)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    status.definition.title,
                    style: TextStyle(color: status.isLocked ? Colors.white.withValues(alpha: 0.4) : Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  if (status.isLocked)
                    Text('Requires Premium', style: TextStyle(color: dk_theme.Theme.gold.withValues(alpha: 0.7), fontSize: 10))
                  else
                    Text('${status.progress}/${status.definition.target}', style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (status.definition.goldReward > 0) ...[
                        Icon(sfSymbol('circle.hexagongrid.fill'), size: 10, color: dk_theme.Theme.gold),
                        const SizedBox(width: 2),
                        Text('${status.definition.goldReward}', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 10)),
                        const SizedBox(width: 8),
                      ],
                      if (status.definition.gemReward > 0) ...[
                        Icon(sfSymbol('sparkles'), size: 10, color: dk_theme.Theme.violet),
                        const SizedBox(width: 2),
                        Text('${status.definition.gemReward}', style: TextStyle(color: dk_theme.Theme.violet, fontSize: 10)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            _trailing(),
          ],
        ),
      ),
    );
  }

  Widget _trailing() {
    if (status.isLocked) return const SizedBox.shrink();
    if (status.isClaimed) {
      return Icon(sfSymbol('checkmark.circle.fill'), color: dk_theme.Theme.gold, size: 22, semanticLabel: 'Claimed');
    }
    if (status.isComplete) {
      return GestureDetector(
        onTap: onClaim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(999)),
          child: const Text('Claim', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      );
    }
    return SizedBox(
      width: 48,
      child: LinearProgressIndicator(
        value: status.definition.target > 0 ? status.progress / status.definition.target : 0,
        color: dk_theme.Theme.softBlue,
        backgroundColor: Colors.white.withValues(alpha: 0.12),
      ),
    );
  }
}

class _WeeklyMissionRow extends StatelessWidget {
  final WeeklyMissionStatus status;
  final VoidCallback onClaim;
  const _WeeklyMissionRow({required this.status, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return dk_theme.GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(sfSymbol(status.definition.icon), size: 20, color: status.isComplete ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.4)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(status.definition.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${status.progress}/${status.definition.target}', style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (status.definition.goldReward > 0) ...[
                      Icon(sfSymbol('circle.hexagongrid.fill'), size: 10, color: dk_theme.Theme.gold),
                      const SizedBox(width: 2),
                      Text('${status.definition.goldReward}', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 10)),
                      const SizedBox(width: 8),
                    ],
                    if (status.definition.gemReward > 0) ...[
                      Icon(sfSymbol('sparkles'), size: 10, color: dk_theme.Theme.violet),
                      const SizedBox(width: 2),
                      Text('${status.definition.gemReward}', style: TextStyle(color: dk_theme.Theme.violet, fontSize: 10)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (status.isClaimed)
            Icon(sfSymbol('checkmark.circle.fill'), color: dk_theme.Theme.gold, size: 22, semanticLabel: 'Claimed')
          else if (status.isComplete)
            GestureDetector(
              onTap: onClaim,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(999)),
                child: const Text('Claim', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            )
          else
            SizedBox(
              width: 48,
              child: LinearProgressIndicator(
                value: status.definition.target > 0 ? status.progress / status.definition.target : 0,
                color: dk_theme.Theme.softBlue,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
              ),
            ),
        ],
      ),
    );
  }
}
