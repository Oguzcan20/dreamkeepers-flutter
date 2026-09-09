import 'package:flutter_test/flutter_test.dart';

import 'package:dreamkeepers/combat/enemy_factory.dart';
import 'package:dreamkeepers/combat/twin_bond.dart';
import 'package:dreamkeepers/data/dreamkeeper_catalog.dart';
import 'package:dreamkeepers/data/monster_catalog.dart';
import 'package:dreamkeepers/data/shop_catalog.dart';
import 'package:dreamkeepers/data/world_catalog.dart';
import 'package:dreamkeepers/models/rarity.dart';

void main() {
  group('WorldCatalog', () {
    test('has exactly 30 worlds spanning 150 contiguous stages', () {
      expect(WorldCatalog.worlds.length, 30);
      expect(WorldCatalog.totalStages, 150);
      for (var stage = 1; stage <= 150; stage++) {
        final world = WorldCatalog.world(stage);
        expect(world.stages.contains(stage), isTrue, reason: 'stage $stage');
      }
    });

    test('world ids are 1..30 with no gaps or dupes', () {
      final ids = WorldCatalog.worlds.map((w) => w.id).toList();
      expect(ids, List.generate(30, (i) => i + 1));
    });
  });

  group('MonsterCatalog', () {
    test('every world 1-30 resolves a boss and at least one regular monster', () {
      for (var worldID = 1; worldID <= 30; worldID++) {
        final boss = MonsterCatalog.boss(worldID);
        expect(boss.lore, isNotEmpty);
        final regular = MonsterCatalog.regularMonster(worldID, 1);
        expect(regular.name, isNotEmpty);
      }
    });

    test('worlds 11-30 echo the same roster as their source world 1-10', () {
      final w1boss = MonsterCatalog.boss(1);
      final w11boss = MonsterCatalog.boss(11);
      final w21boss = MonsterCatalog.boss(21);
      expect(w11boss.lore, w1boss.lore);
      expect(w21boss.lore, w1boss.lore);
    });

    test('allEntries includes the boss as the final, legendary-rarity entry', () {
      final entries = MonsterCatalog.allEntries(1);
      expect(entries.last.isBoss, isTrue);
      expect(entries.last.rarity, Rarity.legendary);
    });
  });

  group('DreamkeeperCatalog', () {
    test('has exactly 38 unique definitions including Igo, Ames and the six Olf variants', () {
      final defs = DreamkeeperCatalog.starter.definitions;
      expect(defs.length, 38);
      final ids = defs.map((d) => d.id).toSet();
      expect(ids.length, 38);
      expect(ids.contains(TwinBond.igoID), isTrue);
      expect(ids.contains(TwinBond.amesID), isTrue);
    });

    test('igo and ames are Rarity.exclusive with their signature passives', () {
      final igo = DreamkeeperCatalog.starter.definition(TwinBond.igoID)!;
      final ames = DreamkeeperCatalog.starter.definition(TwinBond.amesID)!;
      expect(igo.rarity, Rarity.exclusive);
      expect(ames.rarity, Rarity.exclusive);
      expect(igo.passive.reviveHPFraction, 0.3);
      expect(ames.passive.lowHPAttackBonus, 0.6);
    });

    test('unlockOrder entries all resolve to real definitions', () {
      for (final id in DreamkeeperCatalog.unlockOrder) {
        expect(DreamkeeperCatalog.starter.definition(id), isNotNull, reason: id);
      }
    });

    test('definition(for:) returns null for an unknown id', () {
      expect(DreamkeeperCatalog.starter.definition('does_not_exist'), isNull);
    });
  });

  group('ShopCatalog', () {
    test('exclusive character purchases grant igo/ames at the shared \$99.99 price', () {
      expect(ShopCatalog.exclusiveCharacters.length, 2);
      for (final item in ShopCatalog.exclusiveCharacters) {
        expect(item.priceLabel, r'$99.99');
        expect(item.grantsDefinitionID, isNotNull);
      }
    });

    test('allRealMoneyItems excludes goldExchange items', () {
      expect(ShopCatalog.allRealMoneyItems.every((i) => i.productID != null), isTrue);
    });
  });

  group('EnemyFactory', () {
    test('generates a boss combatant on every 5th stage', () {
      final boss = EnemyFactory.enemy(5);
      expect(boss.isBoss, isTrue);
      expect(boss.name, WorldCatalog.world(5).bossName);
    });

    test('generates a regular combatant on non-boss stages', () {
      final regular = EnemyFactory.enemy(1);
      expect(regular.isBoss, isFalse);
    });

    test('stats scale up with stage number', () {
      final early = EnemyFactory.enemy(1);
      final late = EnemyFactory.enemy(149); // last non-boss stage
      expect(late.maxHP, greaterThan(early.maxHP));
      expect(late.attack, greaterThan(early.attack));
    });
  });
}
