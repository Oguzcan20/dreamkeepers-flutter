import '../combat/arena_system.dart';
import '../models/dreamkeeper.dart';
import '../models/equipment.dart';
import '../models/team.dart';
import '../progression/energy_system.dart';

DateTime _distantPast = DateTime.fromMillisecondsSinceEpoch(0);

String? _dateToJson(DateTime d) => d.toIso8601String();
DateTime _dateFromJson(dynamic v, DateTime fallback) {
  if (v == null) return fallback;
  return DateTime.tryParse(v as String) ?? fallback;
}

/// Everything that survives an app relaunch. Deliberately flat and
/// JSON-serializable so it can move to a cloud-synced store later without
/// changing callers — only `LocalSaveStore`'s implementation would change.
/// Mirrors Persistence/GameSave.swift exactly.
class GameSave {
  int playerLevel;
  int playerExp;
  int gold;
  int dreamGems;
  List<DreamkeeperInstance> roster;
  List<Team> teams;
  String activeTeamID;
  List<EquipmentItem> inventory;
  int currentStage;
  DateTime lastGoldCollectedAt;
  DateTime lastTrainingCollectedAt;
  DateTime dailyMissionDay;
  Map<String, int> dailyMissionProgress;
  Set<String> claimedMissionIDs;

  /// Today's randomly-drawn subset of `DailyMissions.rotatingPool`
  /// (`MissionID.name`s), redrawn whenever `dailyMissionDay` rolls over —
  /// the free-tier board isn't the same fixed 7 missions every day. Empty
  /// means "not drawn yet", which the daily-refresh logic also treats as
  /// needing a (re)draw, so a save from before this field existed
  /// backfills it on next load instead of showing zero missions until the
  /// following day.
  List<String> dailyMissionSelectedIDs;
  DateTime weeklyMissionWeek;
  Map<String, int> weeklyMissionProgress;
  Set<String> claimedWeeklyMissionIDs;
  Set<String> purchasedOneTimeOfferIDs;
  bool hapticsEnabled;
  bool soundEnabled;
  Set<String> discoveredMonsters;
  int battlePassXP;
  bool battlePassPremiumUnlocked;
  Set<String> claimedBattlePassRewardIDs;

  /// "de", "en", or null to follow the device's system language.
  String? preferredLanguage;

  /// Local (on-device) reminders for the two offline buildings capping out
  /// and the daily mission reset. Off by default until the player opts in
  /// via Settings — enabling it is what actually requests OS permission.
  bool notificationsEnabled;

  /// Whether the first-launch walkthrough (Summon / Fusion / Team /
  /// Campaign) has already been shown. `newGame()` starts this at `false`;
  /// saves from before this flag existed default to `true` when loaded so
  /// it never retroactively interrupts an existing player.
  bool hasSeenOnboarding;

  /// True once the player has locked in the starter Olf's element (or
  /// unlocked Ultimate Olf via the secret hold) — see
  /// `GameState.needsStarterOlfChoice`/`chooseStarterOlf`. Deliberately a
  /// separate flag rather than inferring "already chosen" from the roster's
  /// `definitionID`: `DreamkeeperCatalog.olfDefinitionID(GameElement.ember)`
  /// happens to equal `DreamkeeperCatalog.starterOlfDefaultID` itself, so a
  /// player who picks Ember would otherwise leave the placeholder id
  /// unchanged and get the choice screen again on every visit to Dream
  /// Haven. `newGame()` starts this at `false`; saves from before this flag
  /// existed default to `true` when loaded so it never retroactively
  /// interrupts an existing player.
  bool hasChosenStarterElement;

  /// Milestone IDs already unlocked (and already shown to the player) —
  /// see `AchievementSystem`. Persisted so a popup never fires twice.
  Set<String> unlockedAchievementIDs;

  /// Which day (1...`LoginRewardSystem.cycleLength`) of the login-streak
  /// calendar was most recently claimed. 0 means never claimed.
  int loginStreakDay;

  /// Calendar date of that claim, used to tell "continues the streak"
  /// (yesterday), "already claimed" (today), and "streak lapsed" (older)
  /// apart. Epoch (`_distantPast`) until the first ever claim.
  DateTime lastLoginRewardClaimDate;

  /// One-time real-money purchase (see `ShopItemKind.vip`). Removes the
  /// rewarded-ad prompt permanently — nothing else currently checks this,
  /// but it's the natural place to gate any future VIP-only perk too.
  bool isVIP;

  /// Timestamp of the most recent rewarded-ad watch — informational only
  /// (not used for gating).
  DateTime lastRewardedAdClaimedAt;

  /// Calendar day `rewardedAdWatchCount` is counting against. Resets both
  /// once the stored day no longer matches today, same pattern as
  /// `dailyMissionDay`.
  DateTime rewardedAdWatchDay;
  int rewardedAdWatchCount;

  /// Stages cleared since the last automatic interstitial. Reset (not
  /// incremented) by anything else touching `currentStage`.
  int stagesSinceLastInterstitial;

  /// Pacing floor so an interstitial can never fire twice within a
  /// minimum interval, however fast stages clear. Epoch means never shown.
  DateTime lastInterstitialShownAt;

  /// Pulls since the last Epic+ / Legendary+ result — shared across both
  /// Dreamkeeper and Equipment Summoning (same pool as
  /// `SummonSystem.rarityOdds`) so the pity clock is one dial, not two.
  int pullsSinceEpicSummon;
  int pullsSinceLegendarySummon;

  /// True once the player has used their very first 10x multi-summon (of
  /// either type) — that pull is upgraded so it can't roll an all-Common
  /// result. One-time, shared across Dreamkeeper and Equipment Summoning.
  bool hasUsedBeginnerMultiSummon;

  /// 1.0 or 2.0 — persisted battle tick-rate multiplier set via the
  /// in-battle speed toggle.
  double battleSpeedMultiplier;

  /// Persisted state of the in-battle Auto-Battle toggle: fires each
  /// deployed Dreamkeeper's Active Skill/Ultimate the instant it's ready.
  bool autoBattleEnabled;

  /// Current stamina — spent per stage attempt (fight or Sweep alike),
  /// regenerated over time. See `EnergySystem`.
  int energy;

  /// Clock baseline the passive regen ticks forward from. Pinned to "now"
  /// whenever `energy` is at `EnergySystem.maxEnergy` so a long stretch at
  /// full never banks phantom ticks for later.
  DateTime lastEnergyUpdateAt;

  /// Calendar day `energyRefillCount` is counting against — resets both
  /// once the stored day no longer matches today.
  DateTime energyRefillDay;
  int energyRefillCount;

  /// Arena Tower progress — the next floor (1...`ArenaSystem.maxFloor`)
  /// the player will fight; a value beyond `maxFloor` means the tower is
  /// fully cleared. Only ever advances on a win.
  int arenaFloor;

  /// Daily attempts left for the Arena Tower — deliberately its own
  /// ticket economy instead of spending shared `energy`, so climbing the
  /// tower never competes with Campaign stages for the same stamina bar.
  int arenaTickets;

  /// Calendar day `arenaTickets` was last refilled to
  /// `ArenaSystem.maxTicketsPerDay` — resets both once the stored day no
  /// longer matches today.
  DateTime arenaTicketDay;

  /// Non-resetting Arena ticket balance, spent only after the daily free
  /// `arenaTickets` run out. Filled by real-money purchases
  /// (`ShopItemKind.arenaTicketPack` — tickets are never buyable with
  /// gold) and Battle Pass reward tiers. Deliberately separate from
  /// `arenaTickets` so a day rollover never silently wastes a purchase.
  int arenaBonusTickets;

  GameSave({
    required this.playerLevel,
    required this.playerExp,
    required this.gold,
    required this.dreamGems,
    required this.roster,
    required this.teams,
    required this.activeTeamID,
    required this.inventory,
    required this.currentStage,
    required this.lastGoldCollectedAt,
    required this.lastTrainingCollectedAt,
    required this.dailyMissionDay,
    required this.dailyMissionProgress,
    required this.claimedMissionIDs,
    List<String>? dailyMissionSelectedIDs,
    DateTime? weeklyMissionWeek,
    Map<String, int>? weeklyMissionProgress,
    Set<String>? claimedWeeklyMissionIDs,
    required this.purchasedOneTimeOfferIDs,
    this.hapticsEnabled = true,
    this.soundEnabled = true,
    Set<String>? discoveredMonsters,
    this.battlePassXP = 0,
    this.battlePassPremiumUnlocked = false,
    Set<String>? claimedBattlePassRewardIDs,
    this.preferredLanguage,
    this.notificationsEnabled = false,
    this.hasSeenOnboarding = true,
    this.hasChosenStarterElement = true,
    Set<String>? unlockedAchievementIDs,
    this.loginStreakDay = 0,
    DateTime? lastLoginRewardClaimDate,
    this.isVIP = false,
    DateTime? lastRewardedAdClaimedAt,
    DateTime? rewardedAdWatchDay,
    this.rewardedAdWatchCount = 0,
    this.stagesSinceLastInterstitial = 0,
    DateTime? lastInterstitialShownAt,
    this.pullsSinceEpicSummon = 0,
    this.pullsSinceLegendarySummon = 0,
    this.hasUsedBeginnerMultiSummon = false,
    this.battleSpeedMultiplier = 1.0,
    this.autoBattleEnabled = false,
    int? energy,
    DateTime? lastEnergyUpdateAt,
    DateTime? energyRefillDay,
    this.energyRefillCount = 0,
    this.arenaFloor = 1,
    int? arenaTickets,
    DateTime? arenaTicketDay,
    this.arenaBonusTickets = 0,
  })  : dailyMissionSelectedIDs = dailyMissionSelectedIDs ?? [],
        weeklyMissionWeek = weeklyMissionWeek ?? _distantPast,
        weeklyMissionProgress = weeklyMissionProgress ?? {},
        claimedWeeklyMissionIDs = claimedWeeklyMissionIDs ?? {},
        discoveredMonsters = discoveredMonsters ?? {},
        claimedBattlePassRewardIDs = claimedBattlePassRewardIDs ?? {},
        unlockedAchievementIDs = unlockedAchievementIDs ?? {},
        lastLoginRewardClaimDate = lastLoginRewardClaimDate ?? _distantPast,
        lastRewardedAdClaimedAt = lastRewardedAdClaimedAt ?? _distantPast,
        rewardedAdWatchDay = rewardedAdWatchDay ?? _distantPast,
        lastInterstitialShownAt = lastInterstitialShownAt ?? _distantPast,
        energy = energy ?? EnergySystem.maxEnergy,
        lastEnergyUpdateAt = lastEnergyUpdateAt ?? DateTime.now(),
        energyRefillDay = energyRefillDay ?? _distantPast,
        arenaTickets = arenaTickets ?? ArenaSystem.maxTicketsPerDay,
        arenaTicketDay = arenaTicketDay ?? _distantPast;

  static GameSave newGame({required String starterDefinitionID}) {
    final starter = DreamkeeperInstance(definitionID: starterDefinitionID);
    final mainTeam = Team(memberIDs: [starter.id]);
    final now = DateTime.now();
    return GameSave(
      playerLevel: 1,
      playerExp: 0,
      gold: 100,
      dreamGems: 50,
      roster: [starter],
      teams: [mainTeam],
      activeTeamID: mainTeam.id,
      inventory: [],
      currentStage: 1,
      lastGoldCollectedAt: now,
      lastTrainingCollectedAt: now,
      dailyMissionDay: _distantPast,
      dailyMissionProgress: {},
      claimedMissionIDs: {},
      purchasedOneTimeOfferIDs: {},
      hasSeenOnboarding: false,
      hasChosenStarterElement: false,
    );
  }

  Map<String, dynamic> toJson() => {
        'playerLevel': playerLevel,
        'playerExp': playerExp,
        'gold': gold,
        'dreamGems': dreamGems,
        'roster': roster.map((r) => r.toJson()).toList(),
        'teams': teams.map((t) => t.toJson()).toList(),
        'activeTeamID': activeTeamID,
        'inventory': inventory.map((i) => i.toJson()).toList(),
        'currentStage': currentStage,
        'lastGoldCollectedAt': _dateToJson(lastGoldCollectedAt),
        'lastTrainingCollectedAt': _dateToJson(lastTrainingCollectedAt),
        'dailyMissionDay': _dateToJson(dailyMissionDay),
        'dailyMissionProgress': dailyMissionProgress,
        'claimedMissionIDs': claimedMissionIDs.toList(),
        'dailyMissionSelectedIDs': dailyMissionSelectedIDs,
        'weeklyMissionWeek': _dateToJson(weeklyMissionWeek),
        'weeklyMissionProgress': weeklyMissionProgress,
        'claimedWeeklyMissionIDs': claimedWeeklyMissionIDs.toList(),
        'purchasedOneTimeOfferIDs': purchasedOneTimeOfferIDs.toList(),
        'hapticsEnabled': hapticsEnabled,
        'soundEnabled': soundEnabled,
        'discoveredMonsters': discoveredMonsters.toList(),
        'battlePassXP': battlePassXP,
        'battlePassPremiumUnlocked': battlePassPremiumUnlocked,
        'claimedBattlePassRewardIDs': claimedBattlePassRewardIDs.toList(),
        if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
        'notificationsEnabled': notificationsEnabled,
        'hasSeenOnboarding': hasSeenOnboarding,
        'hasChosenStarterElement': hasChosenStarterElement,
        'unlockedAchievementIDs': unlockedAchievementIDs.toList(),
        'loginStreakDay': loginStreakDay,
        'lastLoginRewardClaimDate': _dateToJson(lastLoginRewardClaimDate),
        'isVIP': isVIP,
        'lastRewardedAdClaimedAt': _dateToJson(lastRewardedAdClaimedAt),
        'rewardedAdWatchDay': _dateToJson(rewardedAdWatchDay),
        'rewardedAdWatchCount': rewardedAdWatchCount,
        'stagesSinceLastInterstitial': stagesSinceLastInterstitial,
        'lastInterstitialShownAt': _dateToJson(lastInterstitialShownAt),
        'pullsSinceEpicSummon': pullsSinceEpicSummon,
        'pullsSinceLegendarySummon': pullsSinceLegendarySummon,
        'hasUsedBeginnerMultiSummon': hasUsedBeginnerMultiSummon,
        'battleSpeedMultiplier': battleSpeedMultiplier,
        'autoBattleEnabled': autoBattleEnabled,
        'energy': energy,
        'lastEnergyUpdateAt': _dateToJson(lastEnergyUpdateAt),
        'energyRefillDay': _dateToJson(energyRefillDay),
        'energyRefillCount': energyRefillCount,
        'arenaFloor': arenaFloor,
        'arenaTickets': arenaTickets,
        'arenaTicketDay': _dateToJson(arenaTicketDay),
        'arenaBonusTickets': arenaBonusTickets,
      };

  /// Backfills missing keys with the same defaults the Swift
  /// `init(from:)` used, so a save from an older schema version still
  /// loads instead of crashing.
  factory GameSave.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final roster = (json['roster'] as List)
        .map((e) => DreamkeeperInstance.fromJson(e as Map<String, dynamic>))
        .toList();

    List<Team> teams;
    String activeTeamID;
    final decodedTeams = (json['teams'] as List?)
        ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
        .toList();
    if (decodedTeams != null && decodedTeams.isNotEmpty) {
      teams = decodedTeams;
      activeTeamID = json['activeTeamID'] as String? ?? decodedTeams[0].id;
    } else {
      final fallback = Team();
      teams = [fallback];
      activeTeamID = fallback.id;
    }

    return GameSave(
      playerLevel: json['playerLevel'] as int,
      playerExp: json['playerExp'] as int,
      gold: json['gold'] as int,
      dreamGems: json['dreamGems'] as int,
      roster: roster,
      teams: teams,
      activeTeamID: activeTeamID,
      inventory: (json['inventory'] as List)
          .map((e) => EquipmentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentStage: json['currentStage'] as int,
      lastGoldCollectedAt: _dateFromJson(json['lastGoldCollectedAt'], now),
      lastTrainingCollectedAt: _dateFromJson(json['lastTrainingCollectedAt'], now),
      dailyMissionDay: _dateFromJson(json['dailyMissionDay'], _distantPast),
      dailyMissionProgress:
          (json['dailyMissionProgress'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as int)) ?? {},
      claimedMissionIDs: (json['claimedMissionIDs'] as List?)?.cast<String>().toSet() ?? {},
      dailyMissionSelectedIDs: (json['dailyMissionSelectedIDs'] as List?)?.cast<String>() ?? [],
      weeklyMissionWeek: _dateFromJson(json['weeklyMissionWeek'], _distantPast),
      weeklyMissionProgress:
          (json['weeklyMissionProgress'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as int)) ?? {},
      claimedWeeklyMissionIDs: (json['claimedWeeklyMissionIDs'] as List?)?.cast<String>().toSet() ?? {},
      purchasedOneTimeOfferIDs: (json['purchasedOneTimeOfferIDs'] as List?)?.cast<String>().toSet() ?? {},
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      discoveredMonsters: (json['discoveredMonsters'] as List?)?.cast<String>().toSet() ?? {},
      battlePassXP: json['battlePassXP'] as int? ?? 0,
      battlePassPremiumUnlocked: json['battlePassPremiumUnlocked'] as bool? ?? false,
      claimedBattlePassRewardIDs: (json['claimedBattlePassRewardIDs'] as List?)?.cast<String>().toSet() ?? {},
      preferredLanguage: json['preferredLanguage'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      // Missing key means this save predates onboarding — treat as already
      // seen so an existing player is never dropped into it retroactively.
      hasSeenOnboarding: json['hasSeenOnboarding'] as bool? ?? true,
      // Missing key means this save predates the starter-Olf-element choice
      // (or already carries a resolved non-placeholder starter from before
      // the feature existed) — treat as already chosen so it never
      // retroactively interrupts an existing player.
      hasChosenStarterElement: json['hasChosenStarterElement'] as bool? ?? true,
      unlockedAchievementIDs: (json['unlockedAchievementIDs'] as List?)?.cast<String>().toSet() ?? {},
      loginStreakDay: json['loginStreakDay'] as int? ?? 0,
      lastLoginRewardClaimDate: _dateFromJson(json['lastLoginRewardClaimDate'], _distantPast),
      isVIP: json['isVIP'] as bool? ?? false,
      lastRewardedAdClaimedAt: _dateFromJson(json['lastRewardedAdClaimedAt'], _distantPast),
      rewardedAdWatchDay: _dateFromJson(json['rewardedAdWatchDay'], _distantPast),
      rewardedAdWatchCount: json['rewardedAdWatchCount'] as int? ?? 0,
      stagesSinceLastInterstitial: json['stagesSinceLastInterstitial'] as int? ?? 0,
      lastInterstitialShownAt: _dateFromJson(json['lastInterstitialShownAt'], _distantPast),
      pullsSinceEpicSummon: json['pullsSinceEpicSummon'] as int? ?? 0,
      pullsSinceLegendarySummon: json['pullsSinceLegendarySummon'] as int? ?? 0,
      // Missing key means this save predates the Beginner's Banner
      // guarantee — treat as already used so an existing player's next 10x
      // pull doesn't suddenly get a floor they never opted into mid-progress.
      hasUsedBeginnerMultiSummon: json['hasUsedBeginnerMultiSummon'] as bool? ?? true,
      battleSpeedMultiplier: (json['battleSpeedMultiplier'] as num?)?.toDouble() ?? 1.0,
      autoBattleEnabled: json['autoBattleEnabled'] as bool? ?? false,
      // Missing key means this save predates the Energy system — start
      // existing players full rather than at 0 so it never retroactively
      // locks them out on the update that introduced it.
      energy: json['energy'] as int? ?? EnergySystem.maxEnergy,
      lastEnergyUpdateAt: _dateFromJson(json['lastEnergyUpdateAt'], now),
      energyRefillDay: _dateFromJson(json['energyRefillDay'], _distantPast),
      energyRefillCount: json['energyRefillCount'] as int? ?? 0,
      // Missing key means this save predates the Arena Tower rework — start
      // existing players at floor 1, same as a fresh save.
      arenaFloor: json['arenaFloor'] as int? ?? 1,
      arenaTickets: json['arenaTickets'] as int? ?? ArenaSystem.maxTicketsPerDay,
      arenaTicketDay: _dateFromJson(json['arenaTicketDay'], _distantPast),
      arenaBonusTickets: json['arenaBonusTickets'] as int? ?? 0,
    );
  }
}
