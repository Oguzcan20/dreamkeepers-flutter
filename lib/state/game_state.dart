import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../combat/arena_system.dart';
import '../combat/battle_engine.dart';
import '../combat/combatant.dart';
import '../combat/enemy_factory.dart';
import '../combat/twin_bond.dart';
import '../data/dreamkeeper_catalog.dart';
import '../data/monster_catalog.dart';
import '../data/shop_catalog.dart';
import '../data/world_catalog.dart';
import '../models/dreamkeeper.dart';
import '../models/element.dart';
import '../models/equipment.dart';
import '../models/rarity.dart';
import '../models/shop_item.dart';
import '../models/stats.dart';
import '../models/team.dart';
import '../models/world.dart';
import '../persistence/cloud_save_store.dart';
import '../persistence/game_save.dart';
import '../persistence/save_system.dart';
import '../platform/ad_reward_service.dart';
import '../platform/interstitial_ad_service.dart';
import '../platform/platform_service.dart';
import '../platform/purchase_service.dart';
import '../progression/achievement_system.dart';
import '../progression/battle_pass_system.dart';
import '../progression/daily_missions.dart';
import '../progression/dreamkeeper_sale_system.dart';
import '../progression/energy_system.dart';
import '../progression/equipment_factory.dart';
import '../progression/equipment_summon_system.dart';
import '../progression/equipment_upgrade.dart';
import '../progression/level_system.dart';
import '../progression/login_reward_system.dart';
import '../progression/offline_rewards.dart';
import '../progression/rewards.dart';
import '../progression/star_fusion_system.dart';
import '../progression/summon_system.dart';
import '../progression/weekly_missions.dart';

final _random = Random();

// -- Date helpers ------------------------------------------------------
// Private top-level functions replacing Swift's `Calendar.current` helpers.

DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool _isToday(DateTime d) => _isSameDay(d, DateTime.now());

bool _isYesterday(DateTime d) =>
    _isSameDay(d, DateTime.now().subtract(const Duration(days: 1)));

/// Monday-start of the calendar week containing `d` — mirrors Swift's
/// `Calendar.current.dateInterval(of: .weekOfYear, for:)?.start`.
DateTime _startOfWeek(DateTime d) {
  final start = _startOfDay(d);
  return start.subtract(Duration(days: start.weekday - DateTime.monday));
}

// -- Result types --------------------------------------------------------

class LevelUpSummary {
  final String name;
  final int oldLevel;
  final int newLevel;
  final Stats statsBefore;
  final Stats statsAfter;

  const LevelUpSummary({
    required this.name,
    required this.oldLevel,
    required this.newLevel,
    required this.statsBefore,
    required this.statsAfter,
  });
}

class AccountLevelUp {
  final int oldLevel;
  final int newLevel;

  const AccountLevelUp({required this.oldLevel, required this.newLevel});
}

/// Result of one Arena Tower floor fight — deliberately its own type rather
/// than reusing `BattleResultSummary`: this never touches roster EXP/levels
/// or campaign progress, and adds tower-specific concepts (`isMilestoneFloor`,
/// `towerCleared`) that don't apply to a campaign stage.
class ArenaBattleResultSummary {
  final BattleOutcome outcome;
  final int floor;
  final int goldGained;
  final ArenaTier newTier;
  final bool tierChanged;
  final EquipmentItem? droppedEquipment;

  /// True when this win was `floor`'s very first clear (bigger, fixed
  /// reward, and the one that advances `GameState.arenaFloor`) rather than
  /// a replay of an already-cleared floor (smaller, RNG farm reward).
  final bool isFirstClear;

  /// True when `floor` was a multiple of `ArenaSystem.milestoneInterval`
  /// AND this was its first clear.
  final bool isMilestoneFloor;

  /// True the instant `floor` was `ArenaSystem.maxFloor` and its first
  /// clear was won.
  final bool towerCleared;

  const ArenaBattleResultSummary({
    required this.outcome,
    required this.floor,
    required this.goldGained,
    required this.newTier,
    required this.tierChanged,
    this.droppedEquipment,
    required this.isFirstClear,
    required this.isMilestoneFloor,
    required this.towerCleared,
  });
}

class BattleResultSummary {
  final BattleOutcome outcome;
  final int stage;
  final bool wasBoss;
  final int goldGained;
  final int expGained;
  final List<LevelUpSummary> levelUps;
  final DreamkeeperDefinition? newRecruit;
  final EquipmentItem? droppedEquipment;
  final AccountLevelUp? accountLevelUp;

  /// True when the whole party ended the fight at full HP.
  final bool isPerfectClear;
  final int perfectClearBonusGold;

  const BattleResultSummary({
    required this.outcome,
    required this.stage,
    required this.wasBoss,
    required this.goldGained,
    required this.expGained,
    required this.levelUps,
    this.newRecruit,
    this.droppedEquipment,
    this.accountLevelUp,
    this.isPerfectClear = false,
    this.perfectClearBonusGold = 0,
  });
}

class TrainingResult {
  final int expGranted;
  final List<LevelUpSummary> levelUps;

  const TrainingResult({required this.expGranted, required this.levelUps});
}

class MissionStatus {
  final MissionDefinition definition;
  final int progress;
  final bool isClaimed;
  final bool isLocked;

  const MissionStatus({
    required this.definition,
    required this.progress,
    required this.isClaimed,
    required this.isLocked,
  });

  MissionID get id => definition.id;
  bool get isComplete => progress >= definition.target;
}

class WeeklyMissionStatus {
  final WeeklyMissionDefinition definition;
  final int progress;
  final bool isClaimed;

  const WeeklyMissionStatus({
    required this.definition,
    required this.progress,
    required this.isClaimed,
  });

  WeeklyMissionID get id => definition.id;
  bool get isComplete => progress >= definition.target;
}

/// App-wide root state: the single source of truth the UI reads and
/// mutates. Owns persistence (via SaveSystem) and content (via
/// DreamkeeperCatalog) but stays free of any particular UI framework
/// coupling beyond `ChangeNotifier` (the Flutter analog of Swift's
/// `@Observable`). Mirrors GameCore/State/GameState.swift exactly, adapted
/// for Dart's lack of a synchronous-constructor-with-async-load pattern —
/// see `GameState.create`.
class GameState extends ChangeNotifier {
  final DreamkeeperCatalog catalog;
  final PlatformService _platform;
  final SaveSystem _saveSystem;
  final AdRewardService _adService;
  final InterstitialAdService _interstitialAdService;
  final PurchaseService _purchaseService;

  GameSave _save;
  GameSave get save => _save;

  /// Which stage a battle will be fought at — distinct from `save.currentStage`
  /// (the progression frontier) so cleared stages can be replayed without
  /// re-advancing the campaign or re-granting boss rewards.
  int _selectedStage;
  int get selectedStage => _selectedStage;

  /// Newly-unlocked achievements waiting for their celebration popup —
  /// transient (not persisted; `save.unlockedAchievementIDs` is the
  /// durable record). The UI drains this one at a time.
  final List<Achievement> _pendingAchievements = [];
  List<Achievement> get pendingAchievements => List.unmodifiable(_pendingAchievements);

  Achievement? consumeNextPendingAchievement() =>
      _pendingAchievements.isEmpty ? null : _pendingAchievements.removeAt(0);

  GameState._({
    required PlatformService platform,
    required SaveSystem saveSystem,
    required this.catalog,
    required AdRewardService adService,
    required InterstitialAdService interstitialAdService,
    required PurchaseService purchaseService,
    required GameSave save,
    required int selectedStage,
  })  : _platform = platform,
        _saveSystem = saveSystem,
        _adService = adService,
        _interstitialAdService = interstitialAdService,
        _purchaseService = purchaseService,
        _save = save,
        _selectedStage = selectedStage;

  /// Async factory replacing Swift's synchronous `init` — Dart's
  /// `SaveSystem.load()` is `Future`-based (backed by `shared_preferences`),
  /// so the whole construction has to be asynchronous. Every service
  /// defaults to its noop/mock implementation, same fallback Swift's
  /// default parameter values provide.
  static Future<GameState> create({
    PlatformService? platform,
    SaveSystem? saveSystem,
    DreamkeeperCatalog? catalog,
    AdRewardService? adService,
    InterstitialAdService? interstitialAdService,
    PurchaseService? purchaseService,
  }) async {
    final resolvedPlatform = platform ?? NoopPlatformService();
    final resolvedSaveSystem = saveSystem ?? CloudSaveStore();
    final resolvedCatalog = catalog ?? DreamkeeperCatalog.starter;
    final resolvedAdService = adService ?? MockAdRewardService();
    final resolvedInterstitialAdService = interstitialAdService ?? MockInterstitialAdService();
    final resolvedPurchaseService = purchaseService ?? MockPurchaseService();

    final loaded = await resolvedSaveSystem.load() ??
        GameSave.newGame(starterDefinitionID: DreamkeeperCatalog.starterOlfDefaultID);

    final state = GameState._(
      platform: resolvedPlatform,
      saveSystem: resolvedSaveSystem,
      catalog: resolvedCatalog,
      adService: resolvedAdService,
      interstitialAdService: resolvedInterstitialAdService,
      purchaseService: resolvedPurchaseService,
      save: loaded,
      selectedStage: min(loaded.currentStage, WorldCatalog.totalStages),
    );

    state.persist();
    if (loaded.notificationsEnabled) {
      // Re-arm both building timers on every cold launch (cheap and
      // idempotent) so a pending reminder that already fired, or never got
      // scheduled before a force-quit, is always caught up.
      state._scheduleBuildingNotifications();
    }
    // Simplified vs. Swift's `StoreKitPurchaseService` type-check: no
    // platform-specific purchase implementation exists yet in Dart, so
    // every `PurchaseService` (mock included) gets this wired.
    resolvedPurchaseService.onExternalPurchase = state._grantPurchase;

    return state;
  }

  /// Grants the `ShopItem` matching `productID` — called for a verified
  /// transaction the billing SDK reports outside the interactive purchase
  /// flow (a restore, or an approval that completes after the original
  /// `purchaseWithRealMoney` call already returned).
  void _grantPurchase(String productID) {
    final matches = ShopCatalog.allRealMoneyItems.where((i) => i.productID == productID);
    if (matches.isEmpty) return;
    purchase(matches.first);
  }

  // MARK: - Persistence

  void persist() {
    _saveSystem.save(_save);
    notifyListeners();
  }

  /// Saves immediately, but defers `notifyListeners()` to the next
  /// microtask instead of firing it synchronously.
  ///
  /// `_ensureMissionsCurrent`/`_ensureWeeklyMissionsCurrent` persist a reset
  /// or a fresh daily draw from inside plain read getters (`dailyMissions`,
  /// `hasUnclaimedMissions`, ...) — and those getters are read directly from
  /// widget `build()` methods (e.g. `DreamHavenView`'s header badge). A
  /// synchronous `notifyListeners()` there trips Flutter's "setState() or
  /// markNeedsBuild() called during build" assertion, since `Provider`
  /// tries to mark its `InheritedWidget` dirty while the tree is still
  /// being built. Deferring to a microtask (rather than gating on
  /// `SchedulerBinding`, which asserts if no Flutter binding has been
  /// initialized — true of plain `GameState`-only unit tests) sidesteps the
  /// assertion in every context, widget tree or not. Use this instead of
  /// `persist()` for any mutation that can be triggered by a getter read
  /// during build.
  void _persistDeferringNotifyDuringBuild() {
    _saveSystem.save(_save);
    scheduleMicrotask(notifyListeners);
  }

  // MARK: - Achievements

  /// Re-evaluates every not-yet-unlocked `AchievementSystem` milestone
  /// against current state and queues any that just became true.
  List<Achievement> checkAchievements({AchievementContext context = const AchievementContext()}) {
    final unlocked = <Achievement>[];
    for (final achievement in AchievementSystem.all) {
      if (_save.unlockedAchievementIDs.contains(achievement.id)) continue;
      if (achievement.predicate(this, context)) {
        _save.unlockedAchievementIDs.add(achievement.id);
        unlocked.add(achievement);
      }
    }
    if (unlocked.isNotEmpty) {
      _pendingAchievements.addAll(unlocked);
      persist();
    }
    return unlocked;
  }

  // MARK: - Energy

  int get maxEnergy => EnergySystem.maxEnergy;

  /// Applies any regen owed since `lastEnergyUpdateAt` before returning the
  /// current total — called on every read so the displayed number is
  /// always live without needing a running timer.
  int get energy {
    _refreshEnergy();
    return _save.energy;
  }

  /// Seconds until the next point regenerates, or null once the bar is
  /// already full.
  int? get secondsUntilNextEnergy {
    _refreshEnergy();
    if (_save.energy >= EnergySystem.maxEnergy) return null;
    final elapsed = DateTime.now().difference(_save.lastEnergyUpdateAt).inSeconds;
    return max(0, EnergySystem.regenIntervalSeconds - elapsed);
  }

  bool canAffordEnergy(int amount) => energy >= amount;

  /// Advances `save.energy` by however many `regenIntervalSeconds` ticks
  /// have elapsed since the stored baseline, preserving any leftover
  /// partial progress toward the next tick. A no-op whenever there's
  /// nothing to apply, so read-time callers never write (and thus never
  /// `notifyListeners()`) unless something actually changed.
  void _refreshEnergy() {
    if (_save.energy >= EnergySystem.maxEnergy) return;
    final elapsed = DateTime.now().difference(_save.lastEnergyUpdateAt).inSeconds;
    final ticks = elapsed ~/ EnergySystem.regenIntervalSeconds;
    if (ticks <= 0) return;
    _save.energy = min(EnergySystem.maxEnergy, _save.energy + ticks);
    _save.lastEnergyUpdateAt = _save.lastEnergyUpdateAt
        .add(Duration(seconds: ticks * EnergySystem.regenIntervalSeconds));
    persist();
  }

  /// Tops energy up without exceeding the cap — used by mission/login
  /// rewards, which would otherwise waste the overflow on a full bar.
  void _grantEnergy(int amount) {
    if (amount <= 0) return;
    _refreshEnergy();
    _save.energy = min(EnergySystem.maxEnergy, _save.energy + amount);
    if (_save.energy >= EnergySystem.maxEnergy) {
      _save.lastEnergyUpdateAt = DateTime.now();
    }
  }

  bool spendEnergy(int amount) {
    if (!canAffordEnergy(amount)) return false;
    final wasFull = _save.energy >= EnergySystem.maxEnergy;
    _save.energy -= amount;
    if (wasFull) {
      _save.lastEnergyUpdateAt = DateTime.now();
    }
    persist();
    return true;
  }

  /// Calendar-day-scoped counter, same reset pattern as `rewardedAdWatchDay`.
  void _ensureEnergyRefillDayCurrent() {
    final today = _startOfDay(DateTime.now());
    if (_isSameDay(_save.energyRefillDay, today)) return;
    _save.energyRefillDay = today;
    _save.energyRefillCount = 0;
  }

  int get energyRefillsRemainingToday {
    _ensureEnergyRefillDayCurrent();
    return max(0, EnergySystem.maxRefillsPerDay - _save.energyRefillCount);
  }

  int get nextEnergyRefillGemCost {
    _ensureEnergyRefillDayCurrent();
    return EnergySystem.refillGemCost(_save.energyRefillCount);
  }

  bool get canRefillEnergyWithGems =>
      energyRefillsRemainingToday > 0 && _save.dreamGems >= nextEnergyRefillGemCost;

  /// Spends Dream Gems for an immediate `EnergySystem.energyPerRefill`
  /// top-up.
  bool refillEnergyWithGems() {
    _ensureEnergyRefillDayCurrent();
    if (!canRefillEnergyWithGems) return false;
    _save.dreamGems -= nextEnergyRefillGemCost;
    _save.energyRefillCount += 1;
    _grantEnergy(EnergySystem.energyPerRefill);
    persist();
    return true;
  }

  // MARK: - Login streak

  /// True whenever today's login reward hasn't been claimed yet.
  bool get isLoginRewardAvailable => !_isToday(_save.lastLoginRewardClaimDate);

  /// The day (1...`LoginRewardSystem.cycleLength`) that `claimLoginReward()`
  /// would grant right now.
  int get nextLoginRewardDay {
    if (_isYesterday(_save.lastLoginRewardClaimDate)) {
      return _save.loginStreakDay % LoginRewardSystem.cycleLength + 1;
    }
    return 1;
  }

  /// Grants today's login-streak reward and advances the streak. No-op
  /// (returns null) if already claimed today.
  LoginRewardDay? claimLoginReward() {
    if (!isLoginRewardAvailable) return null;
    final reward = LoginRewardSystem.reward(nextLoginRewardDay);
    if (reward == null) return null;
    _save.gold += reward.gold;
    _save.dreamGems += reward.gems;
    _grantEnergy(reward.energy);
    _save.loginStreakDay = reward.day;
    _save.lastLoginRewardClaimDate = DateTime.now();
    persist();
    checkAchievements();
    return reward;
  }

  // MARK: - Roster / team

  List<DreamkeeperInstance> get roster => _save.roster;

  /// Distinct species owned — unlike `roster.length`, doesn't inflate with
  /// duplicate copies kept around as fusion fodder.
  int get ownedSpeciesCount => _save.roster.map((i) => i.definitionID).toSet().length;

  static const maxTeams = 5;

  List<Team> get teams => _save.teams;
  String get activeTeamID => _save.activeTeamID;

  int get _activeTeamIndex {
    final idx = _save.teams.indexWhere((t) => t.id == _save.activeTeamID);
    return idx >= 0 ? idx : 0;
  }

  Team get activeTeam => _save.teams[_activeTeamIndex];

  void setActiveTeam(String id) {
    if (!_save.teams.any((t) => t.id == id)) return;
    _save.activeTeamID = id;
    persist();
  }

  Team? createTeam() {
    if (_save.teams.length >= maxTeams) return null;
    final newTeam = Team(name: 'Team ${_save.teams.length + 1}');
    _save.teams.add(newTeam);
    persist();
    return newTeam;
  }

  List<DreamkeeperInstance> get deployedTeam {
    final members = _save.teams[_activeTeamIndex].memberIDs;
    final result = <DreamkeeperInstance>[];
    for (final id in members) {
      final matches = _save.roster.where((r) => r.id == id);
      if (matches.isNotEmpty) result.add(matches.first);
    }
    return result;
  }

  bool isDeployed(DreamkeeperInstance instance) =>
      _save.teams[_activeTeamIndex].memberIDs.contains(instance.id);

  void toggleDeployed(DreamkeeperInstance instance) {
    final members = _save.teams[_activeTeamIndex].memberIDs;
    if (members.contains(instance.id)) {
      members.remove(instance.id);
    } else if (members.length < Team.maxSize) {
      members.add(instance.id);
    }
    if (members.length == Team.maxSize) {
      _incrementMission(MissionID.deployFullTeam);
    }
    persist();
    checkAchievements();
  }

  DreamkeeperDefinition? definition(DreamkeeperInstance instance) =>
      catalog.definition(instance.definitionID);

  // MARK: - Selling Dreamkeepers

  /// A Dreamkeeper can always be sold except the very last one in the
  /// roster. Igo and Ames are never sellable — see `TwinBond`.
  bool canSellDreamkeeper(DreamkeeperInstance instance) {
    if (_save.roster.length <= 1 || !_save.roster.any((r) => r.id == instance.id)) {
      return false;
    }
    return definition(instance)?.rarity != Rarity.exclusive;
  }

  /// Gold (always) and Dream Gems (Legendary/Mythic only) a sale would pay
  /// out right now.
  ({int gold, int gems}) sellValue(DreamkeeperInstance instance) {
    final rarity = definition(instance)?.rarity ?? Rarity.common;
    return (
      gold: DreamkeeperSaleSystem.goldValue(rarity: rarity, level: instance.level, stars: instance.stars),
      gems: DreamkeeperSaleSystem.gemValue(rarity),
    );
  }

  /// Sells any number of roster Dreamkeepers at once — benching and
  /// unequipping each first.
  ({int gold, int gems, int count}) sellDreamkeepers(Set<String> ids) {
    var totalGold = 0;
    var totalGems = 0;
    var sold = 0;
    for (final id in ids) {
      if (_save.roster.length <= 1) continue;
      final matches = _save.roster.where((r) => r.id == id);
      if (matches.isEmpty) continue;
      final instance = matches.first;
      if (!canSellDreamkeeper(instance)) continue;
      final value = sellValue(instance);
      totalGold += value.gold;
      totalGems += value.gems;
      sold += 1;
      for (final team in _save.teams) {
        team.memberIDs.removeWhere((m) => m == id);
      }
      _save.roster.removeWhere((r) => r.id == id);
    }
    if (sold == 0) return (gold: 0, gems: 0, count: 0);
    _save.gold += totalGold;
    _save.dreamGems += totalGems;
    persist();
    checkAchievements();
    return (gold: totalGold, gems: totalGems, count: sold);
  }

  // MARK: - Star fusion

  /// Other owned copies of the same species as `target` — fusion fodder.
  /// When `target`'s definition has a non-null `family` (currently only
  /// Olf's six entries), any roster member sharing that family counts as a
  /// duplicate too, not just an exact `definitionID` match — so any Olf
  /// variant pulled later from Summoning can be fused straight into
  /// whichever one the player is actually raising. Every other Dreamkeeper
  /// (`family == null`) keeps the original strict-id match.
  List<DreamkeeperInstance> duplicates(DreamkeeperInstance target) {
    final targetFamily = catalog.definition(target.definitionID)?.family;
    if (targetFamily == null) {
      return _save.roster
          .where((i) => i.definitionID == target.definitionID && i.id != target.id)
          .toList();
    }
    return _save.roster
        .where((i) =>
            i.id != target.id &&
            (i.definitionID == target.definitionID ||
                catalog.definition(i.definitionID)?.family == targetFamily))
        .toList();
  }

  /// Duplicates required for `target`'s next star tier, or null if already maxed.
  int? nextFusionCost(DreamkeeperInstance target) {
    if (target.stars >= StarFusionSystem.maxStars) return null;
    return StarFusionSystem.duplicatesRequired(target.stars + 1);
  }

  /// `selected` just needs to be one or more real duplicates of `target`
  /// currently in the roster, with no repeats.
  bool canFuseDreamkeeper(DreamkeeperInstance target, List<DreamkeeperInstance> selected) {
    if (target.stars >= StarFusionSystem.maxStars || selected.isEmpty) return false;
    final selectedIDs = selected.map((i) => i.id).toSet();
    if (selectedIDs.length != selected.length || selectedIDs.contains(target.id)) return false;
    final validDuplicateIDs = duplicates(target).map((i) => i.id).toSet();
    return selectedIDs.every(validDuplicateIDs.contains);
  }

  /// Deletes `selected` from the roster (and benches them if deployed),
  /// then banks their count onto `target.fusionProgress`, resolving as
  /// many star tier-ups as the combined total supports.
  bool fuseDreamkeeper(DreamkeeperInstance target, List<DreamkeeperInstance> selected) {
    if (!canFuseDreamkeeper(target, selected)) return false;
    final selectedIDs = selected.map((i) => i.id).toSet();
    _save.roster.removeWhere((r) => selectedIDs.contains(r.id));
    for (final team in _save.teams) {
      team.memberIDs.removeWhere(selectedIDs.contains);
    }
    final idx = _save.roster.indexWhere((r) => r.id == target.id);
    if (idx == -1) return false;
    final result = StarFusionSystem.applyFusion(
      newDuplicates: selected.length,
      stars: _save.roster[idx].stars,
      progress: _save.roster[idx].fusionProgress,
    );
    _save.roster[idx] = _save.roster[idx].copyWith(stars: result.$1, fusionProgress: result.$2);
    persist();
    checkAchievements();
    return true;
  }

  // MARK: - Campaign / battle setup

  int get currentStage => _save.currentStage;
  bool get isCampaignComplete => _save.currentStage > WorldCatalog.totalStages;

  /// A stage is selectable once it's been unlocked by reaching it.
  bool isStageUnlocked(int stage) => stage <= _save.currentStage;

  void selectStage(int stage) {
    if (!isStageUnlocked(stage) || stage < 1 || stage > WorldCatalog.totalStages) return;
    _selectedStage = stage;
  }

  /// Selects `stage` and spends its Energy cost up front. Returns false (no
  /// state change) when the stage can't be selected or Energy is short.
  bool attemptStage(int stage) {
    if (!isStageUnlocked(stage) || stage < 1 || stage > WorldCatalog.totalStages) return false;
    final isBoss = stage % World.stagesPerWorld == 0;
    if (!spendEnergy(EnergySystem.stageCost(isBoss: isBoss))) return false;
    _selectedStage = stage;
    persist();
    return true;
  }

  /// Shared by `makeBattleEngine()` and `makeArenaBattleEngine(floor:)` so
  /// Campaign and Arena battles apply Zwillingsbund identically.
  List<Combatant> _makePlayerCombatants(List<DreamkeeperInstance> team) {
    final twinBondActive = TwinBond.isActive(team.map((i) => i.definitionID));
    final result = <Combatant>[];
    for (final instance in team) {
      final def = definition(instance);
      if (def == null) continue;
      var stats = instance.currentStats(definition: def, inventory: _save.inventory);
      if (twinBondActive && TwinBond.isBondCharacter(instance.definitionID)) {
        stats = Stats(
          hp: stats.hp,
          attack: stats.attack * (1 + TwinBond.statBonusMultiplier),
          defense: stats.defense * (1 + TwinBond.statBonusMultiplier),
          speed: stats.speed,
        );
      }
      result.add(Combatant(
        id: instance.id,
        name: def.name,
        element: def.element,
        role: def.role,
        isPlayer: true,
        isBoss: false,
        definitionID: instance.definitionID,
        maxHP: stats.hp,
        currentHP: stats.hp,
        attack: stats.attack,
        defense: stats.defense,
        speed: stats.speed,
        ultimate: def.ultimate,
        activeSkill: def.activeSkill,
        reviveHPFraction: def.passive.reviveHPFraction,
        lowHPAttackBonus: def.passive.lowHPAttackBonus,
      ));
    }
    return result;
  }

  BattleEngine? makeBattleEngine() {
    if (deployedTeam.isEmpty) return null;
    final playerCombatants = _makePlayerCombatants(deployedTeam);
    if (playerCombatants.isEmpty) return null;
    final isBoss = _selectedStage % World.stagesPerWorld == 0;
    final enemy = EnemyFactory.enemy(_selectedStage);
    return BattleEngine(
      playerUnits: playerCombatants,
      enemy: enemy,
      stage: _selectedStage,
      isBossStage: isBoss,
    );
  }

  // MARK: - Resolving a finished battle

  BattleResultSummary applyBattleResult(BattleEngine engine) {
    final outcome = engine.outcome ?? BattleOutcome.defeat;
    final stage = engine.stage;
    final isBoss = engine.isBossStage;
    final levelUps = <LevelUpSummary>[];
    var goldGained = 0;
    var expGained = 0;
    DreamkeeperDefinition? newRecruit;
    EquipmentItem? droppedEquipment;
    AccountLevelUp? accountLevelUp;
    var perfectClearBonusGold = 0;
    final isPerfectClear = outcome == BattleOutcome.victory &&
        engine.playerUnits.isNotEmpty &&
        engine.playerUnits.every((u) => u.currentHP >= u.maxHP);

    for (final foe in engine.enemyUnits) {
      _save.discoveredMonsters.add(foe.name);
    }

    if (outcome == BattleOutcome.victory) {
      _recordStageForInterstitialPacing();
      _incrementMission(MissionID.winBattle);
      _incrementMission(MissionID.premiumBonusStages);
      _incrementWeeklyMission(WeeklyMissionID.clearStages);
      if (isBoss) {
        _incrementMission(MissionID.defeatBoss);
        _incrementWeeklyMission(WeeklyMissionID.defeatBosses);
      }
      final rewards = RewardTable.rewards(stage: stage, isBoss: isBoss);
      goldGained = rewards.gold;
      expGained = rewards.expPerSurvivor;
      _save.gold += rewards.gold;
      _save.battlePassXP += BattlePassSystem.xpGained(isBoss: isBoss);

      if (isPerfectClear) {
        perfectClearBonusGold = max(1, (rewards.gold * 0.25).toInt());
        goldGained += perfectClearBonusGold;
        _save.gold += perfectClearBonusGold;
      }

      final accountBefore = _save.playerLevel;
      final accountResult =
          LevelSystem.applyExp(rewards.accountExp, level: _save.playerLevel, exp: _save.playerExp);
      _save.playerLevel = accountResult.finalLevel;
      _save.playerExp = accountResult.finalExp;
      if (accountResult.levelsGained > 0) {
        accountLevelUp = AccountLevelUp(oldLevel: accountBefore, newLevel: accountResult.finalLevel);
      }

      final survivorIDs = engine.playerUnits.where((u) => u.isAlive).map((u) => u.id).toSet();
      for (var i = 0; i < _save.roster.length; i++) {
        if (!survivorIDs.contains(_save.roster[i].id)) continue;
        final def = definition(_save.roster[i]);
        if (def == null) continue;
        final before = _save.roster[i];
        final statsBefore = before.currentStats(definition: def, inventory: _save.inventory);

        final result = LevelSystem.applyExp(rewards.expPerSurvivor, level: before.level, exp: before.exp);
        _save.roster[i] = before.copyWith(level: result.finalLevel, exp: result.finalExp);

        if (result.levelsGained > 0) {
          final statsAfter = _save.roster[i].currentStats(definition: def, inventory: _save.inventory);
          levelUps.add(LevelUpSummary(
            name: def.name,
            oldLevel: before.level,
            newLevel: result.finalLevel,
            statsBefore: statsBefore,
            statsAfter: statsAfter,
          ));
        }
      }

      if (EquipmentFactory.shouldDrop(isBoss: isBoss)) {
        final item = EquipmentFactory.randomItem(stage: stage, isBoss: isBoss);
        _save.inventory.add(item);
        droppedEquipment = item;
      }

      // Only the frontier stage advances the campaign.
      final wasFrontierClear = stage == _save.currentStage;
      if (wasFrontierClear) {
        _save.currentStage += 1;
        _selectedStage = min(_save.currentStage, WorldCatalog.totalStages);

        if (isBoss) {
          newRecruit = _grantNextRecruitIfAvailable();
        }
      }
    }

    persist();
    checkAchievements(context: AchievementContext(isPerfectClear: isPerfectClear));
    return BattleResultSummary(
      outcome: outcome,
      stage: stage,
      wasBoss: isBoss,
      goldGained: goldGained,
      expGained: expGained,
      levelUps: levelUps,
      newRecruit: newRecruit,
      droppedEquipment: droppedEquipment,
      accountLevelUp: accountLevelUp,
      isPerfectClear: isPerfectClear,
      perfectClearBonusGold: perfectClearBonusGold,
    );
  }

  // MARK: - Arena Tower

  int get arenaFloor => _save.arenaFloor;
  int get arenaMaxFloor => ArenaSystem.maxFloor;
  ArenaTier get arenaTier => ArenaTier.tier(_save.arenaFloor);
  bool get isArenaTowerCleared => _save.arenaFloor > ArenaSystem.maxFloor;

  /// Calendar-day-scoped ticket counter.
  void _ensureArenaTicketDayCurrent() {
    final today = _startOfDay(DateTime.now());
    if (_isSameDay(_save.arenaTicketDay, today)) return;
    _save.arenaTicketDay = today;
    _save.arenaTickets = ArenaSystem.maxTicketsPerDay;
  }

  int get arenaTicketsRemainingToday {
    _ensureArenaTicketDayCurrent();
    return _save.arenaTickets;
  }

  /// Non-resetting balance from real-money ticket packs and Battle Pass
  /// rewards.
  int get arenaBonusTickets => _save.arenaBonusTickets;

  int get totalArenaTicketsAvailable => arenaTicketsRemainingToday + arenaBonusTickets;

  /// A floor is unlocked once the player has reached it as their climb
  /// frontier.
  bool isFloorUnlocked(int floor) => floor >= 1 && floor <= _save.arenaFloor;

  /// True once `floor` has already been cleared at least once.
  bool isFloorCleared(int floor) => floor < _save.arenaFloor;

  /// The rival guarding `floor` — deterministic per floor.
  ArenaOpponent arenaOpponent(int floor) => ArenaSystem.opponentForFloor(floor, catalog);

  bool canAffordArenaBattle() => deployedTeam.isNotEmpty && totalArenaTicketsAvailable > 0;

  /// Builds a battle against `floor`'s rival, spending a ticket up front.
  BattleEngine? makeArenaBattleEngine(int floor) {
    _ensureArenaTicketDayCurrent();
    if (deployedTeam.isEmpty || !isFloorUnlocked(floor)) return null;
    final rival = ArenaSystem.makeCombatant(arenaOpponent(floor), catalog);
    if (rival == null) return null;

    final playerCombatants = _makePlayerCombatants(deployedTeam);
    if (playerCombatants.isEmpty || totalArenaTicketsAvailable <= 0) return null;
    if (_save.arenaTickets > 0) {
      _save.arenaTickets -= 1;
    } else {
      _save.arenaBonusTickets -= 1;
    }
    persist();
    return BattleEngine(playerUnits: playerCombatants, enemy: rival, stage: floor, isBossStage: false);
  }

  /// Applies reward changes for a finished Arena Tower fight.
  ArenaBattleResultSummary applyArenaBattleResult(BattleEngine engine) {
    final outcome = engine.outcome ?? BattleOutcome.defeat;
    final won = outcome == BattleOutcome.victory;
    final floor = engine.stage;
    final oldTier = arenaTier;
    final isFirstClear = floor == _save.arenaFloor;
    final isMilestone = ArenaSystem.isMilestoneFloor(floor);

    var goldGained = 0;
    EquipmentItem? droppedEquipment;
    var towerCleared = false;

    if (won) {
      _incrementMission(MissionID.winBattle);

      if (isFirstClear) {
        goldGained = ArenaSystem.firstClearGoldReward(floor);
        _save.gold += goldGained;
        final item = ArenaSystem.firstClearEquipment(floor);
        _save.inventory.add(item);
        droppedEquipment = item;
        _save.arenaFloor = floor + 1;
        towerCleared = _save.arenaFloor > ArenaSystem.maxFloor;
      } else {
        goldGained = ArenaSystem.standardGoldReward(floor);
        _save.gold += goldGained;
        final item = ArenaSystem.standardEquipmentDrop(floor);
        if (item != null) {
          _save.inventory.add(item);
          droppedEquipment = item;
        }
      }
    }

    persist();
    checkAchievements();
    final newTier = arenaTier;
    return ArenaBattleResultSummary(
      outcome: outcome,
      floor: floor,
      goldGained: goldGained,
      newTier: newTier,
      tierChanged: newTier != oldTier,
      droppedEquipment: droppedEquipment,
      isFirstClear: isFirstClear,
      isMilestoneFloor: isFirstClear && isMilestone,
      towerCleared: towerCleared,
    );
  }

  // MARK: - Stage sweep

  /// A stage can be swept once it's behind the campaign frontier.
  bool canSweepStage(int stage) =>
      stage >= 1 && stage < _save.currentStage && deployedTeam.isNotEmpty;

  /// Instantly re-clears an already-cleared stage for the exact same
  /// payout as fighting it live — no `BattleEngine`, no animation.
  BattleResultSummary? sweepStage(int stage) {
    if (!canSweepStage(stage)) return null;
    final isBoss = stage % World.stagesPerWorld == 0;
    if (!spendEnergy(EnergySystem.stageCost(isBoss: isBoss))) return null;
    final rewards = RewardTable.rewards(stage: stage, isBoss: isBoss);

    _save.gold += rewards.gold;

    final accountBefore = _save.playerLevel;
    final accountResult =
        LevelSystem.applyExp(rewards.accountExp, level: _save.playerLevel, exp: _save.playerExp);
    _save.playerLevel = accountResult.finalLevel;
    _save.playerExp = accountResult.finalExp;
    final accountLevelUp = accountResult.levelsGained > 0
        ? AccountLevelUp(oldLevel: accountBefore, newLevel: accountResult.finalLevel)
        : null;

    final levelUps = <LevelUpSummary>[];
    for (var i = 0; i < _save.roster.length; i++) {
      if (!isDeployed(_save.roster[i])) continue;
      final def = definition(_save.roster[i]);
      if (def == null) continue;
      final before = _save.roster[i];
      final statsBefore = before.currentStats(definition: def, inventory: _save.inventory);

      final result = LevelSystem.applyExp(rewards.expPerSurvivor, level: before.level, exp: before.exp);
      _save.roster[i] = before.copyWith(level: result.finalLevel, exp: result.finalExp);

      if (result.levelsGained > 0) {
        final statsAfter = _save.roster[i].currentStats(definition: def, inventory: _save.inventory);
        levelUps.add(LevelUpSummary(
          name: def.name,
          oldLevel: before.level,
          newLevel: result.finalLevel,
          statsBefore: statsBefore,
          statsAfter: statsAfter,
        ));
      }
    }

    EquipmentItem? droppedEquipment;
    if (EquipmentFactory.shouldDrop(isBoss: isBoss)) {
      final item = EquipmentFactory.randomItem(stage: stage, isBoss: isBoss);
      _save.inventory.add(item);
      droppedEquipment = item;
    }

    persist();
    checkAchievements();
    return BattleResultSummary(
      outcome: BattleOutcome.victory,
      stage: stage,
      wasBoss: isBoss,
      goldGained: rewards.gold,
      expGained: rewards.expPerSurvivor,
      levelUps: levelUps,
      droppedEquipment: droppedEquipment,
      accountLevelUp: accountLevelUp,
      isPerfectClear: false,
      perfectClearBonusGold: 0,
    );
  }

  // MARK: - Equipment

  List<EquipmentItem> get inventory => _save.inventory;

  /// Items in a slot not currently worn by anyone.
  List<EquipmentItem> availableItems(EquipmentSlot slot) {
    final equippedIDs = _save.roster.expand((r) => r.equipped.values).toSet();
    return _save.inventory.where((i) => i.slot == slot && !equippedIDs.contains(i.id)).toList();
  }

  EquipmentItem? equippedItem(EquipmentSlot slot, DreamkeeperInstance instance) {
    final itemID = instance.equipped[slot.name];
    if (itemID == null) return null;
    final matches = _save.inventory.where((i) => i.id == itemID);
    return matches.isEmpty ? null : matches.first;
  }

  void equip(EquipmentItem item, DreamkeeperInstance instance) {
    final idx = _save.roster.indexWhere((r) => r.id == instance.id);
    if (idx == -1) return;
    final equipped = Map<String, String>.from(_save.roster[idx].equipped);
    equipped[item.slot.name] = item.id;
    _save.roster[idx] = _save.roster[idx].copyWith(equipped: equipped);
    persist();
  }

  void unequip(EquipmentSlot slot, DreamkeeperInstance instance) {
    final idx = _save.roster.indexWhere((r) => r.id == instance.id);
    if (idx == -1) return;
    final equipped = Map<String, String>.from(_save.roster[idx].equipped);
    equipped.remove(slot.name);
    _save.roster[idx] = _save.roster[idx].copyWith(equipped: equipped);
    persist();
  }

  Stats currentStats(DreamkeeperInstance instance) =>
      instance.currentStats(definition: definition(instance), inventory: _save.inventory);

  /// Best unworn item in a slot, ranked rarity first, then level, then the
  /// slot's own primary stat bonus. Dart has no `max(by:)`, so this is a
  /// manual fold keeping the first-encountered maximal element on ties,
  /// same tie-break semantics as Swift's `max(by:)`.
  EquipmentItem? _bestAvailableItem(EquipmentSlot slot) {
    final items = availableItems(slot);
    EquipmentItem? best;
    for (final item in items) {
      if (best == null || _isUpgrade(item, best, slot)) {
        best = item;
      }
    }
    return best;
  }

  bool _isUpgrade(EquipmentItem candidate, EquipmentItem current, EquipmentSlot slot) {
    if (candidate.rarity != current.rarity) return candidate.rarity > current.rarity;
    if (candidate.level != current.level) return candidate.level > current.level;
    return slot.primaryStat(candidate.effectiveStatBonus) > slot.primaryStat(current.effectiveStatBonus);
  }

  /// Whether `autoEquipBest` would actually change anything for `instance`
  /// right now.
  bool canAutoEquip(DreamkeeperInstance instance) {
    for (final slot in EquipmentSlot.values) {
      final candidate = _bestAvailableItem(slot);
      if (candidate == null) continue;
      final current = equippedItem(slot, instance);
      if (current == null) return true;
      if (_isUpgrade(candidate, current, slot)) return true;
    }
    return false;
  }

  /// Equips the best available item into every slot at once.
  bool autoEquipBest(DreamkeeperInstance instance) {
    final idx = _save.roster.indexWhere((r) => r.id == instance.id);
    if (idx == -1) return false;
    var changed = false;
    var equipped = Map<String, String>.from(_save.roster[idx].equipped);
    for (final slot in EquipmentSlot.values) {
      final candidate = _bestAvailableItem(slot);
      if (candidate == null) continue;
      final current = equippedItem(slot, _save.roster[idx]);
      if (current != null && !_isUpgrade(candidate, current, slot)) continue;
      equipped[slot.name] = candidate.id;
      changed = true;
    }
    if (changed) {
      _save.roster[idx] = _save.roster[idx].copyWith(equipped: equipped);
      persist();
    }
    return changed;
  }

  /// Which Dreamkeeper (if any) currently has this item equipped.
  DreamkeeperInstance? wearer(EquipmentItem item) {
    final matches = _save.roster.where((r) => r.equipped[item.slot.name] == item.id);
    return matches.isEmpty ? null : matches.first;
  }

  /// Spends gold to raise an item's level in place. Returns false if the
  /// item is missing, already maxed, or the player can't afford it.
  bool upgradeEquipment(EquipmentItem item) {
    final idx = _save.inventory.indexWhere((i) => i.id == item.id);
    if (idx == -1 || !EquipmentUpgrade.canUpgrade(item)) return false;
    final cost = EquipmentUpgrade.cost(item);
    if (_save.gold < cost) return false;

    _save.gold -= cost;
    _save.inventory[idx] = EquipmentUpgrade.upgraded(item);
    _incrementMission(MissionID.upgradeEquipment);
    _incrementWeeklyMission(WeeklyMissionID.upgradeEquipment);
    persist();
    return true;
  }

  // MARK: - Equipment star fusion

  /// Other owned items of the same kind as `target` — fusion fodder.
  List<EquipmentItem> duplicatesOfItem(EquipmentItem target) =>
      _save.inventory.where((i) => i.id != target.id && i.isSameKind(target)).toList();

  /// Duplicates required for `target`'s next star tier, or null if already maxed.
  int? nextFusionCostForItem(EquipmentItem target) {
    if (target.stars >= StarFusionSystem.maxStars) return null;
    return StarFusionSystem.duplicatesRequired(target.stars + 1);
  }

  /// `selected` just needs to be one or more real duplicates of `target`
  /// currently in the inventory, with no repeats.
  bool canFuseItem(EquipmentItem target, List<EquipmentItem> selected) {
    if (target.stars >= StarFusionSystem.maxStars || selected.isEmpty) return false;
    final selectedIDs = selected.map((i) => i.id).toSet();
    if (selectedIDs.length != selected.length || selectedIDs.contains(target.id)) return false;
    final validDuplicateIDs = duplicatesOfItem(target).map((i) => i.id).toSet();
    return selectedIDs.every(validDuplicateIDs.contains);
  }

  /// Deletes `selected` from the inventory (unequipping them first if
  /// worn), then banks their count onto `target.fusionProgress`.
  bool fuseItem(EquipmentItem target, List<EquipmentItem> selected) {
    if (!canFuseItem(target, selected)) return false;
    final selectedIDs = selected.map((i) => i.id).toSet();
    for (var i = 0; i < _save.roster.length; i++) {
      final equipped = Map<String, String>.from(_save.roster[i].equipped);
      final toRemove = equipped.entries.where((e) => selectedIDs.contains(e.value)).map((e) => e.key).toList();
      if (toRemove.isEmpty) continue;
      for (final key in toRemove) {
        equipped.remove(key);
      }
      _save.roster[i] = _save.roster[i].copyWith(equipped: equipped);
    }
    _save.inventory.removeWhere((i) => selectedIDs.contains(i.id));
    final idx = _save.inventory.indexWhere((i) => i.id == target.id);
    if (idx == -1) return false;
    final result = StarFusionSystem.applyFusion(
      newDuplicates: selected.length,
      stars: _save.inventory[idx].stars,
      progress: _save.inventory[idx].fusionProgress,
    );
    _save.inventory[idx] = _save.inventory[idx].copyWith(stars: result.$1, fusionProgress: result.$2);
    persist();
    return true;
  }

  // MARK: - Summon pity

  /// Exposed for the Summoning Shrine's odds card, so pity progress is
  /// visible rather than a hidden mechanic.
  int get pullsSinceEpicSummon => _save.pullsSinceEpicSummon;
  int get pullsSinceLegendarySummon => _save.pullsSinceLegendarySummon;

  /// Rolls one pity-aware rarity and updates both counters from the
  /// result — the single roll path shared by Dreamkeeper and Equipment
  /// Summoning so the pity clock is one dial.
  Rarity _nextPitySummonRarity({double? roll}) {
    final rarity = SummonSystem.rollRarityWithPity(
      pullsSinceEpic: _save.pullsSinceEpicSummon,
      pullsSinceLegendary: _save.pullsSinceLegendarySummon,
      roll: roll,
    );
    if (rarity >= Rarity.legendary) {
      _save.pullsSinceEpicSummon = 0;
      _save.pullsSinceLegendarySummon = 0;
    } else if (rarity >= Rarity.epic) {
      _save.pullsSinceEpicSummon = 0;
      _save.pullsSinceLegendarySummon += 1;
    } else {
      _save.pullsSinceEpicSummon += 1;
      _save.pullsSinceLegendarySummon += 1;
    }
    return rarity;
  }

  // MARK: - Summoning

  bool get canAffordSummon => _save.dreamGems >= SummonSystem.cost;
  bool get canAffordMultiSummon => _save.dreamGems >= SummonSystem.multiPullCost;

  /// Rolls one pull and lands it in the roster — including duplicates,
  /// which sit benched as fusion fodder for a later manual fusion.
  /// `minimumRarity`, when set, raises a below-floor roll to it — used only
  /// for the one-time Beginner's Banner guarantee.
  SummonResult rollAndAddSummon({Rarity? minimumRarity, double? roll}) {
    var rarity = _nextPitySummonRarity(roll: roll);
    if (minimumRarity != null && rarity < minimumRarity) {
      rarity = minimumRarity;
    }
    // `.exclusive` (Igo/Ames) has no dupes and is always granted at max
    // level/stars — once both are owned the tier is unreachable, so a roll
    // that lands there quietly becomes a `.mythic` pull instead. See
    // `TwinBond`.
    var unownedExclusive = <DreamkeeperDefinition>[];
    if (rarity == Rarity.exclusive) {
      final ownedIDs = _save.roster.map((i) => i.definitionID).toSet();
      unownedExclusive =
          catalog.definitions.where((d) => d.rarity == Rarity.exclusive && !ownedIDs.contains(d.id)).toList();
      if (unownedExclusive.isEmpty) {
        rarity = Rarity.mythic;
      }
    }
    final definition = rarity == Rarity.exclusive
        ? unownedExclusive[_random.nextInt(unownedExclusive.length)]
        : SummonSystem.rollDefinitionForRarity(catalog, rarity);
    final isNew = !_save.roster.any((r) => r.definitionID == definition.id);
    final instance = rarity == Rarity.exclusive
        ? DreamkeeperInstance(
            definitionID: definition.id, level: LevelSystem.maxLevel, stars: StarFusionSystem.maxStars)
        : DreamkeeperInstance(definitionID: definition.id);
    _save.roster.add(instance);
    final members = _save.teams[_activeTeamIndex].memberIDs;
    if (isNew && members.length < Team.maxSize) {
      members.add(instance.id);
    }
    return SummonResult(definition: definition, isNew: isNew);
  }

  /// Returns null only when the player can't afford it.
  SummonResult? performSummon() {
    if (!canAffordSummon) return null;
    _save.dreamGems -= SummonSystem.cost;
    final result = rollAndAddSummon();
    _incrementMission(MissionID.performSummon);
    _incrementMission(MissionID.premiumBonusSummons);
    _incrementWeeklyMission(WeeklyMissionID.performSummons);
    persist();
    checkAchievements();
    return result;
  }

  /// Pays for `SummonSystem.multiPullPaidCount` pulls and returns
  /// `SummonSystem.multiPullTotalCount` results — the "10+1 free" bundle.
  /// The very first multi-pull the player ever makes (Dreamkeeper or
  /// Equipment) is a "Beginner's Banner": every roll in it is floored at
  /// Uncommon.
  List<SummonResult>? performMultiSummon() {
    if (!canAffordMultiSummon) return null;
    _save.dreamGems -= SummonSystem.multiPullCost;
    final isBeginnerPull = !_save.hasUsedBeginnerMultiSummon;
    final results = List.generate(
      SummonSystem.multiPullTotalCount,
      (_) => rollAndAddSummon(minimumRarity: isBeginnerPull ? Rarity.uncommon : null),
    );
    _save.hasUsedBeginnerMultiSummon = true;
    _incrementMission(MissionID.performSummon, by: results.length);
    _incrementMission(MissionID.premiumBonusSummons, by: results.length);
    _incrementWeeklyMission(WeeklyMissionID.performSummons, by: results.length);
    persist();
    checkAchievements();
    return results;
  }

  // MARK: - Equipment Summoning

  bool get canAffordEquipmentSummon => _save.dreamGems >= EquipmentSummonSystem.cost;
  bool get canAffordEquipmentMultiSummon => _save.dreamGems >= EquipmentSummonSystem.multiPullCost;

  /// Rolls one item at the player's current stage and drops it straight
  /// into the inventory — mirrors `rollAndAddSummon` above, but no
  /// mission/achievement bookkeeping here.
  EquipmentItem _rollAndAddEquipmentSummon({Rarity? minimumRarity}) {
    var rarity = _nextPitySummonRarity();
    if (minimumRarity != null && rarity < minimumRarity) {
      rarity = minimumRarity;
    }
    final item = EquipmentSummonSystem.rollItemForRarity(stage: _save.currentStage, rarity: rarity);
    _save.inventory.add(item);
    return item;
  }

  /// Returns null only when the player can't afford it.
  EquipmentItem? performEquipmentSummon() {
    if (!canAffordEquipmentSummon) return null;
    _save.dreamGems -= EquipmentSummonSystem.cost;
    final result = _rollAndAddEquipmentSummon();
    persist();
    checkAchievements();
    return result;
  }

  /// Pays for `EquipmentSummonSystem.multiPullPaidCount` pulls and returns
  /// `EquipmentSummonSystem.multiPullTotalCount` results — the "10+1 free"
  /// bundle. Shares the same one-time Beginner's Banner guarantee as
  /// `performMultiSummon`.
  List<EquipmentItem>? performEquipmentMultiSummon() {
    if (!canAffordEquipmentMultiSummon) return null;
    _save.dreamGems -= EquipmentSummonSystem.multiPullCost;
    final isBeginnerPull = !_save.hasUsedBeginnerMultiSummon;
    final results = List.generate(
      EquipmentSummonSystem.multiPullTotalCount,
      (_) => _rollAndAddEquipmentSummon(minimumRarity: isBeginnerPull ? Rarity.uncommon : null),
    );
    _save.hasUsedBeginnerMultiSummon = true;
    persist();
    checkAchievements();
    return results;
  }

  // MARK: - Offline buildings

  int get pendingGoldFountainReward => OfflineRewards.pendingGold(lastCollected: _save.lastGoldCollectedAt);

  int get pendingTrainingGardenReward =>
      OfflineRewards.pendingExp(lastCollected: _save.lastTrainingCollectedAt);

  int collectGoldFountain() {
    final amount = pendingGoldFountainReward;
    if (amount <= 0) return 0;
    _save.gold += amount;
    _save.lastGoldCollectedAt = DateTime.now();
    _incrementMission(MissionID.collectBuilding);
    persist();
    if (_save.notificationsEnabled) {
      _scheduleGoldFountainNotification();
    }
    return amount;
  }

  /// Grants the accrued EXP to every deployed Dreamkeeper. Requires a
  /// deployed team so the EXP has someone to go to.
  TrainingResult? collectTrainingGarden() {
    final amount = pendingTrainingGardenReward;
    if (amount <= 0 || deployedTeam.isEmpty) return null;

    final levelUps = <LevelUpSummary>[];
    for (var i = 0; i < _save.roster.length; i++) {
      if (!isDeployed(_save.roster[i])) continue;
      final def = definition(_save.roster[i]);
      if (def == null) continue;
      final before = _save.roster[i];
      final statsBefore = before.currentStats(definition: def, inventory: _save.inventory);

      final result = LevelSystem.applyExp(amount, level: before.level, exp: before.exp);
      _save.roster[i] = before.copyWith(level: result.finalLevel, exp: result.finalExp);

      if (result.levelsGained > 0) {
        final statsAfter = _save.roster[i].currentStats(definition: def, inventory: _save.inventory);
        levelUps.add(LevelUpSummary(
          name: def.name,
          oldLevel: before.level,
          newLevel: result.finalLevel,
          statsBefore: statsBefore,
          statsAfter: statsAfter,
        ));
      }
    }

    _save.lastTrainingCollectedAt = DateTime.now();
    _incrementMission(MissionID.collectBuilding);
    persist();
    if (_save.notificationsEnabled) {
      _scheduleTrainingGardenNotification();
    }
    return TrainingResult(expGranted: amount, levelUps: levelUps);
  }

  // MARK: - Daily Missions

  /// Today's board: every Premium bonus mission (always shown, locked
  /// until Premium is unlocked) plus whichever free-tier missions today's
  /// draw selected.
  List<MissionStatus> get dailyMissions {
    _ensureMissionsCurrent();
    final selected = _save.dailyMissionSelectedIDs.toSet();
    return DailyMissions.definitions
        .where((d) => d.isPremiumOnly || selected.contains(d.id.name))
        .map((def) => MissionStatus(
              definition: def,
              progress: min(def.target, _save.dailyMissionProgress[def.id.name] ?? 0),
              isClaimed: _save.claimedMissionIDs.contains(def.id.name),
              isLocked: def.isPremiumOnly && !battlePassPremiumUnlocked,
            ))
        .toList();
  }

  bool get hasUnclaimedMissions =>
      dailyMissions.any((m) => m.isComplete && !m.isClaimed && !m.isLocked) || hasUnclaimedWeeklyMissions;

  bool claimMission(MissionID id) {
    _ensureMissionsCurrent();
    final matches = DailyMissions.definitions.where((d) => d.id == id);
    if (matches.isEmpty) return false;
    final def = matches.first;
    if (def.isPremiumOnly && !battlePassPremiumUnlocked) return false;
    if ((_save.dailyMissionProgress[id.name] ?? 0) < def.target) return false;
    if (_save.claimedMissionIDs.contains(id.name)) return false;

    _save.gold += def.goldReward;
    _save.dreamGems += def.gemReward;
    _grantEnergy(def.energyReward);
    _save.claimedMissionIDs.add(id.name);
    persist();
    return true;
  }

  void _incrementMission(MissionID id, {int by = 1}) {
    _ensureMissionsCurrent();
    final matches = DailyMissions.definitions.where((d) => d.id == id);
    if (matches.isEmpty) return;
    final def = matches.first;
    final current = _save.dailyMissionProgress[id.name] ?? 0;
    _save.dailyMissionProgress[id.name] = min(def.target, current + by);
  }

  /// Missions and claims are scoped to a calendar day; once the stored day
  /// no longer matches today, both reset and a fresh set of free-tier
  /// missions is drawn for the new day.
  void _ensureMissionsCurrent() {
    final today = _startOfDay(DateTime.now());
    if (!_isSameDay(_save.dailyMissionDay, today)) {
      _save.dailyMissionDay = today;
      _save.dailyMissionProgress = {};
      _save.claimedMissionIDs = {};
      _save.dailyMissionSelectedIDs = DailyMissions.drawDaily();
      _persistDeferringNotifyDuringBuild();
    } else if (_save.dailyMissionSelectedIDs.isEmpty) {
      _save.dailyMissionSelectedIDs = DailyMissions.drawDaily();
      _persistDeferringNotifyDuringBuild();
    }
  }

  // MARK: - Weekly Missions (Battle Pass Premium)

  List<WeeklyMissionStatus> get weeklyMissions {
    _ensureWeeklyMissionsCurrent();
    return WeeklyMissions.definitions
        .map((def) => WeeklyMissionStatus(
              definition: def,
              progress: min(def.target, _save.weeklyMissionProgress[def.id.name] ?? 0),
              isClaimed: _save.claimedWeeklyMissionIDs.contains(def.id.name),
            ))
        .toList();
  }

  bool get hasUnclaimedWeeklyMissions {
    if (!battlePassPremiumUnlocked) return false;
    return weeklyMissions.any((m) => m.isComplete && !m.isClaimed);
  }

  bool claimWeeklyMission(WeeklyMissionID id) {
    _ensureWeeklyMissionsCurrent();
    if (!battlePassPremiumUnlocked) return false;
    final matches = WeeklyMissions.definitions.where((d) => d.id == id);
    if (matches.isEmpty) return false;
    final def = matches.first;
    if ((_save.weeklyMissionProgress[id.name] ?? 0) < def.target) return false;
    if (_save.claimedWeeklyMissionIDs.contains(id.name)) return false;

    _save.gold += def.goldReward;
    _save.dreamGems += def.gemReward;
    _grantEnergy(def.energyReward);
    _save.claimedWeeklyMissionIDs.add(id.name);
    persist();
    return true;
  }

  void _incrementWeeklyMission(WeeklyMissionID id, {int by = 1}) {
    _ensureWeeklyMissionsCurrent();
    final matches = WeeklyMissions.definitions.where((d) => d.id == id);
    if (matches.isEmpty) return;
    final def = matches.first;
    final current = _save.weeklyMissionProgress[id.name] ?? 0;
    _save.weeklyMissionProgress[id.name] = min(def.target, current + by);
  }

  /// Weekly missions reset on a calendar-week boundary rather than daily.
  void _ensureWeeklyMissionsCurrent() {
    final thisWeek = _startOfWeek(DateTime.now());
    if (_isSameDay(_save.weeklyMissionWeek, thisWeek)) return;
    _save.weeklyMissionWeek = thisWeek;
    _save.weeklyMissionProgress = {};
    _save.claimedWeeklyMissionIDs = {};
    _persistDeferringNotifyDuringBuild();
  }

  // MARK: - Shop

  bool isPurchased(ShopItem item) => _save.purchasedOneTimeOfferIDs.contains(item.id);

  bool canPurchase(ShopItem item) {
    switch (item.kind) {
      case ShopItemKind.gemPack:
      case ShopItemKind.arenaTicketPack:
        return true;
      case ShopItemKind.starterPack:
      case ShopItemKind.vip:
        return !isPurchased(item);
      case ShopItemKind.exclusiveCharacter:
        // Also block if the character was already obtained through the
        // Summoning Shrine's `.exclusive` gacha path.
        if (isPurchased(item)) return false;
        final definitionID = item.grantsDefinitionID;
        if (definitionID == null) return true;
        return !_save.roster.any((r) => r.definitionID == definitionID);
      case ShopItemKind.goldExchange:
        return _save.dreamGems >= item.gemCost;
    }
  }

  /// Grants an item's rewards unconditionally once `canPurchase` passes —
  /// this is the *grant* step only and never itself charges real money.
  bool purchase(ShopItem item) {
    if (!canPurchase(item)) return false;

    if (item.kind == ShopItemKind.goldExchange) {
      _save.dreamGems -= item.gemCost;
    }
    _save.gold += item.goldGranted;
    _save.dreamGems += item.gemsGranted;
    if (item.kind == ShopItemKind.arenaTicketPack) {
      _save.arenaBonusTickets += item.ticketsGranted;
    }
    if (item.kind == ShopItemKind.starterPack ||
        item.kind == ShopItemKind.vip ||
        item.kind == ShopItemKind.exclusiveCharacter) {
      _save.purchasedOneTimeOfferIDs.add(item.id);
    }
    if (item.kind == ShopItemKind.vip) {
      _save.isVIP = true;
    }
    if (item.kind == ShopItemKind.exclusiveCharacter && item.grantsDefinitionID != null) {
      _save.roster.add(DreamkeeperInstance(
        definitionID: item.grantsDefinitionID!,
        level: LevelSystem.maxLevel,
        stars: StarFusionSystem.maxStars,
      ));
    }

    _incrementMission(MissionID.spendInShop);
    _incrementWeeklyMission(WeeklyMissionID.visitShop);
    persist();
    return true;
  }

  /// The real entry point for every real-money `ShopItem` — charges
  /// through `_purchaseService` first and only calls `purchase(_)` to
  /// grant the reward once the billing SDK reports a verified transaction.
  Future<bool> purchaseWithRealMoney(ShopItem item) async {
    if (item.productID == null) return purchase(item);
    if (!canPurchase(item)) return false;
    final outcome = await _purchaseService.purchase(item);
    if (outcome != PurchaseOutcome.success) return false;
    return purchase(item);
  }

  // MARK: - Rewarded ads

  static const maxRewardedAdsPerDay = 3;
  static const rewardedAdGold = 80;
  static const rewardedAdGems = 5;

  bool get isVIP => _save.isVIP;

  /// Rewarded-ad watches are scoped to a calendar day.
  void _ensureRewardedAdDayCurrent() {
    final today = _startOfDay(DateTime.now());
    if (_isSameDay(_save.rewardedAdWatchDay, today)) return;
    _save.rewardedAdWatchDay = today;
    _save.rewardedAdWatchCount = 0;
  }

  int get rewardedAdWatchesRemainingToday {
    _ensureRewardedAdDayCurrent();
    return max(0, maxRewardedAdsPerDay - _save.rewardedAdWatchCount);
  }

  /// True while the daily cap hasn't been hit and the player hasn't gone VIP.
  bool get isRewardedAdAvailable => !_save.isVIP && rewardedAdWatchesRemainingToday > 0;

  /// Presents a rewarded ad through `_adService` and grants a fixed
  /// Gold+Gems bonus if the viewer watches it through.
  Future<bool> watchRewardedAd() async {
    if (!isRewardedAdAvailable) return false;
    final rewarded = await _adService.showRewardedAd();
    if (rewarded) {
      _save.gold += rewardedAdGold;
      _save.dreamGems += rewardedAdGems;
      _save.rewardedAdWatchCount += 1;
      _save.lastRewardedAdClaimedAt = DateTime.now();
      persist();
    }
    return rewarded;
  }

  // MARK: - Interstitial ads

  /// Stages between automatic interstitials, and the minimum real time
  /// that must also have passed.
  static const stagesPerInterstitial = 2;
  static const minSecondsBetweenInterstitials = 2 * 60;

  /// True once both the stage-count and time pacing floors are clear and
  /// the player hasn't gone VIP.
  bool get shouldShowInterstitial =>
      !_save.isVIP &&
      _save.stagesSinceLastInterstitial >= stagesPerInterstitial &&
      DateTime.now().difference(_save.lastInterstitialShownAt).inSeconds >= minSecondsBetweenInterstitials;

  /// Called once per completed stage.
  void _recordStageForInterstitialPacing() {
    _save.stagesSinceLastInterstitial += 1;
  }

  /// Resets both pacing counters — called the moment an interstitial is
  /// *attempted*, whether or not it actually filled.
  void _markInterstitialAttempted() {
    _save.stagesSinceLastInterstitial = 0;
    _save.lastInterstitialShownAt = DateTime.now();
    persist();
  }

  Future<void> showInterstitialAd() async {
    _markInterstitialAttempted();
    await _interstitialAdService.showInterstitialAd();
  }

  DreamkeeperDefinition? _grantNextRecruitIfAvailable() {
    final owned = _save.roster.map((r) => r.definitionID).toSet();
    final matches = DreamkeeperCatalog.unlockOrder.where((id) => !owned.contains(id));
    if (matches.isEmpty) return null;
    final nextID = matches.first;
    final def = catalog.definition(nextID);
    if (def == null) return null;

    final instance = DreamkeeperInstance(definitionID: nextID);
    _save.roster.add(instance);
    final members = _save.teams[_activeTeamIndex].memberIDs;
    if (members.length < Team.maxSize) {
      members.add(instance.id);
    }
    return def;
  }

  void playHaptic(HapticStyle style) {
    if (_save.hapticsEnabled) {
      _platform.playHaptic(style);
    }
    final effect = style.pairedSoundEffect;
    if (effect != null) {
      playSound(effect);
    }
  }

  void playSound(SoundEffect effect) {
    if (!_save.soundEnabled) return;
    _platform.playSound(effect);
  }

  // MARK: - Bestiary (Dream Observatory)

  /// Every monster/boss the player has encountered at least once, keyed by
  /// name.
  bool isDiscovered(String monsterName) => _save.discoveredMonsters.contains(monsterName);

  int get bestiaryDiscoveredCount {
    var count = 0;
    for (final world in WorldCatalog.worlds) {
      count += MonsterCatalog.allEntries(world.id).where((e) => isDiscovered(e.name)).length;
    }
    return count;
  }

  int get bestiaryTotalCount =>
      WorldCatalog.worlds.fold(0, (total, world) => total + MonsterCatalog.allEntries(world.id).length);

  // MARK: - Battle Pass

  int get battlePassTier => BattlePassSystem.tier(_save.battlePassXP);
  ({int current, int needed}) get battlePassProgress {
    final progress = BattlePassSystem.progressWithinTier(_save.battlePassXP);
    return (current: progress.$1, needed: progress.$2);
  }

  bool get battlePassPremiumUnlocked => _save.battlePassPremiumUnlocked;

  String _battlePassRewardID(int tier, bool premium) => '$tier-${premium ? "premium" : "free"}';

  bool isBattlePassRewardClaimed(int tier, bool premium) =>
      _save.claimedBattlePassRewardIDs.contains(_battlePassRewardID(tier, premium));

  bool canClaimBattlePassReward(int tier, bool premium) {
    if (tier < 1 || tier > battlePassTier) return false;
    if (premium && !battlePassPremiumUnlocked) return false;
    return !isBattlePassRewardClaimed(tier, premium);
  }

  /// Any reachable, unclaimed reward on either track.
  bool get hasUnclaimedBattlePassRewards {
    if (battlePassTier < 1) return false;
    for (var tier = 1; tier <= battlePassTier; tier++) {
      if (canClaimBattlePassReward(tier, false) || canClaimBattlePassReward(tier, true)) return true;
    }
    return false;
  }

  bool claimBattlePassReward({required int tier, required bool premium}) {
    if (!canClaimBattlePassReward(tier, premium)) return false;
    final reward = premium ? BattlePassSystem.premiumReward(tier) : BattlePassSystem.freeReward(tier);
    _save.gold += reward.gold;
    _save.dreamGems += reward.gems;
    _save.arenaBonusTickets += reward.tickets;
    _save.claimedBattlePassRewardIDs.add(_battlePassRewardID(tier, premium));
    persist();
    return true;
  }

  /// Placeholder real-money unlock, same "grant directly, no charge" MVP
  /// pattern as `ShopItemKind.gemPack`.
  bool purchaseBattlePassPremium() {
    if (battlePassPremiumUnlocked) return false;
    _save.battlePassPremiumUnlocked = true;
    persist();
    return true;
  }

  // MARK: - Settings

  bool get hapticsEnabled => _save.hapticsEnabled;

  void setHapticsEnabled(bool enabled) {
    _save.hapticsEnabled = enabled;
    persist();
  }

  bool get soundEnabled => _save.soundEnabled;

  void setSoundEnabled(bool enabled) {
    _save.soundEnabled = enabled;
    persist();
  }

  /// 1.0 or 2.0 — read by `BattleEngine.tick(dt)` callers to scale the tick rate.
  double get battleSpeedMultiplier => _save.battleSpeedMultiplier;

  void setBattleSpeedMultiplier(double multiplier) {
    _save.battleSpeedMultiplier = multiplier;
    persist();
  }

  /// When on, the battle screen fires each ready Dreamkeeper's Active
  /// Skill and Ultimate automatically every tick instead of waiting for a tap.
  bool get autoBattleEnabled => _save.autoBattleEnabled;

  void setAutoBattleEnabled(bool enabled) {
    _save.autoBattleEnabled = enabled;
    persist();
  }

  /// null means "follow the device's system language".
  String? get preferredLanguage => _save.preferredLanguage;

  void setPreferredLanguage(String? languageCode) {
    _save.preferredLanguage = languageCode;
    persist();
  }

  // MARK: - Notifications

  static const _goldFountainNotificationID = 'dk.notif.goldFountain';
  static const _trainingGardenNotificationID = 'dk.notif.trainingGarden';
  static const _dailyMissionsNotificationID = 'dk.notif.dailyMissions';
  static const _loginRewardNotificationID = 'dk.notif.loginReward';

  bool get notificationsEnabled => _save.notificationsEnabled;

  /// Turning this on requests OS permission (a no-op if already granted or
  /// denied) and, only once actually authorized, arms both building
  /// reminders and the daily missions nudge. Turning it off cancels
  /// everything immediately. Returns whether notifications ended up
  /// enabled (`false` if the player declined), so the Settings toggle can
  /// snap back instead of showing a state that isn't actually in effect.
  /// Replaces Swift's completion-handler version with a direct `async`
  /// return — Dart's `PlatformService.requestNotificationAuthorization` is
  /// already `Future<bool>`-based.
  Future<bool> setNotificationsEnabled(bool enabled) async {
    if (!enabled) {
      _save.notificationsEnabled = false;
      persist();
      _platform.cancelAllNotifications();
      return false;
    }
    final granted = await _platform.requestNotificationAuthorization();
    _save.notificationsEnabled = granted;
    persist();
    if (granted) {
      _scheduleBuildingNotifications();
      _platform.scheduleDailyNotification(
        id: _dailyMissionsNotificationID,
        title: _notificationText(en: 'Daily Missions', de: 'Tägliche Missionen'),
        body: _notificationText(
          en: 'New daily missions are ready in Dream Haven.',
          de: 'Neue tägliche Missionen warten im Traumhafen.',
        ),
        hour: 18,
        minute: 0,
      );
      _platform.scheduleDailyNotification(
        id: _loginRewardNotificationID,
        title: _notificationText(en: 'Daily Login Bonus', de: 'Tägliche Login-Belohnung'),
        body: _notificationText(
          en: 'Your login streak reward is waiting in Dream Haven.',
          de: 'Deine Login-Streak-Belohnung wartet im Traumhafen.',
        ),
        hour: 10,
        minute: 0,
      );
    }
    return granted;
  }

  void _scheduleBuildingNotifications() {
    _scheduleGoldFountainNotification();
    _scheduleTrainingGardenNotification();
  }

  void _scheduleGoldFountainNotification() {
    _platform.scheduleNotification(
      id: _goldFountainNotificationID,
      title: _notificationText(en: 'Gold Fountain is full!', de: 'Der Goldbrunnen ist voll!'),
      body: _notificationText(
        en: 'Come collect your gold before it caps out.',
        de: 'Hol dir dein Gold ab, bevor es überläuft.',
      ),
      fireDate: _save.lastGoldCollectedAt.add(const Duration(seconds: OfflineRewards.maxAccrualSeconds)),
    );
  }

  void _scheduleTrainingGardenNotification() {
    _platform.scheduleNotification(
      id: _trainingGardenNotificationID,
      title: _notificationText(en: 'Training Garden is full!', de: 'Der Trainingsgarten ist voll!'),
      body: _notificationText(
        en: 'Your team has EXP waiting to be collected.',
        de: 'Dein Team hat EP, die abgeholt werden können.',
      ),
      fireDate: _save.lastTrainingCollectedAt.add(const Duration(seconds: OfflineRewards.maxAccrualSeconds)),
    );
  }

  /// Local notifications can't pick up localized strings the way on-screen
  /// widget text does — this picks between two hand-supplied strings using
  /// the same preference the rest of the app reads. Simplified vs. Swift's
  /// version: checks `save.preferredLanguage` directly rather than also
  /// falling back to the system locale, since no real locale/notification
  /// plugin is wired in yet.
  String _notificationText({required String en, required String de}) =>
      _save.preferredLanguage == 'de' ? de : en;

  // MARK: - Onboarding

  bool get hasSeenOnboarding => _save.hasSeenOnboarding;

  void completeOnboarding() {
    _save.hasSeenOnboarding = true;
    persist();
  }

  /// Right after onboarding finishes — true while the player hasn't locked
  /// in the starter Olf's element yet. Backed by
  /// `GameSave.hasChosenStarterElement` rather than a `definitionID`
  /// identity check: `DreamkeeperCatalog.olfDefinitionID(GameElement.ember)`
  /// equals `DreamkeeperCatalog.starterOlfDefaultID` itself, so comparing
  /// against the placeholder id would make choosing Ember a silent no-op and
  /// reopen this screen on every visit to Dream Haven forever. Mirrors
  /// `GameState.needsStarterOlfChoice` in GameCore/State/GameState.swift.
  bool get needsStarterOlfChoice => !_save.hasChosenStarterElement;

  /// Locks in the starter Olf's element (or, when [element] is null — the
  /// secret hold-on-Ember gesture fired — grants Ultimate Olf instead).
  /// Mutates the same instance in place, preserving its id/level/exp/
  /// equipped, and sets `hasChosenStarterElement` unconditionally so the
  /// choice never resurfaces — regardless of which element (even Ember) was
  /// picked. Mirrors `GameState.chooseStarterOlf(element:)` in
  /// GameCore/State/GameState.swift.
  bool chooseStarterOlf(GameElement? element) {
    if (_save.hasChosenStarterElement) return false;
    final index = _save.roster
        .indexWhere((i) => i.definitionID == DreamkeeperCatalog.starterOlfDefaultID);
    if (index != -1) {
      final newDefinitionID = element != null
          ? DreamkeeperCatalog.olfDefinitionID(element)
          : DreamkeeperCatalog.ultimateOlfID;
      _save.roster[index] = DreamkeeperInstance(
        id: _save.roster[index].id,
        definitionID: newDefinitionID,
        level: _save.roster[index].level,
        exp: _save.roster[index].exp,
        stars: _save.roster[index].stars,
        fusionProgress: _save.roster[index].fusionProgress,
        equipped: _save.roster[index].equipped,
      );
    }
    _save.hasChosenStarterElement = true;
    persist();
    return true;
  }

  /// Wipes all progress and starts over from a fresh save. Irreversible —
  /// the UI must confirm with the player before calling this.
  void resetProgress() {
    _save = GameSave.newGame(starterDefinitionID: DreamkeeperCatalog.starterOlfDefaultID);
    _selectedStage = 1;
    persist();
    _platform.cancelAllNotifications();
  }

  /// QA-only: drops a sample item of every slot into the inventory.
  void debugSeedInventory() {
    for (final _ in EquipmentSlot.values) {
      _save.inventory.add(EquipmentFactory.randomItem(stage: 3, isBoss: false));
    }
    persist();
  }

  /// Testing-only: replaces the inventory with exact items.
  void debugSetInventory(List<EquipmentItem> items) {
    _save.inventory = items;
    persist();
  }

  /// QA-only: adds `count` extra duplicate instances of the first roster
  /// member's species.
  void debugSeedDuplicates([int count = 20]) {
    if (_save.roster.isEmpty) return;
    final first = _save.roster.first;
    for (var i = 0; i < count; i++) {
      _save.roster.add(DreamkeeperInstance(definitionID: first.definitionID));
    }
    persist();
  }

  /// QA-only: adds `count` identical duplicate items to the inventory.
  void debugSeedItemDuplicates([int count = 5]) {
    final template = EquipmentFactory.randomItem(stage: 3, isBoss: false);
    for (var i = 0; i < count; i++) {
      _save.inventory.add(EquipmentItem(
        slot: template.slot,
        name: template.name,
        rarity: template.rarity,
        level: 1,
        statBonus: template.statBonus,
      ));
    }
    persist();
  }

  /// QA-only: jumps the campaign frontier straight to `stage` (and selects it).
  void debugSeedStage(int stage) {
    _save.currentStage = stage;
    _selectedStage = stage;
    persist();
  }

  /// QA-only: discovers a handful of monsters/bosses across every world.
  void debugSeedBestiary() {
    for (final world in WorldCatalog.worlds) {
      final entries = MonsterCatalog.allEntries(world.id);
      for (final entry in entries.take(2)) {
        _save.discoveredMonsters.add(entry.name);
      }
    }
    persist();
  }

  /// QA-only: grants enough Battle Pass XP to reach tier 3 and unlocks Premium.
  void debugSeedBattlePass() {
    _save.battlePassXP = BattlePassSystem.xpPerTier * 3;
    _save.battlePassPremiumUnlocked = true;
    persist();
  }

  /// QA-only: backdates both offline-building timers.
  void debugSeedOfflineTime() {
    final backdated = DateTime.now().subtract(const Duration(minutes: 45));
    _save.lastGoldCollectedAt = backdated;
    _save.lastTrainingCollectedAt = backdated;
    persist();
  }

  /// QA-only: marks every daily and weekly mission as complete (unclaimed).
  void debugCompleteAllMissions() {
    _ensureMissionsCurrent();
    for (final def in DailyMissions.definitions) {
      _save.dailyMissionProgress[def.id.name] = def.target;
    }
    _ensureWeeklyMissionsCurrent();
    for (final def in WeeklyMissions.definitions) {
      _save.weeklyMissionProgress[def.id.name] = def.target;
    }
    persist();
  }
}
