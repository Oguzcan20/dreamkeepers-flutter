import 'package:flutter_test/flutter_test.dart';

import 'package:dreamkeepers/progression/world_boss_system.dart';

// 2026-09-25 is a Friday (per this repo's reference date).
DateTime _d(int year, int month, int day, int hour, [int minute = 0]) =>
    DateTime.utc(year, month, day, hour, minute);

void main() {
  group('WorldBossSystem window/schedule', () {
    test('window is Friday 19:00 through Sunday 19:00', () {
      // Saturday, inside the live window — Friday noon that same week
      // still belongs to the *previous* (already-closed) cycle, since the
      // boss hasn't appeared yet at that moment (see the "just before
      // Friday open" test below).
      final w = WorldBossSystem.window(_d(2026, 9, 26, 12));
      expect(w.start, _d(2026, 9, 25, 19));
      expect(w.end, _d(2026, 9, 27, 19));
    });

    test('isActive just after Friday open', () {
      expect(WorldBossSystem.isActive(_d(2026, 9, 25, 19, 1)), isTrue);
    });

    test('isActive just before Friday open is false', () {
      expect(WorldBossSystem.isActive(_d(2026, 9, 25, 18, 59)), isFalse);
    });

    test('isActive during Saturday is true', () {
      expect(WorldBossSystem.isActive(_d(2026, 9, 26, 12)), isTrue);
    });

    test('isActive exactly at Sunday close is false', () {
      // `window(...).end` is exclusive.
      expect(WorldBossSystem.isActive(_d(2026, 9, 27, 19)), isFalse);
    });

    test('isActive just before Sunday close is true', () {
      expect(WorldBossSystem.isActive(_d(2026, 9, 27, 18, 59)), isTrue);
    });

    test('weekStart stays stable through the dormant days after close', () {
      // A player returning Wednesday (well after Sunday 19:00 close) to
      // claim a reward must still resolve to the same cycle they fought in.
      final duringWindow = WorldBossSystem.weekStart(_d(2026, 9, 26, 10));
      final afterClose = WorldBossSystem.weekStart(_d(2026, 10, 1, 10));
      expect(duringWindow, afterClose);
    });

    test('weekStart advances once the next Friday arrives', () {
      final thisWeek = WorldBossSystem.weekStart(_d(2026, 9, 26, 10));
      final nextWeek = WorldBossSystem.weekStart(_d(2026, 10, 2, 20));
      expect(thisWeek, isNot(nextWeek));
      expect(nextWeek, _d(2026, 10, 2, 19));
    });

    test('weekID is stable across the same cycle', () {
      final idDuring = WorldBossSystem.weekID(_d(2026, 9, 26, 10));
      final idAfter = WorldBossSystem.weekID(_d(2026, 9, 29, 10));
      expect(idDuring, idAfter);
    });
  });

  group('WorldBossSystem reward tiers', () {
    test('rank one is the largest prize', () {
      final reward = WorldBossSystem.reward(1);
      expect(reward, const WorldBossReward(gold: 150000, gems: 3000));
    });

    test('rewards step down linearly from rank two to ten', () {
      expect(WorldBossSystem.reward(2), const WorldBossReward(gold: 100000, gems: 2000));
      expect(WorldBossSystem.reward(10), const WorldBossReward(gold: 20000, gems: 400));
    });

    test('reward bracket boundaries', () {
      expect(WorldBossSystem.reward(11), const WorldBossReward(gold: 15000, gems: 150));
      expect(WorldBossSystem.reward(50), const WorldBossReward(gold: 15000, gems: 150));
      expect(WorldBossSystem.reward(51), const WorldBossReward(gold: 8000, gems: 75));
      expect(WorldBossSystem.reward(100), const WorldBossReward(gold: 8000, gems: 75));
      expect(WorldBossSystem.reward(101), const WorldBossReward(gold: 3000, gems: 30));
      expect(WorldBossSystem.reward(200), const WorldBossReward(gold: 3000, gems: 30));
    });

    test('reward is null past rank two hundred', () {
      expect(WorldBossSystem.reward(201), isNull);
      expect(WorldBossSystem.reward(10000), isNull);
    });
  });

  group('WorldBossSystem boss combatant', () {
    test('boss combatant is shared and not a player', () {
      final boss = WorldBossSystem.bossCombatant();
      expect(boss.isPlayer, isFalse);
      expect(boss.isBoss, isTrue);
      expect(boss.maxHP, WorldBossSystem.bossMaxHP);
    });
  });
}
