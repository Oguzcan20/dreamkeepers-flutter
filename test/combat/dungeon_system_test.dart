import 'package:flutter_test/flutter_test.dart';

import 'package:dreamkeepers/combat/battle_engine.dart';
import 'package:dreamkeepers/combat/combatant.dart';
import 'package:dreamkeepers/combat/dungeon_system.dart';
import 'package:dreamkeepers/models/element.dart';
import 'package:dreamkeepers/models/role.dart';

void main() {
  group('DungeonSystem.waves', () {
    test('every dungeon yields exactly waveCount enemies, boss last', () {
      for (final id in DungeonSystem.all) {
        final waves = DungeonSystem.waves(id);
        expect(waves.length, DungeonSystem.waveCount);
        expect(waves.every((c) => !c.isPlayer), isTrue);
        expect(waves.last.isBoss, isTrue);
        expect(waves.take(waves.length - 1).every((c) => !c.isBoss), isTrue);
        expect(waves.last.mechanic, isNotNull);
      }
    });

    test('boss is tougher than the regular waves of the same run', () {
      for (final id in DungeonSystem.all) {
        final waves = DungeonSystem.waves(id);
        final boss = waves.last;
        for (final mob in waves.take(waves.length - 1)) {
          expect(boss.maxHP, greaterThan(mob.maxHP));
          expect(boss.attack, greaterThan(mob.attack));
        }
      }
    });

    test('dungeons form a strictly rising power ladder', () {
      double firstBossHp(DungeonId id) => DungeonSystem.waves(id).last.maxHP;
      expect(firstBossHp(DungeonId.whisperwood), lessThan(firstBossHp(DungeonId.gloomvault)));
      expect(firstBossHp(DungeonId.gloomvault), lessThan(firstBossHp(DungeonId.starspire)));
    });
  });

  group('DungeonSystem rewards', () {
    test('first-clear gold and gems rise across the ladder', () {
      final ids = DungeonSystem.all;
      for (var i = 1; i < ids.length; i++) {
        expect(DungeonSystem.firstClearGold(ids[i]), greaterThan(DungeonSystem.firstClearGold(ids[i - 1])));
        expect(DungeonSystem.firstClearGems(ids[i]), greaterThan(DungeonSystem.firstClearGems(ids[i - 1])));
        expect(DungeonSystem.lootStage(ids[i]), greaterThan(DungeonSystem.lootStage(ids[i - 1])));
      }
    });

    test('repeat gold is a fraction of the first-clear payout', () {
      for (final id in DungeonSystem.all) {
        expect(DungeonSystem.repeatGold(id), lessThan(DungeonSystem.firstClearGold(id)));
        expect(DungeonSystem.repeatGold(id), greaterThan(0));
      }
    });
  });

  group('BattleEngine wave queue', () {
    Combatant player() => Combatant(
          id: 'p',
          name: 'Hero',
          element: GameElement.ember,
          role: Role.damage,
          isPlayer: true,
          isBoss: false,
          maxHP: 100000,
          currentHP: 100000,
          attack: 5000,
          defense: 10,
          speed: 100,
          symbol: 'star.fill',
        );

    Combatant weakFoe(String id) => Combatant(
          id: id,
          name: 'Foe $id',
          element: GameElement.tide,
          role: Role.damage,
          isPlayer: false,
          isBoss: false,
          maxHP: 1,
          currentHP: 1,
          attack: 0,
          defense: 0,
          speed: 1,
          symbol: 'circle.fill',
        );

    test('run advances through every wave before declaring victory', () {
      final engine = BattleEngine(
        playerUnits: [player()],
        enemy: weakFoe('a'),
        stage: 10,
        isBossStage: false,
        reinforcements: [weakFoe('b'), weakFoe('c')],
        varianceProvider: () => 1.0,
      );
      expect(engine.currentWave, 1);
      expect(engine.totalWaves, 3);

      for (var i = 0; i < 2000 && engine.outcome == null; i++) {
        engine.tick(0.1);
      }

      expect(engine.outcome, BattleOutcome.victory);
      expect(engine.currentWave, 3);
    });
  });
}
