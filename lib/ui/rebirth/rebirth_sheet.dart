import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../progression/rebirth_system.dart';
import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

/// Prestige / Rebirth ("Wiedergeburt") sheet — reset the Endless Trial tower
/// for permanent Soul Point upgrades. A Flutter-only screen; there is no
/// Swift-original counterpart. Shown via `showModalBottomSheet`, so it drives
/// its own `AnimatedBuilder` off `gameState` the same way `MissionsSheet`
/// does, otherwise a purchase made in here wouldn't redraw the sheet.
class RebirthSheet extends StatelessWidget {
  final GameState gameState;
  const RebirthSheet({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 12),
              Text(l.rebirthTitle, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  l.rebirthBlurb,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                  children: [
                    _balanceCard(l),
                    const SizedBox(height: 12),
                    _rebirthActionCard(context, l),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(sfSymbol('sparkles'), size: 16, color: Colors.white.withValues(alpha: 0.85)),
                        const SizedBox(width: 8),
                        Text(
                          l.rebirthUpgradesTitle,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final u in SoulUpgrade.values) ...[
                      _UpgradeRow(
                        gameState: gameState,
                        upgrade: u,
                        onBuy: () {
                          if (gameState.buySoulUpgrade(u)) gameState.playHaptic(HapticStyle.levelUp);
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _balanceCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: dk_theme.Theme.violet.withValues(alpha: 0.25), shape: BoxShape.circle),
            child: Icon(sfSymbol('flame.fill'), size: 20, color: dk_theme.Theme.violet),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${gameState.soulPoints}',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(l.rebirthSoulPointsLabel,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
              ],
            ),
          ),
          Text(
            l.rebirthCountLabel(gameState.rebirthCount),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _rebirthActionCard(BuildContext context, AppLocalizations l) {
    final canRebirth = gameState.canRebirth;
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (canRebirth) ...[
            Text(
              l.rebirthGainPreview(gameState.pendingRebirthSoulPoints),
              style: TextStyle(color: dk_theme.Theme.gold, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              l.rebirthResetWarning,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _confirmRebirth(context, l),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: dk_theme.Theme.gold.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(l.rebirthButton,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ] else
            Row(
              children: [
                Icon(sfSymbol('lock.fill'), size: 16, color: dk_theme.Theme.gold.withValues(alpha: 0.7)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.rebirthRequirementNotMet(RebirthSystem.rebirthFloorRequirement),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _confirmRebirth(BuildContext context, AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: Text(l.rebirthConfirmTitle),
          content: Text(l.rebirthResetWarning),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l.commonCancel)),
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l.rebirthButton)),
          ],
        ),
      ),
    );
    if (confirmed == true && gameState.performRebirth()) {
      gameState.playHaptic(HapticStyle.levelUp);
    }
  }
}

class _UpgradeRow extends StatelessWidget {
  final GameState gameState;
  final SoulUpgrade upgrade;
  final VoidCallback onBuy;
  const _UpgradeRow({required this.gameState, required this.upgrade, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rank = gameState.soulUpgradeRank(upgrade);
    final maxRank = RebirthSystem.maxRank(upgrade);
    final isMaxed = rank >= maxRank;
    final nextCost = isMaxed ? 0 : RebirthSystem.costForRank(upgrade, rank + 1);
    final canAfford = !isMaxed && gameState.soulPoints >= nextCost;

    return dk_theme.GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(sfSymbol(upgrade.icon), size: 20, color: dk_theme.Theme.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(upgrade.displayName,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(upgrade.detail,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
                const SizedBox(height: 4),
                Text(l.rebirthUpgradeRank(rank, maxRank),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isMaxed)
            Text(l.rebirthMaxed, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600))
          else
            Opacity(
              opacity: canAfford ? 1 : 0.4,
              child: GestureDetector(
                onTap: canAfford ? onBuy : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: dk_theme.Theme.gold.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(l.rebirthUpgradeCost(nextCost),
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
