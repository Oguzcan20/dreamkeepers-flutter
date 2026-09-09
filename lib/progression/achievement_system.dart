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
      title: 'First Summon',
      detail: 'Summon your first Dreamkeeper.',
      icon: 'sparkles',
      predicate: (state, _) => state.roster.length >= 2,
    ),
    Achievement(
      id: 'first_legendary',
      title: 'Legendary!',
      detail: 'Recruit a Legendary Dreamkeeper.',
      icon: 'star.circle.fill',
      predicate: (state, _) =>
          state.roster.any((i) => state.definition(i)?.rarity == Rarity.legendary),
    ),
    Achievement(
      id: 'collector_5',
      title: 'Growing Collection',
      detail: 'Own 5 different Dreamkeepers.',
      icon: 'person.3.fill',
      predicate: (state, _) => state.ownedSpeciesCount >= 5,
    ),
    Achievement(
      id: 'collector_10',
      title: 'Dream Team',
      detail: 'Own 10 different Dreamkeepers.',
      icon: 'person.3.sequence.fill',
      predicate: (state, _) => state.ownedSpeciesCount >= 10,
    ),
    Achievement(
      id: 'first_boss',
      title: 'Boss Slayer',
      detail: 'Defeat your first Boss.',
      icon: 'flame.fill',
      predicate: (state, _) => state.save.currentStage > World.stagesPerWorld,
    ),
    Achievement(
      id: 'star_up',
      title: 'Star Power',
      detail: 'Fuse a Dreamkeeper to raise its stars.',
      icon: 'star.fill',
      predicate: (state, _) => state.roster.any((i) => i.stars >= 1),
    ),
    Achievement(
      id: 'max_stars',
      title: 'Fully Ascended',
      detail: 'Raise a Dreamkeeper to max stars.',
      icon: 'star.circle.fill',
      predicate: (state, _) => state.roster.any((i) => i.stars >= StarFusionSystem.maxStars),
    ),
    Achievement(
      id: 'full_team',
      title: 'Squad Goals',
      detail: 'Deploy a full team of ${Team.maxSize}.',
      icon: 'shield.fill',
      predicate: (state, _) => state.deployedTeam.length >= Team.maxSize,
    ),
    Achievement(
      id: 'perfect_clear',
      title: 'Untouchable',
      detail: 'Win a battle without taking damage.',
      icon: 'shield.checkered',
      predicate: (_, context) => context.isPerfectClear,
    ),
    Achievement(
      id: 'account_level_10',
      title: 'Rising Dreamer',
      detail: 'Reach Account Level 10.',
      icon: 'arrow.up.circle.fill',
      predicate: (state, _) => state.save.playerLevel >= 10,
    ),
    Achievement(
      id: 'gold_hoarder',
      title: 'Gold Hoarder',
      detail: 'Hold 5,000 Gold at once.',
      icon: 'circle.hexagongrid.fill',
      predicate: (state, _) => state.save.gold >= 5000,
    ),
    Achievement(
      id: 'monster_hunter',
      title: 'Monster Hunter',
      detail: 'Discover 10 different monsters.',
      icon: 'eye.fill',
      predicate: (state, _) => state.save.discoveredMonsters.length >= 10,
    ),
    Achievement(
      id: 'week_streak',
      title: 'Dedicated Dreamer',
      detail: 'Claim all 7 days of a Login Streak.',
      icon: 'calendar.badge.checkmark',
      predicate: (state, _) => state.save.loginStreakDay >= LoginRewardSystem.cycleLength,
    ),
  ];
}
