import 'dart:async';

import 'package:flutter/material.dart';

import '../../platform/platform_service.dart';
import '../../progression/offline_rewards.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

/// The Gold Fountain building's collect sheet — accrues gold passively (see
/// `OfflineRewards`) and lets the player collect it here. Mirrors
/// `GoldFountainSheet` (UI/Buildings/GoldFountainSheet.swift) exactly. The
/// pending amount grows every second it's open, so a `Timer.periodic` here
/// stands in for Swift's `TimelineView(.periodic(from:by:))`.
class GoldFountainSheet extends StatefulWidget {
  final GameState gameState;
  const GoldFountainSheet({super.key, required this.gameState});

  @override
  State<GoldFountainSheet> createState() => _GoldFountainSheetState();
}

class _GoldFountainSheetState extends State<GoldFountainSheet> {
  Timer? _ticker;
  int? _justCollected;

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
    final amount = widget.gameState.collectGoldFountain();
    if (amount <= 0) return;
    widget.gameState.playHaptic(HapticStyle.levelUp);
    setState(() => _justCollected = amount);
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pending = widget.gameState.pendingGoldFountainReward;
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
                _fountainCard(pending),
                const SizedBox(height: 14),
                _collectButton(pending),
              ],
            ),
            if (_justCollected != null) dk_theme.CollectConfirmation(text: '+$_justCollected Gold', tint: dk_theme.Theme.gold),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        const Text('Gold Fountain', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          "Generates ${OfflineRewards.goldPerMinute} gold/min while you're away · caps after 8h",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
        ),
      ],
    );
  }

  Widget _fountainCard(int pending) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.5), shape: BoxShape.circle),
              ),
              Icon(sfSymbol('circle.hexagongrid.fill'), size: 32, color: dk_theme.Theme.gold),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('+$pending', style: const TextStyle(color: dk_theme.Theme.gold, fontSize: 26, fontWeight: FontWeight.w900)),
                Text(
                  _justCollected != null ? 'Collected!' : 'Gold ready to collect',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _collectButton(int pending) {
    return SizedBox(
      width: double.infinity,
      child: dk_theme.PrimaryButton(
        onPressed: pending <= 0 || _justCollected != null ? null : _collect,
        tint: dk_theme.Theme.gold,
        child: const Text('Collect'),
      ),
    );
  }
}
