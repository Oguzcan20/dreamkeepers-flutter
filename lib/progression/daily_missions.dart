/// Mirrors GameCore/Progression/DailyMissions.swift's `MissionID` exactly.
enum MissionID {
  winBattle,
  performSummon,
  collectBuilding,
  upgradeEquipment,
  spendInShop,
  defeatBoss,
  deployFullTeam,
  premiumBonusStages,
  premiumBonusSummons,
}

class MissionDefinition {
  final MissionID id;
  final String title;
  final String icon;
  final int target;
  final int goldReward;
  final int gemReward;

  /// Energy granted on claim — a small comeback source so a stamina-empty
  /// player still has a free way back in besides waiting or spending gems.
  final int energyReward;

  /// Battle Pass Premium-exclusive bonus mission — tracked like any other
  /// daily mission, but only claimable (and only shown as available,
  /// rather than locked) once Premium is unlocked.
  final bool isPremiumOnly;

  const MissionDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.target,
    required this.goldReward,
    required this.gemReward,
    this.energyReward = 0,
    this.isPremiumOnly = false,
  });
}

/// Quest pool. Progress and claims live on the save, keyed by
/// `MissionID.name`, and reset once the stored day no longer matches
/// today. The 7 free-tier missions are a rotation pool, not a fixed daily
/// set — each day draws `activeCount` of them at random (see `drawDaily`)
/// so the board isn't identical every day. Premium bonus missions aren't
/// part of the rotation; they're always shown (locked until Premium is
/// unlocked), same as before. Mirrors
/// GameCore/Progression/DailyMissions.swift exactly.
class DailyMissions {
  /// How many of the 7 free-tier missions are active on a given day.
  static const activeCount = 4;

  static const List<MissionDefinition> definitions = [
    MissionDefinition(
      id: MissionID.winBattle,
      title: 'Clear a Stage',
      icon: 'flag.checkered',
      target: 1,
      goldReward: 40,
      gemReward: 0,
      energyReward: 10,
    ),
    MissionDefinition(
      id: MissionID.performSummon,
      title: 'Summon a Dreamkeeper',
      icon: 'sparkles',
      target: 1,
      goldReward: 0,
      gemReward: 5,
    ),
    MissionDefinition(
      id: MissionID.collectBuilding,
      title: 'Collect from a Building',
      icon: 'hand.tap.fill',
      target: 1,
      goldReward: 30,
      gemReward: 0,
    ),
    MissionDefinition(
      id: MissionID.upgradeEquipment,
      title: 'Upgrade a Piece of Gear',
      icon: 'hammer.fill',
      target: 1,
      goldReward: 0,
      gemReward: 6,
    ),
    MissionDefinition(
      id: MissionID.spendInShop,
      title: 'Visit the Shop',
      icon: 'cart.fill',
      target: 1,
      goldReward: 25,
      gemReward: 0,
    ),
    MissionDefinition(
      id: MissionID.defeatBoss,
      title: 'Defeat a Boss',
      icon: 'flame.fill',
      target: 1,
      goldReward: 0,
      gemReward: 10,
      energyReward: 15,
    ),
    MissionDefinition(
      id: MissionID.deployFullTeam,
      title: 'Field a Full Team',
      icon: 'person.3.fill',
      target: 1,
      goldReward: 20,
      gemReward: 0,
    ),
    MissionDefinition(
      id: MissionID.premiumBonusStages,
      title: 'Clear 3 Stages',
      icon: 'flag.2.crossed.fill',
      target: 3,
      goldReward: 80,
      gemReward: 8,
      energyReward: 20,
      isPremiumOnly: true,
    ),
    MissionDefinition(
      id: MissionID.premiumBonusSummons,
      title: 'Summon 3 Dreamkeepers',
      icon: 'wand.and.stars',
      target: 3,
      goldReward: 0,
      gemReward: 15,
      isPremiumOnly: true,
    ),
  ];

  /// The free-tier rotation pool — every mission that isn't a Premium
  /// bonus. Exactly 7 today; `drawDaily` picks `activeCount` of these.
  static final List<MissionID> rotatingPool =
      definitions.where((d) => !d.isPremiumOnly).map((d) => d.id).toList();

  /// Picks today's active free-tier missions at random. Called once per
  /// calendar day, which persists the result — this itself is stateless so
  /// the same day never has to re-derive a matching draw from a seed.
  static List<String> drawDaily() {
    final shuffled = List<MissionID>.from(rotatingPool)..shuffle();
    return shuffled.take(activeCount).map((id) => id.name).toList();
  }
}
