import 'package:flutter_test/flutter_test.dart';

import 'package:dreamkeepers/data/dreamkeeper_catalog.dart';
import 'package:dreamkeepers/models/rarity.dart';
import 'package:dreamkeepers/progression/battle_pass_system.dart';
import 'package:dreamkeepers/progression/daily_missions.dart';
import 'package:dreamkeepers/progression/dreamkeeper_sale_system.dart';
import 'package:dreamkeepers/progression/energy_system.dart';
import 'package:dreamkeepers/progression/equipment_summon_system.dart';
import 'package:dreamkeepers/progression/login_reward_system.dart';
import 'package:dreamkeepers/progression/offline_rewards.dart';
import 'package:dreamkeepers/progression/rewards.dart';
import 'package:dreamkeepers/progression/summon_system.dart';
import 'package:dreamkeepers/progression/weekly_missions.dart';

void main() {
  group('RewardTable', () {
    test('boss stages pay out more than regular stages at the same number', () {
      final regular = RewardTable.rewards(stage: 10, isBoss: false);
      final boss = RewardTable.rewards(stage: 10, isBoss: true);
      expect(boss.gold, greaterThan(regular.gold));
      expect(boss.expPerSurvivor, greaterThan(regular.expPerSurvivor));
      expect(boss.accountExp, greaterThan(regular.accountExp));
    });
  });

  group('EnergySystem', () {
    test('boss stage costs double a normal stage', () {
      expect(EnergySystem.stageCost(isBoss: true), EnergySystem.bossStageCost);
      expect(EnergySystem.stageCost(isBoss: false), EnergySystem.normalStageCost);
      expect(EnergySystem.bossStageCost, EnergySystem.normalStageCost * 2);
    });

    test('refill gem cost climbs with refills used today', () {
      expect(EnergySystem.refillGemCost(1), greaterThan(EnergySystem.refillGemCost(0)));
    });
  });

  group('SummonSystem', () {
    test('rarityOdds sums to 1.0', () {
      final total = SummonSystem.rarityOdds.fold<double>(0, (sum, e) => sum + e.$2);
      expect(total, closeTo(1.0, 1e-9));
    });

    test('rollRarity is deterministic for a given roll value', () {
      expect(SummonSystem.rollRarity(roll: 0.0), Rarity.common);
      expect(SummonSystem.rollRarity(roll: 0.9999), Rarity.exclusive);
    });

    test('legendary pity forces at least legendary rarity', () {
      final rarity = SummonSystem.rollRarityWithPity(
        pullsSinceEpic: 0,
        pullsSinceLegendary: SummonSystem.legendaryPityThreshold - 1,
        roll: 0.0, // would otherwise be common
      );
      expect(rarity, Rarity.legendary);
    });

    test('epic pity forces at least epic rarity (when legendary pity not also hit)', () {
      final rarity = SummonSystem.rollRarityWithPity(
        pullsSinceEpic: SummonSystem.epicPityThreshold - 1,
        pullsSinceLegendary: 0,
        roll: 0.0,
      );
      expect(rarity, Rarity.epic);
    });

    test('rollDefinitionForRarity returns a definition of the requested rarity', () {
      final def = SummonSystem.rollDefinitionForRarity(DreamkeeperCatalog.starter, Rarity.rare);
      expect(def.rarity, Rarity.rare);
    });
  });

  group('EquipmentSummonSystem', () {
    test('exclusive rarity downgrades to mythic for equipment', () {
      final item = EquipmentSummonSystem.rollItemForRarity(stage: 10, rarity: Rarity.exclusive);
      expect(item.rarity, Rarity.mythic);
    });
  });

  group('DailyMissions', () {
    test('rotating pool excludes premium-only missions', () {
      expect(DailyMissions.rotatingPool.contains(MissionID.premiumBonusStages), isFalse);
      expect(DailyMissions.rotatingPool.contains(MissionID.premiumBonusSummons), isFalse);
    });

    test('drawDaily picks exactly activeCount unique missions from the pool', () {
      final drawn = DailyMissions.drawDaily();
      expect(drawn.length, DailyMissions.activeCount);
      expect(drawn.toSet().length, DailyMissions.activeCount);
      for (final id in drawn) {
        expect(DailyMissions.rotatingPool.map((m) => m.name), contains(id));
      }
    });
  });

  group('WeeklyMissions', () {
    test('has 5 definitions with unique ids', () {
      expect(WeeklyMissions.definitions.length, 5);
      expect(WeeklyMissions.definitions.map((d) => d.id).toSet().length, 5);
    });
  });

  group('LoginRewardSystem', () {
    test('has exactly cycleLength days, day 7 is the biggest reward', () {
      expect(LoginRewardSystem.days.length, LoginRewardSystem.cycleLength);
      final day7 = LoginRewardSystem.reward(7)!;
      expect(day7.gold, 200);
      expect(day7.gems, 40);
    });

    test('reward returns null for an out-of-range day', () {
      expect(LoginRewardSystem.reward(8), isNull);
      expect(LoginRewardSystem.reward(0), isNull);
    });
  });

  group('OfflineRewards', () {
    test('pending gold/exp scale with elapsed time up to the cap', () {
      final now = DateTime(2026, 1, 1, 12, 0, 0);
      final tenMinAgo = now.subtract(const Duration(minutes: 10));
      expect(OfflineRewards.pendingGold(lastCollected: tenMinAgo, now: now), 60);
      expect(OfflineRewards.pendingExp(lastCollected: tenMinAgo, now: now), 40);

      final wayBack = now.subtract(const Duration(hours: 20));
      final cappedSeconds = OfflineRewards.accruedSeconds(lastCollected: wayBack, now: now);
      expect(cappedSeconds, OfflineRewards.maxAccrualSeconds.toDouble());
    });

    test('accruedSeconds never goes negative for a future lastCollected', () {
      final now = DateTime(2026, 1, 1, 12, 0, 0);
      final future = now.add(const Duration(minutes: 5));
      expect(OfflineRewards.accruedSeconds(lastCollected: future, now: now), 0);
    });
  });

  group('DreamkeeperSaleSystem', () {
    test('gold value climbs with rarity, level, and stars', () {
      final base = DreamkeeperSaleSystem.goldValue(rarity: Rarity.common, level: 1, stars: 0);
      final upgraded = DreamkeeperSaleSystem.goldValue(rarity: Rarity.common, level: 10, stars: 3);
      expect(upgraded, greaterThan(base));
      final rarer = DreamkeeperSaleSystem.goldValue(rarity: Rarity.mythic, level: 1, stars: 0);
      expect(rarer, greaterThan(base));
    });

    test('gem value is only nonzero at legendary and above', () {
      expect(DreamkeeperSaleSystem.gemValue(Rarity.common), 0);
      expect(DreamkeeperSaleSystem.gemValue(Rarity.legendary), greaterThan(0));
      expect(DreamkeeperSaleSystem.gemValue(Rarity.mythic), greaterThan(0));
    });
  });

  group('BattlePassSystem', () {
    test('tier climbs with xp and clamps at tierCount', () {
      expect(BattlePassSystem.tier(0), 0);
      expect(BattlePassSystem.tier(BattlePassSystem.xpPerTier), 1);
      expect(BattlePassSystem.tier(BattlePassSystem.xpPerTier * 100), BattlePassSystem.tierCount);
    });

    test('premium reward includes a milestone bonus every 5th tier', () {
      final normal = BattlePassSystem.premiumReward(1);
      final milestone = BattlePassSystem.premiumReward(5);
      expect(milestone.gems, greaterThan(normal.gems));
      expect(milestone.tickets, greaterThan(0));
      expect(normal.tickets, 0);
    });
  });
}
