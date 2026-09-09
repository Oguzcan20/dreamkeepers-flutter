/// A season's worth of tiered rewards along two tracks (free and premium).
/// Pure, testable math — GameState owns persistence, the Battle Pass screen
/// owns presentation. Mirrors GameCore/Progression/BattlePassSystem.swift
/// exactly.
class BattlePassSystem {
  static const tierCount = 20;
  static const xpPerTier = 120;

  /// Flat Battle Pass XP granted per battle win, independent of stage —
  /// keeps season pacing predictable regardless of which stage is farmed.
  static int xpGained({required bool isBoss}) => isBoss ? 40 : 15;

  /// The highest tier unlocked by `xp`, clamped to `tierCount`. Tier 0
  /// means no tier has been reached yet.
  static int tier(int xp) {
    final t = xp ~/ xpPerTier;
    return t < tierCount ? t : tierCount;
  }

  /// XP progress within the current (not yet completed) tier, for a
  /// progress bar toward the next one.
  static (int current, int needed) progressWithinTier(int xp) {
    if (tier(xp) >= tierCount) return (xpPerTier, xpPerTier);
    return (xp % xpPerTier, xpPerTier);
  }

  static Reward freeReward(int tier) =>
      Reward(gold: 40 * tier, gems: 0, tickets: tier % 10 == 0 ? 3 : 0);

  static Reward premiumReward(int tier) {
    final milestoneBonus = tier % 5 == 0 ? 30 : 0;
    final tickets = tier % 5 == 0 ? 5 : 0;
    return Reward(gold: 25 * tier, gems: 10 + milestoneBonus, tickets: tickets);
  }
}

class Reward {
  final int gold;
  final int gems;
  final int tickets;

  const Reward({required this.gold, required this.gems, this.tickets = 0});

  @override
  bool operator ==(Object other) =>
      other is Reward && gold == other.gold && gems == other.gems && tickets == other.tickets;

  @override
  int get hashCode => Object.hash(gold, gems, tickets);
}
