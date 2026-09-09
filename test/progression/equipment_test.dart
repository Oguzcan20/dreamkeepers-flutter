import 'package:flutter_test/flutter_test.dart';

import 'package:dreamkeepers/data/dreamkeeper_catalog.dart';
import 'package:dreamkeepers/combat/arena_system.dart';
import 'package:dreamkeepers/models/equipment.dart';
import 'package:dreamkeepers/models/rarity.dart';
import 'package:dreamkeepers/progression/equipment_factory.dart';
import 'package:dreamkeepers/progression/equipment_upgrade.dart';

void main() {
  group('EquipmentFactory', () {
    test('shouldDrop always true for boss stages', () {
      for (var i = 0; i < 20; i++) {
        expect(EquipmentFactory.shouldDrop(isBoss: true), isTrue);
      }
    });

    test('item(forStage:rarity:slot:) builds a nonzero bonus on the correct stat only', () {
      final item = EquipmentFactory.item(stage: 10, rarity: Rarity.rare, slot: EquipmentSlot.weapon);
      expect(item.slot, EquipmentSlot.weapon);
      expect(item.statBonus.attack, greaterThan(0));
      expect(item.statBonus.hp, 0);
      expect(item.statBonus.defense, 0);
      expect(item.statBonus.speed, 0);
      expect(item.level, 1);
    });

    test('higher rarity yields a larger stat magnitude at the same stage', () {
      final common = EquipmentFactory.item(stage: 20, rarity: Rarity.common, slot: EquipmentSlot.ring);
      final mythic = EquipmentFactory.item(stage: 20, rarity: Rarity.mythic, slot: EquipmentSlot.ring);
      expect(mythic.statBonus.speed, greaterThan(common.statBonus.speed));
    });
  });

  group('EquipmentUpgrade', () {
    test('upgraded compounds the stat bonus and increments level', () {
      final base = EquipmentFactory.item(stage: 5, rarity: Rarity.epic, slot: EquipmentSlot.charm);
      final upgraded = EquipmentUpgrade.upgraded(base);
      expect(upgraded.level, base.level + 1);
      expect(upgraded.statBonus.hp, greaterThan(base.statBonus.hp));
    });

    test('canUpgrade is false at maxLevel and upgraded is a no-op past it', () {
      var item = EquipmentFactory.item(stage: 1, rarity: Rarity.common, slot: EquipmentSlot.ring);
      for (var i = 0; i < EquipmentUpgrade.maxLevel + 3; i++) {
        item = EquipmentUpgrade.upgraded(item);
      }
      expect(item.level, EquipmentUpgrade.maxLevel);
      expect(EquipmentUpgrade.canUpgrade(item), isFalse);
    });

    test('cost scales with rarity and level', () {
      final lowLevel = EquipmentFactory.item(stage: 1, rarity: Rarity.common, slot: EquipmentSlot.weapon);
      final highRarity = EquipmentFactory.item(stage: 1, rarity: Rarity.mythic, slot: EquipmentSlot.weapon);
      expect(EquipmentUpgrade.cost(highRarity), greaterThan(EquipmentUpgrade.cost(lowLevel)));
    });
  });

  group('ArenaSystem', () {
    test('opponentForFloor is deterministic for the same floor', () {
      final a = ArenaSystem.opponentForFloor(42, DreamkeeperCatalog.starter);
      final b = ArenaSystem.opponentForFloor(42, DreamkeeperCatalog.starter);
      expect(a, b);
    });

    test('different floors usually produce different opponents', () {
      final opponents = {
        for (var f = 1; f <= 20; f++)
          f: ArenaSystem.opponentForFloor(f, DreamkeeperCatalog.starter),
      };
      final distinctDefinitionIDs = opponents.values.map((o) => o.definitionID).toSet();
      expect(distinctDefinitionIDs.length, greaterThan(1));
    });

    test('tier bands match the documented floor ranges', () {
      expect(ArenaTier.tier(1), ArenaTier.bronze);
      expect(ArenaTier.tier(20), ArenaTier.bronze);
      expect(ArenaTier.tier(21), ArenaTier.silver);
      expect(ArenaTier.tier(60), ArenaTier.gold);
      expect(ArenaTier.tier(81), ArenaTier.diamond);
      expect(ArenaTier.tier(100), ArenaTier.diamond);
    });

    test('makeCombatant scales stats up with floor', () {
      final opp1 = ArenaSystem.opponentForFloor(1, DreamkeeperCatalog.starter);
      final opp100 = ArenaSystem.opponentForFloor(100, DreamkeeperCatalog.starter);
      final c1 = ArenaSystem.makeCombatant(opp1, DreamkeeperCatalog.starter)!;
      final c100 = ArenaSystem.makeCombatant(opp100, DreamkeeperCatalog.starter)!;
      expect(c100.maxHP, greaterThan(c1.maxHP));
      expect(c100.attack, greaterThan(c1.attack));
      expect(c1.portraitOverrideName, isNotEmpty);
    });

    test('milestone floors are guaranteed legendary first-clear rarity', () {
      expect(ArenaSystem.isMilestoneFloor(25), isTrue);
      expect(ArenaSystem.firstClearRarity(25), Rarity.legendary);
      expect(ArenaSystem.firstClearRarity(50), Rarity.legendary);
    });

    test('firstClearEquipment is deterministic per floor', () {
      final a = ArenaSystem.firstClearEquipment(7);
      final b = ArenaSystem.firstClearEquipment(7);
      expect(a.slot, b.slot);
      expect(a.rarity, b.rarity);
      expect(a.statBonus, b.statBonus);
    });

    test('gold rewards climb with floor', () {
      expect(ArenaSystem.goldReward(100), greaterThan(ArenaSystem.goldReward(1)));
      expect(ArenaSystem.standardGoldReward(100), greaterThan(ArenaSystem.standardGoldReward(1)));
    });
  });
}
