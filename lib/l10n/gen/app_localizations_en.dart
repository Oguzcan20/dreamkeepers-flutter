// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRestartNow => 'Restart Now';

  @override
  String get commonDone => 'Done';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCollect => 'Collect';

  @override
  String get commonClaim => 'Claim';

  @override
  String get commonClaimed => 'Claimed';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonOk => 'OK';

  @override
  String commonAmountGold(int count) {
    return '$count Gold';
  }

  @override
  String commonAmountGems(int count) {
    return '$count Gems';
  }

  @override
  String get commonCollectedExclaim => 'Collected!';

  @override
  String get commonSell => 'Sell';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsBack => 'Back';

  @override
  String get settingsSoundEffects => 'Sound Effects';

  @override
  String get settingsHaptics => 'Haptics';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsBlurb =>
      'Get notified when the Gold Fountain or Training Garden is full, about daily missions, and when your Login Bonus is ready.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsAccountBlurb =>
      'Sign in to keep your progress recognizable across devices.';

  @override
  String get settingsSignInWithGoogle => 'Sign in with Google';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsSignedIn => 'Signed in';

  @override
  String get settingsDefaultPlayerName => 'Dreamkeeper';

  @override
  String get settingsPlayGames => 'Play Games';

  @override
  String get settingsNotSignedIn => 'Not signed in';

  @override
  String get settingsLeaderboard => 'Leaderboard';

  @override
  String get settingsSignIn => 'Sign In';

  @override
  String get settingsYourData => 'Your Data';

  @override
  String get settingsYourDataBlurb =>
      'Progress is stored on this device and, when a cloud account is available, synced privately to your other devices. Dreamkeepers doesn\'t collect or share personal data.';

  @override
  String get settingsResetProgress => 'Reset Progress';

  @override
  String get settingsResetTitle => 'Reset all progress?';

  @override
  String get settingsResetBody =>
      'This deletes your Dreamkeepers, gold, gems, and campaign progress. This can\'t be undone.';

  @override
  String settingsVersionLine(String version) {
    return 'Dreamkeepers · v$version';
  }

  @override
  String get settingsLanguageRestartTitle => 'Restart required';

  @override
  String get settingsLanguageRestartBody =>
      'The game needs to restart to apply the new language. It will close now — reopen it to continue playing.';

  @override
  String get mainMenuTagline =>
      'A cozy fantasy RPG for a few quiet minutes at a time.';

  @override
  String get mainMenuPlay => 'Play';

  @override
  String get mainMenuSettings => 'Settings';

  @override
  String get loadingHeader => 'LOADING…';

  @override
  String get loadingTipLabel => 'TIP: ';

  @override
  String get loadingAdTitle => 'Loading Ad…';

  @override
  String get loadingTip1 =>
      'Match elements for an advantage against tough enemies.';

  @override
  String get loadingTip2 =>
      'Fuse duplicate Dreamkeepers to raise their star rank.';

  @override
  String get loadingTip3 =>
      'Upgrade equipment from the Inventory to boost your team\'s stats.';

  @override
  String get loadingTip4 =>
      'Collect offline rewards from the Gold Fountain and Training Garden.';

  @override
  String get loadingTip5 => 'Complete Daily Missions for extra Gold and Gems.';

  @override
  String get loadingTip6 =>
      'Deploy up to five Dreamkeepers per team — balance your elements.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingLetsGo => 'Let\'s Go!';

  @override
  String get onboardingSummoningTitle => 'Summoning Shrine';

  @override
  String get onboardingSummoningBody =>
      'Spend Dream Gems at the Summoning Shrine to recruit new Dreamkeepers. Odds are shown up front — no hidden mechanics. A 10x Summon always includes a bonus pull for free.';

  @override
  String get onboardingFusionTitle => 'Fusion';

  @override
  String get onboardingFusionBody =>
      'Summoning a Dreamkeeper you already own doesn\'t waste it — the duplicate goes straight to your Inventory. Fuse duplicates onto that Dreamkeeper there to raise its star tier and make it stronger.';

  @override
  String get onboardingTeamTitle => 'Team';

  @override
  String get onboardingTeamBody =>
      'Build a team from your roster in the Inventory screen. Only deployed Dreamkeepers fight in battle and train at the Training Garden — keep your best team on deck.';

  @override
  String get onboardingCampaignTitle => 'Campaign';

  @override
  String get onboardingCampaignBody =>
      'Send your team into the Campaign to clear stages, earn gold and EXP, and defeat bosses. Boss victories recruit your next Dreamkeeper automatically.';

  @override
  String get starterElementTitle => 'Choose Olf\'s Element';

  @override
  String get starterElementSubtitle =>
      'This sticks with him for good — pick whatever feels right.';

  @override
  String get navDreamHaven => 'Dream Haven';

  @override
  String get achievementUnlockedBanner => 'ACHIEVEMENT UNLOCKED';

  @override
  String get achievementsSheetTitle => 'Achievements';

  @override
  String achievementsUnlockedCount(int unlocked, int total) {
    return '$unlocked/$total unlocked';
  }

  @override
  String get cardTwinBond => 'Twin Bond';

  @override
  String get navShop => 'Shop';

  @override
  String get navDailyMissions => 'Daily Missions';

  @override
  String get navDailyLoginBonus => 'Daily Login Bonus';

  @override
  String get navSummoningShrine => 'Summoning Shrine';

  @override
  String get navTrainingGarden => 'Training Garden';

  @override
  String get navGoldFountain => 'Gold Fountain';

  @override
  String get navObservatory => 'Dream Observatory';

  @override
  String get navEndlessTrial => 'The Endless Trial';

  @override
  String get navWatchAd => 'Watch Ad';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navCampaign => 'Campaign';

  @override
  String get resGold => 'Gold';

  @override
  String get resDreamGems => 'Dream Gems';

  @override
  String get resEnergy => 'Energy';

  @override
  String havenPlayerLevel(int level) {
    return 'Player Lv $level';
  }

  @override
  String get havenYourTeam => 'Your Team';

  @override
  String get havenNoTeam =>
      'No Dreamkeepers deployed yet. Tap to build your team.';

  @override
  String havenTeamPower(int power) {
    return 'Team Power $power';
  }

  @override
  String get havenSeasonPass => 'Season Pass';

  @override
  String havenSeasonPassSemantic(int tier, int total) {
    return 'Season Pass, Tier $tier of $total';
  }

  @override
  String havenTier(int tier, int total) {
    return 'Tier $tier/$total';
  }

  @override
  String havenGemsAmount(int count) {
    return '$count Gems';
  }

  @override
  String havenExpReady(int amount) {
    return '+$amount EXP ready';
  }

  @override
  String havenGoldReady(int amount) {
    return '+$amount Gold ready';
  }

  @override
  String get havenTapToCollect => 'Tap to collect';

  @override
  String havenDiscovered(int count, int total) {
    return '$count/$total Discovered';
  }

  @override
  String havenFloor(int floor, int max) {
    return 'Floor $floor/$max';
  }

  @override
  String havenWatchAdStatus(int gold, int gems, int used, int max) {
    return '+$gold Gold, +$gems Gems · $used/$max today';
  }

  @override
  String havenPlusGold(int amount) {
    return '+$amount Gold';
  }

  @override
  String havenPlusExp(int amount) {
    return '+$amount EXP';
  }

  @override
  String goldFountainBlurb(int rate) {
    return 'Generates $rate gold/min while you\'re away · caps after 8h';
  }

  @override
  String get goldFountainReady => 'Gold ready to collect';

  @override
  String trainingGardenBlurb(int rate) {
    return 'Grants $rate EXP/min to your deployed team while you\'re away · caps after 8h';
  }

  @override
  String trainingGardenPendingExp(int amount) {
    return '+$amount EXP';
  }

  @override
  String get trainingGardenNoTeam => 'Deploy a team to put the garden to work.';

  @override
  String get trainingGardenReady => 'Ready for your deployed team';

  @override
  String get trainingGardenLevelUp => 'Level Up!';

  @override
  String trainingGardenLevelChange(int from, int to) {
    return 'Lv $from → Lv $to';
  }

  @override
  String loginDayOfCycle(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String loginClaimedTomorrow(int day) {
    return 'Claimed — Day $day tomorrow';
  }

  @override
  String get loginSeeYouTomorrow => 'See You Tomorrow';

  @override
  String loginDayLabel(int day) {
    return 'Day $day';
  }

  @override
  String get rewardedAdClaimed => 'Reward Claimed!';

  @override
  String get rewardedAdNice => 'Nice!';

  @override
  String get rewardedAdUnavailable => 'Ad Unavailable';

  @override
  String get missionsTitle => 'Missions';

  @override
  String get missionsResetBlurb =>
      'Daily resets every day · Weekly resets every Monday';

  @override
  String get missionsBattlePassBonus => 'Battle Pass Bonus';

  @override
  String get missionsWeeklyChallenge => 'Weekly Challenge';

  @override
  String get missionsWeeklyLocked =>
      'Unlock Battle Pass Premium to access harder weekly challenges with bigger rewards.';

  @override
  String get missionsRequiresPremium => 'Requires Premium';

  @override
  String get shopBadgePopular => 'Popular';

  @override
  String get shopBadgeBestValue => 'Best Value';

  @override
  String get shopPurchased => 'Purchased!';

  @override
  String get shopAdded => 'Added!';

  @override
  String get shopTrialTickets => 'Trial Tickets';

  @override
  String get shopGoldExchange => 'Gold Exchange';

  @override
  String shopTicketsGranted(int count) {
    return '+$count Tickets';
  }

  @override
  String campaignStageLabel(int stage) {
    return 'Stage $stage';
  }

  @override
  String campaignBossStageLabel(int stage) {
    return 'Boss Stage $stage';
  }

  @override
  String get campaignStageLockedSuffix => ', locked';

  @override
  String get campaignStageClearedSuffix => ', cleared';

  @override
  String campaignStageClearedTitle(int stage) {
    return 'Stage $stage — already cleared';
  }

  @override
  String get campaignStageClearedBody =>
      'Replay the battle for the same rewards, or skip straight to the payout.';

  @override
  String campaignFightCost(int cost) {
    return 'Fight ($cost Energy)';
  }

  @override
  String campaignSweepCost(int cost) {
    return 'Sweep — Instant Clear ($cost Energy)';
  }

  @override
  String get campaignNotEnoughEnergyTitle => 'Not Enough Energy';

  @override
  String campaignNotEnoughEnergyBody(int cost, int current, int max) {
    return 'This stage costs $cost Energy. You have $current/$max.';
  }

  @override
  String campaignRefillForGems(int count) {
    return 'Refill for $count Gems';
  }

  @override
  String get campaignComplete =>
      'You\'ve cleared every known dream. More worlds are on the way.';

  @override
  String campaignEnergySemantic(int current, int max) {
    return 'Energy $current of $max';
  }

  @override
  String campaignStageSwept(int stage) {
    return 'Stage $stage swept';
  }

  @override
  String campaignSweepPayout(int gold, int exp) {
    return '+$gold Gold · +$exp EXP';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String profilePlayerLevel(int level) {
    return 'Player Level $level';
  }

  @override
  String get profileMaxLevel => 'Max level reached';

  @override
  String profileExpToNext(int current, int next) {
    return '$current / $next EXP to next level';
  }

  @override
  String get profileJourneySoFar => 'Journey So Far';

  @override
  String get profileStatDreamkeepers => 'Dreamkeepers';

  @override
  String get profileStatStagesCleared => 'Stages Cleared';

  @override
  String get navCodex => 'Dreamkeeper Codex';

  @override
  String get invTabDreamkeepers => 'Dreamkeepers';

  @override
  String get invTabItems => 'Items';

  @override
  String get invSortLevel => 'Level';

  @override
  String get invSortRarity => 'Rarity';

  @override
  String get invSortStars => 'Stars';

  @override
  String get invSortAttack => 'Attack';

  @override
  String get invSortTooltip => 'Sort Dreamkeepers';

  @override
  String get invTapHint => 'Tap a Dreamkeeper to view stats and fusion.';

  @override
  String invDeployedCount(int count, int max) {
    return '$count/$max deployed';
  }

  @override
  String invSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String invSellGainGoldGems(int gold, int gems) {
    return '+$gold Gold · +$gems Gems';
  }

  @override
  String invSellForGoldGems(int gold, int gems) {
    return 'Sell for $gold Gold + $gems Gems';
  }

  @override
  String invSellForGold(int gold) {
    return 'Sell for $gold Gold';
  }

  @override
  String invSellConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sell $count Dreamkeepers?',
      one: 'Sell 1 Dreamkeeper?',
    );
    return '$_temp0';
  }

  @override
  String get invSellConfirmBody =>
      'This can\'t be undone. Equipped gear is unequipped, not sold.';

  @override
  String get invCreateTeam => 'Create Team';

  @override
  String get invNoItemsTitle => 'No Items Yet';

  @override
  String get invNoItemsBody =>
      'Clear a campaign stage to find equipment for your Dreamkeepers.';

  @override
  String get invGoToCampaign => 'Go to Campaign';

  @override
  String invItemSubtitle(String rarity, int level, int max) {
    return '$rarity · Lv $level/$max';
  }

  @override
  String invItemWornBy(String wearer) {
    return 'Worn by $wearer';
  }

  @override
  String get invItemInStorage => 'In storage';

  @override
  String invItemSemanticWorn(
      String name, String rarity, int level, String wearer) {
    return '$name, $rarity, Lv $level, worn by $wearer';
  }

  @override
  String invItemSemanticStored(String name, String rarity, int level) {
    return '$name, $rarity, Lv $level, in storage';
  }

  @override
  String get summonNew => 'New!';

  @override
  String get summonDuplicate => 'Duplicate';

  @override
  String summonEquipSubtitle(String slot, int level) {
    return '$slot · Lv $level';
  }

  @override
  String summonMultiTitle(int count) {
    return 'Summon x$count';
  }

  @override
  String summonMultiBody(int cost, int count) {
    return 'Spend $cost Gems for $count pulls?';
  }

  @override
  String get summonAction => 'Summon';

  @override
  String get summonNotEnoughGemsTitle => 'Not Enough Gems';

  @override
  String summonNotEnoughGemsBody(int cost, int have) {
    return 'This costs $cost Gems. You have $have.';
  }

  @override
  String get summonGetGems => 'Get Gems';

  @override
  String get summonModeDreamkeeper => 'Dreamkeeper';

  @override
  String get summonModeEquipment => 'Equipment';

  @override
  String get summonBlurbDreamkeeper =>
      'Summon a Dreamkeeper from the shrine\'s deep waters.';

  @override
  String get summonBlurbEquipment =>
      'Summon a piece of Equipment forged for your current stage.';

  @override
  String summonSingleButton(int cost) {
    return 'Summon ($cost Gems)';
  }

  @override
  String summonMultiButton(int count, int cost) {
    return 'x$count ($cost Gems)';
  }

  @override
  String summonInsufficientHint(int needed, int have) {
    return 'Not enough Gems for a pull ($needed needed). You have $have.';
  }

  @override
  String get summonOddsTitle => 'Odds';

  @override
  String get summonEpicPity => 'Epic+ pity';

  @override
  String get summonLegendaryPity => 'Legendary+ pity';

  @override
  String get summonTapToOpen => 'Tap to open';

  @override
  String get summonResultsTitle => 'Summon Results';

  @override
  String get summonTapToRevealAll => 'Tap to reveal all';
}
