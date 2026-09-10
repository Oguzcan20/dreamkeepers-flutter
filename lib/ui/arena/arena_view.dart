// The Arena Tower hub. Mirrors `ArenaView` (UI/Arena/ArenaView.swift): a
// scrollable list of all 100 floors, always fully visible (spec: "ALLE 100
// stufen sollen zu sehen sein") — a player farming gear can jump straight to
// whichever cleared floor drops what they need, not just the current
// frontier. Floors `1...arenaFloor` are unlocked; `arenaFloor` itself is the
// still-unclaimed first-clear frontier, and every floor below it is already
// cleared and freely replayable for its smaller standard reward. There's no
// real backend or matchmaking — every floor's rival is a freshly-synthesized,
// deterministic stand-in from `ArenaSystem`, not another real player's team.
//
// The auto-scroll-to-frontier on appear is simplified from Swift's
// `ScrollViewReader.scrollTo(_:anchor:)` (which needs per-row identity) to a
// plain fractional `ScrollController.jumpTo` based on the frontier floor's
// position in the tower — decorative convenience, not game logic, same
// simplification precedent as Battle's effects layer.

import 'package:flutter/material.dart';

import '../../combat/arena_system.dart';
import '../../l10n/l10n.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

class ArenaView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;
  final ValueChanged<int> onFight;

  const ArenaView({super.key, required this.gameState, required this.onNavigate, required this.onFight});

  @override
  State<ArenaView> createState() => _ArenaViewState();
}

class _ArenaViewState extends State<ArenaView> {
  final _scrollController = ScrollController();
  bool _appeared = false;

  GameState get _gameState => widget.gameState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
      Future.delayed(const Duration(milliseconds: 350), _scrollToFrontier);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFrontier() {
    if (!mounted || !_scrollController.hasClients) return;
    final target = _gameState.arenaFloor.clamp(1, ArenaSystem.maxFloor);
    // The list runs floor 100 (top) down to floor 1 (bottom) — position the
    // frontier floor as a fraction of the way down the full scroll extent.
    final fraction = (ArenaSystem.maxFloor - target) / (ArenaSystem.maxFloor - 1);
    _scrollController.animateTo(
      fraction * _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _attemptFight(int floor) {
    final l = AppLocalizations.of(context);
    if (_gameState.deployedTeam.isEmpty) {
      _showAlert(l.arenaNoTeamTitle, l.arenaNoTeamBody);
      return;
    }
    if (!_gameState.canAffordArenaBattle()) {
      _showAlert(l.arenaNoTicketsTitle, l.arenaNoTicketsBody);
      return;
    }
    widget.onFight(floor);
  }

  Future<void> _showAlert(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(AppLocalizations.of(context).commonOk))],
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
            builder: (context, _) => Column(
              children: [
                AnimatedOpacity(
                  opacity: _appeared ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: _header(),
                ),
                AnimatedOpacity(
                  opacity: _appeared ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: _progressCard(),
                  ),
                ),
                if (_gameState.isArenaTowerCleared)
                  AnimatedOpacity(
                    opacity: _appeared ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: _towerClearedBanner(),
                    ),
                  ),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _appeared ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    // A GlassCard row scrolled flush against the viewport top
                    // otherwise lets its BackdropFilter blur bleed up over the
                    // progress card above (Flutter #48212 — BackdropFilter
                    // ignores an ancestor's scroll clip). In the tight
                    // landscape layout the frontier row sits right at that
                    // edge, making the bleed obvious — clip it explicitly.
                    child: ClipRect(
                      child: SingleChildScrollView(
                      controller: _scrollController,
                      // Bottom pad clears the floating home button in the
                      // bottom-left corner (RootView only reserves ~56 of
                      // outer clearance now — see `_homeButtonClearance`).
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 76),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // Diamond (top, hardest) down to Bronze (bottom, floor
                        // 1) — climbing the list reads as physically climbing
                        // the tower from its base.
                        children: [
                          for (final tier in ArenaTier.values.reversed) ...[
                            Padding(padding: const EdgeInsets.only(bottom: 10), child: _TowerZoneBanner(tier: tier)),
                            for (var floor = tier.floorRange.$2; floor >= tier.floorRange.$1; floor--)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ArenaFloorRow(floor: floor, gameState: _gameState, onFight: _attemptFight),
                              ),
                          ],
                        ],
                      ),
                    ),
                    ),
                  ),
                ),
              ],
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
          Text(l.navEndlessTrial, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          const SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }

  Widget _progressCard() {
    final l = AppLocalizations.of(context);
    final tier = _gameState.arenaTier;
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.25), shape: BoxShape.circle),
            child: Icon(sfSymbol(tier.symbol), size: 20, color: dk_theme.Theme.gold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tier.displayName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  l.arenaFloorProgress(_gameState.arenaFloor.clamp(0, _gameState.arenaMaxFloor), _gameState.arenaMaxFloor),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Semantics(
                label: l.arenaTicketsSemantic(_gameState.arenaTicketsRemainingToday, ArenaSystem.maxTicketsPerDay),
                child: ExcludeSemantics(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(sfSymbol('ticket.fill'), size: 12, color: dk_theme.Theme.softBlue),
                      const SizedBox(width: 5),
                      Text(
                        '${_gameState.arenaTicketsRemainingToday}/${ArenaSystem.maxTicketsPerDay}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              if (_gameState.arenaBonusTickets > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    l.arenaBonusTickets(_gameState.arenaBonusTickets),
                    style: TextStyle(color: dk_theme.Theme.softBlue.withValues(alpha: 0.85), fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _towerClearedBanner() {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.6), width: 1.5),
      ),
      child: dk_theme.GlassCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: dk_theme.Theme.gold.withValues(alpha: 0.35),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.6), blurRadius: 10)],
              ),
              child: Icon(sfSymbol('crown.fill'), size: 18, color: dk_theme.Theme.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.arenaTowerCleared, style: TextStyle(color: dk_theme.Theme.gold, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    l.arenaTowerClearedBody,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header shown once per `ArenaTier`, between that tier's block of
/// floor rows — the tier's `ArenaTower_*` backdrop art under a tier-tinted
/// gradient scrim where art exists (`ArenaArt.hasArt`), or just the tinted
/// gradient alone otherwise, so climbing the list reads as ascending through
/// distinct zones of one building instead of scrolling a flat,
/// undifferentiated list.
class _TowerZoneBanner extends StatelessWidget {
  final ArenaTier tier;
  const _TowerZoneBanner({required this.tier});

  LinearGradient get _tierGradient {
    switch (tier) {
      case ArenaTier.bronze:
        return const LinearGradient(
          colors: [Color.fromRGBO(140, 89, 46, 1), Color.fromRGBO(77, 48, 26, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case ArenaTier.silver:
        return const LinearGradient(
          colors: [Color.fromRGBO(184, 189, 199, 1), Color.fromRGBO(102, 107, 117, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case ArenaTier.gold:
        return LinearGradient(
          colors: [dk_theme.Theme.gold, const Color.fromRGBO(128, 92, 20, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case ArenaTier.platinum:
        return const LinearGradient(
          colors: [Color.fromRGBO(173, 224, 235, 1), Color.fromRGBO(71, 122, 135, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case ArenaTier.diamond:
        return LinearGradient(
          colors: [dk_theme.Theme.softBlue, dk_theme.Theme.violet],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          if (dk_theme.ArenaArt.hasArt(tier))
            Positioned.fill(child: Image.asset(dk_theme.ArenaArt.assetName(tier), fit: BoxFit.cover)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: dk_theme.ArenaArt.hasArt(tier)
                    ? LinearGradient(
                        colors: [_tierGradient.colors.first.withValues(alpha: 0.55), _tierGradient.colors.last.withValues(alpha: 0.75)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : _tierGradient,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
                  child: Icon(sfSymbol(tier.symbol), size: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.zoneName,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      AppLocalizations.of(context).arenaFloorsRange(tier.floorRange.$1, tier.floorRange.$2),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600),
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

/// One floor's row in the Tower list. Shows the exact first-clear reward
/// (deterministic — see `ArenaSystem.firstClearEquipment`) for a floor not
/// yet cleared, or the smaller repeatable standard reward for one that's
/// already been beaten, so a player can scan the whole list for the gear
/// they're after before spending a ticket.
class _ArenaFloorRow extends StatelessWidget {
  final int floor;
  final GameState gameState;
  final ValueChanged<int> onFight;

  const _ArenaFloorRow({required this.floor, required this.gameState, required this.onFight});

  bool get _isUnlocked => gameState.isFloorUnlocked(floor);
  bool get _isCleared => gameState.isFloorCleared(floor);
  bool get _isFrontier => floor == gameState.arenaFloor;
  bool get _isMilestone => ArenaSystem.isMilestoneFloor(floor);
  ArenaOpponent get _opponent => gameState.arenaOpponent(floor);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final definition = _isUnlocked ? gameState.catalog.definition(_opponent.definitionID) : null;
    return Opacity(
      opacity: _isUnlocked ? 1 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
          border: Border.all(color: _isFrontier ? dk_theme.Theme.gold.withValues(alpha: 0.55) : Colors.transparent, width: 1.5),
        ),
        child: dk_theme.GlassCard(
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _isUnlocked ? definition?.rarity.gradient : null,
                  color: _isUnlocked ? (definition == null ? dk_theme.Theme.violet.withValues(alpha: 0.35) : null) : Colors.white.withValues(alpha: 0.06),
                ),
                child: !_isUnlocked
                    ? Icon(sfSymbol('lock.fill'), size: 16, color: Colors.white.withValues(alpha: 0.35))
                    : (definition != null ? Icon(sfSymbol(definition.symbol), size: 18, color: Colors.white) : null),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Excluded from semantics: it's purely decorative next to
                    // the Fight/Farm button below, which already announces
                    // "Floor $floor" as its own accessible label — without
                    // this, VoiceOver would hit the same "Floor N" twice per
                    // row (once here, once on the button).
                    ExcludeSemantics(
                      child: Row(
                        children: [
                          Text(
                            l.arenaFloorLabel(floor),
                            style: TextStyle(
                              color: _isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.4),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isMilestone && !_isCleared) ...[
                            const SizedBox(width: 6),
                            Icon(sfSymbol('sparkles'), size: 11, color: dk_theme.Theme.gold),
                          ],
                          if (_isCleared) ...[
                            const SizedBox(width: 6),
                            Icon(sfSymbol('checkmark.seal.fill'), size: 11, color: Colors.green.withValues(alpha: 0.75)),
                          ],
                        ],
                      ),
                    ),
                    if (_isUnlocked) ...[
                      const SizedBox(height: 4),
                      Text(
                        l.arenaOpponentLine(_opponent.level, _opponent.name),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                      ),
                    ],
                    const SizedBox(height: 4),
                    _rewardPreview(l),
                  ],
                ),
              ),
              SizedBox(
                width: 84,
                child: Semantics(
                  label: l.arenaFloorLabel(floor),
                  button: true,
                  excludeSemantics: true,
                  child: Opacity(
                    opacity: _isUnlocked ? 1 : 0.35,
                    child: dk_theme.PrimaryButton(
                      tint: _isMilestone && !_isCleared ? dk_theme.Theme.gold : dk_theme.Theme.violet,
                      onPressed: _isUnlocked ? () => onFight(floor) : null,
                      child: Text(_isCleared ? l.arenaFarm : l.arenaFight, style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rewardPreview(AppLocalizations l) {
    if (_isCleared) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(sfSymbol('circle.hexagongrid.fill'), size: 11, color: dk_theme.Theme.gold),
          const SizedBox(width: 3),
          Text('${ArenaSystem.standardGoldReward(floor)}', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Icon(sfSymbol('shippingbox.fill'), size: 11, color: Colors.white.withValues(alpha: 0.5)),
          const SizedBox(width: 3),
          Text(l.arenaGearChance, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      );
    }
    final rarity = ArenaSystem.firstClearRarity(floor);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(sfSymbol('circle.hexagongrid.fill'), size: 11, color: dk_theme.Theme.gold),
        const SizedBox(width: 3),
        Text(
          '${ArenaSystem.firstClearGoldReward(floor)}',
          style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        Icon(sfSymbol('shippingbox.fill'), size: 11, color: rarity.primaryColor),
        const SizedBox(width: 3),
        Text(rarity.displayName, style: TextStyle(color: rarity.primaryColor, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
