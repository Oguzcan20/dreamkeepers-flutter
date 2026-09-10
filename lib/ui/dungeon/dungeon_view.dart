// The Dungeon hub. A Flutter-only screen with no Swift-original counterpart.
// Lists the three dungeons; each is a 3-wave run (two mobs + a boss, fought
// back-to-back with no heal between waves) costing one Dungeon Key. First
// clears pay a big fixed reward (gold + Dream Gems + a guaranteed high-rarity
// item); later runs pay a smaller repeatable farm reward.

import 'package:flutter/material.dart';

import '../../combat/dungeon_system.dart';
import '../../l10n/l10n.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

class DungeonView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;
  final ValueChanged<DungeonId> onFight;

  const DungeonView({super.key, required this.gameState, required this.onNavigate, required this.onFight});

  @override
  State<DungeonView> createState() => _DungeonViewState();
}

class _DungeonViewState extends State<DungeonView> {
  bool _appeared = false;

  GameState get _gameState => widget.gameState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  void _attemptFight(DungeonId id) {
    final l = AppLocalizations.of(context);
    if (_gameState.deployedTeam.isEmpty) {
      _showAlert(l.arenaNoTeamTitle, l.arenaNoTeamBody);
      return;
    }
    if (_gameState.dungeonKeysRemainingToday <= 0) {
      _showAlert(l.dungeonNoKeysTitle, l.dungeonNoKeysBody);
      return;
    }
    widget.onFight(id);
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
    return Stack(
      children: [
        const dk_theme.AmbientBackground(topTint: dk_theme.Theme.violet, bottomTint: dk_theme.Theme.softBlue),
        SafeArea(
          child: AnimatedBuilder(
            animation: _gameState,
            builder: (context, _) => AnimatedOpacity(
              opacity: _appeared ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: Column(
                children: [
                  _header(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: _keysCard(),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 76),
                      children: [
                        for (final id in _gameState.dungeons) ...[
                          _DungeonCard(
                            gameState: _gameState,
                            dungeon: id,
                            onFight: () => _attemptFight(id),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    final l = AppLocalizations.of(context);
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
          Text(l.navDungeons, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          const SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }

  Widget _keysCard() {
    final l = AppLocalizations.of(context);
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: dk_theme.Theme.softBlue.withValues(alpha: 0.22), shape: BoxShape.circle),
            child: Icon(sfSymbol('key.fill'), size: 18, color: dk_theme.Theme.softBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.dungeonKeysTitle, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(l.dungeonKeysBlurb, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${_gameState.dungeonKeysRemainingToday}/${_gameState.maxDungeonKeysPerDay}',
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _DungeonCard extends StatelessWidget {
  final GameState gameState;
  final DungeonId dungeon;
  final VoidCallback onFight;

  const _DungeonCard({required this.gameState, required this.dungeon, required this.onFight});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cleared = gameState.isDungeonCleared(dungeon);
    final rarity = DungeonSystem.firstClearRarity(dungeon);
    final canFight = gameState.deployedTeam.isNotEmpty && gameState.dungeonKeysRemainingToday > 0;

    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: dk_theme.Theme.violet.withValues(alpha: 0.22), shape: BoxShape.circle),
                child: Icon(sfSymbol(DungeonSystem.icon(dungeon)), size: 18, color: dk_theme.Theme.violet),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(DungeonSystem.displayName(dungeon),
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (cleared) ...[
                          const SizedBox(width: 6),
                          Icon(sfSymbol('checkmark.seal.fill'), size: 14, color: dk_theme.Theme.gold),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(l.dungeonRecommendedLevel(DungeonSystem.recommendedLevel(dungeon)),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(DungeonSystem.blurb(dungeon), style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            children: [
              _rewardChip('circle.hexagongrid.fill', dk_theme.Theme.gold,
                  '${cleared ? DungeonSystem.repeatGold(dungeon) : DungeonSystem.firstClearGold(dungeon)}'),
              const SizedBox(width: 8),
              if (!cleared && DungeonSystem.firstClearGems(dungeon) > 0)
                _rewardChip('sparkles', dk_theme.Theme.violet, '${DungeonSystem.firstClearGems(dungeon)}'),
              if (!cleared && DungeonSystem.firstClearGems(dungeon) > 0) const SizedBox(width: 8),
              _rewardChip('shippingbox.fill', rarity.primaryColor, cleared ? l.dungeonRewardItem : rarity.displayName),
            ],
          ),
          const SizedBox(height: 12),
          Opacity(
            opacity: canFight ? 1 : 0.4,
            child: dk_theme.PrimaryButton(
              tint: dk_theme.Theme.violet,
              onPressed: canFight ? onFight : null,
              child: Text(cleared ? l.dungeonFarmRun : l.dungeonEnter),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rewardChip(String icon, Color tint, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: tint.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(sfSymbol(icon), size: 11, color: tint),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: tint, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
