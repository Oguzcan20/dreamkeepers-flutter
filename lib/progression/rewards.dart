/// Loot granted for clearing a stage. Boss stages pay out more. Mirrors
/// GameCore/Progression/Rewards.swift exactly.
class BattleRewards {
  final int gold;
  final int expPerSurvivor;

  /// Account (player) EXP — smaller than Dreamkeeper EXP since it only
  /// needs to move a single, much slower-growing level track.
  final int accountExp;

  const BattleRewards({
    required this.gold,
    required this.expPerSurvivor,
    required this.accountExp,
  });

  @override
  bool operator ==(Object other) =>
      other is BattleRewards &&
      gold == other.gold &&
      expPerSurvivor == other.expPerSurvivor &&
      accountExp == other.accountExp;

  @override
  int get hashCode => Object.hash(gold, expPerSurvivor, accountExp);
}

class RewardTable {
  static BattleRewards rewards({required int stage, required bool isBoss}) {
    final base = 30 + stage * 8;
    final multiplier = isBoss ? 2.2 : 1.0;
    return BattleRewards(
      gold: (base * multiplier).round(),
      expPerSurvivor: ((18 + stage * 5) * multiplier).round(),
      accountExp: ((8 + stage * 3) * multiplier).round(),
    );
  }
}

/// Dream Gems granted the first time a World's boss is cleared (see
/// `GameState.applyBattleResult`'s `wasFrontierClear` guard — replaying an
/// already-cleared boss never re-grants this, same rule as the recruit
/// grant). Every 5th completed World pays a bigger one-time bonus instead of
/// the standard amount: worlds 1-4 pay 50, world 5 pays 100, worlds 6-9 pay
/// 50 again, world 10 pays 100, and so on — never additive with the
/// standard amount, just a bigger flat payout on the milestone world.
/// Mirrors GameCore/Progression/Rewards.swift's WorldClearRewardSystem
/// exactly.
class WorldClearRewardSystem {
  static const int standardGems = 50;
  static const int milestoneGems = 100;
  static const int milestoneInterval = 5;

  static int gems({required int forCompletedWorld}) =>
      forCompletedWorld % milestoneInterval == 0 ? milestoneGems : standardGems;
}
