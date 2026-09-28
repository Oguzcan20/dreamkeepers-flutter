import 'package:uuid/uuid.dart';

import '../combat/combatant.dart';
import '../models/element.dart';
import '../models/role.dart';

const _uuid = Uuid();

/// The weekly World Boss event: a single shared-stat boss every player fights
/// in their own solo `BattleEngine` instance (there's no server, so there's
/// no single shared boss HP pool — see `GameState`'s World Boss section for
/// why a Firestore leaderboard, not a live shared fight, is what ties players
/// together here). Live Friday 19:00 UTC through Sunday 19:00 UTC; each
/// player gets [attacksPerWeek] tries, damage from every try adds up, and the
/// week's ranking pays out once the window closes.
///
/// Deliberately UTC-fixed rather than using the device's own locale/timezone
/// — a cross-player leaderboard can't tolerate that skew: two players in
/// different regions must see the exact same window and the exact same
/// week's boss. Mirrors GameCore/Progression/WorldBossSystem.swift exactly.
class WorldBossSystem {
  /// Shared with `WorldBossView`/`WorldBossResultView` so `MonsterArt`
  /// lookups (and `bossCombatant()` below) always agree on the exact name.
  static const String bossName = 'Voidmaw, the Devouring Dream';

  static const int attacksPerWeek = 3;

  /// One "round" is one boss attack landing (see `BattleEngine.roundsElapsed`).
  static const int roundLimit = 50;

  /// Midnight UTC of the Monday containing `utcDate` (which must already be
  /// in UTC).
  static DateTime _mondayOfWeek(DateTime utcDate) {
    final startOfDay = DateTime.utc(utcDate.year, utcDate.month, utcDate.day);
    return startOfDay.subtract(Duration(days: startOfDay.weekday - DateTime.monday));
  }

  /// Friday 19:00 UTC that starts the fight window containing `date` — the
  /// stable key every player's window/weekID is computed from, whether
  /// `date` falls inside the live Friday-Sunday window itself or in the
  /// dormant days afterward (so a player returning after the window closed
  /// to claim a reward still resolves to the same cycle they fought in).
  static DateTime weekStart(DateTime date) {
    final utcDate = date.toUtc();
    final mondayThisWeek = _mondayOfWeek(utcDate);
    final fridayThisWeek = mondayThisWeek.add(const Duration(days: 4));
    final friday1900ThisWeek = fridayThisWeek.add(const Duration(hours: 19));
    if (!utcDate.isBefore(friday1900ThisWeek)) return friday1900ThisWeek;
    // Before this week's Friday 19:00 — still in last week's cycle.
    final mondayLastWeek = mondayThisWeek.subtract(const Duration(days: 7));
    final fridayLastWeek = mondayLastWeek.add(const Duration(days: 4));
    return fridayLastWeek.add(const Duration(hours: 19));
  }

  /// A stable, human-inspectable identifier for the week containing `date`
  /// (e.g. `"2026-W39"`) — the Firestore document path segment for that
  /// week's leaderboard and the `GameSave.worldBossClaimedWeeks` dedupe key.
  static String weekID(DateTime date) {
    final start = weekStart(date);
    final (year, week) = _isoWeekOfYear(start);
    return '$year-W${week.toString().padLeft(2, '0')}';
  }

  /// ISO-8601 week-year and week number: week 1 is the week containing the
  /// year's first Thursday.
  static (int, int) _isoWeekOfYear(DateTime utcDate) {
    final date = DateTime.utc(utcDate.year, utcDate.month, utcDate.day);
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final jan1 = DateTime.utc(thursday.year, 1, 1);
    final week = 1 + (thursday.difference(jan1).inDays / 7).floor();
    return (thursday.year, week);
  }

  /// The fight window for the week containing `date`: Friday 19:00 UTC
  /// (announcement/appearance) through Sunday 19:00 UTC (attacks close).
  static ({DateTime start, DateTime end}) window(DateTime date) {
    final start = weekStart(date);
    return (start: start, end: start.add(const Duration(days: 2)));
  }

  static bool isActive([DateTime? at]) {
    final date = (at ?? DateTime.now()).toUtc();
    final w = window(date);
    return !date.isBefore(w.start) && date.isBefore(w.end);
  }

  /// The boss every player fights this week — identical stats for
  /// everyone, so the leaderboard measures skill/roster strength, not luck.
  /// First-pass balance (see doc comment on the constants below); intended
  /// to be retuned from real playtesting, not treated as final.
  static Combatant bossCombatant() {
    return Combatant(
      id: _uuid.v4(),
      name: bossName,
      element: GameElement.astral,
      role: Role.tank,
      isPlayer: false,
      isBoss: true,
      maxHP: bossMaxHP,
      currentHP: bossMaxHP,
      attack: bossAttack,
      defense: bossDefense,
      speed: bossSpeed,
      symbol: 'eye.trianglebadge.exclamationmark.fill',
      mechanic: BossMechanic.enrage,
    );
  }

  /// Tuned so a level-25, 2-star, unequipped four-member team (the "medium
  /// team" the spec calls for) comfortably survives all [roundLimit] rounds
  /// under `BattleEngine`'s real damage formula
  /// (`attack - defense * 0.5`, focus-fire on the lowest-HP ally), while a
  /// fresh level-1 roster still lands real hits and gets a genuine handful
  /// of rounds rather than an instant, meaningless wipe.
  static const double bossMaxHP = 50000;
  static const double bossAttack = 36;
  static const double bossDefense = 22;
  static const double bossSpeed = 52;

  // -- Rewards -------------------------------------------------------------

  /// `null` for rank 201 and beyond — per spec, nothing is paid out past
  /// rank 200. Ranks 1 and 2-10 each get their own individually-sized
  /// reward (rank 1 the single biggest prize); 11-50/51-100/101-200 are
  /// flat brackets, each smaller than the last.
  static WorldBossReward? reward(int rank) {
    if (rank == 1) {
      return const WorldBossReward(gold: 150000, gems: 3000);
    }
    if (rank >= 2 && rank <= 10) {
      // Linear step down from rank 2 (2000 gems/100k gold) to rank 10
      // (400 gems/20k gold).
      final steps = rank - 2;
      return WorldBossReward(gold: 100000 - steps * 10000, gems: 2000 - steps * 200);
    }
    if (rank >= 11 && rank <= 50) return const WorldBossReward(gold: 15000, gems: 150);
    if (rank >= 51 && rank <= 100) return const WorldBossReward(gold: 8000, gems: 75);
    if (rank >= 101 && rank <= 200) return const WorldBossReward(gold: 3000, gems: 30);
    return null;
  }
}

class WorldBossReward {
  final int gold;
  final int gems;
  const WorldBossReward({required this.gold, required this.gems});

  @override
  bool operator ==(Object other) =>
      other is WorldBossReward && other.gold == gold && other.gems == gems;

  @override
  int get hashCode => Object.hash(gold, gems);
}
