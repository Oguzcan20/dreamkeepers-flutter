/// Passive resource accrual for the Gold Fountain (gold) and Training Garden
/// (EXP) buildings. Both accrue at a flat per-minute rate up to a cap so
/// players are rewarded for checking in without needing to stay online.
/// Mirrors GameCore/Progression/OfflineRewards.swift exactly.
class OfflineRewards {
  static const maxAccrualSeconds = 8 * 3600;
  static const goldPerMinute = 6;
  static const expPerMinute = 4;

  static double accruedSeconds({required DateTime lastCollected, DateTime? now}) {
    final n = now ?? DateTime.now();
    final elapsed = n.difference(lastCollected).inMilliseconds / 1000.0;
    return elapsed.clamp(0, maxAccrualSeconds.toDouble());
  }

  static int pendingGold({required DateTime lastCollected, DateTime? now}) {
    final seconds = accruedSeconds(lastCollected: lastCollected, now: now);
    return (seconds / 60 * goldPerMinute).toInt();
  }

  static int pendingExp({required DateTime lastCollected, DateTime? now}) {
    final seconds = accruedSeconds(lastCollected: lastCollected, now: now);
    return (seconds / 60 * expPerMinute).toInt();
  }
}
