import '../l10n/l10n.dart';

/// Mirrors GameCore/Progression/WeeklyMissions.swift's `WeeklyMissionID`
/// exactly.
enum WeeklyMissionID {
  clearStages,
  defeatBosses,
  performSummons,
  upgradeEquipment,
  visitShop,
}

class WeeklyMissionDefinition {
  final WeeklyMissionID id;
  final String title;
  final String icon;
  final int target;
  final int goldReward;
  final int gemReward;
  final int energyReward;

  const WeeklyMissionDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.target,
    required this.goldReward,
    required this.gemReward,
    this.energyReward = 0,
  });
}

/// Battle Pass Premium-exclusive weekly quest set — harder targets than the
/// daily missions, bigger reward, resets on a calendar-week boundary.
/// Progress accrues for every player the same way daily missions do; only
/// claiming is gated behind Premium, so nothing is lost by unlocking
/// mid-week. Mirrors GameCore/Progression/WeeklyMissions.swift exactly.
class WeeklyMissions {
  static final List<WeeklyMissionDefinition> definitions = [
    WeeklyMissionDefinition(
      id: WeeklyMissionID.clearStages,
      title: L.weeklyClearStages,
      icon: 'flag.2.crossed.fill',
      target: 15,
      goldReward: 300,
      gemReward: 20,
      energyReward: 40,
    ),
    WeeklyMissionDefinition(
      id: WeeklyMissionID.defeatBosses,
      title: L.weeklyDefeatBosses,
      icon: 'flame.fill',
      target: 5,
      goldReward: 0,
      gemReward: 30,
      energyReward: 30,
    ),
    WeeklyMissionDefinition(
      id: WeeklyMissionID.performSummons,
      title: L.weeklyPerformSummons,
      icon: 'wand.and.stars',
      target: 5,
      goldReward: 0,
      gemReward: 25,
    ),
    WeeklyMissionDefinition(
      id: WeeklyMissionID.upgradeEquipment,
      title: L.weeklyUpgradeEquipment,
      icon: 'hammer.fill',
      target: 8,
      goldReward: 200,
      gemReward: 0,
    ),
    WeeklyMissionDefinition(
      id: WeeklyMissionID.visitShop,
      title: L.weeklyVisitShop,
      icon: 'cart.fill',
      target: 3,
      goldReward: 0,
      gemReward: 15,
    ),
  ];
}
