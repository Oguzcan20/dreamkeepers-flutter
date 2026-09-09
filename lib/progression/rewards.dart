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
