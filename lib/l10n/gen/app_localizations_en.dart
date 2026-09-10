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
  String get commonAll => 'All';

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

  @override
  String get bestiaryNotEncountered => 'Not yet encountered.';

  @override
  String codexCollected(int count, int total) {
    return '$count/$total Collected';
  }

  @override
  String get codexFilterByRole => 'Filter by Role';

  @override
  String get codexAllRoles => 'All Roles';

  @override
  String get codexNotOwned => 'Not Owned';

  @override
  String get codexDetailClose => 'Close';

  @override
  String get codexInYourCollection => 'In Your Collection';

  @override
  String codexOwnedTimes(int count) {
    return 'Owned ×$count';
  }

  @override
  String get codexNotOwnedYet => 'Not Owned Yet';

  @override
  String get codexNotOwnedHint =>
      'Find this Dreamkeeper at the Summoning Shrine.';

  @override
  String get codexHowItFights => 'How It Fights';

  @override
  String get codexBaseStats => 'Base Stats';

  @override
  String get codexAbilityUltimate => 'Ultimate';

  @override
  String get codexAbilityActiveSkill => 'Active Skill';

  @override
  String get codexAbilityPassive => 'Passive';

  @override
  String get codexElementMatchups => 'Element Matchups';

  @override
  String get codexMatchupBalanced =>
      'Balanced against every element — no bonus or penalty either way.';

  @override
  String get codexStrongAgainst => 'Strong Against';

  @override
  String get codexWeakAgainst => 'Weak Against';

  @override
  String get codexRoleMechanicTank =>
      'High HP and Defense — built to endure. Both the Ultimate and Active Skill strike the enemy directly.';

  @override
  String get codexRoleMechanicDamage =>
      'High Attack. Both the Ultimate and Active Skill strike the enemy for extra damage.';

  @override
  String get codexRoleMechanicHealer =>
      'The Ultimate heals the whole team at once; the Active Skill heals whichever ally is lowest on HP.';

  @override
  String get codexRoleMechanicSupport =>
      'The Ultimate boosts the whole team\'s Attack for the rest of the battle; the Active Skill boosts its own Attack.';

  @override
  String get codexRoleMechanicControl =>
      'The Ultimate strikes the enemy and briefly stuns it; the Active Skill is a quick strike.';

  @override
  String get codexRoleMechanicGuardian =>
      'The Ultimate shields the whole team; the Active Skill strikes the enemy and slows it.';

  @override
  String get brDefeatTitle => 'Defeat...';

  @override
  String get brBossDefeatedTitle => 'Boss Defeated!';

  @override
  String get brVictoryTitle => 'Victory!';

  @override
  String get brDefeatBody =>
      'The team was overwhelmed. Level up or gear up before trying again.';

  @override
  String brPerfectClear(int gold) {
    return 'Perfect Clear! +$gold bonus Gold';
  }

  @override
  String get brRewards => 'Rewards';

  @override
  String get brExp => 'EXP';

  @override
  String brWorldCompleted(int number) {
    return 'World $number Completed!';
  }

  @override
  String brGemsGained(int count) {
    return '+$count Dream Gems';
  }

  @override
  String brAccountLevel(int from, int to) {
    return 'Account Level $from → $to';
  }

  @override
  String get brLevelUpTitle => 'Level Up!';

  @override
  String brLevelChange(int from, int to) {
    return 'Lv.$from → $to';
  }

  @override
  String get brNewRecruit => 'New Recruit!';

  @override
  String get brNextBattle => 'Next Battle';

  @override
  String get brReturnToDreamHaven => 'Return to Dream Haven';

  @override
  String bpTierProgress(int tier, int total) {
    return 'Tier $tier/$total';
  }

  @override
  String get bpSeasonXp => 'Season XP';

  @override
  String get bpMaxTierReached => 'Max Tier Reached';

  @override
  String bpXpProgress(int current, int needed) {
    return '$current/$needed XP';
  }

  @override
  String get bpXpBlurb =>
      'Win battles to earn Season XP — bosses grant more. Each tier unlocks a Free reward automatically; tap the arrow on a tier to claim it, or claim the matching Premium reward too once unlocked.';

  @override
  String get bpUnlockPremium => 'Unlock Premium Track';

  @override
  String get bpPremiumBlurb =>
      'Claim the gold and gem rewards on every tier you\'ve already reached — no rush, they stay unlocked for the rest of the season.';

  @override
  String get bpClaimTierReward => 'Claim tier reward';

  @override
  String get arenaNoTeamTitle => 'No team deployed';

  @override
  String get arenaNoTeamBody =>
      'Deploy a team before entering the Endless Trial.';

  @override
  String get arenaNoTicketsTitle => 'No Trial Tickets Left';

  @override
  String get arenaNoTicketsBody =>
      'You\'ve used all your Endless Trial attempts for today. Come back tomorrow!';

  @override
  String arenaFloorProgress(int current, int total) {
    return 'Floor $current/$total';
  }

  @override
  String arenaTicketsSemantic(int count, int max) {
    return '$count of $max Trial tickets remaining today';
  }

  @override
  String arenaBonusTickets(int count) {
    return '+$count bonus';
  }

  @override
  String get arenaTowerCleared => 'Tower Cleared!';

  @override
  String get arenaTowerClearedBody =>
      'Every floor stays open below for farming gear.';

  @override
  String arenaFloorsRange(int from, int to) {
    return 'Floors $from–$to';
  }

  @override
  String arenaFloorLabel(int floor) {
    return 'Floor $floor';
  }

  @override
  String arenaOpponentLine(int level, String name) {
    return 'Lv $level · $name';
  }

  @override
  String get arenaFarm => 'Farm';

  @override
  String get arenaFight => 'Fight';

  @override
  String get arenaGearChance => 'Gear chance';

  @override
  String get arenaResultDefeat => 'Defeat';

  @override
  String get arenaTowerClearedResultBody =>
      'You\'ve conquered all 100 floors of the Endless Trial.';

  @override
  String get arenaMilestoneReward => 'Milestone Reward!';

  @override
  String get arenaMilestoneBody =>
      'A guaranteed Legendary reward for reaching this floor.';

  @override
  String get arenaNewTier => 'New Tier!';

  @override
  String get arenaFirstClearReward => 'First Clear Reward';

  @override
  String get arenaStandardReward => 'Standard Reward';

  @override
  String get arenaFightAgain => 'Fight Again';

  @override
  String get eqDreamkeeperFallback => 'Dreamkeeper';

  @override
  String get eqItemFallback => 'Item';

  @override
  String eqLevelLabel(int level) {
    return 'Level $level';
  }

  @override
  String get eqBench => 'Bench';

  @override
  String get eqDeploy => 'Deploy';

  @override
  String eqUltimateDetail(int attacks) {
    return 'Ultimate · charges after $attacks attacks';
  }

  @override
  String eqActiveSkillDetail(int seconds) {
    return 'Active Skill · ${seconds}s cooldown';
  }

  @override
  String get eqSkillPassive => 'Passive';

  @override
  String get eqAutoEquip => 'Auto-Equip Best Gear';

  @override
  String get eqMaxStars => 'Max Stars Reached';

  @override
  String eqFusionProgress(int banked, int cost, int available) {
    return '$banked/$cost banked · $available available';
  }

  @override
  String eqFuseToStar(int stars) {
    return 'Fuse to ★$stars';
  }

  @override
  String get eqUnequip => 'Unequip';

  @override
  String get eqNoItems => 'No items in inventory';

  @override
  String eqItemWithRarity(String name, String rarity) {
    return '$name ($rarity)';
  }

  @override
  String get eqEmpty => 'Empty';

  @override
  String get eqChange => 'Change';

  @override
  String get eqMaxLevel => 'Max Level Reached';

  @override
  String get eqUpgrade => 'Upgrade';

  @override
  String get fusionTitle => 'Fuse';

  @override
  String fusionNoDuplicatesDreamkeeper(String name) {
    return 'No duplicate ${name}s yet. Summon more to gather fusion fodder.';
  }

  @override
  String fusionNoDuplicatesItem(String name) {
    return 'No duplicate ${name}s yet. Clear more stages to find fusion fodder.';
  }

  @override
  String get fusionSelectDuplicates => 'Select duplicates to fuse';

  @override
  String fusionProgressTowardStar(int banked, int cost) {
    return '$banked/$cost toward next star';
  }

  @override
  String fusionToStarGrants(int stars) {
    return 'Fusing to ★$stars grants';
  }

  @override
  String get fusionStarUp => 'Star Up!';

  @override
  String get fusionFused => 'Fused!';

  @override
  String get fusionAction => 'Fuse';

  @override
  String fusionAtMaxStars(String name) {
    return '$name is at max stars';
  }

  @override
  String get fusionStarUpShowcase => 'STAR UP!';

  @override
  String starRowSemantic(int stars, int max) {
    return '$stars of $max stars';
  }

  @override
  String battleArenaStageLabel(int floor) {
    return 'Endless Trial · Floor $floor';
  }

  @override
  String battleWorldBossLabel(String world) {
    return '$world · Boss';
  }

  @override
  String battleWorldStageLabel(String world, int stage, int total) {
    return '$world · $stage/$total';
  }

  @override
  String get battleSpeedTo1x => 'Battle speed 2x, tap for 1x';

  @override
  String get battleSpeedTo2x => 'Battle speed 1x, tap for 2x';

  @override
  String get battleAutoOn => 'Auto-Battle on';

  @override
  String get battleAutoOff => 'Auto-Battle off';

  @override
  String get battleBossBadge => 'BOSS';

  @override
  String get battleActiveSkillLabel => 'Active Skill';

  @override
  String get battleUltimateLabel => 'Ultimate';

  @override
  String get elementEmber => 'Ember';

  @override
  String get elementTide => 'Tide';

  @override
  String get elementBloom => 'Bloom';

  @override
  String get elementLunar => 'Lunar';

  @override
  String get elementAstral => 'Astral';

  @override
  String get roleTank => 'Tank';

  @override
  String get roleDamage => 'Damage';

  @override
  String get roleSupport => 'Support';

  @override
  String get roleHealer => 'Healer';

  @override
  String get roleControl => 'Control';

  @override
  String get roleGuardian => 'Guardian';

  @override
  String get rarityCommon => 'Common';

  @override
  String get rarityUncommon => 'Uncommon';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityEpic => 'Epic';

  @override
  String get rarityLegendary => 'Legendary';

  @override
  String get rarityMythic => 'Mythic';

  @override
  String get rarityExclusive => 'Exclusive';

  @override
  String get slotWeapon => 'Weapon';

  @override
  String get slotCharm => 'Charm';

  @override
  String get slotCloak => 'Cloak';

  @override
  String get slotRing => 'Ring';

  @override
  String get arenaTierBronze => 'Bronze';

  @override
  String get arenaTierSilver => 'Silver';

  @override
  String get arenaTierGold => 'Gold';

  @override
  String get arenaTierPlatinum => 'Platinum';

  @override
  String get arenaTierDiamond => 'Diamond';

  @override
  String get arenaZoneBronze => 'Bronze Halls';

  @override
  String get arenaZoneSilver => 'Silver Vault';

  @override
  String get arenaZoneGold => 'Gold Sanctum';

  @override
  String get arenaZonePlatinum => 'Platinum Ascent';

  @override
  String get arenaZoneDiamond => 'Diamond Summit';

  @override
  String get dk_ember_fox_name => 'Ember Fox';

  @override
  String get dk_ember_fox_flavor =>
      'Born from a candle\'s last flicker before dawn.';

  @override
  String get dk_ember_fox_ult => 'Wildfire Pounce';

  @override
  String get dk_ember_fox_ultDesc => 'A blazing leap that scorches the target.';

  @override
  String get dk_ember_fox_skill => 'Ember Nip';

  @override
  String get dk_ember_fox_skillDesc =>
      'A quick, scorching nip at the nearest foe.';

  @override
  String get dk_ember_fox_pass => 'Kindled Spirit';

  @override
  String get dk_ember_fox_passDesc => 'Slightly bolder in a fight.';

  @override
  String get dk_moon_hare_name => 'Moon Hare';

  @override
  String get dk_moon_hare_flavor =>
      'Follows travelers who fall asleep beneath the open sky.';

  @override
  String get dk_moon_hare_ult => 'Moonlit Blessing';

  @override
  String get dk_moon_hare_ultDesc =>
      'Bathes the whole team in restorative moonlight.';

  @override
  String get dk_moon_hare_skill => 'Soothing Touch';

  @override
  String get dk_moon_hare_skillDesc =>
      'A gentle pulse of moonlight for the ally who needs it most.';

  @override
  String get dk_moon_hare_pass => 'Gentle Glow';

  @override
  String get dk_moon_hare_passDesc => 'A quiet, steadying presence.';

  @override
  String get dk_forest_spirit_name => 'Forest Spirit';

  @override
  String get dk_forest_spirit_flavor =>
      'Grown from the dream of a forgotten garden.';

  @override
  String get dk_forest_spirit_ult => 'Verdant Chorus';

  @override
  String get dk_forest_spirit_ultDesc =>
      'Rallies the team with a surge of vitality.';

  @override
  String get dk_forest_spirit_skill => 'Bramble Ward';

  @override
  String get dk_forest_spirit_skillDesc =>
      'Wraps itself in hardy brambles, growing bolder.';

  @override
  String get dk_forest_spirit_pass => 'Rooted Calm';

  @override
  String get dk_forest_spirit_passDesc => 'Steady footing, steady mind.';

  @override
  String get dk_crystal_golem_name => 'Crystal Golem';

  @override
  String get dk_crystal_golem_flavor =>
      'Formed where a tidal dream froze mid-wave.';

  @override
  String get dk_crystal_golem_ult => 'Bulwark Slam';

  @override
  String get dk_crystal_golem_ultDesc =>
      'A ground-shaking blow that staggers the foe.';

  @override
  String get dk_crystal_golem_skill => 'Guard Slam';

  @override
  String get dk_crystal_golem_skillDesc => 'A heavy but unhurried blow.';

  @override
  String get dk_crystal_golem_pass => 'Crystalline Hide';

  @override
  String get dk_crystal_golem_passDesc =>
      'Refracts a portion of incoming force.';

  @override
  String get dk_star_wolf_name => 'Star Wolf';

  @override
  String get dk_star_wolf_flavor => 'Runs the paths between falling stars.';

  @override
  String get dk_star_wolf_ult => 'Starfall Howl';

  @override
  String get dk_star_wolf_ultDesc =>
      'A resonant howl that freezes the enemy in place.';

  @override
  String get dk_star_wolf_skill => 'Quick Bite';

  @override
  String get dk_star_wolf_skillDesc => 'A fast snap before the foe can react.';

  @override
  String get dk_star_wolf_pass => 'Night Vision';

  @override
  String get dk_star_wolf_passDesc => 'Never misses a step in the dark.';

  @override
  String get dk_thorn_viper_name => 'Thorn Viper';

  @override
  String get dk_thorn_viper_flavor =>
      'Coils through brambles that grow only in restless dreams.';

  @override
  String get dk_thorn_viper_ult => 'Venom Fang';

  @override
  String get dk_thorn_viper_ultDesc =>
      'A precise strike laced with dream-thorn poison.';

  @override
  String get dk_thorn_viper_skill => 'Puncture';

  @override
  String get dk_thorn_viper_skillDesc =>
      'A jabbing strike aimed at the weak points.';

  @override
  String get dk_thorn_viper_pass => 'Toxic Coating';

  @override
  String get dk_thorn_viper_passDesc => 'Fangs that never quite stop stinging.';

  @override
  String get dk_tide_serpent_name => 'Tide Serpent';

  @override
  String get dk_tide_serpent_flavor =>
      'Slips between waves too quick for waking eyes to follow.';

  @override
  String get dk_tide_serpent_ult => 'Riptide Coil';

  @override
  String get dk_tide_serpent_ultDesc =>
      'Wraps the foe in a crushing spiral of water.';

  @override
  String get dk_tide_serpent_skill => 'Snap Coil';

  @override
  String get dk_tide_serpent_skillDesc => 'A sudden lash of its coiled body.';

  @override
  String get dk_tide_serpent_pass => 'Slippery Scales';

  @override
  String get dk_tide_serpent_passDesc => 'Hard to pin down, harder to catch.';

  @override
  String get dk_ember_phoenix_name => 'Ember Phoenix';

  @override
  String get dk_ember_phoenix_flavor =>
      'Rises anew each time a dreamer refuses to give up.';

  @override
  String get dk_ember_phoenix_ult => 'Rebirth Flame';

  @override
  String get dk_ember_phoenix_ultDesc =>
      'A blazing rebirth that mends every wound in the team.';

  @override
  String get dk_ember_phoenix_skill => 'Warm Feather';

  @override
  String get dk_ember_phoenix_skillDesc =>
      'Sheds a single ember-warm feather over an ally.';

  @override
  String get dk_ember_phoenix_pass => 'Eternal Ember';

  @override
  String get dk_ember_phoenix_passDesc =>
      'A flame that refuses to be the last one out.';

  @override
  String get dk_lunar_owl_name => 'Lunar Owl';

  @override
  String get dk_lunar_owl_flavor =>
      'Watches from branches that exist only under a full moon.';

  @override
  String get dk_lunar_owl_ult => 'Silent Talons';

  @override
  String get dk_lunar_owl_ultDesc =>
      'A soundless dive that leaves the target reeling.';

  @override
  String get dk_lunar_owl_skill => 'Swift Peck';

  @override
  String get dk_lunar_owl_skillDesc => 'A precise strike from above.';

  @override
  String get dk_lunar_owl_pass => 'Keen Eyes';

  @override
  String get dk_lunar_owl_passDesc => 'Sees every opening before it appears.';

  @override
  String get dk_astral_sentinel_name => 'Astral Sentinel';

  @override
  String get dk_astral_sentinel_flavor =>
      'Stands guard at the border between dream and stars.';

  @override
  String get dk_astral_sentinel_ult => 'Starward Bulwark';

  @override
  String get dk_astral_sentinel_ultDesc =>
      'Calls down a wall of starlight to guard the team.';

  @override
  String get dk_astral_sentinel_skill => 'Brace';

  @override
  String get dk_astral_sentinel_skillDesc =>
      'Plants itself firm and strikes back.';

  @override
  String get dk_astral_sentinel_pass => 'Astral Ward';

  @override
  String get dk_astral_sentinel_passDesc =>
      'A quiet shimmer that deflects the worst of it.';

  @override
  String get dk_coral_warden_name => 'Coral Warden';

  @override
  String get dk_coral_warden_flavor =>
      'Grew from a reef that only blooms in deep sleep.';

  @override
  String get dk_coral_warden_ult => 'Tidal Chorus';

  @override
  String get dk_coral_warden_ultDesc =>
      'A rolling wave of encouragement washes over the team.';

  @override
  String get dk_coral_warden_skill => 'Encourage';

  @override
  String get dk_coral_warden_skillDesc =>
      'A steadying word that stiffens resolve.';

  @override
  String get dk_coral_warden_pass => 'Reef Guard';

  @override
  String get dk_coral_warden_passDesc =>
      'Grew tough where the currents are roughest.';

  @override
  String get dk_cinder_sprite_name => 'Cinder Sprite';

  @override
  String get dk_cinder_sprite_flavor =>
      'A spark that never quite burns out, no matter the dark.';

  @override
  String get dk_cinder_sprite_ult => 'Spark Rally';

  @override
  String get dk_cinder_sprite_ultDesc =>
      'A shower of warm sparks lifts the whole team\'s spirit.';

  @override
  String get dk_cinder_sprite_skill => 'Warm Spark Jab';

  @override
  String get dk_cinder_sprite_skillDesc =>
      'A friendly spark that lifts the spirit.';

  @override
  String get dk_cinder_sprite_pass => 'Warm Spark';

  @override
  String get dk_cinder_sprite_passDesc =>
      'A spark that never quite burns out, no matter the dark.';

  @override
  String get dk_flicker_pup_name => 'Flicker Pup';

  @override
  String get dk_flicker_pup_flavor =>
      'Hatched from the last spark of a dream that almost went out.';

  @override
  String get dk_flicker_pup_ult => 'Candle Charge';

  @override
  String get dk_flicker_pup_ultDesc =>
      'A clumsy but eager charge wreathed in flickering flame.';

  @override
  String get dk_flicker_pup_skill => 'Warm Nip';

  @override
  String get dk_flicker_pup_skillDesc =>
      'A playful nip that\'s hotter than it looks.';

  @override
  String get dk_flicker_pup_pass => 'Restless Spark';

  @override
  String get dk_flicker_pup_passDesc =>
      'Too excitable to ever stay still for long.';

  @override
  String get dk_ripple_minnow_name => 'Ripple Minnow';

  @override
  String get dk_ripple_minnow_flavor =>
      'Swims in the shallow end of dreams too small for anything bigger.';

  @override
  String get dk_ripple_minnow_ult => 'Shoal Surge';

  @override
  String get dk_ripple_minnow_ultDesc =>
      'A rush of small fish that steadies the whole team.';

  @override
  String get dk_ripple_minnow_skill => 'Nudge';

  @override
  String get dk_ripple_minnow_skillDesc =>
      'A gentle push in the right direction.';

  @override
  String get dk_ripple_minnow_pass => 'Safety in Numbers';

  @override
  String get dk_ripple_minnow_passDesc =>
      'Never truly alone, even when it looks that way.';

  @override
  String get dk_sprout_cub_name => 'Sprout Cub';

  @override
  String get dk_sprout_cub_flavor =>
      'A seedling dream that decided to grow claws instead of leaves.';

  @override
  String get dk_sprout_cub_ult => 'Stubborn Root';

  @override
  String get dk_sprout_cub_ultDesc =>
      'Plants itself down and simply refuses to move.';

  @override
  String get dk_sprout_cub_skill => 'Headbutt';

  @override
  String get dk_sprout_cub_skillDesc => 'An earnest, clumsy charge.';

  @override
  String get dk_sprout_cub_pass => 'Thick Bark';

  @override
  String get dk_sprout_cub_passDesc =>
      'Young, but already tougher than it looks.';

  @override
  String get dk_nightling_name => 'Nightling';

  @override
  String get dk_nightling_flavor =>
      'A scrap of night that broke off before the dream was finished.';

  @override
  String get dk_nightling_ult => 'Small Shadow';

  @override
  String get dk_nightling_ultDesc =>
      'Slips a sliver of dark across the enemy\'s eyes.';

  @override
  String get dk_nightling_skill => 'Flicker Step';

  @override
  String get dk_nightling_skillDesc =>
      'A quick sidestep into darkness and back.';

  @override
  String get dk_nightling_pass => 'Half-Seen';

  @override
  String get dk_nightling_passDesc => 'Never quite where you expect it to be.';

  @override
  String get dk_stardust_moth_name => 'Stardust Moth';

  @override
  String get dk_stardust_moth_flavor =>
      'Drawn to any dream still bright enough to see.';

  @override
  String get dk_stardust_moth_ult => 'Dust Trail';

  @override
  String get dk_stardust_moth_ultDesc =>
      'Sheds a fine, healing dust over the team.';

  @override
  String get dk_stardust_moth_skill => 'Wing Flutter';

  @override
  String get dk_stardust_moth_skillDesc =>
      'A soft flutter that eases an ally\'s pain.';

  @override
  String get dk_stardust_moth_pass => 'Drawn to Light';

  @override
  String get dk_stardust_moth_passDesc =>
      'Follows whatever light is left in the fight.';

  @override
  String get dk_cinder_badger_name => 'Cinder Badger';

  @override
  String get dk_cinder_badger_flavor =>
      'Digs its den where a hearth-fire dream burned down to embers.';

  @override
  String get dk_cinder_badger_ult => 'Coal Dig';

  @override
  String get dk_cinder_badger_ultDesc =>
      'Burrows in and erupts with banked heat.';

  @override
  String get dk_cinder_badger_skill => 'Stubborn Charge';

  @override
  String get dk_cinder_badger_skillDesc =>
      'Lowers its head and simply pushes through.';

  @override
  String get dk_cinder_badger_pass => 'Banked Heat';

  @override
  String get dk_cinder_badger_passDesc =>
      'Runs warmer the longer a fight drags on.';

  @override
  String get dk_pearl_otter_name => 'Pearl Otter';

  @override
  String get dk_pearl_otter_flavor =>
      'Collects pearls from dreams too calm to ever make waves.';

  @override
  String get dk_pearl_otter_ult => 'Pearl Tide';

  @override
  String get dk_pearl_otter_ultDesc =>
      'A wave of luminous pearls mends the team\'s wounds.';

  @override
  String get dk_pearl_otter_skill => 'Polish';

  @override
  String get dk_pearl_otter_skillDesc =>
      'A quick, fussy grooming pass over an ally.';

  @override
  String get dk_pearl_otter_pass => 'Buoyant';

  @override
  String get dk_pearl_otter_passDesc => 'Always finds a way to stay afloat.';

  @override
  String get dk_comet_fox_name => 'Comet Fox';

  @override
  String get dk_comet_fox_flavor =>
      'Chases the tail of an actual comet through the dream sky and usually wins.';

  @override
  String get dk_comet_fox_ult => 'Streaking Dash';

  @override
  String get dk_comet_fox_ultDesc =>
      'A blinding dash that leaves a trail of light.';

  @override
  String get dk_comet_fox_skill => 'Tail Flash';

  @override
  String get dk_comet_fox_skillDesc => 'A quick flick of a glowing tail.';

  @override
  String get dk_comet_fox_pass => 'Trailing Light';

  @override
  String get dk_comet_fox_passDesc =>
      'Leaves the air shimmering just from passing through.';

  @override
  String get dk_bramble_lynx_name => 'Bramble Lynx';

  @override
  String get dk_bramble_lynx_flavor =>
      'Stalks the hedgerows of a garden dream no one remembers planting.';

  @override
  String get dk_bramble_lynx_ult => 'Thicket Pounce';

  @override
  String get dk_bramble_lynx_ultDesc =>
      'Vanishes into brush and strikes from an angle no one expects.';

  @override
  String get dk_bramble_lynx_skill => 'Claw Rake';

  @override
  String get dk_bramble_lynx_skillDesc => 'A fast, low rake across the legs.';

  @override
  String get dk_bramble_lynx_pass => 'Thorned Coat';

  @override
  String get dk_bramble_lynx_passDesc =>
      'Grew its fur through a hedge of brambles.';

  @override
  String get dk_shade_panther_name => 'Shade Panther';

  @override
  String get dk_shade_panther_flavor =>
      'Hunts on the nights the moon forgets to rise at all.';

  @override
  String get dk_shade_panther_ult => 'Moonless Strike';

  @override
  String get dk_shade_panther_ultDesc =>
      'A strike timed to the one moment no light reaches it.';

  @override
  String get dk_shade_panther_skill => 'Silent Pounce';

  @override
  String get dk_shade_panther_skillDesc =>
      'Crosses the distance before the sound catches up.';

  @override
  String get dk_shade_panther_pass => 'Unseen';

  @override
  String get dk_shade_panther_passDesc =>
      'Blends into whatever shadow it\'s standing in.';

  @override
  String get dk_nova_falcon_name => 'Nova Falcon';

  @override
  String get dk_nova_falcon_flavor =>
      'Nests at the peak of a mountain that only exists at the top of a dream.';

  @override
  String get dk_nova_falcon_ult => 'Nova Dive';

  @override
  String get dk_nova_falcon_ultDesc =>
      'A screaming dive trailing a burst of starlight.';

  @override
  String get dk_nova_falcon_skill => 'Wing Cut';

  @override
  String get dk_nova_falcon_skillDesc =>
      'A sharp turn that clips the target mid-flight.';

  @override
  String get dk_nova_falcon_pass => 'Updraft';

  @override
  String get dk_nova_falcon_passDesc => 'Rides currents that only it can feel.';

  @override
  String get dk_magma_titan_name => 'Magma Titan';

  @override
  String get dk_magma_titan_flavor =>
      'Stands where a mountain-sized dream slowly finished melting.';

  @override
  String get dk_magma_titan_ult => 'Molten Fist';

  @override
  String get dk_magma_titan_ultDesc =>
      'A slow, unstoppable punch of liquid rock.';

  @override
  String get dk_magma_titan_skill => 'Heat Wall';

  @override
  String get dk_magma_titan_skillDesc =>
      'Radiates enough heat to make the whole front line flinch.';

  @override
  String get dk_magma_titan_pass => 'Molten Core';

  @override
  String get dk_magma_titan_passDesc =>
      'Never quite cools down enough to be safe to touch.';

  @override
  String get dk_verdant_stag_name => 'Verdant Stag';

  @override
  String get dk_verdant_stag_flavor =>
      'Wears a crown grown from a forest\'s oldest, gentlest dream.';

  @override
  String get dk_verdant_stag_ult => 'Antler Bloom';

  @override
  String get dk_verdant_stag_ultDesc =>
      'Flowers burst from its antlers, lifting the whole team.';

  @override
  String get dk_verdant_stag_skill => 'Proud Charge';

  @override
  String get dk_verdant_stag_skillDesc => 'A dignified, unhurried charge.';

  @override
  String get dk_verdant_stag_pass => 'Old Growth';

  @override
  String get dk_verdant_stag_passDesc =>
      'Carries the calm of a forest that\'s stood for ages.';

  @override
  String get dk_abyssal_kraken_name => 'Abyssal Kraken';

  @override
  String get dk_abyssal_kraken_flavor =>
      'Rose once from a dream so deep even the tide forgot it was there.';

  @override
  String get dk_abyssal_kraken_ult => 'Deep Grasp';

  @override
  String get dk_abyssal_kraken_ultDesc =>
      'Coils dragged up from the trench close around the target.';

  @override
  String get dk_abyssal_kraken_skill => 'Tentacle Lash';

  @override
  String get dk_abyssal_kraken_skillDesc =>
      'A heavy lash from somewhere just out of sight.';

  @override
  String get dk_abyssal_kraken_pass => 'Trench Pressure';

  @override
  String get dk_abyssal_kraken_passDesc =>
      'Hits harder the deeper the fight goes.';

  @override
  String get dk_leviathan_queen_name => 'Leviathan Queen';

  @override
  String get dk_leviathan_queen_flavor =>
      'Rules every current in the dream ocean, and every current knows it.';

  @override
  String get dk_leviathan_queen_ult => 'Tidal Crown';

  @override
  String get dk_leviathan_queen_ultDesc =>
      'Calls up a crown of water that crashes down on every foe.';

  @override
  String get dk_leviathan_queen_skill => 'Regal Wave';

  @override
  String get dk_leviathan_queen_skillDesc =>
      'A slow, commanding push of current.';

  @override
  String get dk_leviathan_queen_pass => 'Sovereign Tide';

  @override
  String get dk_leviathan_queen_passDesc =>
      'The ocean itself seems to defer to her.';

  @override
  String get dk_world_tree_warden_name => 'World Tree Warden';

  @override
  String get dk_world_tree_warden_flavor =>
      'Grew from the very first seed a dreamer ever planted.';

  @override
  String get dk_world_tree_warden_ult => 'Root of Ages';

  @override
  String get dk_world_tree_warden_ultDesc =>
      'Draws on a root older than the forest to mend the whole team.';

  @override
  String get dk_world_tree_warden_skill => 'Sap Blessing';

  @override
  String get dk_world_tree_warden_skillDesc =>
      'A slow, warm trickle of restorative sap.';

  @override
  String get dk_world_tree_warden_pass => 'Ancient Roots';

  @override
  String get dk_world_tree_warden_passDesc =>
      'Reaches deeper than any dream has ever needed.';

  @override
  String get dk_celestial_dragon_name => 'Celestial Dragon';

  @override
  String get dk_celestial_dragon_flavor =>
      'The last dream every dreamer has, if they dream long enough.';

  @override
  String get dk_celestial_dragon_ult => 'Starfire Cataclysm';

  @override
  String get dk_celestial_dragon_ultDesc =>
      'Breathes out the light of a dying galaxy.';

  @override
  String get dk_celestial_dragon_skill => 'Comet Bite';

  @override
  String get dk_celestial_dragon_skillDesc =>
      'A bite that still carries the heat of falling through the sky.';

  @override
  String get dk_celestial_dragon_pass => 'Living Constellation';

  @override
  String get dk_celestial_dragon_passDesc =>
      'Made of the same stuff as the stars it flies among.';

  @override
  String get dk_eclipse_empress_name => 'Eclipse Empress';

  @override
  String get dk_eclipse_empress_flavor =>
      'Rules the space between one dream ending and the next beginning.';

  @override
  String get dk_eclipse_empress_ult => 'Total Eclipse';

  @override
  String get dk_eclipse_empress_ultDesc =>
      'Blots out every light at once, leaving the enemy nowhere to hide.';

  @override
  String get dk_eclipse_empress_skill => 'Crescent Edict';

  @override
  String get dk_eclipse_empress_skillDesc =>
      'A single, absolute command carved in moonlight.';

  @override
  String get dk_eclipse_empress_pass => 'Sovereign of Shadow';

  @override
  String get dk_eclipse_empress_passDesc =>
      'Every dark corner of the dream answers to her.';

  @override
  String get dk_igo_name => 'Igo';

  @override
  String get dk_igo_flavor =>
      'Not a creature of the dream at all — Igo is one of only two humans who ever stayed in Dream Haven for good, an outsider who chose to become its shield. The Dreamkeepers call him Dreamwalker, never one of their own, and he wouldn\'t have it any other way.';

  @override
  String get dk_igo_ult => 'Flutwand';

  @override
  String get dk_igo_ultDesc =>
      'Raises a protective wall of water around the whole team.';

  @override
  String get dk_igo_skill => 'Strömungsriss';

  @override
  String get dk_igo_skillDesc =>
      'A tearing current that damages and slows the enemy.';

  @override
  String get dk_igo_pass => 'Gezeitenwache';

  @override
  String get dk_igo_passDesc =>
      'Once per battle, refuses to fall and surges back at 30% HP.';

  @override
  String get dk_ames_name => 'Ames';

  @override
  String get dk_ames_flavor =>
      'Ames walked into Dream Haven once and simply never left — the second of the two humans who made this place home for good. No creature of dream burns quite like she does; the fire is entirely, stubbornly hers.';

  @override
  String get dk_ames_ult => 'Glutschnitt';

  @override
  String get dk_ames_ultDesc => 'A single devastating cut of white-hot flame.';

  @override
  String get dk_ames_skill => 'Aschesturm';

  @override
  String get dk_ames_skillDesc =>
      'A burning strike that keeps the enemy smoldering.';

  @override
  String get dk_ames_pass => 'Feuertaufe';

  @override
  String get dk_ames_passDesc =>
      'Hits harder the closer she comes to falling — up to +60% attack near death.';

  @override
  String get dk_olf_name => 'Olf';

  @override
  String get dk_olf_ember_flavor =>
      'Every save starts with an Olf. Nobody\'s quite sure why he insists on the tunic.';

  @override
  String get dk_olf_ember_ult => 'Wobbly Flame Lunge';

  @override
  String get dk_olf_ember_ultDesc =>
      'Charges in swinging his twig sword, somehow catching fire on the way.';

  @override
  String get dk_olf_ember_skill => 'Hot-Headed Jab';

  @override
  String get dk_olf_ember_skillDesc =>
      'A jab thrown with more enthusiasm than technique.';

  @override
  String get dk_olf_pass => 'Too Dumb to Be Scared';

  @override
  String get dk_olf_passDesc => 'Doesn\'t know enough to flinch.';

  @override
  String get dk_olf_tide_flavor =>
      'Chose Tide because puddles seemed friendlier than the alternative.';

  @override
  String get dk_olf_tide_ult => 'Bellyflop Splash';

  @override
  String get dk_olf_tide_ultDesc =>
      'Cannonballs in, mostly to see what happens.';

  @override
  String get dk_olf_tide_skill => 'Puddle Poke';

  @override
  String get dk_olf_tide_skillDesc =>
      'Pokes the nearest foe with his twig sword, dripping.';

  @override
  String get dk_olf_bloom_flavor =>
      'His sword and his element are, technically, the same plant.';

  @override
  String get dk_olf_bloom_ult => 'Overgrown Tantrum';

  @override
  String get dk_olf_bloom_ultDesc =>
      'Flails wildly through the underbrush he mostly grew himself.';

  @override
  String get dk_olf_bloom_skill => 'Twig Sword Thwack';

  @override
  String get dk_olf_bloom_skillDesc =>
      'A thwack from the twig sword — which is, appropriately, also a twig.';

  @override
  String get dk_olf_lunar_flavor =>
      'Picked Lunar because he liked staying up. He is always tired.';

  @override
  String get dk_olf_lunar_ult => 'Moonstruck Stumble';

  @override
  String get dk_olf_lunar_ultDesc =>
      'Trips over his own feet directly into the enemy, somehow on purpose.';

  @override
  String get dk_olf_lunar_skill => 'Sleepy Swipe';

  @override
  String get dk_olf_lunar_skillDesc =>
      'A swipe thrown half-asleep, which is most of the time.';

  @override
  String get dk_olf_astral_flavor =>
      'Believes the stars picked him. The stars have not commented.';

  @override
  String get dk_olf_astral_ult => 'Starry-Eyed Charge';

  @override
  String get dk_olf_astral_ultDesc =>
      'Charges in staring at the sky instead of the enemy.';

  @override
  String get dk_olf_astral_skill => 'Lucky Jab';

  @override
  String get dk_olf_astral_skillDesc => 'A jab he definitely meant to land.';

  @override
  String get dk_olf_ultimate_flavor =>
      'The other Olf isn\'t sure how this happened either.';

  @override
  String get dk_olf_ultimate_ult => 'Unlikely Hero\'s Flame Lunge';

  @override
  String get dk_olf_ultimate_ultDesc =>
      'The same wobbly lunge — somehow, this time, it actually connects.';

  @override
  String get dk_olf_ultimate_skill => 'Suspiciously Competent Jab';

  @override
  String get dk_olf_ultimate_skillDesc =>
      'A jab that lands exactly where he meant it to. He looks as surprised as you.';

  @override
  String get dk_olf_ultimate_pass => 'Secretly Built Different';

  @override
  String get dk_olf_ultimate_passDesc =>
      'Somehow, against all odds, this Olf turned out unfairly strong.';

  @override
  String get world1Name => 'Whispering Meadow';

  @override
  String get world1Desc =>
      'A quiet, sunlit field where the first dreams take root.';

  @override
  String get world1Boss => 'The Unraveling';

  @override
  String get world2Name => 'Moonlit Forest';

  @override
  String get world2Desc => 'A dark wood lit only by luminous, dreaming flora.';

  @override
  String get world2Boss => 'Nightmare Warden';

  @override
  String get world3Name => 'Crystal Caverns';

  @override
  String get world3Desc => 'Frozen tides given form beneath the waking world.';

  @override
  String get world3Boss => 'Crystal Sentinel';

  @override
  String get world4Name => 'Starfall Peaks';

  @override
  String get world4Desc =>
      'Floating mountains and meteor fields around an ancient star temple.';

  @override
  String get world4Boss => 'Aetherion, the Fallen Star';

  @override
  String get world5Name => 'The Forgotten Dream';

  @override
  String get world5Desc =>
      'Broken buildings and floating ruins lost in a surreal, dense fog.';

  @override
  String get world5Boss => 'Morvane, Dream Eater';

  @override
  String get world6Name => 'Emberheart Wastes';

  @override
  String get world6Desc =>
      'Vast volcanoes and lakes of lava beneath a sky choked with ash.';

  @override
  String get world6Boss => 'Ignivar, Lord of Ash';

  @override
  String get world7Name => 'Tidal Abyss';

  @override
  String get world7Desc =>
      'Sunken temples and coral forests deep in a trench no light reaches.';

  @override
  String get world7Boss => 'Thalassor, Abyssal King';

  @override
  String get world8Name => 'Eternal Bloom';

  @override
  String get world8Desc =>
      'A colossal magical jungle of root tunnels and glowing, oversized flora.';

  @override
  String get world8Boss => 'Verdantor, Ancient Root';

  @override
  String get world9Name => 'Realm of Eclipse';

  @override
  String get world9Desc =>
      'A land locked in permanent eclipse beneath a vast, watching moon.';

  @override
  String get world9Boss => 'Noctyra, Queen of Night';

  @override
  String get world10Name => 'Celestial Dream';

  @override
  String get world10Desc =>
      'Cosmic islands and starlit temples at the very center of the Dream realm.';

  @override
  String get world10Boss => 'Elyndor, The Dream Sovereign';

  @override
  String get world11Name => 'Echoing Meadow';

  @override
  String get world11Desc =>
      'The Whispering Meadow dreams itself again — the same creatures returned, grown feral and strong.';

  @override
  String get world11Boss => 'The Unraveling, Awakened';

  @override
  String get world12Name => 'Shadowed Forest';

  @override
  String get world12Desc =>
      'A darker echo of the Moonlit Forest, where old nightmares have grown teeth.';

  @override
  String get world12Boss => 'Nightmare Warden, Reborn';

  @override
  String get world13Name => 'Deep Crystal Caverns';

  @override
  String get world13Desc =>
      'The Crystal Caverns run deeper now, and the cold within has sharpened.';

  @override
  String get world13Boss => 'Crystal Sentinel, Unbroken';

  @override
  String get world14Name => 'Starfall Reignited';

  @override
  String get world14Desc =>
      'The meteor fields of Starfall Peaks blaze again, brighter and far more dangerous.';

  @override
  String get world14Boss => 'Aetherion, the Star Undying';

  @override
  String get world15Name => 'Dream Beyond Forgetting';

  @override
  String get world15Desc =>
      'The Forgotten Dream loops back on itself, its fog thicker than before.';

  @override
  String get world15Boss => 'Morvane, the Endless Hunger';

  @override
  String get world16Name => 'Emberheart Inferno';

  @override
  String get world16Desc =>
      'The wastes burn hotter still, and the ash titans return renewed.';

  @override
  String get world16Boss => 'Ignivar, Lord of the Deep Ash';

  @override
  String get world17Name => 'The Abyss Unbound';

  @override
  String get world17Desc =>
      'The Tidal Abyss opens wider, and its oldest depths stir once more.';

  @override
  String get world17Boss => 'Thalassor, the Endless Tide';

  @override
  String get world18Name => 'Bloom Everlasting';

  @override
  String get world18Desc =>
      'Eternal Bloom grows without end, its roots stronger than any dreamer remembers.';

  @override
  String get world18Boss => 'Verdantor, the Root Eternal';

  @override
  String get world19Name => 'Eclipse Undying';

  @override
  String get world19Desc =>
      'The Realm of Eclipse falls dark again, and its court has grown far more fierce.';

  @override
  String get world19Boss => 'Noctyra, the Endless Night';

  @override
  String get world20Name => 'Celestial Requiem';

  @override
  String get world20Desc =>
      'The Celestial Dream sings once more, its cosmic guardians returned in greater strength.';

  @override
  String get world20Boss => 'Elyndor, the Last Sovereign';

  @override
  String get world21Name => 'Meadow\'s Final Dream';

  @override
  String get world21Desc =>
      'A third dreaming of the meadow, wilder and far harder to wake from.';

  @override
  String get world21Boss => 'The Unraveling, Eternal';

  @override
  String get world22Name => 'The Last Moonlit Forest';

  @override
  String get world22Desc =>
      'The forest dreams a final time, its shadows deeper than any before.';

  @override
  String get world22Boss => 'Nightmare Warden, Undying';

  @override
  String get world23Name => 'Caverns of Endless Crystal';

  @override
  String get world23Desc =>
      'The caverns crystallize further still, hardening into something almost eternal.';

  @override
  String get world23Boss => 'Crystal Sentinel, Absolute';

  @override
  String get world24Name => 'Starfall\'s End';

  @override
  String get world24Desc =>
      'The star temple\'s final fall, brighter and more violent than the sky can hold.';

  @override
  String get world24Boss => 'Aetherion, the Fallen Sun';

  @override
  String get world25Name => 'The Dream That Never Wakes';

  @override
  String get world25Desc =>
      'The Forgotten Dream folds in on itself one last time, and nothing wakes from it easily.';

  @override
  String get world25Boss => 'Morvane, the Final Hunger';

  @override
  String get world26Name => 'Emberheart\'s Last Fire';

  @override
  String get world26Desc =>
      'The wastes\' final blaze, hot enough to reshape the ash fields entirely.';

  @override
  String get world26Boss => 'Ignivar, the Last Ember';

  @override
  String get world27Name => 'The Abyss Eternal';

  @override
  String get world27Desc =>
      'The trench has no bottom left to find, and what lives there has waited a long time.';

  @override
  String get world27Boss => 'Thalassor, Sovereign of the Deep';

  @override
  String get world28Name => 'The Bloom That Never Fades';

  @override
  String get world28Desc => 'Eternal Bloom reaches its final, endless growth.';

  @override
  String get world28Boss => 'Verdantor, the World Tree\'s Heart';

  @override
  String get world29Name => 'The Eclipse Absolute';

  @override
  String get world29Desc =>
      'Darkness reaches its final form, and its ruler has never been stronger.';

  @override
  String get world29Boss => 'Noctyra, Empress of Shadow';

  @override
  String get world30Name => 'The Final Dream';

  @override
  String get world30Desc =>
      'The last dream the Dreamkeepers will ever need to wake from.';

  @override
  String get world30Boss => 'Elyndor, the Dreaming God';

  @override
  String get monBrambleStalker => 'Bramble Stalker';

  @override
  String get monBrambleStalkerLore =>
      'Creeps through the tall grass, thorns bristling at the first sign of a footstep.';

  @override
  String get monDustWisp => 'Dust Wisp';

  @override
  String get monDustWispLore =>
      'A loose knot of drifting pollen and static, harmless until it swarms.';

  @override
  String get monMeadowSprite => 'Meadow Sprite';

  @override
  String get monMeadowSpriteLore =>
      'Small, quick, and fiercely territorial over its patch of clover.';

  @override
  String get monSunpetalGuardian => 'Sunpetal Guardian';

  @override
  String get monSunpetalGuardianLore =>
      'Blooms once at dawn and stands watch over the meadow until dusk.';

  @override
  String get monGloomHound => 'Gloom Hound';

  @override
  String get monGloomHoundLore =>
      'Hunts in the space between shadows, never quite where you last saw it.';

  @override
  String get monHollowShade => 'Hollow Shade';

  @override
  String get monHollowShadeLore =>
      'Wears the shape of a forgotten dream, hollow at the center.';

  @override
  String get monNightWisp => 'Night Wisp';

  @override
  String get monNightWispLore =>
      'A cold ember of moonlight that flickers whenever it\'s watched.';

  @override
  String get monThornbackProwler => 'Thornback Prowler';

  @override
  String get monThornbackProwlerLore =>
      'Silent on the forest floor, its spines the only warning it gives.';

  @override
  String get monRiftCrawler => 'Rift Crawler';

  @override
  String get monRiftCrawlerLore =>
      'Skitters along cracks in the cavern walls where light doesn\'t quite reach.';

  @override
  String get monFrostWisp => 'Frost Wisp';

  @override
  String get monFrostWispLore =>
      'Breathes out a thin, glittering cold that clings to whatever it touches.';

  @override
  String get monCavernSerpent => 'Cavern Serpent';

  @override
  String get monCavernSerpentLore =>
      'Coils through the underground tides, patient and impossibly long.';

  @override
  String get monCrystalWisp => 'Crystal Wisp';

  @override
  String get monCrystalWispLore =>
      'Refracts every sound in the cavern into a faint, discordant chime.';

  @override
  String get monStarfang => 'Starfang';

  @override
  String get monStarfangLore =>
      'A shard of an old star given teeth, prowling the meteor fields.';

  @override
  String get monCometpaw => 'Cometpaw';

  @override
  String get monCometpawLore =>
      'Leaves a trail of dying light with every leap between floating peaks.';

  @override
  String get monAstralwing => 'Astralwing';

  @override
  String get monAstralwingLore =>
      'Circles the star temple ruins on wings woven from old constellations.';

  @override
  String get monStardustling => 'Stardustling';

  @override
  String get monStardustlingLore =>
      'Small and glittering, it scatters into motes when startled.';

  @override
  String get monCosmobite => 'Cosmobite';

  @override
  String get monCosmobiteLore =>
      'Its bite carries a cold, distant chill from beyond the sky.';

  @override
  String get monNebulaclaw => 'Nebulaclaw';

  @override
  String get monNebulaclawLore =>
      'Claws wreathed in drifting cosmic haze, silent as vacuum.';

  @override
  String get monStarhorn => 'Starhorn';

  @override
  String get monStarhornLore =>
      'Charges the crystal spires of Starfall Peaks head-first.';

  @override
  String get monCometscale => 'Cometscale';

  @override
  String get monCometscaleLore =>
      'Scales that shed light long after the creature has moved on.';

  @override
  String get monMoonfang => 'Moonfang';

  @override
  String get monMoonfangLore =>
      'Wanders the broken buildings, howling at a moon no one else remembers.';

  @override
  String get monDuskhorn => 'Duskhorn';

  @override
  String get monDuskhornLore =>
      'Charges out of the dense fog before its silhouette ever resolves.';

  @override
  String get monNightclaw => 'Nightclaw';

  @override
  String get monNightclawLore =>
      'Claws that leave no mark, only the memory of having been cut.';

  @override
  String get monShadowtail => 'Shadowtail';

  @override
  String get monShadowtailLore =>
      'Its tail lags a full second behind the rest of its body.';

  @override
  String get monEclipsepaw => 'Eclipsepaw';

  @override
  String get monEclipsepawLore =>
      'Steps between floating ruin-fragments as if they were solid ground.';

  @override
  String get monDreamstalker => 'Dreamstalker';

  @override
  String get monDreamstalkerLore =>
      'Follows dreamers through the fog long after they\'ve woken.';

  @override
  String get monMoonscale => 'Moonscale';

  @override
  String get monMoonscaleLore =>
      'Scales that dim and brighten with a moon phase all their own.';

  @override
  String get monGloomfang => 'Gloomfang';

  @override
  String get monGloomfangLore =>
      'A last echo of the dream this ruined city used to be.';

  @override
  String get monCinderfang => 'Cinderfang';

  @override
  String get monCinderfangLore =>
      'Prowls the ash fields, jaws glowing faintly with banked heat.';

  @override
  String get monAshclaw => 'Ashclaw';

  @override
  String get monAshclawLore =>
      'Leaves smoldering prints across the black volcanic rock.';

  @override
  String get monFlamehorn => 'Flamehorn';

  @override
  String get monFlamehornLore => 'Charges lava lakes head-on without slowing.';

  @override
  String get monScorchling => 'Scorchling';

  @override
  String get monScorchlingLore =>
      'Small, quick, and always a little too close to catching fire.';

  @override
  String get monEmbermaw => 'Embermaw';

  @override
  String get monEmbermawLore =>
      'Its bite carries the heat of a coal that never quite cools.';

  @override
  String get monBlazetail => 'Blazetail';

  @override
  String get monBlazetailLore =>
      'A whip-crack tail that leaves a line of fire in the ash.';

  @override
  String get monMagmabite => 'Magmabite';

  @override
  String get monMagmabiteLore =>
      'Bites clean through cooled rock crust in search of the wastes\' heat.';

  @override
  String get monCharhound => 'Charhound';

  @override
  String get monCharhoundLore =>
      'Hunts in the choking ash clouds by scent alone.';

  @override
  String get monPyrewing => 'Pyrewing';

  @override
  String get monPyrewingLore =>
      'Circles the burning ruins on wings of drifting ember.';

  @override
  String get monInferclaw => 'Inferclaw';

  @override
  String get monInferclawLore =>
      'Claws still hot from the lava lake it just crawled out of.';

  @override
  String get monCoalback => 'Coalback';

  @override
  String get monCoalbackLore =>
      'A ridged spine that glows brighter the angrier it gets.';

  @override
  String get monSearscale => 'Searscale';

  @override
  String get monSearscaleLore =>
      'Scales that scald anything that gets too close.';

  @override
  String get monFlarefang => 'Flarefang';

  @override
  String get monFlarefangLore =>
      'A sudden burst of light and teeth from the ash cloud.';

  @override
  String get monBurnpaw => 'Burnpaw';

  @override
  String get monBurnpawLore => 'Leaves scorched pawprints wherever it walks.';

  @override
  String get monIgnisprite => 'Ignisprite';

  @override
  String get monIgnispriteLore =>
      'A tiny fire-spirit born from a stray cinder off Ignivar\'s own flame.';

  @override
  String get monAshenox => 'Ashenox';

  @override
  String get monAshenoxLore =>
      'Wears a coat of drifting ash over skin still smoldering beneath.';

  @override
  String get monMistfin => 'Mistfin';

  @override
  String get monMistfinLore =>
      'Slips through the coral forest wrapped in a veil of cold mist.';

  @override
  String get monTideclaw => 'Tideclaw';

  @override
  String get monTideclawLore =>
      'Claws that pull with the force of a rising tide.';

  @override
  String get monRipplefang => 'Ripplefang';

  @override
  String get monRipplefangLore =>
      'Every bite sends a ring of current rippling outward.';

  @override
  String get monAquabite => 'Aquabite';

  @override
  String get monAquabiteLore =>
      'Small and quick, darting between sunken temple pillars.';

  @override
  String get monWavepup => 'Wavepup';

  @override
  String get monWavepupLore =>
      'Young and playful, riding the abyss\'s slow deep currents.';

  @override
  String get monRainscale => 'Rainscale';

  @override
  String get monRainscaleLore =>
      'Scales that weep a constant, cold trickle of seawater.';

  @override
  String get monDeepfin => 'Deepfin';

  @override
  String get monDeepfinLore =>
      'Never surfaces — the trench is the only home it has known.';

  @override
  String get monBrookling => 'Brookling';

  @override
  String get monBrooklingLore =>
      'A trickle of a creature that pools into something larger when threatened.';

  @override
  String get monFrostgill => 'Frostgill';

  @override
  String get monFrostgillLore =>
      'Gills that chill the water for a body length in every direction.';

  @override
  String get monStormfin => 'Stormfin';

  @override
  String get monStormfinLore =>
      'Churns the water into a squall wherever it swims.';

  @override
  String get monPearlmaw => 'Pearlmaw';

  @override
  String get monPearlmawLore =>
      'Its jaw glints with a lifetime of swallowed pearls.';

  @override
  String get monSplashpaw => 'Splashpaw';

  @override
  String get monSplashpawLore =>
      'Bounds along the sunken temple floor in bursts of current.';

  @override
  String get monDrownscale => 'Drownscale';

  @override
  String get monDrownscaleLore =>
      'Legend says it once pulled an entire temple beneath the waves.';

  @override
  String get monRiverfang => 'Riverfang';

  @override
  String get monRiverfangLore =>
      'Older than the abyss itself, or so the coral forest tells it.';

  @override
  String get monMistcrawler => 'Mistcrawler';

  @override
  String get monMistcrawlerLore =>
      'Crawls along the trench floor where no light has ever reached.';

  @override
  String get monAbyssfin => 'Abyssfin';

  @override
  String get monAbyssfinLore =>
      'The deepest-dwelling of Thalassor\'s countless subjects.';

  @override
  String get monThornpaw => 'Thornpaw';

  @override
  String get monThornpawLore =>
      'Pads silently through root tunnels wider than any road.';

  @override
  String get monMossfang => 'Mossfang';

  @override
  String get monMossfangLore =>
      'So thickly covered in moss it looks like part of the jungle floor.';

  @override
  String get monLeafling => 'Leafling';

  @override
  String get monLeaflingLore =>
      'Small and quick, camouflaged among the oversized canopy.';

  @override
  String get monRootclaw => 'Rootclaw';

  @override
  String get monRootclawLore =>
      'Claws grown from a root that never stopped reaching.';

  @override
  String get monVinebeast => 'Vinebeast';

  @override
  String get monVinebeastLore =>
      'Trails living vine behind it as it moves through the undergrowth.';

  @override
  String get monBloomtail => 'Bloomtail';

  @override
  String get monBloomtailLore =>
      'A flowering tail that opens only when it senses a threat.';

  @override
  String get monPetalhorn => 'Petalhorn';

  @override
  String get monPetalhornLore =>
      'Charges beneath an oversized, brilliantly colored bloom.';

  @override
  String get monBarkhide => 'Barkhide';

  @override
  String get monBarkhideLore =>
      'Skin as tough and gnarled as the jungle\'s oldest trees.';

  @override
  String get monSporeling => 'Sporeling';

  @override
  String get monSporelingLore =>
      'Releases a faint cloud of spores whenever it\'s startled.';

  @override
  String get monWildthorn => 'Wildthorn';

  @override
  String get monWildthornLore =>
      'A tangle of thorn and muscle native only to Eternal Bloom.';

  @override
  String get monFernfang => 'Fernfang';

  @override
  String get monFernfangLore =>
      'Bites through the thick canopy vines with practiced ease.';

  @override
  String get monBrambleback => 'Brambleback';

  @override
  String get monBramblebackLore =>
      'A spine of interlocking brambles no predator wants to test.';

  @override
  String get monRootmaw => 'Rootmaw';

  @override
  String get monRootmawLore =>
      'Waits beneath the tunnel floor for something to walk overhead.';

  @override
  String get monSeedlingBeast => 'Seedling Beast';

  @override
  String get monSeedlingBeastLore =>
      'Young, but already larger than most fully grown Bloom creatures.';

  @override
  String get monIvyclaw => 'Ivyclaw';

  @override
  String get monIvyclawLore =>
      'Ivy grows over its claws between meals, then sheds when it hunts.';

  @override
  String get monThornbloom => 'Thornbloom';

  @override
  String get monThornbloomLore =>
      'The jungle\'s oldest bloom given claws, close kin to Verdantor.';

  @override
  String get monNightshade => 'Nightshade';

  @override
  String get monNightshadeLore =>
      'Grows only where Noctyra\'s permanent eclipse falls darkest.';

  @override
  String get monLunawing => 'Lunawing';

  @override
  String get monLunawingLore =>
      'Circles the watching moon on wings that never cast a shadow.';

  @override
  String get monDarkpelt => 'Darkpelt';

  @override
  String get monDarkpeltLore =>
      'A coat so black it swallows the eclipse\'s faint light entirely.';

  @override
  String get monCrescentclaw => 'Crescentclaw';

  @override
  String get monCrescentclawLore =>
      'Claws curved like the sliver of moon this realm never quite sees.';

  @override
  String get monVoidpaw => 'Voidpaw';

  @override
  String get monVoidpawLore =>
      'Steps leave no print — the eclipse realm forgets it was ever there.';

  @override
  String get monDuskscale => 'Duskscale';

  @override
  String get monDuskscaleLore =>
      'Scales caught permanently between day and night.';

  @override
  String get monNightmareBeast => 'Nightmare Beast';

  @override
  String get monNightmareBeastLore =>
      'One of Noctyra\'s own court, given form from the realm\'s endless dark.';

  @override
  String get monGalaxipaw => 'Galaxipaw';

  @override
  String get monGalaxipawLore =>
      'Each pawprint briefly holds a swirl of tiny stars.';

  @override
  String get monMeteorfang => 'Meteorfang';

  @override
  String get monMeteorfangLore =>
      'Fell to the cosmic islands still burning at the edges.';

  @override
  String get monCelestling => 'Celestling';

  @override
  String get monCelestlingLore =>
      'Small, but drawn from the same light as Elyndor itself.';

  @override
  String get monVoidstar => 'Voidstar';

  @override
  String get monVoidstarLore =>
      'A star gone dark, still pulling everything nearby toward it.';

  @override
  String get monNebulabeast => 'Nebulabeast';

  @override
  String get monNebulabeastLore =>
      'Drifts between the starlit temples wrapped in cosmic haze.';

  @override
  String get monStarlightClaw => 'Starlight Claw';

  @override
  String get monStarlightClawLore =>
      'Claws that glow with borrowed light from a galaxy long gone.';

  @override
  String get monAstralmaw => 'Astralmaw';

  @override
  String get monAstralmawLore =>
      'Guards the center of the Dream realm alongside its sovereign.';

  @override
  String get monBoss1Ult => 'Unraveling Bloom';

  @override
  String get monBoss1UltDesc =>
      'The meadow itself lashes out in bloom and fire.';

  @override
  String get monBoss1Lore =>
      'Once the meadow\'s oldest bloom, now unraveling into thorn and flame with every dream it consumes.';

  @override
  String get monBoss2Ult => 'Nightmare Grasp';

  @override
  String get monBoss2UltDesc => 'Shadows claw in from every direction at once.';

  @override
  String get monBoss2Lore =>
      'Keeper of the forest\'s deepest gloom, it grows more furious the closer it comes to falling.';

  @override
  String get monBoss3Ult => 'Sentinel\'s Judgment';

  @override
  String get monBoss3UltDesc => 'A crushing wave of crystallized force.';

  @override
  String get monBoss3Lore =>
      'A living crystal grown around a dream too heavy to wake from, shielded on every side.';

  @override
  String get monBoss4Ult => 'Starfall Cataclysm';

  @override
  String get monBoss4UltDesc =>
      'A meteor storm crashes down from the shattered sky.';

  @override
  String get monBoss4Lore =>
      'A star that fell from the heavens eons ago, still burning with the light of its old sky.';

  @override
  String get monBoss5Ult => 'Nightmare Feast';

  @override
  String get monBoss5UltDesc =>
      'Consumes the last of its prey\'s waking thoughts.';

  @override
  String get monBoss5Lore =>
      'An ancient thing that feeds on forgotten dreams, growing fatter with every one it swallows.';

  @override
  String get monBoss6Ult => 'Ashfall Reckoning';

  @override
  String get monBoss6UltDesc => 'A tidal wave of molten rock and cinder.';

  @override
  String get monBoss6Lore =>
      'A titan of fire that slept beneath the wastes for a thousand years, now awake and furious.';

  @override
  String get monBoss7Ult => 'Abyssal Tide';

  @override
  String get monBoss7UltDesc => 'A crushing wave from the deepest trench.';

  @override
  String get monBoss7Lore =>
      'Ruler of the deepest trench in the Tidal Abyss, its court are things that never see the surface.';

  @override
  String get monBoss8Ult => 'Rootbound Judgment';

  @override
  String get monBoss8UltDesc => 'The forest floor erupts in thorn and vine.';

  @override
  String get monBoss8Lore =>
      'A root older than the forest itself, slumbering beneath Eternal Bloom since before memory.';

  @override
  String get monBoss9Ult => 'Eclipse Reign';

  @override
  String get monBoss9UltDesc => 'Shadow and light strike as one.';

  @override
  String get monBoss9Lore =>
      'Sovereign of the permanent eclipse, she rules the realm equally in shadow and stolen light.';

  @override
  String get monBoss10Ult => 'Sovereign\'s Dominion';

  @override
  String get monBoss10UltDesc =>
      'Every star in the sky answers its call at once.';

  @override
  String get monBoss10Lore =>
      'Ruler of the highest dream, and the last, greatest guardian the Dreamkeepers must face.';

  @override
  String get shopGemsSmallName => 'Handful of Gems';

  @override
  String get shopGemsSmallDesc => 'A small top-up.';

  @override
  String get shopGemsMediumName => 'Pouch of Gems';

  @override
  String get shopGemsMediumDesc => 'Good value for regular summoning.';

  @override
  String get shopGemsLargeName => 'Chest of Gems';

  @override
  String get shopGemsLargeDesc => 'Best value per gem.';

  @override
  String get shopGemsMegaName => 'Vault of Gems';

  @override
  String get shopGemsMegaDesc => 'For serious Dream Haven builders.';

  @override
  String get shopGoldSmallName => 'Gold Pouch';

  @override
  String get shopGoldSmallDesc => 'Exchange gems for gold.';

  @override
  String get shopGoldLargeName => 'Gold Chest';

  @override
  String get shopGoldLargeDesc => 'Better exchange rate.';

  @override
  String get shopStarterPackName => 'Dreamkeeper Starter Pack';

  @override
  String get shopStarterPackDesc =>
      'One-time bonus for new Dream Haven builders: gold and gems to get your roster going.';

  @override
  String get shopVipPassName => 'VIP Pass';

  @override
  String get shopVipPassDesc =>
      'Removes rewarded-ad prompts for good — a permanent, one-time thank-you for supporting Dream Haven.';

  @override
  String get shopTicketSmallName => 'Trial Ticket Pack';

  @override
  String get shopTicketSmallDesc =>
      '5 extra Endless Trial attempts, on top of your free daily tickets.';

  @override
  String get shopTicketLargeName => 'Trial Ticket Bundle';

  @override
  String get shopTicketLargeDesc =>
      '15 extra Endless Trial attempts — better value for a serious climb.';

  @override
  String get shopExclusiveIgoDesc =>
      'The tide\'s own guardian — permanently joins your roster at max level and max stars.';

  @override
  String get shopExclusiveAmesDesc =>
      'Ember given human form — permanently joins your roster at max level and max stars.';

  @override
  String get achFirstSummonTitle => 'First Summon';

  @override
  String get achFirstSummonDetail => 'Summon your first Dreamkeeper.';

  @override
  String get achFirstLegendaryTitle => 'Legendary!';

  @override
  String get achFirstLegendaryDetail => 'Recruit a Legendary Dreamkeeper.';

  @override
  String get achCollector5Title => 'Growing Collection';

  @override
  String get achCollector5Detail => 'Own 5 different Dreamkeepers.';

  @override
  String get achCollector10Title => 'Dream Team';

  @override
  String get achCollector10Detail => 'Own 10 different Dreamkeepers.';

  @override
  String get achFirstBossTitle => 'Boss Slayer';

  @override
  String get achFirstBossDetail => 'Defeat your first Boss.';

  @override
  String get achStarUpTitle => 'Star Power';

  @override
  String get achStarUpDetail => 'Fuse a Dreamkeeper to raise its stars.';

  @override
  String get achMaxStarsTitle => 'Fully Ascended';

  @override
  String get achMaxStarsDetail => 'Raise a Dreamkeeper to max stars.';

  @override
  String get achFullTeamTitle => 'Squad Goals';

  @override
  String achFullTeamDetail(int size) {
    return 'Deploy a full team of $size.';
  }

  @override
  String get achPerfectClearTitle => 'Untouchable';

  @override
  String get achPerfectClearDetail => 'Win a battle without taking damage.';

  @override
  String get achAccountLevel10Title => 'Rising Dreamer';

  @override
  String get achAccountLevel10Detail => 'Reach Account Level 10.';

  @override
  String get achGoldHoarderTitle => 'Gold Hoarder';

  @override
  String get achGoldHoarderDetail => 'Hold 5,000 Gold at once.';

  @override
  String get achMonsterHunterTitle => 'Monster Hunter';

  @override
  String get achMonsterHunterDetail => 'Discover 10 different monsters.';

  @override
  String get achWeekStreakTitle => 'Dedicated Dreamer';

  @override
  String get achWeekStreakDetail => 'Claim all 7 days of a Login Streak.';

  @override
  String get missionWinBattle => 'Clear a Stage';

  @override
  String get missionPerformSummon => 'Summon a Dreamkeeper';

  @override
  String get missionCollectBuilding => 'Collect from a Building';

  @override
  String get missionUpgradeEquipment => 'Upgrade a Piece of Gear';

  @override
  String get missionSpendInShop => 'Visit the Shop';

  @override
  String get missionDefeatBoss => 'Defeat a Boss';

  @override
  String get missionDeployFullTeam => 'Field a Full Team';

  @override
  String get missionPremiumBonusStages => 'Clear 3 Stages';

  @override
  String get missionPremiumBonusSummons => 'Summon 3 Dreamkeepers';

  @override
  String get weeklyClearStages => 'Clear 15 Stages';

  @override
  String get weeklyDefeatBosses => 'Defeat 5 Bosses';

  @override
  String get weeklyPerformSummons => 'Summon 5 Dreamkeepers';

  @override
  String get weeklyUpgradeEquipment => 'Upgrade Gear 8 Times';

  @override
  String get weeklyVisitShop => 'Visit the Shop 3 Times';

  @override
  String blShieldShatters(String name) {
    return '$name\'s shield shatters!';
  }

  @override
  String blRefusesToFall(String name) {
    return '$name refuses to fall, surging back with the tide!';
  }

  @override
  String blHits(String attacker, String target, int amount) {
    return '$attacker hits $target for $amount.';
  }

  @override
  String blFalls(String name) {
    return '$name falls.';
  }

  @override
  String blUnleashesUltimate(String name, String ultimate) {
    return '$name unleashes $ultimate!';
  }

  @override
  String blFrozenStill(String name) {
    return '$name is frozen still!';
  }

  @override
  String blMoonlightHeal(int amount) {
    return 'The team is bathed in moonlight, healing for $amount.';
  }

  @override
  String blEmpowersTeam(String name) {
    return '$name empowers the whole team!';
  }

  @override
  String blWallOfWater(String name) {
    return '$name raises a wall of water around the team!';
  }

  @override
  String blUsesSkill(String name, String skill) {
    return '$name uses $skill.';
  }

  @override
  String blSoothed(String name, int amount) {
    return '$name is soothed for $amount.';
  }

  @override
  String blSteelsThemself(String name) {
    return '$name steels themself.';
  }

  @override
  String blCaughtInCurrent(String name) {
    return '$name is caught in the current, slowed!';
  }

  @override
  String blHiddenReserves(String name, int amount) {
    return '$name calls on hidden reserves, healing for $amount!';
  }

  @override
  String blRage(String name) {
    return '$name flies into a rage, striking harder!';
  }

  @override
  String blDrainsResolve(String name) {
    return '$name drains the team\'s resolve!';
  }

  @override
  String blFreshShieldRoots(String name) {
    return '$name grows a fresh shield of roots!';
  }

  @override
  String blLightToShadow(String name) {
    return '$name turns from light to shadow!';
  }

  @override
  String blSovereignForm(String name) {
    return '$name awakens its final, sovereign form!';
  }

  @override
  String get blVictory => 'Victory!';

  @override
  String get blDefeat => 'Defeat...';

  @override
  String get mechHealed => 'Healed!';

  @override
  String get mechEnraged => 'Enraged!';

  @override
  String get mechShielded => 'Shielded!';

  @override
  String get mechDrained => 'Drained!';

  @override
  String get mechPhaseShift => 'Phase Shift!';

  @override
  String get mechAwakened => 'Awakened!';

  @override
  String get notifDailyMissionsTitle => 'Daily Missions';

  @override
  String get notifDailyMissionsBody =>
      'New daily missions are ready in Dream Haven.';

  @override
  String get notifLoginBonusTitle => 'Daily Login Bonus';

  @override
  String get notifLoginBonusBody =>
      'Your login streak reward is waiting in Dream Haven.';

  @override
  String get notifGoldFountainTitle => 'Gold Fountain is full!';

  @override
  String get notifGoldFountainBody =>
      'Come collect your gold before it caps out.';

  @override
  String get notifTrainingGardenTitle => 'Training Garden is full!';

  @override
  String get notifTrainingGardenBody =>
      'Your team has EXP waiting to be collected.';

  @override
  String codexUltimateDetail(int attacks, String power) {
    return 'Charges after $attacks attacks · ×$power power';
  }

  @override
  String codexActiveSkillDetail(int seconds, String power) {
    return '${seconds}s cooldown · ×$power power';
  }

  @override
  String get codexTwinBondCategory => 'Twin Bond';

  @override
  String get codexTwinBondDescIgo =>
      'Twin Bond: +75% ATK/DEF — only active while Ames is also in the battle formation.';

  @override
  String get codexTwinBondDescAmes =>
      'Twin Bond: +75% ATK/DEF — only active while Igo is also in the battle formation.';

  @override
  String get codexTwinBondActive => 'Active';

  @override
  String get codexTwinBondInactive => 'Inactive';

  @override
  String get codexPassiveAlwaysActive => 'Always active';

  @override
  String get commonCollected => 'Collected!';

  @override
  String get achUnlockedLabel => 'Unlocked';
}
