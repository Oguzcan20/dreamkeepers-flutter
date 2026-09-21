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
import '../rebirth/rebirth_sheet.dart';
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
                AnimatedOpacity(
                  opacity: _appeared ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: _rebirthCard(),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(sfSymbol(tier.symbol), size: 16, color: dk_theme.Theme.gold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tier.displayName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                Text(
                  l.arenaFloorProgress(_gameState.arenaFloor.clamp(0, _gameState.arenaMaxFloor), _gameState.arenaMaxFloor),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
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
                      Icon(sfSymbol('ticket.fill'), size: 11, color: dk_theme.Theme.softBlue.withValues(alpha: 0.8)),
                      const SizedBox(width: 5),
                      Text(
                        '${_gameState.arenaTicketsRemainingToday}/${ArenaSystem.maxTicketsPerDay}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              if (_gameState.arenaBonusTickets > 0)
                Text(
                  l.arenaBonusTickets(_gameState.arenaBonusTickets),
                  style: TextStyle(color: dk_theme.Theme.softBlue.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _openRebirthSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RebirthSheet(gameState: _gameState),
    );
  }

  /// Entry point to the Prestige / Rebirth ("Wiedergeburt") sheet — a
  /// Flutter-only system with no Swift original. Unlocked/actionable state
  /// is surfaced with the gold accent; otherwise it reads as a locked hint.
  Widget _rebirthCard() {
    final l = AppLocalizations.of(context);
    final canRebirth = _gameState.canRebirth;
    return GestureDetector(
      onTap: _openRebirthSheet,
      child: dk_theme.GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: dk_theme.Theme.violet.withValues(alpha: canRebirth ? 0.3 : 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(sfSymbol('flame.fill'), size: 15, color: dk_theme.Theme.violet.withValues(alpha: canRebirth ? 1 : 0.7)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.rebirthTitle, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(
                    canRebirth
                        ? l.rebirthGainPreview(_gameState.pendingRebirthSoulPoints)
                        : l.rebirthEntrySubtitle,
                    style: TextStyle(
                      color: canRebirth ? dk_theme.Theme.gold.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.45),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(sfSymbol('flame.fill'), size: 11, color: dk_theme.Theme.violet.withValues(alpha: 0.8)),
                const SizedBox(width: 5),
                Text('${_gameState.soulPoints}',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                Icon(sfSymbol('chevron.right'), size: 11, color: Colors.white.withValues(alpha: 0.35)),
              ],
            ),
          ],
        ),
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
      height: 56,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (dk_theme.ArenaArt.hasArt(tier))
            Positioned.fill(child: Image.asset(dk_theme.ArenaArt.assetName(tier), fit: BoxFit.cover)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_tierGradient.colors.first.withValues(alpha: 0.65), _tierGradient.colors.last.withValues(alpha: 0.85)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(sfSymbol(tier.symbol), size: 14, color: Colors.white.withValues(alpha: 0.9)),
                const SizedBox(width: 8),
                Text(
                  tier.zoneName,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).arenaFloorsRange(tier.floorRange.$1, tier.floorRange.$2),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w600),
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
    // A locked, non-milestone floor collapses to a slim placeholder instead
    // of the full card below — with 96 of the tower's 100 floors
    // non-milestone, rendering every one of them at full detail (opponent,
    // reward preview, button) before the player can even fight them buried
    // the handful of rows that actually matter — the current frontier and
    // already-cleared floors — in a wall of near-identical cards. Milestone
    // floors (every 25th, legendary reward) keep the full card as a teaser.
    if (!_isUnlocked && !_isMilestone) return _lockedFiller(l);
    // Full-detail floors (frontier, cleared, milestones) share the locked
    // filler's plain, unblurred `Container` chrome rather than `GlassCard` —
    // the goal is a calm, uniform list where the bold floor number is the
    // one thing that stands out per row, not a wall of colorful badges,
    // rarity-gradient avatars, and opponent names competing for attention.
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _isUnlocked ? 0.045 : 0.02),
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(
          color: _isFrontier ? dk_theme.Theme.gold.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.07),
          width: _isFrontier ? 1.5 : 1,
        ),
      ),
      child: Opacity(
        opacity: _isUnlocked ? 1 : 0.6,
        child: Row(
          children: [
            // Excluded from semantics: it's purely decorative next to the
            // Fight/Farm button below, which already announces
            // "Floor $floor" as its own accessible label.
            Expanded(
              child: ExcludeSemantics(
                child: Row(
                  children: [
                    Text(
                      l.arenaFloorLabel(floor),
                      style: TextStyle(
                        color: _isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.4),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (_isMilestone && !_isCleared) ...[
                      const SizedBox(width: 6),
                      Icon(sfSymbol('sparkles'), size: 11, color: dk_theme.Theme.gold.withValues(alpha: 0.8)),
                    ],
                    if (_isCleared) ...[
                      const SizedBox(width: 6),
                      Icon(sfSymbol('checkmark.seal.fill'), size: 11, color: Colors.white.withValues(alpha: 0.3)),
                    ],
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _rewardLine(l),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 64,
              child: Semantics(
                label: l.arenaFloorLabel(floor),
                button: true,
                excludeSemantics: true,
                child: Opacity(
                  opacity: _isUnlocked ? 1 : 0.35,
                  child: dk_theme.PrimaryButton(
                    tint: _isMilestone && !_isCleared ? dk_theme.Theme.gold : dk_theme.Theme.violet,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    onPressed: _isUnlocked ? () => onFight(floor) : null,
                    child: Text(_isCleared ? l.arenaFarm : l.arenaFight, style: const TextStyle(fontSize: 11)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compact stand-in for a locked, non-milestone floor — just a lock icon
  /// and the floor number, no card chrome, no `BackdropFilter` (100 of
  /// those in one scroll view was also unnecessary GPU cost for rows the
  /// player can't act on yet).
  Widget _lockedFiller(AppLocalizations l) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(sfSymbol('lock.fill'), size: 12, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(width: 10),
          Text(
            l.arenaFloorLabel(floor),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// A single muted line combining the opponent and the reward — kept
  /// deliberately plain (no gold/rarity coloring) so it recedes behind the
  /// bold floor number rather than competing with it for attention.
  String _rewardLine(AppLocalizations l) {
    final gold = _isCleared ? ArenaSystem.standardGoldReward(floor) : ArenaSystem.firstClearGoldReward(floor);
    final rewardLabel = _isCleared ? l.arenaGearChance : ArenaSystem.firstClearRarity(floor).displayName;
    final reward = '$gold · $rewardLabel';
    // A locked milestone floor is a teaser — it shows the reward it's
    // guarding but not the opponent, same as the original full card.
    if (!_isUnlocked) return reward;
    return '${l.arenaOpponentLine(_opponent.level, _opponent.name)} · $reward';
  }
}
