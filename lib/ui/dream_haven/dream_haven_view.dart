import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/dreamkeeper.dart';
import '../../progression/battle_pass_system.dart';
import '../../state/game_state.dart';
import '../../theme/adaptive_scale.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';
import 'gold_fountain_sheet.dart';
import 'login_reward_sheet.dart';
import 'missions_sheet.dart';
import 'rewarded_ad_sheet.dart';
import 'training_garden_sheet.dart';

/// The hub screen every session lands on after Main Menu: live resources,
/// the deployed team at a glance, the Season Pass banner, and the building
/// grid (Summoning Shrine, Training Garden, Gold Fountain, Observatory,
/// Arena, and a conditional Watch-Ad tile). Mirrors `DreamHavenView`
/// (UI/DreamHaven/DreamHavenView.swift) exactly, including its deliberate
/// fixed (non-scrolling) layout scaled uniformly via `AdaptiveScale` to fit
/// smaller landscape heights instead of clipping.
///
/// NOTE: the "Watch Ad" building card (rendered only when
/// `GameState.isRewardedAdAvailable`) triggers `RewardedAdSheet`, which
/// calls the real ad SDK on device — never script/automate a tap on it in
/// the Simulator or in an automated test (see `RewardedAdSheet`'s doc
/// comment).
class DreamHavenView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;
  const DreamHavenView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<DreamHavenView> createState() => _DreamHavenViewState();
}

class _DreamHavenViewState extends State<DreamHavenView> {
  bool _appeared = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  void _openSheet(Widget Function(BuildContext) builder) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    return Stack(
      children: [
        const dk_theme.AmbientBackground(),
        AnimatedBuilder(
          animation: state,
          builder: (context, _) => AnimatedOpacity(
            opacity: _appeared ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _header(state),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 280,
                          child: Column(
                            children: [
                              _teamSnapshotCard(state),
                              const SizedBox(height: 10),
                              _battlePassBanner(state),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _buildingsGrid(state)),
                      ],
                    ),
                  ),
                ),
                _footer(state),
              ],
            ),
          ),
        ),
      ],
    ).adaptiveScale();
  }

  // MARK: - Header

  Widget _header(GameState state) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [dk_theme.Theme.deepNavy.withValues(alpha: 0.5), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.14), width: 1)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.navDreamHaven, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(l.havenPlayerLevel(state.save.playerLevel), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
            ],
          ),
          const Spacer(),
          _iconButton(
            key: const Key('dream-haven-header-profile'),
            icon: 'person.crop.circle.fill',
            label: l.profileTitle,
            onTap: () => widget.onNavigate(const ProfileRoute()),
          ),
          const SizedBox(width: 8),
          _iconButton(
            key: const Key('dream-haven-header-settings'),
            icon: 'gearshape.fill',
            label: l.settingsTitle,
            onTap: () => widget.onNavigate(const SettingsRoute()),
          ),
          const SizedBox(width: 8),
          _iconButton(
            key: const Key('dream-haven-header-shop'),
            icon: 'cart.fill',
            label: l.navShop,
            onTap: () => widget.onNavigate(const ShopRoute()),
          ),
          const SizedBox(width: 8),
          _iconButton(
            key: const Key('dream-haven-header-missions'),
            icon: 'flag.checkered',
            label: l.navDailyMissions,
            badge: state.hasUnclaimedMissions,
            onTap: () => _openSheet((_) => MissionsSheet(gameState: state)),
          ),
          const SizedBox(width: 8),
          _iconButton(
            key: const Key('dream-haven-header-loginreward'),
            icon: 'gift.fill',
            label: l.navDailyLoginBonus,
            badge: state.isLoginRewardAvailable,
            onTap: () => _openSheet((_) => LoginRewardSheet(gameState: state)),
          ),
          const SizedBox(width: 10),
          _resourceBar(state),
        ],
      ),
    );
  }

  Widget _iconButton({Key? key, required String icon, required String label, required VoidCallback onTap, bool badge = false}) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Semantics(
        label: label,
        button: true,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: Icon(sfSymbol(icon), color: Colors.white, size: 18),
            ),
            if (badge)
              Positioned(
                top: -2,
                right: -2,
                child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: dk_theme.Theme.gold, shape: BoxShape.circle)),
              ),
          ],
        ),
      ),
    );
  }

  /// Gold/Gems/Energy as one merged capsule instead of three stacked
  /// `ResourcePill`s. Mirrors `resourceBar` exactly.
  Widget _resourceBar(GameState state) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _resourceItem('circle.hexagongrid.fill', '${state.save.gold}', dk_theme.Theme.gold, l.resGold),
          _resourceDivider(),
          _resourceItem('sparkles', '${state.save.dreamGems}', dk_theme.Theme.violet, l.resDreamGems),
          _resourceDivider(),
          _resourceItem('bolt.fill', '${state.energy}/${state.maxEnergy}', dk_theme.Theme.softBlue, l.resEnergy),
        ],
      ),
    );
  }

  Widget _resourceItem(String icon, String value, Color tint, String label) {
    return Semantics(
      label: '$value $label',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol(icon), size: 12, color: tint),
            const SizedBox(width: 5),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _resourceDivider() => Container(width: 1, height: 15, color: Colors.white.withValues(alpha: 0.14));

  // MARK: - Team Snapshot

  int _teamPower(GameState state) {
    var total = 0;
    for (final instance in state.deployedTeam) {
      final stats = state.currentStats(instance);
      total += (stats.hp / 10 + stats.attack + stats.defense + stats.speed).toInt();
    }
    return total;
  }

  Widget _teamSnapshotCard(GameState state) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      key: const Key('dream-haven-team-card'),
      onTap: () => widget.onNavigate(const TeamRoute()),
      child: dk_theme.GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(sfSymbol('shield.lefthalf.filled'), size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(l.havenYourTeam, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                Icon(sfSymbol('chevron.right'), size: 14, color: Colors.white.withValues(alpha: 0.35)),
              ],
            ),
            const SizedBox(height: 8),
            if (state.deployedTeam.isEmpty)
              Row(
                children: [
                  Icon(sfSymbol('person.fill.badge.plus'), color: dk_theme.Theme.softBlue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.havenNoTeam,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11),
                    ),
                  ),
                ],
              )
            else ...[
              Row(
                children: [
                  for (final instance in state.deployedTeam.take(5)) ...[
                    _TeamAvatar(definition: state.definition(instance)!),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(sfSymbol('bolt.fill'), size: 10, color: dk_theme.Theme.gold),
                  const SizedBox(width: 4),
                  Text(l.havenTeamPower(_teamPower(state)), style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _battlePassBanner(GameState state) {
    final l = AppLocalizations.of(context);
    final progress = state.battlePassProgress;
    final fraction = progress.needed > 0 ? progress.current / progress.needed : 0.0;
    return GestureDetector(
      key: const Key('dream-haven-battlepass-banner'),
      onTap: () => widget.onNavigate(const BattlePassRoute()),
      child: Semantics(
        label: l.havenSeasonPassSemantic(state.battlePassTier, BattlePassSystem.tierCount),
        button: true,
        child: dk_theme.GlassCard(
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.18), shape: BoxShape.circle)),
                  Icon(sfSymbol('rosette'), color: dk_theme.Theme.gold, size: 22),
                  if (state.hasUnclaimedBattlePassRewards)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: dk_theme.Theme.gold, shape: BoxShape.circle)),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.havenSeasonPass, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(l.havenTier(state.battlePassTier, BattlePassSystem.tierCount), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10)),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: fraction.clamp(0, 1).toDouble(),
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        color: dk_theme.Theme.gold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(sfSymbol('chevron.right'), size: 14, color: Colors.white.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - Buildings grid

  Widget _buildingsGrid(GameState state) {
    final l = AppLocalizations.of(context);
    final cards = <Widget>[
      _BuildingCard(
        key: const Key('dream-haven-building-summon'),
        icon: 'sparkles',
        name: l.navSummoningShrine,
        status: l.havenGemsAmount(state.save.dreamGems),
        isActive: true,
        isReady: false,
        delay: 0,
        accent: dk_theme.Theme.violet,
        onTap: () => widget.onNavigate(const SummonRoute()),
      ),
      _BuildingCard(
        key: const Key('dream-haven-building-training'),
        icon: 'leaf.arrow.circlepath',
        name: l.navTrainingGarden,
        status: state.pendingTrainingGardenReward > 0 ? l.havenExpReady(state.pendingTrainingGardenReward) : l.havenTapToCollect,
        isActive: true,
        isReady: state.pendingTrainingGardenReward > 0,
        delay: 50,
        onTap: () => _openSheet((_) => TrainingGardenSheet(gameState: state)),
      ),
      _BuildingCard(
        key: const Key('dream-haven-building-gold'),
        icon: 'circle.hexagongrid.fill',
        name: l.navGoldFountain,
        status: state.pendingGoldFountainReward > 0 ? l.havenGoldReady(state.pendingGoldFountainReward) : l.havenTapToCollect,
        isActive: true,
        isReady: state.pendingGoldFountainReward > 0,
        delay: 100,
        onTap: () => _openSheet((_) => GoldFountainSheet(gameState: state)),
      ),
      _BuildingCard(
        key: const Key('dream-haven-building-observatory'),
        icon: 'sparkle.magnifyingglass',
        name: l.navObservatory,
        status: l.havenDiscovered(state.bestiaryDiscoveredCount, state.bestiaryTotalCount),
        isActive: true,
        isReady: false,
        delay: 150,
        onTap: () => widget.onNavigate(const ObservatoryRoute()),
      ),
      _BuildingCard(
        key: const Key('dream-haven-building-arena'),
        icon: state.arenaTier.symbol,
        name: l.navEndlessTrial,
        status: l.havenFloor(state.arenaFloor, state.arenaMaxFloor),
        isActive: true,
        isReady: false,
        delay: 180,
        accent: dk_theme.Theme.gold,
        onTap: () => widget.onNavigate(const ArenaRoute()),
      ),
      _BuildingCard(
        key: const Key('dream-haven-building-dungeon'),
        icon: 'square.grid.3x3.fill',
        name: l.navDungeons,
        status: l.havenDungeonKeys(state.dungeonKeysRemainingToday, state.maxDungeonKeysPerDay),
        isActive: true,
        isReady: state.dungeonKeysRemainingToday > 0,
        delay: 210,
        accent: dk_theme.Theme.violet,
        onTap: () => widget.onNavigate(const DungeonRoute()),
      ),
      if (state.isRewardedAdAvailable)
        _BuildingCard(
          key: const Key('dream-haven-building-watchad'),
          icon: 'play.rectangle.fill',
          name: l.navWatchAd,
          status: l.havenWatchAdStatus(
            GameState.rewardedAdGold,
            GameState.rewardedAdGems,
            state.rewardedAdWatchesRemainingToday,
            GameState.maxRewardedAdsPerDay,
          ),
          isActive: true,
          isReady: true,
          delay: 200,
          onTap: () => _openSheet((_) => RewardedAdSheet(gameState: state)),
        ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.55,
      children: cards,
    );
  }

  // MARK: - Footer

  Widget _footer(GameState state) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, dk_theme.Theme.deepNavy.withValues(alpha: 0.6), dk_theme.Theme.deepNavy],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.14), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            key: const Key('dream-haven-footer-inventory'),
            child: dk_theme.PrimaryButton(
              tint: dk_theme.Theme.softBlue,
              onPressed: () => widget.onNavigate(const TeamRoute()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(sfSymbol('person.3.fill'), size: 16, color: Colors.white), const SizedBox(width: 8), Text(l.navInventory)],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            key: const Key('dream-haven-footer-campaign'),
            child: dk_theme.PrimaryButton(
              tint: dk_theme.Theme.violet,
              onPressed: state.deployedTeam.isEmpty ? null : () => widget.onNavigate(const CampaignRoute()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(sfSymbol('map.fill'), size: 16, color: Colors.white), const SizedBox(width: 8), Text(l.navCampaign)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small circular portrait used in `_teamSnapshotCard` — real art when
/// available, otherwise the rarity-gradient + symbol fallback used across
/// the app. Mirrors the private `TeamAvatar` exactly (`DreamkeeperArt.hasArt`
/// takes a positional `String` here, unlike Swift's labeled `for:` — see
/// `lib/theme/theme.dart`'s `_ArtLookup`).
class _TeamAvatar extends StatelessWidget {
  final DreamkeeperDefinition definition;
  const _TeamAvatar({required this.definition});

  bool get _hasArt => dk_theme.DreamkeeperArt.hasArt(definition.artName);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        gradient: _hasArt ? null : definition.rarity.gradient,
        shape: BoxShape.circle,
        border: Border.all(color: definition.rarity.primaryColor, width: 1.5),
        boxShadow: definition.rarity.glows
            ? [BoxShadow(color: definition.rarity.primaryColor.withValues(alpha: 0.5), blurRadius: 5)]
            : null,
      ),
      alignment: Alignment.center,
      child: _hasArt
          ? ClipOval(child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.artName), width: 38, height: 38, fit: BoxFit.cover))
          : Icon(sfSymbol(definition.symbol), size: 15, color: Colors.white),
    );
  }
}

class _BuildingCard extends StatefulWidget {
  final String icon;
  final String name;
  final String status;
  final bool isActive;
  final bool isReady;
  final int delay;
  final Color? accent;
  final VoidCallback? onTap;

  const _BuildingCard({
    super.key,
    required this.icon,
    required this.name,
    required this.status,
    required this.isActive,
    required this.isReady,
    required this.delay,
    this.accent,
    this.onTap,
  });

  @override
  State<_BuildingCard> createState() => _BuildingCardState();
}

class _BuildingCardState extends State<_BuildingCard> with SingleTickerProviderStateMixin {
  bool _appeared = false;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));
    if (widget.isReady) _pulseController.repeat(reverse: true);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) setState(() => _appeared = true);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    return Semantics(
      label: widget.name,
      value: widget.status,
      button: widget.isActive,
      child: GestureDetector(
        onTap: widget.isActive ? widget.onTap : null,
        child: AnimatedScale(
          scale: _appeared ? 1 : 0.9,
          duration: const Duration(milliseconds: 250),
          child: AnimatedOpacity(
            opacity: (_appeared ? 1.0 : 0.0) * (widget.isActive ? 1.0 : 0.6),
            duration: const Duration(milliseconds: 250),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: dk_theme.Theme.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.isReady ? dk_theme.Theme.gold.withValues(alpha: 0.5) : (accent?.withValues(alpha: 0.45) ?? dk_theme.Theme.cardStroke),
                  width: widget.isReady || accent != null ? 1.25 : 1,
                ),
                boxShadow: widget.isReady
                    ? [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))]
                    : (accent != null ? [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        if (widget.isReady)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, _) => Opacity(
                              opacity: 0.4 + _pulseController.value * 0.5,
                              child: Transform.scale(
                                scale: 0.9 + _pulseController.value * 0.35,
                                child: Container(width: 26, height: 26, decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.35), shape: BoxShape.circle)),
                              ),
                            ),
                          )
                        else if (accent != null)
                          Container(width: 26, height: 26, decoration: BoxDecoration(color: accent.withValues(alpha: 0.3), shape: BoxShape.circle)),
                        Icon(sfSymbol(widget.icon), size: 18, color: accent ?? (widget.isActive ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.4))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Name + status together get whatever vertical space is
                  // left in the card (`Expanded`), each on a `Flexible` of
                  // its own — the Swift original relies on
                  // `.minimumScaleFactor` to shrink text that would
                  // otherwise overflow a fixed-height card; Flutter has no
                  // built-in equivalent for wrapped multi-line text, so this
                  // instead reallocates space between the two labels
                  // (falling back to their own `maxLines`/ellipsis) rather
                  // than ever overflowing the card.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            widget.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Flexible(
                          child: Text(
                            widget.status,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: widget.isReady ? dk_theme.Theme.gold : (widget.isActive ? dk_theme.Theme.softBlue : Colors.white.withValues(alpha: 0.4)),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
