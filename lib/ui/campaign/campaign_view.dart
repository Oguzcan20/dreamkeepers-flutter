import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../data/world_catalog.dart';
import '../../l10n/l10n.dart';
import '../../models/world.dart';
import '../../platform/platform_service.dart';
import '../../progression/energy_system.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// The campaign map — 30 worlds x 5 stages each. Mirrors `CampaignView`
/// (UI/Campaign/CampaignView.swift) exactly, including the blurred
/// `CampaignBanner` key-art image behind the header.
class CampaignView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const CampaignView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<CampaignView> createState() => _CampaignViewState();
}

class _CampaignViewState extends State<CampaignView> {
  bool _appeared = false;
  BattleResultSummary? _sweepResult;
  Timer? _sweepDismissTimer;

  GameState get _gameState => widget.gameState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  @override
  void dispose() {
    _sweepDismissTimer?.cancel();
    super.dispose();
  }

  /// Cleared, sweepable stages ask which path to take; everything else (the
  /// frontier stage, a stage still selected mid-attempt) fights directly.
  void _tapStage(int stage) {
    _gameState.playHaptic(HapticStyle.light);
    if (_gameState.canSweepStage(stage)) {
      _showStageChoiceDialog(stage);
    } else {
      _fight(stage);
    }
  }

  /// Both options cost the same Energy for a given stage (see
  /// `EnergySystem.stageCost`), so this is purely "watch it happen" vs.
  /// "skip straight to the payout".
  Future<void> _showStageChoiceDialog(int stage) async {
    final l = AppLocalizations.of(context);
    final cost = EnergySystem.stageCost(isBoss: stage % World.stagesPerWorld == 0);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: Text(l.campaignStageClearedTitle(stage)),
          content: Text(l.campaignStageClearedBody),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _fight(stage);
              },
              child: Text(l.campaignFightCost(cost)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _sweep(stage);
              },
              child: Text(l.campaignSweepCost(cost)),
            ),
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l.commonCancel)),
          ],
        ),
      ),
    );
  }

  /// Spends Energy and opens the Battle screen. Shows the insufficient-Energy
  /// dialog instead when the player can't afford the attempt.
  void _fight(int stage) {
    if (!_gameState.attemptStage(stage)) {
      _showInsufficientEnergyDialog(stage);
      return;
    }
    widget.onNavigate(const BattleRoute());
  }

  /// Instantly clears an already-cleared stage via `GameState.sweepStage`
  /// and flashes the payout as a brief toast instead of a full result
  /// screen — a sweep is deliberately lighter-weight than a played battle.
  void _sweep(int stage) {
    final result = _gameState.sweepStage(stage);
    if (result == null) {
      _showInsufficientEnergyDialog(stage);
      return;
    }
    _gameState.playHaptic(HapticStyle.success);
    _sweepDismissTimer?.cancel();
    setState(() => _sweepResult = result);
    _sweepDismissTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _sweepResult = null);
    });
  }

  Future<void> _showInsufficientEnergyDialog(int stage) async {
    final l = AppLocalizations.of(context);
    final cost = EnergySystem.stageCost(isBoss: stage % World.stagesPerWorld == 0);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: Text(l.campaignNotEnoughEnergyTitle),
          content: Text(l.campaignNotEnoughEnergyBody(cost, _gameState.energy, _gameState.maxEnergy)),
          actions: [
            if (_gameState.canRefillEnergyWithGems)
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _gameState.refillEnergyWithGems();
                  _gameState.playHaptic(HapticStyle.light);
                },
                child: Text(l.campaignRefillForGems(_gameState.nextEnergyRefillGemCost)),
              ),
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l.commonOk)),
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
        const dk_theme.AmbientBackground(topTint: dk_theme.Theme.violet, bottomTint: dk_theme.Theme.softBlue),
        AnimatedBuilder(
          animation: _gameState,
          builder: (context, _) => AnimatedOpacity(
            opacity: _appeared ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Column(
              children: [
                _header(l),
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      // Bottom pad clears the floating home button in the
                      // bottom-left corner (RootView only reserves ~56 of
                      // outer clearance now — see `_homeButtonClearance`).
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 76),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final world in WorldCatalog.worlds)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _WorldSection(world: world, gameState: _gameState, onTapStage: _tapStage),
                            ),
                          if (_gameState.isCampaignComplete)
                            dk_theme.GlassCard(
                              child: Text(
                                l.campaignComplete,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_sweepResult != null)
          Positioned(
            top: 74,
            left: 0,
            right: 0,
            child: IgnorePointer(child: Center(child: _SweepToast(result: _sweepResult!, l: l))),
          ),
      ],
    );
  }

  /// The banner image/gradient spans the full device width, edge to edge —
  /// only the row of buttons/text inside gets safe-area padding (via the
  /// inner `SafeArea`), so the sensor-housing safe zone on a landscape
  /// iPhone doesn't cut the bar short and leave a bare seam next to it.
  Widget _header(AppLocalizations l) {
    return Container(
      height: 64,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.14), width: 1)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(dk_theme.SingletonArt.campaignBanner, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [dk_theme.Theme.violet.withValues(alpha: 0.35), dk_theme.Theme.deepNavy.withValues(alpha: 0.85)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _iconButton(icon: 'chevron.left', label: l.commonBack, onTap: () => widget.onNavigate(const DreamHavenRoute())),
                  const Spacer(),
                  Text(l.navCampaign, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  _energyPill(l),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({required String icon, required String label, required VoidCallback onTap}) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: Icon(sfSymbol(icon), size: 16, color: Colors.white),
        ),
      ),
    );
  }

  /// Same Energy readout as the Dream Haven header, mirrored here so the
  /// player can see at a glance whether they can afford the next stage
  /// without backing out of Campaign.
  Widget _energyPill(AppLocalizations l) {
    return Semantics(
      label: l.campaignEnergySemantic(_gameState.energy, _gameState.maxEnergy),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol('bolt.fill'), size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              '${_gameState.energy}/${_gameState.maxEnergy}',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StageState { locked, cleared, frontier, selected }

class _WorldSection extends StatelessWidget {
  final World world;
  final GameState gameState;
  final ValueChanged<int> onTapStage;

  const _WorldSection({required this.world, required this.gameState, required this.onTapStage});

  _StageState _stateFor(int stage) {
    if (!gameState.isStageUnlocked(stage)) return _StageState.locked;
    if (stage == gameState.selectedStage) return _StageState.selected;
    if (stage < gameState.currentStage) return _StageState.cleared;
    return _StageState.frontier;
  }

  @override
  Widget build(BuildContext context) {
    final accent = world.accentColor;
    // Each card is backed by that world's own painted background (the same
    // art used cyclically across its "dreamed again" repeats, see
    // `WorldArt`), with an accent-tinted scrim so the map reads as thirty
    // distinct places rather than identical cards with different text.
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: accent.withValues(alpha: 0.4), width: 1.25),
        boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: Image.asset(dk_theme.WorldArt.assetName(world.id), fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent.withValues(alpha: 0.28), dk_theme.Theme.deepNavy.withValues(alpha: 0.82)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(world.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(world.description, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: accent.withValues(alpha: 0.25), shape: BoxShape.circle),
                      child: Icon(
                        sfSymbol(world.elementBias.isNotEmpty ? world.elementBias.first.symbol : 'sparkles'),
                        size: 18,
                        color: accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var stage = world.firstStage; stage <= world.lastStage; stage++)
                      _StageNode(
                        stage: stage,
                        isBoss: stage == world.lastStage,
                        accent: accent,
                        state: _stateFor(stage),
                        isSweepable: gameState.canSweepStage(stage),
                        onTap: () => onTapStage(stage),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageNode extends StatefulWidget {
  final int stage;
  final bool isBoss;
  final Color accent;
  final _StageState state;
  /// True only for an already-cleared stage — shows the small bolt badge
  /// hinting that tapping it now offers a Sweep option, not just a replay.
  final bool isSweepable;
  final VoidCallback onTap;

  const _StageNode({
    required this.stage,
    required this.isBoss,
    required this.accent,
    required this.state,
    required this.isSweepable,
    required this.onTap,
  });

  @override
  State<_StageNode> createState() => _StageNodeState();
}

class _StageNodeState extends State<_StageNode> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  /// The stage the player would actually tackle next — glows softly so the
  /// map reads at a glance instead of requiring the player to scan
  /// checkmarks and numbers.
  bool get _isActionable => widget.state == _StageState.frontier || widget.state == _StageState.selected;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    if (_isActionable) _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _StageNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isActionable && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!_isActionable && _pulseController.isAnimating) {
      _pulseController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _fillColor {
    switch (widget.state) {
      case _StageState.locked:
        return Colors.white.withValues(alpha: 0.06);
      case _StageState.cleared:
        return widget.accent.withValues(alpha: 0.55);
      case _StageState.frontier:
      case _StageState.selected:
        return widget.isBoss ? Colors.red.withValues(alpha: 0.7) : widget.accent;
    }
  }

  Widget _icon() {
    if (widget.state == _StageState.locked) {
      return Icon(sfSymbol('lock.fill'), size: 12, color: Colors.white.withValues(alpha: 0.5));
    }
    if (widget.isBoss) {
      return Icon(sfSymbol('flame.fill'), size: 16, color: Colors.white);
    }
    if (widget.state == _StageState.cleared) {
      return Icon(sfSymbol('checkmark'), size: 12, color: Colors.white);
    }
    return Text('${widget.stage}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locked = widget.state == _StageState.locked;
    // A bare `Button` in SwiftUI reads just the glyph inside to VoiceOver
    // ("lock", "checkmark", or a bare number) — not enough to tell stages
    // apart. Speak the stage number, boss status and progress state
    // explicitly instead.
    final label = (widget.isBoss ? l.campaignBossStageLabel(widget.stage) : l.campaignStageLabel(widget.stage)) +
        (widget.state == _StageState.locked
            ? l.campaignStageLockedSuffix
            : widget.state == _StageState.cleared
                ? l.campaignStageClearedSuffix
                : '');
    return Semantics(
      label: label,
      button: !locked,
      // Without this, the frontier/selected node's bare digit `Text` (from
      // `_icon()`) has its own implicit text semantics, which merges into
      // this node's label as e.g. "Stage 1\n1" instead of "Stage 1" — same
      // gotcha as `DreamHavenView._resourceItem`.
      excludeSemantics: true,
      child: GestureDetector(
        onTap: locked ? null : widget.onTap,
        child: Opacity(
          opacity: locked ? 0.5 : 1,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (_isActionable)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) => Opacity(
                      opacity: 0.45 + _pulseController.value * 0.4,
                      child: Transform.scale(
                        scale: 1 + _pulseController.value * 0.35,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (widget.isBoss ? Colors.red : widget.accent).withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _fillColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.state == _StageState.selected ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.18),
                      width: widget.state == _StageState.selected ? 2 : 1,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Center(child: _icon()),
                ),
                if (widget.isSweepable)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: dk_theme.Theme.gold,
                          shape: BoxShape.circle,
                          border: Border.all(color: dk_theme.Theme.deepNavy.withValues(alpha: 0.6), width: 1),
                        ),
                        child: Icon(sfSymbol('bolt.fill'), size: 8, color: Colors.black),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Brief, self-dismissing payout summary for a swept stage — lighter than
/// a full result screen since sweeping is meant to be the fast path, not
/// another screen to sit through.
class _SweepToast extends StatelessWidget {
  final BattleResultSummary result;
  final AppLocalizations l;

  const _SweepToast({required this.result, required this.l});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: dk_theme.GlassCard(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol('bolt.fill'), size: 16, color: dk_theme.Theme.gold),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.campaignStageSwept(result.stage), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  l.campaignSweepPayout(result.goldGained, result.expGained),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
