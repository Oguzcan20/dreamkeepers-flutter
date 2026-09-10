import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../platform/platform_service.dart';
import '../../progression/battle_pass_system.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// Season Pass. Every battle win grants season XP; each tier unlocks a free
/// reward and, once Premium is purchased, a richer premium reward on the
/// same tier. Mirrors `BattlePassView.swift` (UI/BattlePass/BattlePassView.swift)
/// exactly.
class BattlePassView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const BattlePassView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<BattlePassView> createState() => _BattlePassViewState();
}

class _BattlePassViewState extends State<BattlePassView> {
  GameState get _gameState => widget.gameState;

  // Swift's `justClaimedID` is set on claim but never actually read by the
  // view body (no visible effect it drives, in the Swift source either) —
  // dropped here rather than carried over as genuinely dead state, since
  // keeping it would just produce an analyzer "unused field" warning for
  // zero behavior difference. `claimBattlePassReward` itself already
  // notifies `GameState`'s listeners (this widget's `AnimatedBuilder`), so
  // no local `setState` is needed to reflect the claim.
  void _claim({required int tier, required bool premium}) {
    if (!_gameState.claimBattlePassReward(tier: tier, premium: premium)) return;
    _gameState.playHaptic(HapticStyle.success);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gameState,
      builder: (context, _) {
        return Column(
          children: [
            _header(),
            Expanded(
              child: SingleChildScrollView(
                key: const Key('battle-pass-scroll'),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
                child: Column(
                  children: [
                    _xpCard(),
                    if (!_gameState.battlePassPremiumUnlocked) ...[
                      const SizedBox(height: 14),
                      _premiumUpsellCard(),
                    ],
                    const SizedBox(height: 14),
                    // A plain `Wrap` of fixed-width cards rather than a
                    // `GridView` — the tier count (20) is small and fixed,
                    // so there's no lazy-building benefit to a `GridView`
                    // here (`shrinkWrap: true` would force it to lay out
                    // every item immediately anyway), and a `GridView`
                    // always builds its own internal `Scrollable` even under
                    // `NeverScrollableScrollPhysics` — nested inside this
                    // screen's own outer `SingleChildScrollView`, that
                    // second `Scrollable` made `scrollUntilVisible`'s
                    // default ancestor search ambiguous in tests. A `Wrap`
                    // has no `Scrollable` of its own, so this screen has
                    // exactly one, like most others in the port.
                    LayoutBuilder(
                      key: const Key('battle-pass-grid'),
                      builder: (context, constraints) {
                        const spacing = 10.0;
                        final itemWidth = (constraints.maxWidth - spacing) / 2;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (var tier = 1; tier <= BattlePassSystem.tierCount; tier++)
                              SizedBox(
                                width: itemWidth,
                                child: _TierRow(
                                  tier: tier,
                                  isUnlocked: tier <= _gameState.battlePassTier,
                                  premiumUnlocked: _gameState.battlePassPremiumUnlocked,
                                  freeState: _rewardState(tier: tier, premium: false),
                                  premiumState: _rewardState(tier: tier, premium: true),
                                  onClaimFree: () => _claim(tier: tier, premium: false),
                                  onClaimPremium: () => _claim(tier: tier, premium: true),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _RewardState _rewardState({required int tier, required bool premium}) {
    if (_gameState.isBattlePassRewardClaimed(tier, premium)) return _RewardState.claimed;
    if (_gameState.canClaimBattlePassReward(tier, premium)) return _RewardState.claimable;
    return _RewardState.locked;
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
                child: const Icon(Icons.chevron_left, color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text(l.havenSeasonPass, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                l.bpTierProgress(_gameState.battlePassTier, BattlePassSystem.tierCount),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              dk_theme.ResourcePill(
                icon: sfSymbol('circle.hexagongrid.fill'),
                value: '${_gameState.save.gold}',
                tint: dk_theme.Theme.gold,
                semanticLabel: l.resGold,
              ),
              const SizedBox(height: 6),
              dk_theme.ResourcePill(
                icon: sfSymbol('sparkles'),
                value: '${_gameState.save.dreamGems}',
                tint: dk_theme.Theme.violet,
                semanticLabel: l.resDreamGems,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Makes the underlying points system legible: how much Season XP the
  /// player has right now, how much the next tier needs, and how to earn
  /// more — the tier number alone (in the header) wasn't explaining that.
  Widget _xpCard() {
    final l = AppLocalizations.of(context);
    final progress = _gameState.battlePassProgress;
    final atMaxTier = _gameState.battlePassTier >= BattlePassSystem.tierCount;
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l.bpSeasonXp, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                atMaxTier ? l.bpMaxTierReached : l.bpXpProgress(progress.current, progress.needed),
                style: TextStyle(
                  color: dk_theme.Theme.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final ratio = progress.needed == 0 ? 0.0 : progress.current / progress.needed;
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                  ),
                  Container(
                    height: 8,
                    width: (constraints.maxWidth * ratio).clamp(6, constraints.maxWidth),
                    decoration: BoxDecoration(color: dk_theme.Theme.gold, borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            l.bpXpBlurb,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _premiumUpsellCard() {
    final l = AppLocalizations.of(context);
    return Stack(
      children: [
        dk_theme.GlassCard(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Icon(sfSymbol('rosette'), size: 34, color: dk_theme.Theme.gold),
                const SizedBox(height: 10),
                Text(l.bpUnlockPremium, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Text(
                  l.bpPremiumBlurb,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
                ),
                const SizedBox(height: 10),
                dk_theme.PrimaryButton(
                  tint: dk_theme.Theme.gold,
                  onPressed: () {
                    if (!_gameState.purchaseBattlePassPremium()) return;
                    _gameState.playHaptic(HapticStyle.levelUp);
                  },
                  child: const Text('\$4.99'),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
                border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.6), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _RewardState { locked, claimable, claimed }

class _TierRow extends StatelessWidget {
  final int tier;
  final bool isUnlocked;
  final bool premiumUnlocked;
  final _RewardState freeState;
  final _RewardState premiumState;
  final VoidCallback onClaimFree;
  final VoidCallback onClaimPremium;

  const _TierRow({
    required this.tier,
    required this.isUnlocked,
    required this.premiumUnlocked,
    required this.freeState,
    required this.premiumState,
    required this.onClaimFree,
    required this.onClaimPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1 : 0.55,
      child: dk_theme.GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isUnlocked ? dk_theme.Theme.softBlue.withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$tier',
                    style: TextStyle(
                      color: isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RewardSlot(
                claimKey: Key('battle-pass-claim-$tier-free'),
                reward: BattlePassSystem.freeReward(tier),
                tint: dk_theme.Theme.softBlue,
                state: freeState,
                isLockedByPremium: false,
                onClaim: onClaimFree,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _RewardSlot(
                claimKey: Key('battle-pass-claim-$tier-premium'),
                reward: BattlePassSystem.premiumReward(tier),
                tint: dk_theme.Theme.gold,
                state: premiumState,
                isLockedByPremium: isUnlocked && !premiumUnlocked,
                onClaim: onClaimPremium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardSlot extends StatelessWidget {
  final Reward reward;
  final Color tint;
  final _RewardState state;
  final bool isLockedByPremium;
  final VoidCallback onClaim;

  /// Test-addressability key for the actual tap target (see
  /// `_stateIcon()`'s `claimable` branch) — deliberately NOT this widget's
  /// own `key`. Giving both the same `Key` produced two widgets sharing one
  /// key in the same tree, which broke `find.byKey` uniqueness.
  final Key? claimKey;

  const _RewardSlot({
    required this.reward,
    required this.tint,
    required this.state,
    required this.isLockedByPremium,
    required this.onClaim,
    this.claimKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _currencyLabel(icon: sfSymbol('circle.hexagongrid.fill'), value: reward.gold, color: dk_theme.Theme.gold),
                if (reward.gems > 0)
                  _currencyLabel(icon: sfSymbol('sparkles'), value: reward.gems, color: dk_theme.Theme.violet),
                if (reward.tickets > 0)
                  _currencyLabel(icon: sfSymbol('ticket.fill'), value: reward.tickets, color: dk_theme.Theme.softBlue),
              ],
            ),
          ),
          _stateIcon(AppLocalizations.of(context)),
        ],
      ),
    );
  }

  Widget _currencyLabel({required IconData icon, required int value, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              '$value',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stateIcon(AppLocalizations l) {
    switch (state) {
      case _RewardState.claimed:
        return Icon(sfSymbol('checkmark.circle.fill'), color: Colors.green.withValues(alpha: 0.8), size: 20);
      case _RewardState.claimable:
        // `claimKey` (`battle-pass-claim-<tier>-<free|premium>`, set by
        // `_TierRow`) is applied directly to the actual tap target rather
        // than relying on the ambiguous `Semantics(label: 'Claim tier
        // reward')` for test addressability — that label is fine for
        // VoiceOver (only one slot is ever focused at a time) but every
        // claimable slot on screen shares it, so `find.bySemanticsLabel`
        // alone can't pick out a specific tier.
        return Semantics(
          label: l.bpClaimTierReward,
          button: true,
          child: GestureDetector(
            key: claimKey,
            onTap: onClaim,
            child: Icon(sfSymbol('arrow.down.circle.fill'), color: tint, size: 20),
          ),
        );
      case _RewardState.locked:
        // Tinted gold when the tier is already reached and the only thing
        // missing is Premium — a visual nudge toward the upsell.
        return Icon(
          sfSymbol('lock.fill'),
          color: isLockedByPremium ? dk_theme.Theme.gold.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.3),
          size: 18,
        );
    }
  }
}
