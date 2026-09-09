import 'dart:async';

import 'package:flutter/material.dart';

import '../../platform/platform_service.dart';
import '../../progression/offline_rewards.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

/// The Training Garden building's collect sheet — accrues EXP for the
/// deployed team while away, and may trigger level-ups on collect. Mirrors
/// `TrainingGardenSheet` (UI/Buildings/TrainingGardenSheet.swift) exactly.
class TrainingGardenSheet extends StatefulWidget {
  final GameState gameState;
  const TrainingGardenSheet({super.key, required this.gameState});

  @override
  State<TrainingGardenSheet> createState() => _TrainingGardenSheetState();
}

class _TrainingGardenSheetState extends State<TrainingGardenSheet> {
  Timer? _ticker;
  TrainingResult? _lastResult;
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _collect() {
    final result = widget.gameState.collectTrainingGarden();
    if (result == null) return;
    setState(() {
      _lastResult = result;
      _showConfirmation = true;
    });
    widget.gameState.playHaptic(HapticStyle.levelUp);
    final delay = result.levelUps.isEmpty ? 900 : 1600;
    Timer(Duration(milliseconds: delay), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    final pending = state.pendingTrainingGardenReward;
    final result = _lastResult;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(gradient: dk_theme.Theme.background),
      child: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _header(),
                const SizedBox(height: 14),
                _gardenCard(state, pending),
                if (result != null && result.levelUps.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _levelUpsCard(result.levelUps),
                ],
                const SizedBox(height: 14),
                _collectButton(state, pending),
              ],
            ),
            if (_showConfirmation && result != null)
              dk_theme.CollectConfirmation(text: '+${result.expGranted} EXP', tint: dk_theme.Theme.softBlue),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        const Text('Training Garden', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          "Grants ${OfflineRewards.expPerMinute} EXP/min to your deployed team while you're away · caps after 8h",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
        ),
      ],
    );
  }

  Widget _gardenCard(GameState state, int pending) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: dk_theme.Theme.softBlue.withValues(alpha: 0.5), shape: BoxShape.circle),
              ),
              Icon(sfSymbol('leaf.arrow.circlepath'), size: 32, color: dk_theme.Theme.softBlue),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('+$pending EXP', style: const TextStyle(color: dk_theme.Theme.softBlue, fontSize: 26, fontWeight: FontWeight.w900)),
                Text(
                  state.deployedTeam.isEmpty ? 'Deploy a team to put the garden to work.' : 'Ready for your deployed team',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelUpsCard(List<LevelUpSummary> levelUps) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Level Up!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          for (final levelUp in levelUps)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Expanded(child: Text(levelUp.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                  Text('Lv ${levelUp.oldLevel} → Lv ${levelUp.newLevel}', style: const TextStyle(color: dk_theme.Theme.gold, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _collectButton(GameState state, int pending) {
    return SizedBox(
      width: double.infinity,
      child: dk_theme.PrimaryButton(
        onPressed: pending <= 0 || state.deployedTeam.isEmpty || _showConfirmation ? null : _collect,
        tint: dk_theme.Theme.softBlue,
        child: const Text('Collect'),
      ),
    );
  }
}
