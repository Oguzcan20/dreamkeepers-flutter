import 'package:flutter/material.dart';

import '../../progression/achievement_system.dart';
import '../../progression/level_system.dart';
import '../../data/world_catalog.dart';
import '../../state/game_state.dart';
import '../../theme/adaptive_scale.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';
import 'achievements_sheet.dart';

/// Player level + lifetime-stats hub. Mirrors UI/Profile/ProfileView.swift —
/// a fixed, non-scrolling two-card layout (unlike most other ported
/// screens) scaled to fit via `AdaptiveScale`, same technique
/// `DreamHavenView` uses for its own hub layout.
class ProfileView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;
  const ProfileView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int get _expToNext => LevelSystem.expToNextLevel(widget.gameState.save.playerLevel);
  bool get _isMaxLevel => widget.gameState.save.playerLevel >= LevelSystem.maxLevel;
  int get _stagesCleared {
    final cleared = widget.gameState.save.currentStage - 1;
    return cleared < WorldCatalog.totalStages ? cleared : WorldCatalog.totalStages;
  }

  void _openAchievements() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => AchievementsSheet(gameState: widget.gameState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const dk_theme.AmbientBackground(topTint: dk_theme.Theme.gold, bottomTint: dk_theme.Theme.softBlue),
        SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: AnimatedBuilder(
                  animation: widget.gameState,
                  builder: (context, _) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _levelCard()),
                        const SizedBox(width: 16),
                        Expanded(child: _statsGrid()),
                      ],
                    ).adaptiveScale(reference: const Size(600, 220), maxScale: 1.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Semantics(
            label: 'Back',
            button: true,
            child: GestureDetector(
              onTap: () => widget.onNavigate(const DreamHavenRoute()),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: const Icon(Icons.chevron_left, color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
          const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          const SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }

  Widget _levelCard() {
    return dk_theme.GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.25), shape: BoxShape.circle),
              ),
              Icon(sfSymbol('person.fill'), size: 28, color: Colors.white),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Player Level ${widget.gameState.save.playerLevel}',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          if (_isMaxLevel)
            Text('Max level reached', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12))
          else
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    height: 10,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final fraction = (widget.gameState.save.playerExp / _expToNext).clamp(0.0, 1.0);
                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(color: Colors.white.withValues(alpha: 0.12)),
                            Container(width: constraints.maxWidth * fraction, color: dk_theme.Theme.gold),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.gameState.save.playerExp} / $_expToNext EXP to next level',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    final gameState = widget.gameState;
    return dk_theme.GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Journey So Far', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ProfileStatColumn(
                  icon: 'sparkles',
                  label: 'Dreamkeepers',
                  value: '${gameState.ownedSpeciesCount}/${gameState.catalog.definitions.length}',
                ),
              ),
              Expanded(
                child: _ProfileStatColumn(
                  icon: 'map.fill',
                  label: 'Stages Cleared',
                  value: '$_stagesCleared/${WorldCatalog.totalStages}',
                ),
              ),
              Expanded(
                child: _ProfileStatColumn(icon: 'circle.hexagongrid.fill', label: 'Gold', value: '${gameState.save.gold}'),
              ),
              Expanded(
                child: _ProfileStatColumn(icon: 'star.fill', label: 'Dream Gems', value: '${gameState.save.dreamGems}'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _openAchievements,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(sfSymbol('rosette'), size: 14, color: dk_theme.Theme.gold),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Achievements',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${gameState.save.unlockedAchievementIDs.length}/${AchievementSystem.all.length}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  Icon(sfSymbol('chevron.right'), size: 11, color: Colors.white.withValues(alpha: 0.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatColumn extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _ProfileStatColumn({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(sfSymbol(icon), size: 14, color: dk_theme.Theme.softBlue),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 9),
        ),
      ],
    );
  }
}
