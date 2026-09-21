import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/dreamkeeper.dart';
import '../../models/equipment.dart';
import '../../models/rarity.dart';
import '../../platform/platform_service.dart';
import '../../progression/equipment_summon_system.dart';
import '../../progression/summon_system.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../codex/dreamkeeper_codex_detail_view.dart';
import '../equipment/equipment_detail_sheet.dart';
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
/// every rarity/cost/pity number matches Swift exactly. What it does add:
/// an Epic+ reveal spawns a rarity-tinted particle burst sized by
/// `Rarity.summonBurstParticleCount`, a Legendary+ reveal fires a brief
/// full-screen color flash, and the whole reveal overlay scales itself to
/// fit the available screen instead of scrolling — see `_RevealOverlay`.
/// Tapping any revealed result — a grid tile, the single-pull card, or the
/// Legendary spotlight's portrait — opens that specific pull's detail page
/// (`DreamkeeperCodexDetailView` or `EquipmentDetailSheet`), same as Swift.
enum _SummonMode { dreamkeeper, equipment }

class SummoningShrineView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const SummoningShrineView(
      {super.key, required this.gameState, required this.onNavigate});

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

  /// Set for Dreamkeeper-mode pulls only — lets a tap open the full Codex
  /// detail page for exactly this creature.
  final DreamkeeperDefinition? dreamkeeperDefinition;

  /// Set for Equipment-mode pulls only — the pulled item's id, already
  /// present in `gameState.inventory` by the time the reveal shows, so a tap
  /// can open its detail sheet directly.
  final String? equipmentItemID;

  const _PullDisplay({
    required this.name,
    required this.rarity,
    required this.subtitle,
    required this.symbol,
    this.artAssetName,
    this.dreamkeeperDefinition,
    this.equipmentItemID,
  });

  factory _PullDisplay.fromSummon(SummonResult result, AppLocalizations l) =>
      _PullDisplay(
        name: result.definition.name,
        rarity: result.definition.rarity,
        subtitle: result.isNew ? l.summonNew : l.summonDuplicate,
        symbol: result.definition.symbol,
        artAssetName: dk_theme.DreamkeeperArt.hasArt(result.definition.artName)
            ? dk_theme.DreamkeeperArt.assetName(result.definition.artName)
            : null,
        dreamkeeperDefinition: result.definition,
      );

  factory _PullDisplay.fromEquipment(EquipmentItem item, AppLocalizations l) =>
      _PullDisplay(
        name: item.name,
        rarity: item.rarity,
        subtitle: l.summonEquipSubtitle(item.slot.displayName, item.level),
        symbol: item.slot.symbol,
        artAssetName: dk_theme.ItemArt.hasArt(item.name)
            ? dk_theme.ItemArt.assetName(item.name)
            : null,
        equipmentItemID: item.id,
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

  /// Index (within `_multiReveal`) of the single highest-rarity pull, or
  /// `null` when nothing in the pull reached Epic. Only this one tile gets
  /// the big/effects treatment — a 10+1 pull with several Epics should still
  /// spotlight just its best result, not turn every one of them into a
  /// production.
  int? _bestPullIndex;

  // Full-screen flash effect for a Legendary+ reveal — `_flashToken` gives
  // each trigger a fresh `_RevealFlash` widget identity (via its `key`) so
  // two flashes landing within the same animation window each restart
  // cleanly instead of the second one being a no-op rebuild.
  Rarity? _flashRarity;
  int _flashToken = 0;
  Timer? _flashTimer;

  // A Legendary+ best pull gets a second, bigger moment on top of the grid
  // and flash: a full-screen spotlight card dead center. Stays up until the
  // player dismisses it (tapping the backdrop) or taps the portrait to open
  // its detail page — no auto-dismiss, so there's no rush to look at it.
  _PullDisplay? _legendarySpotlight;

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
    _flashTimer?.cancel();
    super.dispose();
  }

  void _triggerFlashIfNotable(Rarity rarity) {
    if (rarity < Rarity.legendary) return;
    _flashTimer?.cancel();
    setState(() {
      _flashRarity = rarity;
      _flashToken++;
    });
    _flashTimer = Timer(const Duration(milliseconds: 420), () {
      if (mounted) setState(() => _flashRarity = null);
    });
  }

  void _triggerLegendarySpotlightIfNotable(_PullDisplay display) {
    if (display.rarity < Rarity.legendary) return;
    _gameState.playHaptic(HapticStyle.success);
    setState(() => _legendarySpotlight = display);
  }

  void _dismissLegendarySpotlight() =>
      setState(() => _legendarySpotlight = null);

  /// Opens the appropriate detail page for a tapped pull — the Codex detail
  /// page for a Dreamkeeper, the equipment detail sheet for an item. Pushed
  /// as a full-screen route so it works the same from the grid, the
  /// single-pull card, and the Legendary spotlight without disturbing
  /// whichever reveal overlay is still showing underneath.
  void _openDetail(_PullDisplay display) {
    _gameState.playHaptic(HapticStyle.light);
    final definition = display.dreamkeeperDefinition;
    final itemID = display.equipmentItemID;
    if (definition != null) {
      final owned =
          _gameState.roster.where((i) => i.definitionID == definition.id);
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                DreamkeeperCodexDetailView(
                  definition: definition,
                  isOwned: owned.isNotEmpty,
                  ownedCount: owned.length,
                  maxStars: owned.isEmpty
                      ? 0
                      : owned
                          .map((i) => i.stars)
                          .reduce((a, b) => a > b ? a : b),
                  gameState: _gameState,
                  onClose: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (itemID != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) =>
              EquipmentDetailSheet(itemID: itemID, gameState: _gameState),
        ),
      );
    }
  }

  bool get _canAffordSingle => _mode == _SummonMode.dreamkeeper
      ? _gameState.canAffordSummon
      : _gameState.canAffordEquipmentSummon;
  bool get _canAffordMulti => _mode == _SummonMode.dreamkeeper
      ? _gameState.canAffordMultiSummon
      : _gameState.canAffordEquipmentMultiSummon;
  int get _singleCost => _mode == _SummonMode.dreamkeeper
      ? SummonSystem.cost
      : EquipmentSummonSystem.cost;
  int get _multiCost => _mode == _SummonMode.dreamkeeper
      ? SummonSystem.multiPullCost
      : EquipmentSummonSystem.multiPullCost;
  int get _multiCount => _mode == _SummonMode.dreamkeeper
      ? SummonSystem.multiPullTotalCount
      : EquipmentSummonSystem.multiPullTotalCount;

  void _tapSingle() {
    final l = AppLocalizations.of(context);
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
      display = _PullDisplay.fromSummon(result, l);
    } else {
      final item = _gameState.performEquipmentSummon();
      if (item == null) {
        _showInsufficientGemsDialog(_singleCost);
        return;
      }
      display = _PullDisplay.fromEquipment(item, l);
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
    final rarity = _singleReveal!.rarity;
    _gameState
        .playHaptic(rarity.glows ? HapticStyle.success : HapticStyle.light);
    setState(() => _singleChestOpened = true);
    _triggerFlashIfNotable(rarity);
  }

  Future<void> _tapMulti() async {
    final l = AppLocalizations.of(context);
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
          title: Text(l.summonMultiTitle(_multiCount)),
          content: Text(l.summonMultiBody(_multiCost, _multiCount)),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l.commonCancel)),
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l.summonAction)),
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
      displays = results.map((r) => _PullDisplay.fromSummon(r, l)).toList();
    } else {
      final items = _gameState.performEquipmentMultiSummon();
      if (items == null) {
        _showInsufficientGemsDialog(_multiCost);
        return;
      }
      displays = items.map((i) => _PullDisplay.fromEquipment(i, l)).toList();
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
      _bestPullIndex = _findBestPullIndex(displays);
    });
    _multiRevealTimer =
        Timer.periodic(const Duration(milliseconds: 140), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final index = _multiRevealedCount;
      final rarity = displays[index].rarity;
      setState(() => _multiRevealedCount++);
      _gameState
          .playHaptic(rarity.glows ? HapticStyle.success : HapticStyle.light);
      if (index == _bestPullIndex) {
        _triggerFlashIfNotable(rarity);
        _triggerLegendarySpotlightIfNotable(displays[index]);
      }
      if (_multiRevealedCount >= displays.length) timer.cancel();
    });
  }

  /// The single highest-rarity pull in the batch (first one, on a tie) —
  /// `null` unless it's at least Epic, matching the "ab episch" threshold
  /// for the big reveal.
  int? _findBestPullIndex(List<_PullDisplay> displays) {
    var bestIndex = 0;
    var bestRarity = displays[0].rarity;
    for (var i = 1; i < displays.length; i++) {
      if (displays[i].rarity > bestRarity) {
        bestRarity = displays[i].rarity;
        bestIndex = i;
      }
    }
    return bestRarity.glows ? bestIndex : null;
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
      _legendarySpotlight = null;
    });
  }

  Future<void> _showInsufficientGemsDialog(int cost) async {
    final l = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: Text(l.summonNotEnoughGemsTitle),
          content:
              Text(l.summonNotEnoughGemsBody(cost, _gameState.save.dreamGems)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.onNavigate(const ShopRoute());
              },
              child: Text(l.summonGetGems),
            ),
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l.commonOk)),
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
        const dk_theme.AmbientBackground(
            topTint: dk_theme.Theme.gold, bottomTint: dk_theme.Theme.violet),
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
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _modePicker(l),
                          const SizedBox(height: 16),
                          _pullCard(l),
                          const SizedBox(height: 16),
                          _oddsCard(l),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                  ? _ResultCard(
                      display: _singleReveal!,
                      large: true,
                      onTap: () => _openDetail(_singleReveal!))
                  : _ChestReveal(
                      rarity: _singleReveal!.rarity,
                      onTap: _openSingleChest,
                      l: l),
            ),
          ),
        if (_multiReveal != null)
          Positioned.fill(
            child: _RevealOverlay(
              onDismiss: _dismissMultiReveal,
              onTapBeforeDone: _multiRevealedCount < _multiReveal!.length
                  ? _skipMultiReveal
                  : null,
              // Unlike the single-pull card, the multi-pull grid should
              // genuinely fill the available box in both directions —
              // `expand` hands it the real screen constraints instead of
              // scaling a fixed-size reference layout up to fit (which only
              // ever matched one axis and left the other full of dead
              // margin, since a fixed reference's aspect ratio rarely
              // matches whatever device/orientation it's rendered on).
              expand: true,
              child: _MultiResultGrid(
                displays: _multiReveal!,
                revealedCount: _multiRevealedCount,
                bestIndex: _bestPullIndex,
                onContinue: _dismissMultiReveal,
                onTapResult: _openDetail,
                l: l,
              ),
            ),
          ),
        if (_flashRarity != null)
          Positioned.fill(
            child: IgnorePointer(
                child: _RevealFlash(
                    key: ValueKey(_flashToken), rarity: _flashRarity!)),
          ),
        // On top of everything, including the flash — a Legendary+ best
        // pull gets a second, bigger moment: full-screen, dead center, with
        // heavier effects than any grid tile gets.
        if (_legendarySpotlight != null)
          Positioned.fill(
            child: _LegendarySpotlight(
              key: ValueKey(_legendarySpotlight),
              display: _legendarySpotlight!,
              onDismiss: _dismissLegendarySpotlight,
              onTapInfo: () => _openDetail(_legendarySpotlight!),
            ),
          ),
      ],
    );
  }

  /// The gradient/border background spans the full device width, edge to
  /// edge — only the row of buttons/text inside gets safe-area padding
  /// (via the inner `SafeArea`), so the sensor-housing safe zone on a
  /// landscape iPhone doesn't cut the bar short and leave a bare seam of
  /// plain background showing next to it.
  Widget _header(AppLocalizations l) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            dk_theme.Theme.gold.withValues(alpha: 0.3),
            dk_theme.Theme.deepNavy.withValues(alpha: 0.85)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
            bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.14), width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _iconButton(
                  icon: 'chevron.left',
                  label: l.commonBack,
                  onTap: () => widget.onNavigate(const DreamHavenRoute())),
              const Spacer(),
              Text(l.navSummoningShrine,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              dk_theme.ResourcePill(
                icon: sfSymbol('sparkles'),
                value: '${_gameState.save.dreamGems}',
                tint: dk_theme.Theme.violet,
                semanticLabel: l.resDreamGems,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(
      {required String icon,
      required String label,
      required VoidCallback onTap}) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle),
          child: Icon(sfSymbol(icon), size: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _modePicker(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Expanded(
              child: _modeSegment(_SummonMode.dreamkeeper,
                  l.summonModeDreamkeeper, 'person.3.fill')),
          Expanded(
              child: _modeSegment(
                  _SummonMode.equipment, l.summonModeEquipment, 'shield.fill')),
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
            color: selected
                ? dk_theme.Theme.violet.withValues(alpha: 0.55)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(sfSymbol(icon), size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pullCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _mode == _SummonMode.dreamkeeper
                ? l.summonBlurbDreamkeeper
                : l.summonBlurbEquipment,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
          ),
          const SizedBox(height: 14),
          if (!_canAffordSingle) _insufficientGemsHint(l) else _pullButtons(l),
        ],
      ),
    );
  }

  Widget _pullButtons(AppLocalizations l) {
    return Row(
      children: [
        Expanded(
          child: dk_theme.PrimaryButton(
            onPressed: _tapSingle,
            child: Text(l.summonSingleButton(_singleCost)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: dk_theme.PrimaryButton(
            tint: dk_theme.Theme.gold,
            onPressed: _canAffordMulti
                ? _tapMulti
                : () => _showInsufficientGemsDialog(_multiCost),
            child: Text(l.summonMultiButton(_multiCount, _multiCost)),
          ),
        ),
      ],
    );
  }

  Widget _insufficientGemsHint(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.summonInsufficientHint(_singleCost, _gameState.save.dreamGems),
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
        ),
        const SizedBox(height: 10),
        dk_theme.PrimaryButton(
          tint: dk_theme.Theme.gold,
          onPressed: () => widget.onNavigate(const ShopRoute()),
          child: Text(l.summonGetGems),
        ),
      ],
    );
  }

  Widget _oddsCard(AppLocalizations l) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.summonOddsTitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          for (final (rarity, weight) in SummonSystem.rarityOdds)
            _oddsRow(rarity, weight),
          const SizedBox(height: 14),
          _pityRow(
            label: l.summonEpicPity,
            current: _gameState.pullsSinceEpicSummon,
            threshold: SummonSystem.epicPityThreshold,
            tint: Rarity.epic.primaryColor,
          ),
          const SizedBox(height: 8),
          _pityRow(
            label: l.summonLegendaryPity,
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
    final text = percent == percent.roundToDouble()
        ? '${percent.round()}%'
        : '${percent.toStringAsFixed(2)}%';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: rarity.primaryColor, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(rarity.displayName,
                  style: const TextStyle(color: Colors.white, fontSize: 12))),
          Text(text,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _pityRow(
      {required String label,
      required int current,
      required int threshold,
      required Color tint}) {
    final progress = (current / threshold).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75), fontSize: 11)),
            Text('$current/$threshold',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
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
  final bool expand;

  const _RevealOverlay(
      {required this.child,
      required this.onDismiss,
      this.onTapBeforeDone,
      this.expand = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBeforeDone ?? onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.88),
        padding: const EdgeInsets.all(12),
        // `expand` (the multi-pull grid) hands the child the real available
        // box so it can size itself to fill it directly — see `_MultiResultGrid`.
        // The single-pull card instead centers and only ever shrinks
        // (`scaleDown`), since it's a single fixed-size card, not a grid
        // that needs to spread out.
        child: expand
            ? GestureDetector(onTap: () {}, child: child)
            : Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: GestureDetector(onTap: () {}, child: child),
                ),
              ),
      ),
    );
  }
}

/// Compact horizontal result display — a simplified stand-in for Swift's
/// `resultCard`/`equipmentResultCard` `GlassCard` rows. Tapping it opens the
/// pull's detail page via `onTap`, same as Swift's tap-to-open-Codex
/// affordance.
class _ResultCard extends StatelessWidget {
  final _PullDisplay display;
  final bool large;

  /// The multi-pull grid computes this per-render from the actual available
  /// screen space (see `_MultiResultGrid`), so every tile is as big as the
  /// device genuinely has room for. Ignored when `large` (the single-pull
  /// card always uses its own fixed size).
  final double? portraitSize;

  /// Whether this is the single highest-rarity pull in the batch (see
  /// `_SummoningShrineViewState._findBestPullIndex`) — only that one tile
  /// gets the bigger portrait, burst particles, and bouncier pop-in, even
  /// when several other tiles in the same grid are also Epic+.
  final bool isBest;

  /// Opens this pull's detail page (Codex or equipment sheet) — see
  /// `_SummoningShrineViewState._openDetail`. `null` disables the tap (never
  /// happens in practice; every revealed tile has somewhere to go).
  final VoidCallback? onTap;

  const _ResultCard(
      {required this.display,
      this.large = false,
      this.portraitSize,
      this.isBest = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    // The best pull gets a visibly bigger portrait, a burst of particles,
    // and a bouncier, longer pop-in than the rest of the grid — reserved
    // for a single tile so it actually reads as "the" standout result
    // instead of every Epic+ tile competing for attention.
    final prominent = !large && isBest;
    // The single-pull card (`large`) still glows by its own rarity — there's
    // no "batch" to pick a best from. The multi-pull grid's tiles glow only
    // when they're the batch's best pull.
    final glowEffects = large ? display.rarity.glows : prominent;
    final base = large ? 72.0 : (portraitSize ?? 56.0);
    final size =
        large ? base : (prominent ? math.min(base * 1.3, base + 36) : base);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: prominent ? 500 : 320),
      curve: prominent ? Curves.elasticOut : Curves.easeOutBack,
      builder: (context, t, revealChild) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.scale(scale: 0.7 + 0.3 * t, child: revealChild),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: dk_theme.GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size + 28,
                height: size + 28,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (glowEffects)
                      _BurstParticles(
                          rarity: display.rarity, spread: size / 2 + 14),
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        gradient: display.artAssetName == null
                            ? display.rarity.gradient
                            : null,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.5),
                        boxShadow: glowEffects
                            ? [
                                BoxShadow(
                                    color: display.rarity.primaryColor
                                        .withValues(alpha: 0.6),
                                    blurRadius: 16,
                                    spreadRadius: 2)
                              ]
                            : null,
                      ),
                      child: display.artAssetName != null
                          ? ClipOval(
                              child: Image.asset(display.artAssetName!,
                                  width: size, height: size, fit: BoxFit.cover))
                          : Icon(sfSymbol(display.symbol),
                              color: Colors.white, size: large ? 32 : 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: large ? 12 : 6),
              // `FittedBox` + `maxLines: 1` shrinks long names to fit instead
              // of `Text` wrapping mid-word inside a narrow multi-pull tile
              // (e.g. "Schattenpanther" breaking into "Schattenp"/"anther").
              SizedBox(
                width: large ? 140 : (size * 2.1).clamp(90.0, 200.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    display.name,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: large ? 16 : (size * 0.24).clamp(12.0, 18.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: large ? 4 : 2),
              Text(
                display.rarity.displayName,
                style: TextStyle(
                  color: display.rarity.primaryColor,
                  fontSize: large ? 13 : (size * 0.2).clamp(10.0, 15.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (large) ...[
                const SizedBox(height: 2),
                Text(display.subtitle,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12)),
              ],
            ],
          ),
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
  final AppLocalizations l;

  const _ChestReveal(
      {required this.rarity, required this.onTap, required this.l});

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
                BoxShadow(
                    color: rarity.primaryColor.withValues(alpha: 0.6),
                    blurRadius: 28,
                    spreadRadius: 4),
              ],
            ),
            child: Image.asset(dk_theme.SingletonArt.chestClosed,
                fit: BoxFit.contain),
          ),
          const SizedBox(height: 18),
          Text(
            l.summonTapToOpen,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 15,
                fontWeight: FontWeight.w600),
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
  final int? bestIndex;
  final VoidCallback onContinue;
  final ValueChanged<_PullDisplay> onTapResult;
  final AppLocalizations l;

  const _MultiResultGrid({
    required this.displays,
    required this.revealedCount,
    required this.bestIndex,
    required this.onContinue,
    required this.onTapResult,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    final done = revealedCount >= displays.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        const headerHeight = 26.0 + 16.0;
        // Extra-generous footer reserve (vs. the button/hint's own ~54px)
        // so the last row's rarity label never sits flush against — or
        // behind — the Continue button; a tight fit there is what made the
        // bottom row's rarity unreadable before.
        const footerHeight = 18.0 + 70.0;
        final availableWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 520.0;
        final availableHeight =
            ((constraints.maxHeight.isFinite ? constraints.maxHeight : 700.0) -
                    headerHeight -
                    footerHeight)
                .clamp(120.0, double.infinity);
        final count = displays.length;

        // Pick whichever column count lets a tile be biggest while still
        // fitting all `count` tiles in the available box without scrolling.
        // A fixed-size reference layout scaled with `BoxFit.contain` (the
        // previous approach) only ever matched one axis and left the other
        // full of dead margin — measuring against the real box on every
        // build is what actually makes the grid spread across the whole
        // screen on any device/orientation.
        var bestColumns = 1;
        var bestPortraitSize = 0.0;
        for (var columns = 1; columns <= count; columns++) {
          final rows = (count / columns).ceil();
          final tileWidth =
              (availableWidth - spacing * (columns - 1)) / columns;
          final tileHeight = (availableHeight - spacing * (rows - 1)) / rows;
          // A tile's portrait sits inside ~1.4x its width (card padding)
          // and ~2.1x its height (portrait + two lines of text below) —
          // deliberately roomier than `_ResultCard`'s tightest fit so every
          // row, including the last, has margin to spare instead of
          // clipping against its neighbors or the footer.
          final portraitSize = math.min(tileWidth / 1.4, tileHeight / 2.1);
          if (portraitSize > bestPortraitSize) {
            bestPortraitSize = portraitSize;
            bestColumns = columns;
          }
        }
        // A further ~10% shrink on top of the roomier ratios above — a
        // fully edge-to-edge grid left the bottom row's rarity text too
        // close to the Continue button to read comfortably.
        final portraitSize = (bestPortraitSize * 0.9).clamp(36.0, 110.0);
        final tileWidth =
            (availableWidth - spacing * (bestColumns - 1)) / bestColumns;

        return SizedBox(
          width: availableWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l.summonResultsTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.center,
                children: [
                  for (var i = 0; i < count; i++)
                    SizedBox(
                      width: tileWidth,
                      child: i < revealedCount
                          ? _ResultCard(
                              display: displays[i],
                              portraitSize: portraitSize,
                              isBest: i == bestIndex,
                              onTap: () => onTapResult(displays[i]),
                            )
                          : _PendingTile(size: portraitSize),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              if (done)
                SizedBox(
                  width: 200,
                  child: dk_theme.PrimaryButton(
                      onPressed: onContinue, child: Text(l.commonContinue)),
                )
              else
                Text(l.summonTapToRevealAll,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12)),
            ],
          ),
        );
      },
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
  final double size;

  const _PendingTile({this.size = 56});

  @override
  Widget build(BuildContext context) {
    return dk_theme.GlassCard(
      child: SizedBox(
        height: size * 1.9,
        child: Center(
          child: Opacity(
            opacity: 0.55,
            child: Image.asset(dk_theme.SingletonArt.chestClosed,
                width: size, height: size, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

/// Small dots radiating outward from a reveal's portrait and fading out —
/// a lightweight stand-in for a real particle system. Count scales with
/// `Rarity.summonBurstParticleCount`, so a Mythic pull visibly bursts
/// harder than a Rare one; only spawned for `rarity.glows` (Epic+), see
/// `_ResultCard`. Runs once per instance — give it a fresh `key` (or a
/// fresh `_ResultCard`, since tiles are only built once revealed) to
/// replay it.
class _BurstParticles extends StatefulWidget {
  final Rarity rarity;
  final double spread;

  const _BurstParticles({required this.rarity, required this.spread});

  @override
  State<_BurstParticles> createState() => _BurstParticlesState();
}

class _BurstParticlesState extends State<_BurstParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<double> _angles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    final count = widget.rarity.summonBurstParticleCount;
    _angles = List.generate(count, (i) => (2 * math.pi * i) / count);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_angles.isEmpty) return const SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeOut.transform(_controller.value);
          final distance = widget.spread * t;
          final opacity = (1 - t).clamp(0.0, 1.0);
          return Stack(
            alignment: Alignment.center,
            children: [
              for (final angle in _angles)
                Transform.translate(
                  offset: Offset(
                      math.cos(angle) * distance, math.sin(angle) * distance),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.rarity.primaryColor,
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// A brief full-screen tinted flash — fired when a multi-pull tile (or a
/// single-pull chest) reveals Legendary rarity or higher, so a top-tier
/// pull reads as a genuine moment instead of just another grid tile.
class _RevealFlash extends StatefulWidget {
  final Rarity rarity;

  const _RevealFlash({super.key, required this.rarity});

  @override
  State<_RevealFlash> createState() => _RevealFlashState();
}

class _RevealFlashState extends State<_RevealFlash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420))
      ..forward();
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.65), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.65, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, _) => Container(
          color: widget.rarity.primaryColor.withValues(alpha: _opacity.value)),
    );
  }
}

/// A Legendary+ best pull's second, bigger moment — after popping in inside
/// the grid, it gets shown again dead center, full-screen, at roughly double
/// the grid tile's portrait size with a much heavier particle burst and a
/// multi-layer glow. Stays up until dismissed (tap the backdrop) — tapping
/// the portrait itself instead opens the detail page via `onTapInfo`.
class _LegendarySpotlight extends StatelessWidget {
  final _PullDisplay display;
  final VoidCallback onDismiss;
  final VoidCallback onTapInfo;

  const _LegendarySpotlight(
      {super.key,
      required this.display,
      required this.onDismiss,
      required this.onTapInfo});

  @override
  Widget build(BuildContext context) {
    const portraitSize = 176.0;
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.93),
        alignment: Alignment.center,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 750),
          curve: Curves.elasticOut,
          builder: (context, t, child) => Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(scale: 0.35 + 0.65 * t, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onTapInfo,
                child: SizedBox(
                  width: portraitSize + 90,
                  height: portraitSize + 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _BurstParticles(
                          rarity: display.rarity,
                          spread: portraitSize / 2 + 40),
                      Container(
                        width: portraitSize,
                        height: portraitSize,
                        decoration: BoxDecoration(
                          gradient: display.artAssetName == null
                              ? display.rarity.gradient
                              : null,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.55),
                              width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: display.rarity.primaryColor
                                    .withValues(alpha: 0.9),
                                blurRadius: 50,
                                spreadRadius: 12),
                            BoxShadow(
                                color: display.rarity.primaryColor
                                    .withValues(alpha: 0.5),
                                blurRadius: 100,
                                spreadRadius: 30),
                          ],
                        ),
                        child: display.artAssetName != null
                            ? ClipOval(
                                child: Image.asset(display.artAssetName!,
                                    width: portraitSize,
                                    height: portraitSize,
                                    fit: BoxFit.cover))
                            : Icon(sfSymbol(display.symbol),
                                color: Colors.white, size: 64),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: onTapInfo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    display.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                display.rarity.displayName,
                style: TextStyle(
                    color: display.rarity.primaryColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context).summonTapPortraitForInfo,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).summonTapToContinue,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
