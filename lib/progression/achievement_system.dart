import '../l10n/l10n.dart';
import '../models/rarity.dart';
import '../models/team.dart';
import '../models/world.dart';
import '../state/game_state.dart';
import 'login_reward_system.dart';
import 'star_fusion_system.dart';

/// One-off milestone context that isn't derivable from persistent save
/// state alone — currently just "did the battle just resolved end with the
/// party at full HP." Extend this rather than adding one-off flags to
/// `GameSave` for events that only matter for a single instant. Mirrors
/// GameCore/Progression/AchievementSystem.swift's `AchievementContext`
/// exactly.
class AchievementContext {
  final bool isPerfectClear;

  const AchievementContext({this.isPerfectClear = false});
}

/// A single unlockable milestone: static content plus the predicate that
/// decides whether it's currently true against live game state. Mirrors
/// `Achievement` exactly.
class Achievement {
  final String id;
  final String title;
  final String detail;
  final String icon;
  final bool Function(GameState state, AchievementContext context) predicate;

  const Achievement({
    required this.id,
    required this.title,
    required this.detail,
    required this.icon,
    required this.predicate,
  });

  @override
  bool operator ==(Object other) => other is Achievement && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// The full catalog of milestones plus the evaluation pass `GameState` runs
/// after any mutation that could complete one. Deliberately simple: no
/// tiers or points, just a title/detail/icon worth a celebration popup the
/// instant its predicate first turns true. Mirrors
/// GameCore/Progression/AchievementSystem.swift exactly.
class AchievementSystem {
  static final List<Achievement> all = [
    Achievement(
      id: 'first_summon',
      title: L.achFirstSummonTitle,
      detail: L.achFirstSummonDetail,
      icon: 'sparkles',
      predicate: (state, _) => state.roster.length >= 2,
    ),
    Achievement(
      id: 'first_legendary',
      title: L.achFirstLegendaryTitle,
      detail: L.achFirstLegendaryDetail,
      icon: 'star.circle.fill',
      predicate: (state, _) =>
          state.roster.any((i) => state.definition(i)?.rarity == Rarity.legendary),
    ),
    Achievement(
      id: 'collector_5',
      title: L.achCollector5Title,
      detail: L.achCollector5Detail,
      icon: 'person.3.fill',
      predicate: (state, _) => state.ownedSpeciesCount >= 5,
    ),
    Achievement(
      id: 'collector_10',
      title: L.achCollector10Title,
      detail: L.achCollector10Detail,
      icon: 'person.3.sequence.fill',
      predicate: (state, _) => state.ownedSpeciesCount >= 10,
    ),
    Achievement(
      id: 'first_boss',
      title: L.achFirstBossTitle,
      detail: L.achFirstBossDetail,
      icon: 'flame.fill',
      predicate: (state, _) => state.save.currentStage > World.stagesPerWorld,
    ),
    Achievement(
      id: 'star_up',
      title: L.achStarUpTitle,
      detail: L.achStarUpDetail,
      icon: 'star.fill',
      predicate: (state, _) => state.roster.any((i) => i.stars >= 1),
    ),
    Achievement(
      id: 'max_stars',
      title: L.achMaxStarsTitle,
      detail: L.achMaxStarsDetail,
      icon: 'star.circle.fill',
      predicate: (state, _) => state.roster.any((i) => i.stars >= StarFusionSystem.maxStars),
    ),
    Achievement(
      id: 'full_team',
      title: L.achFullTeamTitle,
      detail: L.achFullTeamDetail(Team.maxSize),
      icon: 'shield.fill',
      predicate: (state, _) => state.deployedTeam.length >= Team.maxSize,
    ),
    Achievement(
      id: 'perfect_clear',
      title: L.achPerfectClearTitle,
      detail: L.achPerfectClearDetail,
      icon: 'shield.checkered',
      predicate: (_, context) => context.isPerfectClear,
    ),
    Achievement(
      id: 'account_level_10',
      title: L.achAccountLevel10Title,
      detail: L.achAccountLevel10Detail,
      icon: 'arrow.up.circle.fill',
      predicate: (state, _) => state.save.playerLevel >= 10,
    ),
    Achievement(
      id: 'gold_hoarder',
      title: L.achGoldHoarderTitle,
      detail: L.achGoldHoarderDetail,
      icon: 'circle.hexagongrid.fill',
      predicate: (state, _) => state.save.gold >= 5000,
    ),
    Achievement(
      id: 'monster_hunter',
      title: L.achMonsterHunterTitle,
      detail: L.achMonsterHunterDetail,
      icon: 'eye.fill',
      predicate: (state, _) => state.save.discoveredMonsters.length >= 10,
    ),
    Achievement(
      id: 'week_streak',
      title: L.achWeekStreakTitle,
      detail: L.achWeekStreakDetail,
      icon: 'calendar.badge.checkmark',
      predicate: (state, _) => state.save.loginStreakDay >= LoginRewardSystem.cycleLength,
    ),
  ];
}
