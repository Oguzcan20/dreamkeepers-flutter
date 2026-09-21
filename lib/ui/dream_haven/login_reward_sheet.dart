import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../progression/login_reward_system.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;

enum _LoginRewardDayState { claimed, current, locked }

/// The daily login-streak calendar: 7 escalating rewards, one claim per
/// calendar day, streak resets to Day 1 if a day is skipped. Reachable two
/// ways — auto-presented once per launch from `RootView` the moment it's
/// available (not yet wired — see `RootView`'s doc comment), and any time
/// after via the gift button in `DreamHavenView`'s header, so dismissing the
/// auto-popup without claiming never loses it. Mirrors `LoginRewardSheet`
/// (UI/DreamHaven/LoginRewardSheet.swift) exactly.
class LoginRewardSheet extends StatelessWidget {
  final GameState gameState;
  const LoginRewardSheet({super.key, required this.gameState});

  int get _nextDay => gameState.nextLoginRewardDay;
  bool get _isAvailable => gameState.isLoginRewardAvailable;

  String _dayCaption(AppLocalizations l) => _isAvailable
      ? l.loginDayOfCycle(_nextDay, LoginRewardSystem.cycleLength)
      : l.loginClaimedTomorrow(_nextDay);

  _LoginRewardDayState _cellState(int day) {
    if (_isAvailable) {
      if (day < _nextDay) return _LoginRewardDayState.claimed;
      if (day == _nextDay) return _LoginRewardDayState.current;
      return _LoginRewardDayState.locked;
    }
    // Already claimed today — today's own slot still reads as claimed.
    return day <= gameState.save.loginStreakDay ? _LoginRewardDayState.claimed : _LoginRewardDayState.locked;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(gradient: dk_theme.Theme.background),
      // `showModalBottomSheet(isScrollControlled: true)` lets this sheet grow
      // up to the screen height, but with the Claim button living inside the
      // same `SingleChildScrollView` as the 7-day grid, a short landscape
      // screen (or a larger system text size) pushed the button below the
      // fold — reachable only by scrolling, which reads as broken on a
      // "collect your reward" screen. Capping the sheet at a fixed fraction
      // of the screen and pinning the button *outside* the scrollable area
      // (only the grid scrolls, if it even needs to) keeps Claim on-screen
      // and tappable the instant the sheet opens.
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 22),
              _header(l),
              const SizedBox(height: 18),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      for (final reward in LoginRewardSystem.days) _DayCell(reward: reward, state: _cellState(reward.day)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: dk_theme.PrimaryButton(
                    tint: _isAvailable ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.15),
                    onPressed: _isAvailable
                        ? () {
                            gameState.claimLoginReward();
                            Timer(const Duration(milliseconds: 700), () {
                              Navigator.of(context).pop();
                            });
                          }
                        : null,
                    child: Text(_isAvailable ? l.commonClaim : l.loginSeeYouTomorrow),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: dk_theme.Theme.gold.withValues(alpha: 0.25), shape: BoxShape.circle),
            ),
            Icon(sfSymbol('gift.fill'), size: 26, color: dk_theme.Theme.gold),
          ],
        ),
        const SizedBox(height: 10),
        Text(l.navDailyLoginBonus, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(_dayCaption(l), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final LoginRewardDay reward;
  final _LoginRewardDayState state;
  const _DayCell({required this.reward, required this.state});

  String _rewardCaption(AppLocalizations l) =>
      reward.gems > 0 ? l.commonAmountGems(reward.gems) : l.commonAmountGold(reward.gold);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locked = state == _LoginRewardDayState.locked;
    final claimed = state == _LoginRewardDayState.claimed;
    final current = state == _LoginRewardDayState.current;
    return Opacity(
      opacity: locked ? 0.55 : 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.loginDayLabel(reward.day), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: current ? dk_theme.Theme.gold.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
              border: Border.all(
                color: current ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.12),
                width: current ? 2 : 1,
              ),
            ),
            child: Icon(
              claimed ? sfSymbol('checkmark') : sfSymbol(reward.icon),
              size: 18,
              color: locked ? Colors.white.withValues(alpha: 0.3) : (claimed ? dk_theme.Theme.gold : Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _rewardCaption(l),
            style: TextStyle(color: Colors.white.withValues(alpha: locked ? 0.3 : 0.7), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
