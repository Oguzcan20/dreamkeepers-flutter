import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/equipment.dart';
import '../../models/rarity.dart';
import '../../platform/platform_service.dart';
import '../../progression/equipment_summon_system.dart';
import '../../progression/summon_system.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// The Summoning Shrine — gacha pulls for new Dreamkeepers (mode
/// `.dreamkeeper`) or Equipment (mode `.equipment`). Mirrors
/// `SummoningShrineView` (UI/Summon/SummoningShrineView.swift) structurally
/// and functionally (mode picker, single/10+1 pulls, pity floors, odds
/// disclosure, insufficient-Gems hint) but deliberately simplifies its very
/// large decorative layer: no tap-escalation reveal ladder, no full-screen
/// `SummonRevealShowcase` cutscene, no whole-screen shake/ray-burst effects,
/// and no animated rolling-gems-counter widget. Swift leans on those
/// specifically because its own doc comments record a confirmed history of
/// `RadialGradient` corrupting *this* screen's SwiftUI compositing — a
/// Flutter-specific rendering bug that doesn't exist here, so replicating
/// the workaround layer wouldn't buy anything. A single pull still gets a
/// pop-in reveal card and a multi-pull still gets a staggered reveal grid;
/// every rarity/cost/pity number matches Swift exactly.
///
/// The Swift screen's "tap a result's portrait to open
/// `DreamkeeperCodexDetailView`" affordance is omitted — Codex isn't ported
/// yet (still `_ComingSoonScreen` in `RootView`), so there is nowhere for
/// that tap to go.
enum _SummonMode { dreamkeeper, equipment }

class SummoningShrineView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const SummoningShrineView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<SummoningShrineView> createState() => _SummoningShrineViewState();
}

/// A pull result, flattened to just what the reveal UI needs — lets the
/// Dreamkeeper and Equipment flows share one reveal-card/grid
/// implementation instead of two near-identical copies.
class _PullDisplay {
  final String name;
  final Rarity rarity;
  final String subtitle;
  final String symbol;
  /// Real bundled art for this pull, when it exists (`DreamkeeperArt`/
  /// `ItemArt` — see `theme.dart`); `null` falls back to the icon-badge
  /// treatment, same convention as `DreamkeeperCard`/`EquipmentSheet`.
  final String? artAssetName;

  const _PullDisplay({required this.name, required this.rarity, required this.subtitle, required this.symbol, this.artAssetName});

  factory _PullDisplay.fromSummon(SummonResult result) => _PullDisplay(
        name: result.definition.name,
        rarity: result.definition.rarity,
        subtitle: result.isNew ? 'New!' : 'Duplicate',
        symbol: result.definition.symbol,
        artAssetName: dk_theme.DreamkeeperArt.hasArt(result.definition.name)
            ? dk_theme.DreamkeeperArt.assetName(result.definition.name)
            : null,
      );

  factory _PullDisplay.fromEquipment(EquipmentItem item) => _PullDisplay(
        name: item.name,
        rarity: item.rarity,
        subtitle: '${item.slot.displayName} · Lv ${item.level}',
        symbol: item.slot.symbol,
        artAssetName: dk_theme.ItemArt.hasArt(item.name) ? dk_theme.ItemArt.assetName(item.name) : null,
      );
}

class _SummoningShrineViewState extends State<SummoningShrineView> {
  bool _appeared = false;
  _SummonMode _mode = _SummonMode.dreamkeeper;

  _PullDisplay? _singleReveal;
  bool _singleChestOpened = false;
  List<_PullDisplay>? _multiReveal;
  int _multiRevealedCount = 0;
  Timer? _multiRevealTimer;

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
    _multiRevealTimer?.cancel();
    super.dispose();
  }

  bool get _canAffordSingle =>
      _mode == _SummonMode.dreamkeeper ? _gameState.canAffordSummon : _gameState.canAffordEquipmentSummon;
  bool get _canAffordMulti =>
      _mode == _SummonMode.dreamkeeper ? _gameState.canAffordMultiSummon : _gameState.canAffordEquipmentMultiSummon;
  int get _singleCost => _mode == _SummonMode.dreamkeeper ? SummonSystem.cost : EquipmentSummonSystem.cost;
  int get _multiCost => _mode == _SummonMode.dreamkeeper ? SummonSystem.multiPullCost : EquipmentSummonSystem.multiPullCost;
  int get _multiCount =>
      _mode == _SummonMode.dreamkeeper ? SummonSystem.multiPullTotalCount : EquipmentSummonSystem.multiPullTotalCount;

  void _tapSingle() {
    _gameState.playHaptic(HapticStyle.light);
    if (!_canAffordSingle) {
      _showInsufficientGemsDialog(_singleCost);
      return;
    }
    final _PullDisplay display;
    if (_mode == _SummonMode.dreamkeeper) {
      final result = _gameState.performSummon();
      if (result == null) {
        _showInsufficientGemsDialog(_singleCost);
        return;
      }
      display = _PullDisplay.fromSummon(result);
    } else {
      final item = _gameState.performEquipmentSummon();
      if (item == null) {
        _showInsufficientGemsDialog(_singleCost);
        return;
      }
      display = _PullDisplay.fromEquipment(item);
    }
    _gameState.playHaptic(HapticStyle.success);
    _gameState.playSound(SoundEffect.summon);
    setState(() {
      _singleReveal = display;
      _singleChestOpened = false;
    });
  }

  void _openSingleChest() {
    if (_singleChestOpened) return;
    _gameState.playHaptic(HapticStyle.light);
    setState(() => _singleChestOpened = true);
  }

  Future<void> _tapMulti() async {
    _gameState.playHaptic(HapticStyle.light);
    if (!_canAffordMulti) {
      _showInsufficientGemsDialog(_multiCost);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: Text('Summon x$_multiCount'),
          content: Text('Spend $_multiCost Gems for $_multiCount pulls?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Summon')),
          ],
        ),
      ),
    );
    if (confirmed != true) return;

    final List<_PullDisplay> displays;
    if (_mode == _SummonMode.dreamkeeper) {
      final results = _gameState.performMultiSummon();
      if (results == null) {
        _showInsufficientGemsDialog(_multiCost);
        return;
      }
      displays = results.map(_PullDisplay.fromSummon).toList();
    } else {
      final items = _gameState.performEquipmentMultiSummon();
      if (items == null) {
        _showInsufficientGemsDialog(_multiCost);
        return;
      }
      displays = items.map(_PullDisplay.fromEquipment).toList();
    }
    _gameState.playHaptic(HapticStyle.success);
    _gameState.playSound(SoundEffect.summon);
    _startMultiReveal(displays);
  }

  /// Reveals the grid's tiles one at a time instead of all at once — a much
  /// lighter stand-in for Swift's staggered per-tile pop/burst animations,
  /// but it keeps the same "results trickle in" feel.
  void _startMultiReveal(List<_PullDisplay> displays) {
    _multiRevealTimer?.cancel();
    setState(() {
      _multiReveal = displays;
      _multiRevealedCount = 0;
    });
    _multiRevealTimer = Timer.periodic(const Duration(milliseconds: 140), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _multiRevealedCount++);
      if (_multiRevealedCount >= displays.length) timer.cancel();
    });
  }

  void _skipMultiReveal() {
    _multiRevealTimer?.cancel();
    setState(() => _multiRevealedCount = _multiReveal?.length ?? 0);
  }

  void _dismissSingleReveal() => setState(() => _singleReveal = null);
  void _dismissMultiReveal() {
    _multiRevealTimer?.cancel();
    setState(() {
      _multiReveal = null;
      _multiRevealedCount = 0;
    });
  }

  Future<void> _showInsufficientGemsDialog(int cost) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: const Text('Not Enough Gems'),
          content: Text('This costs $cost Gems. You have ${_gameState.save.dreamGems}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.onNavigate(const ShopRoute());
              },
              child: const Text('Get Gems'),
            ),
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const dk_theme.AmbientBackground(topTint: dk_theme.Theme.gold, bottomTint: dk_theme.Theme.violet),
        SafeArea(
          child: AnimatedBuilder(
            animation: _gameState,
            builder: (context, _) => AnimatedOpacity(
              opacity: _appeared ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  _header(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _modePicker(),
                          const SizedBox(height: 16),
                          _pullCard(),
                          const SizedBox(height: 16),
                          _oddsCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_singleReveal != null)
          Positioned.fill(
            child: _RevealOverlay(
              onDismiss: _dismissSingleReveal,
              // Before the chest is opened, tapping anywhere on the dimmed
              // backdrop opens it too (not just the chest art itself) —
              // once open, a further tap falls through to the normal
              // dismiss behavior.
              onTapBeforeDone: _singleChestOpened ? null : _openSingleChest,
              child: _singleChestOpened
                  ? _ResultCard(display: _singleReveal!, large: true)
                  : _ChestReveal(rarity: _singleReveal!.rarity, onTap: _openSingleChest),
            ),
          ),
        if (_multiReveal != null)
          Positioned.fill(
            child: _RevealOverlay(
              onDismiss: _dismissMultiReveal,
              onTapBeforeDone: _multiRevealedCount < _multiReveal!.length ? _skipMultiReveal : null,
              child: _MultiResultGrid(
                displays: _multiReveal!,
                revealedCount: _multiRevealedCount,
                onContinue: _dismissMultiReveal,
              ),
            ),
          ),
      ],
    );
  }

  Widget _header() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [dk_theme.Theme.gold.withValues(alpha: 0.3), dk_theme.Theme.deepNavy.withValues(alpha: 0.85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.14), width: 1)),
      ),
      child: Row(
        children: [
          _iconButton(icon: 'chevron.left', label: 'Back', onTap: () => widget.onNavigate(const DreamHavenRoute())),
          const Spacer(),
          const Text('Summoning Shrine', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          dk_theme.ResourcePill(
            icon: sfSymbol('sparkles'),
            value: '${_gameState.save.dreamGems}',
            tint: dk_theme.Theme.violet,
            semanticLabel: 'Dream Gems',
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

  Widget _modePicker() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Expanded(child: _modeSegment(_SummonMode.dreamkeeper, 'Dreamkeeper', 'person.3.fill')),
          Expanded(child: _modeSegment(_SummonMode.equipment, 'Equipment', 'shield.fill')),
        ],
      ),
    );
  }

  Widget _modeSegment(_SummonMode mode, String label, String icon) {
    final selected = _mode == mode;
    return Semantics(
      label: label,
      button: true,
      selected: selected,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          if (_mode == mode) return;
          _gameState.playHaptic(HapticStyle.light);
          setState(() => _mode = mode);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? dk_theme.Theme.violet.withValues(alpha: 0.55) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(sfSymbol(icon), size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pullCard() {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _mode == _SummonMode.dreamkeeper
                ? 'Summon a Dreamkeeper from the shrine\'s deep waters.'
                : 'Summon a piece of Equipment forged for your current stage.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
          ),
          const SizedBox(height: 14),
          if (!_canAffordSingle) _insufficientGemsHint() else _pullButtons(),
        ],
      ),
    );
  }

  Widget _pullButtons() {
    return Row(
      children: [
        Expanded(
          child: dk_theme.PrimaryButton(
            onPressed: _tapSingle,
            child: Text('Summon ($_singleCost Gems)'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: dk_theme.PrimaryButton(
            tint: dk_theme.Theme.gold,
            onPressed: _canAffordMulti ? _tapMulti : () => _showInsufficientGemsDialog(_multiCost),
            child: Text('x$_multiCount ($_multiCost Gems)'),
          ),
        ),
      ],
    );
  }

  Widget _insufficientGemsHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Not enough Gems for a pull ($_singleCost needed). You have ${_gameState.save.dreamGems}.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
        ),
        const SizedBox(height: 10),
        dk_theme.PrimaryButton(
          tint: dk_theme.Theme.gold,
          onPressed: () => widget.onNavigate(const ShopRoute()),
          child: const Text('Get Gems'),
        ),
      ],
    );
  }

  Widget _oddsCard() {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Odds', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          for (final (rarity, weight) in SummonSystem.rarityOdds) _oddsRow(rarity, weight),
          const SizedBox(height: 14),
          _pityRow(
            label: 'Epic+ pity',
            current: _gameState.pullsSinceEpicSummon,
            threshold: SummonSystem.epicPityThreshold,
            tint: Rarity.epic.primaryColor,
          ),
          const SizedBox(height: 8),
          _pityRow(
            label: 'Legendary+ pity',
            current: _gameState.pullsSinceLegendarySummon,
            threshold: SummonSystem.legendaryPityThreshold,
            tint: Rarity.legendary.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _oddsRow(Rarity rarity, double weight) {
    final percent = weight * 100;
    final text = percent == percent.roundToDouble() ? '${percent.round()}%' : '${percent.toStringAsFixed(2)}%';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: rarity.primaryColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(rarity.displayName, style: const TextStyle(color: Colors.white, fontSize: 12))),
          Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _pityRow({required String label, required int current, required int threshold, required Color tint}) {
    final progress = (current / threshold).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11)),
            Text('$current/$threshold', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation(tint),
          ),
        ),
      ],
    );
  }
}

/// Dimmed full-screen backdrop behind a reveal card/grid, tap-to-dismiss
/// once nothing is still animating in. A much lighter stand-in for Swift's
/// in-place `ZStack` overlay presentation — see this file's top doc comment.
class _RevealOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback onDismiss;
  final VoidCallback? onTapBeforeDone;

  const _RevealOverlay({required this.child, required this.onDismiss, this.onTapBeforeDone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBeforeDone ?? onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.72),
        padding: const EdgeInsets.all(24),
        // The 11-tile multi-pull grid can be taller than the available
        // height on a small/landscape screen — scroll rather than overflow,
        // while still centering short content (the single-pull card) the
        // way a plain `Center` would.
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(child: GestureDetector(onTap: () {}, child: child)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact horizontal result display — a simplified stand-in for Swift's
/// `resultCard`/`equipmentResultCard` `GlassCard` rows (no tap-to-open-Codex
/// affordance, since Codex isn't ported yet).
class _ResultCard extends StatelessWidget {
  final _PullDisplay display;
  final bool large;

  const _ResultCard({required this.display, this.large = false});

  @override
  Widget build(BuildContext context) {
    final size = large ? 72.0 : 44.0;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutBack,
      builder: (context, t, revealChild) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.scale(scale: 0.7 + 0.3 * t, child: revealChild),
      ),
      child: dk_theme.GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: display.artAssetName == null ? display.rarity.gradient : null,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
                boxShadow: display.rarity.glows
                    ? [BoxShadow(color: display.rarity.primaryColor.withValues(alpha: 0.6), blurRadius: 16, spreadRadius: 2)]
                    : null,
              ),
              child: display.artAssetName != null
                  ? ClipOval(child: Image.asset(display.artAssetName!, width: size, height: size, fit: BoxFit.cover))
                  : Icon(sfSymbol(display.symbol), color: Colors.white, size: large ? 32 : 20),
            ),
            SizedBox(height: large ? 12 : 6),
            Text(
              display.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: large ? 16 : 11, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: large ? 4 : 2),
            Text(
              display.rarity.displayName,
              style: TextStyle(color: display.rarity.primaryColor, fontSize: large ? 13 : 10, fontWeight: FontWeight.w600),
            ),
            if (large) ...[
              const SizedBox(height: 2),
              Text(display.subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tap-to-open chest step shown before a single-pull result — mirrors
/// Swift's `SummoningShrineView` chest mechanic (`chestOpened`/
/// `equipmentChestOpened` driving `Image(chestOpened ? "ChestOpen" :
/// "ChestClosed")`), minus the ray-burst/shake cutscene machinery that
/// exists in Swift only to work around a `RadialGradient` rendering bug —
/// that workaround doesn't apply here, so this stays a plain glow + tap
/// prompt. The parent (`_SummoningShrineViewState`) owns the open/closed
/// state and swaps this widget out for `_ResultCard` on tap, so this only
/// ever needs to render the closed chest.
class _ChestReveal extends StatelessWidget {
  final Rarity rarity;
  final VoidCallback onTap;

  const _ChestReveal({required this.rarity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 132,
            height: 132,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: rarity.gradient,
              boxShadow: [
                BoxShadow(color: rarity.primaryColor.withValues(alpha: 0.6), blurRadius: 28, spreadRadius: 4),
              ],
            ),
            child: Image.asset(dk_theme.SingletonArt.chestClosed, fit: BoxFit.contain),
          ),
          const SizedBox(height: 18),
          Text(
            'Tap to open',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Full 11-tile grid for a 10+1 pull, revealing tiles one at a time as
/// `revealedCount` climbs — see `_startMultiReveal`. Unrevealed slots show a
/// plain question-mark placeholder.
class _MultiResultGrid extends StatelessWidget {
  final List<_PullDisplay> displays;
  final int revealedCount;
  final VoidCallback onContinue;

  const _MultiResultGrid({required this.displays, required this.revealedCount, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final done = revealedCount >= displays.length;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Summon Results', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < displays.length; i++)
                SizedBox(
                  width: 96,
                  child: i < revealedCount ? _ResultCard(display: displays[i]) : const _PendingTile(),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (done)
            SizedBox(
              width: 200,
              child: dk_theme.PrimaryButton(onPressed: onContinue, child: const Text('Continue')),
            )
          else
            Text('Tap to reveal all', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
        ],
      ),
    );
  }
}

/// An unrevealed slot in the multi-pull grid — a closed chest (`ChestClosed`
/// key art) waiting its turn in `_startMultiReveal`'s stagger. Mirrors
/// Swift's `ChestClosed`/`ChestOpen` gacha-chest imagery. The single-pull
/// flow gets the full tap-to-open `ChestOpen`/`ChestClosed` step via
/// `_ChestReveal` above; the 10+1 grid keeps the lighter staggered pop-in
/// reveal instead of a chest-tap per tile, since Swift's own multi-pull grid
/// does the same (only its single-pull path uses the chest tap).
class _PendingTile extends StatelessWidget {
  const _PendingTile();

  @override
  Widget build(BuildContext context) {
    return dk_theme.GlassCard(
      child: SizedBox(
        height: 96,
        child: Center(
          child: Opacity(
            opacity: 0.55,
            child: Image.asset(dk_theme.SingletonArt.chestClosed, width: 40, height: 40, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
