import '../l10n/l10n.dart';

/// Prestige / Rebirth ("Wiedergeburt / Seelenpunkte").
///
/// A Flutter-only progression system with **no Swift-original counterpart** —
/// it deliberately diverges from the rest of the codebase's
/// `GameCore/...`-Swift-parity convention.
///
/// Once the Arena Tower climb reaches [rebirthFloorRequirement], the player
/// can perform a Rebirth: the tower frontier resets to floor 1 and they bank
/// [soulPointsForFloor] Seelenpunkte (Soul Points) — a permanent currency
/// spent on the four [SoulUpgrade] tracks for account-wide, multiplicative
/// bonuses. Turns the finite 100-floor tower into effectively unbounded
/// long-term progression.
///
/// Pure, testable math only — `GameState` owns persistence and the reward
/// hooks, `RebirthSheet` owns presentation.
class RebirthSystem {
  RebirthSystem._();

  /// Lowest Arena Tower frontier (`GameState.arenaFloor`) at which a Rebirth
  /// is allowed. Deliberately below `ArenaSystem.maxFloor` so a player can
  /// opt into the loop well before a full clear.
  static const int rebirthFloorRequirement = 50;

  /// Soul Points banked by a Rebirth performed at Arena frontier
  /// [arenaFloor] — one per five floors climbed. Floor 1 pays 0, so the
  /// value only ever rewards real progress.
  static int soulPointsForFloor(int arenaFloor) => (arenaFloor - 1) ~/ 5;

  /// Rank cap for [u].
  static int maxRank(SoulUpgrade u) {
    switch (u) {
      case SoulUpgrade.goldFind:
      case SoulUpgrade.expBoost:
      case SoulUpgrade.damage:
        return 10;
      case SoulUpgrade.offlineRewards:
        return 5;
    }
  }

  /// Multiplicative bonus per rank of [u] (0.04 == +4% per rank).
  static double effectPerRank(SoulUpgrade u) {
    switch (u) {
      case SoulUpgrade.goldFind:
        return 0.04;
      case SoulUpgrade.expBoost:
        return 0.04;
      case SoulUpgrade.damage:
        return 0.02;
      case SoulUpgrade.offlineRewards:
        return 0.10;
    }
  }

  /// Soul Point cost to buy rank [rank] (1-based) of [u] — escalates
  /// linearly so each track's later ranks cost progressively more.
  static int costForRank(SoulUpgrade u, int rank) => _baseCost(u) * rank;

  static int _baseCost(SoulUpgrade u) {
    switch (u) {
      case SoulUpgrade.goldFind:
      case SoulUpgrade.expBoost:
        return 2;
      case SoulUpgrade.damage:
      case SoulUpgrade.offlineRewards:
        return 3;
    }
  }

  /// The bonus multiplier [u] currently applies at [rank] — `1.0` at rank 0
  /// (i.e. no effect), climbing by [effectPerRank] each rank.
  static double effectMultiplier(SoulUpgrade u, int rank) {
    final clamped = rank.clamp(0, maxRank(u));
    return 1.0 + clamped * effectPerRank(u);
  }
}

/// The four permanent Soul Point upgrade tracks. Screenshot #7 also listed a
/// "+1 Monster-Slot" track — deliberately dropped for v1 because
/// `Team.maxSize` is a compile-time constant baked into every battle/roster
/// grid, so a variable team size is far too invasive a change to bundle here.
enum SoulUpgrade {
  goldFind,
  expBoost,
  damage,
  offlineRewards;

  /// Stable key for `GameSave.soulUpgradeRanks` — never localized.
  String get storageKey => name;

  String get displayName {
    switch (this) {
      case SoulUpgrade.goldFind:
        return L.soulUpgradeGoldFindName;
      case SoulUpgrade.expBoost:
        return L.soulUpgradeExpBoostName;
      case SoulUpgrade.damage:
        return L.soulUpgradeDamageName;
      case SoulUpgrade.offlineRewards:
        return L.soulUpgradeOfflineName;
    }
  }

  String get detail {
    switch (this) {
      case SoulUpgrade.goldFind:
        return L.soulUpgradeGoldFindDetail;
      case SoulUpgrade.expBoost:
        return L.soulUpgradeExpBoostDetail;
      case SoulUpgrade.damage:
        return L.soulUpgradeDamageDetail;
      case SoulUpgrade.offlineRewards:
        return L.soulUpgradeOfflineDetail;
    }
  }

  String get icon {
    switch (this) {
      case SoulUpgrade.goldFind:
        return 'circle.hexagongrid.fill';
      case SoulUpgrade.expBoost:
        return 'sparkles';
      case SoulUpgrade.damage:
        return 'bolt.fill';
      case SoulUpgrade.offlineRewards:
        return 'moon.stars.fill';
    }
  }
}
