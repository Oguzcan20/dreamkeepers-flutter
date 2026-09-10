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
}
