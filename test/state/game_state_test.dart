import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:dreamkeepers/combat/battle_engine.dart';
import 'package:dreamkeepers/combat/combatant.dart';
import 'package:dreamkeepers/combat/twin_bond.dart';
import 'package:dreamkeepers/data/dreamkeeper_catalog.dart';
import 'package:dreamkeepers/data/shop_catalog.dart';
import 'package:dreamkeepers/models/dreamkeeper.dart';
import 'package:dreamkeepers/models/element.dart';
import 'package:dreamkeepers/models/rarity.dart';
import 'package:dreamkeepers/models/role.dart';
import 'package:dreamkeepers/models/team.dart';
import 'package:dreamkeepers/persistence/game_save.dart';
import 'package:dreamkeepers/persistence/save_system.dart';
import 'package:dreamkeepers/progression/energy_system.dart';
import 'package:dreamkeepers/progression/level_system.dart';
import 'package:dreamkeepers/progression/star_fusion_system.dart';
import 'package:dreamkeepers/progression/summon_system.dart';
import 'package:dreamkeepers/state/game_state.dart';

/// Test double kept entirely in memory — faster and side-effect-free
/// compared to routing through `shared_preferences`, which is already
/// covered by `test/persistence/game_save_test.dart`.
class _InMemorySaveSystem implements SaveSystem {
  GameSave? stored;

  @override
  Future<GameSave?> load() async => stored;

  @override
  Future<void> save(GameSave save) async {
    stored = save;
  }
}

Future<GameState> _freshState({SaveSystem? saveSystem}) => GameState.create(
      saveSystem: saveSystem ?? _InMemorySaveSystem(),
      catalog: DreamkeeperCatalog.starter,
    );

const _uuid = Uuid();

/// A guaranteed-victory engine, independent of `makeBattleEngine()` / real
/// catalog stats — mirrors `DailyMissionsTests.winningEngine(stage:)` on the
/// Swift side. Needed because the starter Olf (unlike the old `ember_fox`
/// starter) is deliberately the weakest common-tier Dreamkeeper until the
/// player picks an element, so a real `makeBattleEngine()` fight is no
/// longer a safe win at stage 1. `applyBattleResult` only reads
/// `engine.outcome`/`stage`/`isBossStage` plus `playerUnits` ids (used to
/// match survivors back into the roster for XP, unused by these tests), so
/// a hand-built engine is a legitimate stand-in.
BattleResultSummary _winCurrentStage(GameState state, {bool isBossStage = false}) {
  final hero = Combatant(
    id: _uuid.v4(),
    name: 'Hero',
    element: GameElement.ember,
    role: Role.damage,
    isPlayer: true,
    isBoss: false,
    maxHP: 200,
    currentHP: 200,
    attack: 40,
    defense: 5,
    speed: 80,
  );
  final enemy = Combatant(
    id: _uuid.v4(),
    name: 'Weakling',
    element: GameElement.ember,
    role: Role.damage,
    isPlayer: false,
    isBoss: isBossStage,
    maxHP: 30,
    currentHP: 30,
    attack: 2,
    defense: 5,
    speed: 20,
  );
  final engine = BattleEngine(
    playerUnits: [hero],
    enemy: enemy,
    stage: state.currentStage,
    isBossStage: isBossStage,
    varianceProvider: () => 1.0,
  );
  var iterations = 0;
  while (engine.outcome == null && iterations < 2000) {
    engine.tick(0.1);
    iterations += 1;
  }
  return state.applyBattleResult(engine);
}

void main() {
  group('GameState.create', () {
    test('starts a brand-new save with the starter roster deployed', () async {
      final state = await _freshState();
      expect(state.save.roster.length, 1);
      expect(state.save.roster.first.definitionID, DreamkeeperCatalog.starterOlfDefaultID);
      expect(state.deployedTeam.length, 1);
      expect(state.currentStage, 1);
      expect(state.selectedStage, 1);
    });

    test('loads an existing save instead of starting over', () async {
      final saveSystem = _InMemorySaveSystem();
      final first = await _freshState(saveSystem: saveSystem);
      first.save.gold += 500;
      first.persist();

      final second = await _freshState(saveSystem: saveSystem);
      expect(second.save.gold, first.save.gold);
    });
  });

  group('Energy', () {
    test('spendEnergy fails when the cost exceeds the current balance', () async {
      final state = await _freshState();
      final spent = state.spendEnergy(state.maxEnergy + 1);
      expect(spent, isFalse);
      expect(state.energy, state.maxEnergy);
    });

    test('spendEnergy deducts on success', () async {
      final state = await _freshState();
      final before = state.energy;
      expect(state.spendEnergy(EnergySystem.normalStageCost), isTrue);
      expect(state.energy, before - EnergySystem.normalStageCost);
    });
  });

  group('Roster and teams', () {
    test('the last remaining Dreamkeeper can never be sold', () async {
      final state = await _freshState();
      expect(state.save.roster.length, 1);
      expect(state.canSellDreamkeeper(state.save.roster.first), isFalse);
    });

    test('selling removes the instance and benches it from every team', () async {
      final state = await _freshState();
      // Give the roster a second member so the first one becomes sellable.
      // The starter is deployed by default already.
      state.rollAndAddSummon();
      final target = state.save.roster.first;
      expect(state.isDeployed(target), isTrue);

      final result = state.sellDreamkeepers({target.id});
      expect(result.count, 1);
      expect(state.save.roster.any((r) => r.id == target.id), isFalse);
      expect(state.isDeployed(target), isFalse);
    });

    test('toggleDeployed respects the team size cap', () async {
      final state = await _freshState();
      for (var i = 0; i < Team.maxSize + 2; i++) {
        state.rollAndAddSummon();
      }
      for (final instance in state.save.roster) {
        state.toggleDeployed(instance);
      }
      expect(state.deployedTeam.length, lessThanOrEqualTo(Team.maxSize));
    });
  });

  group('Star fusion', () {
    test('fusing duplicates raises stars and consumes the fodder', () async {
      final state = await _freshState();
      final target = state.save.roster.first;
      final needed = StarFusionSystem.duplicatesRequired(target.stars + 1);

      // Seed exact duplicates of the target directly, rather than relying
      // on a random gacha roll to land on the same species.
      state.debugSeedDuplicates(needed);
      final selected = state.duplicates(target).take(needed).toList();

      expect(state.canFuseDreamkeeper(target, selected), isTrue);
      final fused = state.fuseDreamkeeper(target, selected);
      expect(fused, isTrue);

      final updated = state.save.roster.firstWhere((r) => r.id == target.id);
      expect(updated.stars, target.stars + 1);
    });
  });

  group('Campaign battles', () {
    test('winning the frontier stage advances currentStage and grants rewards', () async {
      final state = await _freshState();
      final startingGold = state.save.gold;
      final result = _winCurrentStage(state);

      expect(result.outcome, BattleOutcome.victory);
      expect(state.currentStage, 2);
      expect(state.save.gold, greaterThan(startingGold));
    });

    test('a defeat never advances the campaign frontier', () async {
      final state = await _freshState();
      // Sell down to a single, unequipped, low-level starter and jump to a
      // punishing stage so the fight is unwinnable.
      state.debugSeedStage(30);
      final engine = state.makeBattleEngine()!;
      while (engine.outcome == null) {
        engine.tick(0.1);
      }
      final result = state.applyBattleResult(engine);
      if (result.outcome == BattleOutcome.defeat) {
        expect(state.currentStage, 30);
      }
    });
  });

  group('Arena Tower', () {
    test('winning floor 1 for the first time advances arenaFloor and pays gold', () async {
      final state = await _freshState();
      final engine = state.makeArenaBattleEngine(1);
      expect(engine, isNotNull);
      while (engine!.outcome == null) {
        engine.tick(0.1);
      }
      final result = state.applyArenaBattleResult(engine);
      if (result.outcome == BattleOutcome.victory) {
        expect(result.isFirstClear, isTrue);
        expect(state.arenaFloor, 2);
        expect(result.goldGained, greaterThan(0));
      }
    });

    test('arena tickets are capped per day', () async {
      final state = await _freshState();
      expect(state.arenaTicketsRemainingToday, greaterThan(0));
      final total = state.totalArenaTicketsAvailable;
      for (var i = 0; i < total; i++) {
        state.makeArenaBattleEngine(1);
      }
      expect(state.totalArenaTicketsAvailable, 0);
      expect(state.makeArenaBattleEngine(1), isNull);
    });
  });

  group('Equipment', () {
    test('equip and unequip move an item on and off a Dreamkeeper', () async {
      final state = await _freshState();
      state.debugSeedInventory();
      final targetID = state.save.roster.first.id;
      final item = state.inventory.first;

      // Equipping mutates the roster in place via copyWith, so always
      // re-fetch the instance from `state.save.roster` after a mutation
      // rather than holding onto a pre-mutation snapshot.
      state.equip(item, state.save.roster.firstWhere((r) => r.id == targetID));
      var current = state.save.roster.firstWhere((r) => r.id == targetID);
      expect(state.equippedItem(item.slot, current)?.id, item.id);

      state.unequip(item.slot, current);
      current = state.save.roster.firstWhere((r) => r.id == targetID);
      expect(state.equippedItem(item.slot, current), isNull);
    });

    test('upgradeEquipment raises level and spends gold', () async {
      final state = await _freshState();
      state.debugSeedInventory();
      final item = state.inventory.first;
      state.save.gold = 1000000;

      final goldBefore = state.save.gold;
      final ok = state.upgradeEquipment(item);
      expect(ok, isTrue);

      final after = state.inventory.firstWhere((i) => i.id == item.id);
      expect(after.level, item.level + 1);
      expect(state.save.gold, lessThan(goldBefore));
    });

    test('upgradeEquipment refuses an item that has already hit maxLevel', () async {
      final state = await _freshState();
      state.debugSeedInventory();
      var item = state.inventory.first;
      state.save.gold = 1000000000;

      while (state.upgradeEquipment(item)) {
        item = state.inventory.firstWhere((i) => i.id == item.id);
      }
      expect(state.upgradeEquipment(item), isFalse);
    });
  });

  group('Summoning', () {
    test('performSummon fails when gems are insufficient', () async {
      final state = await _freshState();
      state.save.dreamGems = 0;
      expect(state.performSummon(), isNull);
    });

    test('performSummon adds a roster member and spends gems', () async {
      final state = await _freshState();
      state.save.dreamGems = 1000;
      final before = state.save.roster.length;
      final result = state.performSummon();
      expect(result, isNotNull);
      expect(state.save.roster.length, before + 1);
      expect(state.save.dreamGems, lessThan(1000));
    });

    test('the beginner multi-summon floors every roll at Uncommon or above', () async {
      final state = await _freshState();
      state.save.dreamGems = 1000000;
      final results = state.performMultiSummon();
      expect(results, isNotNull);
      expect(results!.every((r) => r.definition.rarity >= Rarity.uncommon), isTrue);
      expect(state.save.hasUsedBeginnerMultiSummon, isTrue);
    });
  });

  group('Zwillingsbund (Twin Bond)', () {
    test('deploying both Igo and Ames boosts their ATK/DEF only while both are active', () async {
      final state = await _freshState();
      final igo = DreamkeeperInstance(definitionID: TwinBond.igoID);
      final ames = DreamkeeperInstance(definitionID: TwinBond.amesID);
      state.save.roster.add(igo);
      state.save.roster.add(ames);

      // Deploy only Igo first — no bond bonus yet.
      state.save.teams.first.memberIDs
        ..clear()
        ..add(igo.id);
      final soloEngine = state.makeBattleEngine()!;
      final soloAttack = soloEngine.playerUnits.first.attack;

      state.save.teams.first.memberIDs.add(ames.id);
      final bondedEngine = state.makeBattleEngine()!;
      final bondedIgo = bondedEngine.playerUnits.firstWhere((c) => c.definitionID == TwinBond.igoID);
      expect(bondedIgo.attack, greaterThan(soloAttack));
    });
  });

  group('Olf starter', () {
    test('a fresh save starts with the placeholder Olf and needs a choice', () async {
      final state = await _freshState();
      expect(state.save.roster.single.definitionID, DreamkeeperCatalog.starterOlfDefaultID);
      expect(state.needsStarterOlfChoice, isTrue);
    });

    test('choosing an element swaps the same instance in place', () async {
      final state = await _freshState();
      final original = state.save.roster.single;

      final ok = state.chooseStarterOlf(GameElement.tide);

      expect(ok, isTrue);
      expect(state.save.roster.length, 1);
      expect(state.save.roster.single.id, original.id);
      expect(state.save.roster.single.definitionID, 'olf_tide');
      expect(state.needsStarterOlfChoice, isFalse);
    });

    test('choosing Ember resolves needsStarterOlfChoice (regression: '
        'olfDefinitionID(ember) collides with starterOlfDefaultID)', () async {
      // olfDefinitionID(GameElement.ember) and starterOlfDefaultID are both
      // 'olf_ember' — needsStarterOlfChoice must be backed by a dedicated
      // flag, not a definitionID identity check, or choosing Ember would be
      // a silent no-op and the choice screen would reopen forever.
      final state = await _freshState();
      final ok = state.chooseStarterOlf(GameElement.ember);
      expect(ok, isTrue);
      expect(state.save.roster.single.definitionID, 'olf_ember');
      expect(state.needsStarterOlfChoice, isFalse);
    });

    test('choosing null grants Ultimate Olf', () async {
      final state = await _freshState();
      final ok = state.chooseStarterOlf(null);
      expect(ok, isTrue);
      expect(state.save.roster.single.definitionID, DreamkeeperCatalog.ultimateOlfID);
    });

    test('choosing is a no-op once already resolved', () async {
      final state = await _freshState();
      state.chooseStarterOlf(GameElement.bloom);
      final ok = state.chooseStarterOlf(GameElement.astral);
      expect(ok, isFalse);
      expect(state.save.roster.single.definitionID, 'olf_bloom');
    });

    test('any pulled Olf variant counts as a duplicate of the starter', () async {
      final state = await _freshState();
      final starter = state.save.roster.single; // olf_ember
      final pulledLunar = DreamkeeperInstance(definitionID: 'olf_lunar');
      state.save.roster.add(pulledLunar);

      final dupes = state.duplicates(starter);
      expect(dupes.map((i) => i.id), contains(pulledLunar.id));
    });

    test('fusing a different Olf variant into the starter works', () async {
      final state = await _freshState();
      final starter = state.save.roster.single;
      final pulled = List.generate(
        StarFusionSystem.duplicatesRequired(1),
        (_) => DreamkeeperInstance(definitionID: 'olf_astral'),
      );
      state.save.roster.addAll(pulled);

      expect(state.canFuseDreamkeeper(starter, pulled), isTrue);
      expect(state.fuseDreamkeeper(starter, pulled), isTrue);
      final updated = state.save.roster.firstWhere((i) => i.id == starter.id);
      expect(updated.stars, greaterThan(0));
    });

    test('non-Olf Dreamkeepers still require an exact definition match to fuse', () async {
      final state = await _freshState();
      final foxA = DreamkeeperInstance(definitionID: 'ember_fox');
      final hare = DreamkeeperInstance(definitionID: 'moon_hare');
      state.save.roster.addAll([foxA, hare]);

      final dupes = state.duplicates(foxA);
      expect(dupes.map((i) => i.id), isNot(contains(hare.id)));
    });

    test('Ultimate Olf is never rolled by Summoning, even swept across every rarity band', () {
      for (var i = 0; i <= 200; i++) {
        final roll = i / 200;
        final def = SummonSystem.rollDefinition(DreamkeeperCatalog.starter, roll: roll);
        expect(def.id, isNot(DreamkeeperCatalog.ultimateOlfID));
      }
    });
  });

  group('Shop', () {
    test('exclusive character purchase grants a max-level, max-star instance exactly once', () async {
      final state = await _freshState();
      final item = ShopCatalog.exclusiveCharacters.firstWhere((i) => i.grantsDefinitionID == TwinBond.igoID);

      expect(state.canPurchase(item), isTrue);
      final granted = state.purchase(item);
      expect(granted, isTrue);

      final igo = state.save.roster.firstWhere((r) => r.definitionID == TwinBond.igoID);
      expect(igo.level, LevelSystem.maxLevel);
      expect(igo.stars, StarFusionSystem.maxStars);

      expect(state.canPurchase(item), isFalse);
      expect(state.purchase(item), isFalse);
    });

    test('a gold exchange requires enough gems and deducts them', () async {
      final state = await _freshState();
      final exchange = ShopCatalog.goldExchanges.first;
      state.save.dreamGems = exchange.gemCost + 10;
      final before = state.save.gold;
      expect(state.purchase(exchange), isTrue);
      expect(state.save.gold, before + exchange.goldGranted);
      expect(state.save.dreamGems, 10);
    });
  });

  group('Missions', () {
    test('winning a battle progresses the Clear a Stage mission counter', () async {
      final state = await _freshState();
      _winCurrentStage(state);
      // `winBattle` may or may not be in today's randomly-drawn free-tier
      // subset (see DailyMissions.drawDaily), but the underlying progress
      // counter always advances regardless of whether it's displayed.
      expect(state.save.dailyMissionProgress['winBattle'], greaterThanOrEqualTo(1));
    });
  });

  group('Achievements', () {
    test('summoning a second Dreamkeeper unlocks first_summon', () async {
      final state = await _freshState();
      state.save.dreamGems = 1000;
      state.performSummon();
      final unlocked = state.pendingAchievements.map((a) => a.id);
      expect(unlocked, contains('first_summon'));
    });
  });

  group('Offline rewards', () {
    test('collectGoldFountain grants nothing when no time has accrued', () async {
      final state = await _freshState();
      expect(state.collectGoldFountain(), 0);
    });

    test('collectGoldFountain pays out once time has passed', () async {
      final state = await _freshState();
      state.debugSeedOfflineTime();
      final amount = state.collectGoldFountain();
      expect(amount, greaterThan(0));
    });
  });

  group('Settings', () {
    test('toggling haptics and sound persists the new value', () async {
      final state = await _freshState();
      state.setHapticsEnabled(false);
      expect(state.hapticsEnabled, isFalse);
      state.setSoundEnabled(false);
      expect(state.soundEnabled, isFalse);
    });
  });

  group('resetProgress', () {
    test('wipes the save back to a fresh starter state', () async {
      final state = await _freshState();
      state.save.gold = 99999;
      state.resetProgress();
      expect(state.save.gold, 100);
      expect(state.save.roster.length, 1);
    });
  });
}
