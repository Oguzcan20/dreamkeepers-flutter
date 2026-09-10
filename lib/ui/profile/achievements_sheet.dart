import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../progression/achievement_system.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

/// Browsable list of every `AchievementSystem` milestone, locked or not —
/// the toast in `RootView` only ever shows a freshly-unlocked one in
/// passing, so this is the one place a player can see the full set and
/// what's left to chase. Presented via `showModalBottomSheet` from
/// `ProfileView`, same pattern as `MissionsSheet`. Mirrors
/// UI/Profile/AchievementsSheet.swift.
class AchievementsSheet extends StatelessWidget {
  final GameState gameState;
  const AchievementsSheet({super.key, required this.gameState});

  int get _unlockedCount => gameState.save.unlockedAchievementIDs.length;

  @override
  Widget build(BuildContext context) {
    // Shown outside the subtree any ambient `context.watch<GameState>()`
    // covers — same rationale as `MissionsSheet` — so it needs its own
    // listener even though nothing in here mutates state itself (a fresh
    // unlock could land while the sheet is open).
    return AnimatedBuilder(
      animation: gameState,
      builder: (context, _) => _buildSheet(context),
    );
  }

  Widget _buildSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
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
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 12),
              Text(l.achievementsSheetTitle, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                l.achievementsUnlockedCount(_unlockedCount, AchievementSystem.all.length),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 132,
                  ),
                  itemCount: AchievementSystem.all.length,
                  itemBuilder: (context, index) {
                    final achievement = AchievementSystem.all[index];
                    return _AchievementCard(
                      achievement: achievement,
                      isUnlocked: gameState.save.unlockedAchievementIDs.contains(achievement.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  const _AchievementCard({required this.achievement, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1 : 0.75,
      child: dk_theme.GlassCard(
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (isUnlocked ? dk_theme.Theme.gold : Colors.white).withValues(alpha: isUnlocked ? 0.22 : 0.06),
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  sfSymbol(isUnlocked ? achievement.icon : 'lock.fill'),
                  size: 16,
                  color: isUnlocked ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    achievement.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.45),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    achievement.detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withValues(alpha: isUnlocked ? 0.6 : 0.35), fontSize: 11),
                  ),
                ],
              ),
            ),
            if (isUnlocked)
              Semantics(
                container: true,
                label: 'Unlocked',
                child: Icon(sfSymbol('checkmark.circle.fill'), size: 16, color: dk_theme.Theme.gold),
              ),
          ],
        ),
      ),
    );
  }
}
