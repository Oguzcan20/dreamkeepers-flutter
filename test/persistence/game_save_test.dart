import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/persistence/cloud_save_store.dart';
import 'package:dreamkeepers/persistence/game_save.dart';
import 'package:dreamkeepers/persistence/save_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('GameSave', () {
    test('newGame seeds a starter roster/team and default currencies', () {
      final save = GameSave.newGame(starterDefinitionID: 'ember_fox');
      expect(save.roster.length, 1);
      expect(save.roster.first.definitionID, 'ember_fox');
      expect(save.teams.length, 1);
      expect(save.teams.first.memberIDs, [save.roster.first.id]);
      expect(save.activeTeamID, save.teams.first.id);
      expect(save.gold, 100);
      expect(save.dreamGems, 50);
      expect(save.hasSeenOnboarding, isFalse);
    });

    test('toJson/fromJson round-trips every field', () {
      final original = GameSave.newGame(starterDefinitionID: 'moon_hare');
      original.gold = 999;
      original.dreamGems = 42;
      original.currentStage = 17;
      original.arenaFloor = 8;
      original.unlockedAchievementIDs = {'first_summon', 'first_boss'};
      original.dailyMissionProgress = {'winBattle': 2};
      original.preferredLanguage = 'de';

      final restored = GameSave.fromJson(jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>);

      expect(restored.gold, 999);
      expect(restored.dreamGems, 42);
      expect(restored.currentStage, 17);
      expect(restored.arenaFloor, 8);
      expect(restored.unlockedAchievementIDs, {'first_summon', 'first_boss'});
      expect(restored.dailyMissionProgress, {'winBattle': 2});
      expect(restored.preferredLanguage, 'de');
      expect(restored.roster.first.definitionID, 'moon_hare');
      expect(restored.activeTeamID, original.activeTeamID);
    });

    test('fromJson backfills missing newer fields with safe defaults', () {
      final minimal = GameSave.newGame(starterDefinitionID: 'ember_fox').toJson();
      minimal.remove('arenaFloor');
      minimal.remove('energy');
      minimal.remove('hasSeenOnboarding');
      minimal.remove('hasUsedBeginnerMultiSummon');

      final restored = GameSave.fromJson(minimal);
      expect(restored.arenaFloor, 1);
      expect(restored.energy, greaterThan(0));
      // Missing hasSeenOnboarding means an old save — treat as already seen.
      expect(restored.hasSeenOnboarding, isTrue);
      // Missing hasUsedBeginnerMultiSummon means an old save — treat as used.
      expect(restored.hasUsedBeginnerMultiSummon, isTrue);
    });
  });

  group('LocalSaveStore', () {
    test('load returns null when nothing has been saved yet', () async {
      final store = LocalSaveStore();
      expect(await store.load(), isNull);
    });

    test('save then load round-trips through shared_preferences', () async {
      final store = LocalSaveStore();
      final save = GameSave.newGame(starterDefinitionID: 'forest_spirit');
      save.gold = 555;
      await store.save(save);

      final loaded = await store.load();
      expect(loaded, isNotNull);
      expect(loaded!.gold, 555);
      expect(loaded.roster.first.definitionID, 'forest_spirit');
    });
  });

  group('CloudSaveStore', () {
    test('falls back to the local copy (no cloud backend wired up yet)', () async {
      final store = CloudSaveStore();
      final save = GameSave.newGame(starterDefinitionID: 'ember_fox');
      save.gold = 321;
      await store.save(save);

      final loaded = await store.load();
      expect(loaded, isNotNull);
      expect(loaded!.gold, 321);
    });
  });
}
