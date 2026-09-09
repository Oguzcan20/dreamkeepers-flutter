/// One day's reward in the login-streak calendar. Mirrors
/// GameCore/Progression/LoginRewardSystem.swift's `LoginRewardDay` exactly.
class LoginRewardDay {
  final int day;
  final int gold;
  final int gems;

  /// Energy granted alongside gold/gems — every day gives at least some, so
  /// logging in is always a meaningful top-up even on a gold-only day.
  final int energy;
  final String icon;

  const LoginRewardDay({
    required this.day,
    required this.gold,
    required this.gems,
    this.energy = 0,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      other is LoginRewardDay &&
      day == other.day &&
      gold == other.gold &&
      gems == other.gems &&
      energy == other.energy &&
      icon == other.icon;

  @override
  int get hashCode => Object.hash(day, gold, gems, energy, icon);
}

/// The fixed 7-day login-streak calendar. Claiming is once per calendar day;
/// missing a day resets back to Day 1 rather than losing progress mid-cycle,
/// so a lapsed player always has the same easy on-ramp back in as a brand
/// new one. Mirrors GameCore/Progression/LoginRewardSystem.swift exactly.
class LoginRewardSystem {
  static const cycleLength = 7;

  static const List<LoginRewardDay> days = [
    LoginRewardDay(day: 1, gold: 50, gems: 0, energy: 15, icon: 'circle.hexagongrid.fill'),
    LoginRewardDay(day: 2, gold: 80, gems: 0, energy: 15, icon: 'circle.hexagongrid.fill'),
    LoginRewardDay(day: 3, gold: 0, gems: 10, energy: 20, icon: 'sparkles'),
    LoginRewardDay(day: 4, gold: 120, gems: 0, energy: 15, icon: 'circle.hexagongrid.fill'),
    LoginRewardDay(day: 5, gold: 0, gems: 15, energy: 20, icon: 'sparkles'),
    LoginRewardDay(day: 6, gold: 150, gems: 0, energy: 15, icon: 'circle.hexagongrid.fill'),
    LoginRewardDay(day: 7, gold: 200, gems: 40, energy: 40, icon: 'star.circle.fill'),
  ];

  static LoginRewardDay? reward(int day) {
    for (final d in days) {
      if (d.day == day) return d;
    }
    return null;
  }
}
