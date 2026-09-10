import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRestartNow.
  ///
  /// In en, this message translates to:
  /// **'Restart Now'**
  String get commonRestartNow;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get commonCollect;

  /// No description provided for @commonClaim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get commonClaim;

  /// No description provided for @commonClaimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get commonClaimed;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonAmountGold.
  ///
  /// In en, this message translates to:
  /// **'{count} Gold'**
  String commonAmountGold(int count);

  /// No description provided for @commonAmountGems.
  ///
  /// In en, this message translates to:
  /// **'{count} Gems'**
  String commonAmountGems(int count);

  /// No description provided for @commonCollectedExclaim.
  ///
  /// In en, this message translates to:
  /// **'Collected!'**
  String get commonCollectedExclaim;

  /// No description provided for @commonSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get commonSell;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get settingsBack;

  /// No description provided for @settingsSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get settingsSoundEffects;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHaptics;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsBlurb.
  ///
  /// In en, this message translates to:
  /// **'Get notified when the Gold Fountain or Training Garden is full, about daily missions, and when your Login Bonus is ready.'**
  String get settingsNotificationsBlurb;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsAccountBlurb.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your progress recognizable across devices.'**
  String get settingsAccountBlurb;

  /// No description provided for @settingsSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get settingsSignInWithGoogle;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOut;

  /// No description provided for @settingsSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get settingsSignedIn;

  /// No description provided for @settingsDefaultPlayerName.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeeper'**
  String get settingsDefaultPlayerName;

  /// No description provided for @settingsPlayGames.
  ///
  /// In en, this message translates to:
  /// **'Play Games'**
  String get settingsPlayGames;

  /// No description provided for @settingsNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get settingsNotSignedIn;

  /// No description provided for @settingsLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get settingsLeaderboard;

  /// No description provided for @settingsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get settingsSignIn;

  /// No description provided for @settingsYourData.
  ///
  /// In en, this message translates to:
  /// **'Your Data'**
  String get settingsYourData;

  /// No description provided for @settingsYourDataBlurb.
  ///
  /// In en, this message translates to:
  /// **'Progress is stored on this device and, when a cloud account is available, synced privately to your other devices. Dreamkeepers doesn\'t collect or share personal data.'**
  String get settingsYourDataBlurb;

  /// No description provided for @settingsResetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get settingsResetProgress;

  /// No description provided for @settingsResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all progress?'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetBody.
  ///
  /// In en, this message translates to:
  /// **'This deletes your Dreamkeepers, gold, gems, and campaign progress. This can\'t be undone.'**
  String get settingsResetBody;

  /// No description provided for @settingsVersionLine.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeepers · v{version}'**
  String settingsVersionLine(String version);

  /// No description provided for @settingsLanguageRestartTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart required'**
  String get settingsLanguageRestartTitle;

  /// No description provided for @settingsLanguageRestartBody.
  ///
  /// In en, this message translates to:
  /// **'The game needs to restart to apply the new language. It will close now — reopen it to continue playing.'**
  String get settingsLanguageRestartBody;

  /// No description provided for @mainMenuTagline.
  ///
  /// In en, this message translates to:
  /// **'A cozy fantasy RPG for a few quiet minutes at a time.'**
  String get mainMenuTagline;

  /// No description provided for @mainMenuPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get mainMenuPlay;

  /// No description provided for @mainMenuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainMenuSettings;

  /// No description provided for @loadingHeader.
  ///
  /// In en, this message translates to:
  /// **'LOADING…'**
  String get loadingHeader;

  /// No description provided for @loadingTipLabel.
  ///
  /// In en, this message translates to:
  /// **'TIP: '**
  String get loadingTipLabel;

  /// No description provided for @loadingAdTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading Ad…'**
  String get loadingAdTitle;

  /// No description provided for @loadingTip1.
  ///
  /// In en, this message translates to:
  /// **'Match elements for an advantage against tough enemies.'**
  String get loadingTip1;

  /// No description provided for @loadingTip2.
  ///
  /// In en, this message translates to:
  /// **'Fuse duplicate Dreamkeepers to raise their star rank.'**
  String get loadingTip2;

  /// No description provided for @loadingTip3.
  ///
  /// In en, this message translates to:
  /// **'Upgrade equipment from the Inventory to boost your team\'s stats.'**
  String get loadingTip3;

  /// No description provided for @loadingTip4.
  ///
  /// In en, this message translates to:
  /// **'Collect offline rewards from the Gold Fountain and Training Garden.'**
  String get loadingTip4;

  /// No description provided for @loadingTip5.
  ///
  /// In en, this message translates to:
  /// **'Complete Daily Missions for extra Gold and Gems.'**
  String get loadingTip5;

  /// No description provided for @loadingTip6.
  ///
  /// In en, this message translates to:
  /// **'Deploy up to five Dreamkeepers per team — balance your elements.'**
  String get loadingTip6;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingLetsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go!'**
  String get onboardingLetsGo;

  /// No description provided for @onboardingSummoningTitle.
  ///
  /// In en, this message translates to:
  /// **'Summoning Shrine'**
  String get onboardingSummoningTitle;

  /// No description provided for @onboardingSummoningBody.
  ///
  /// In en, this message translates to:
  /// **'Spend Dream Gems at the Summoning Shrine to recruit new Dreamkeepers. Odds are shown up front — no hidden mechanics. A 10x Summon always includes a bonus pull for free.'**
  String get onboardingSummoningBody;

  /// No description provided for @onboardingFusionTitle.
  ///
  /// In en, this message translates to:
  /// **'Fusion'**
  String get onboardingFusionTitle;

  /// No description provided for @onboardingFusionBody.
  ///
  /// In en, this message translates to:
  /// **'Summoning a Dreamkeeper you already own doesn\'t waste it — the duplicate goes straight to your Inventory. Fuse duplicates onto that Dreamkeeper there to raise its star tier and make it stronger.'**
  String get onboardingFusionBody;

  /// No description provided for @onboardingTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get onboardingTeamTitle;

  /// No description provided for @onboardingTeamBody.
  ///
  /// In en, this message translates to:
  /// **'Build a team from your roster in the Inventory screen. Only deployed Dreamkeepers fight in battle and train at the Training Garden — keep your best team on deck.'**
  String get onboardingTeamBody;

  /// No description provided for @onboardingCampaignTitle.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get onboardingCampaignTitle;

  /// No description provided for @onboardingCampaignBody.
  ///
  /// In en, this message translates to:
  /// **'Send your team into the Campaign to clear stages, earn gold and EXP, and defeat bosses. Boss victories recruit your next Dreamkeeper automatically.'**
  String get onboardingCampaignBody;

  /// No description provided for @starterElementTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Olf\'s Element'**
  String get starterElementTitle;

  /// No description provided for @starterElementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This sticks with him for good — pick whatever feels right.'**
  String get starterElementSubtitle;

  /// No description provided for @navDreamHaven.
  ///
  /// In en, this message translates to:
  /// **'Dream Haven'**
  String get navDreamHaven;

  /// No description provided for @achievementUnlockedBanner.
  ///
  /// In en, this message translates to:
  /// **'ACHIEVEMENT UNLOCKED'**
  String get achievementUnlockedBanner;

  /// No description provided for @achievementsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsSheetTitle;

  /// No description provided for @achievementsUnlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{unlocked}/{total} unlocked'**
  String achievementsUnlockedCount(int unlocked, int total);

  /// No description provided for @cardTwinBond.
  ///
  /// In en, this message translates to:
  /// **'Twin Bond'**
  String get cardTwinBond;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navDailyMissions.
  ///
  /// In en, this message translates to:
  /// **'Daily Missions'**
  String get navDailyMissions;

  /// No description provided for @navDailyLoginBonus.
  ///
  /// In en, this message translates to:
  /// **'Daily Login Bonus'**
  String get navDailyLoginBonus;

  /// No description provided for @navSummoningShrine.
  ///
  /// In en, this message translates to:
  /// **'Summoning Shrine'**
  String get navSummoningShrine;

  /// No description provided for @navTrainingGarden.
  ///
  /// In en, this message translates to:
  /// **'Training Garden'**
  String get navTrainingGarden;

  /// No description provided for @navGoldFountain.
  ///
  /// In en, this message translates to:
  /// **'Gold Fountain'**
  String get navGoldFountain;

  /// No description provided for @navObservatory.
  ///
  /// In en, this message translates to:
  /// **'Dream Observatory'**
  String get navObservatory;

  /// No description provided for @navEndlessTrial.
  ///
  /// In en, this message translates to:
  /// **'The Endless Trial'**
  String get navEndlessTrial;

  /// No description provided for @navWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get navWatchAd;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navCampaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get navCampaign;

  /// No description provided for @resGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get resGold;

  /// No description provided for @resDreamGems.
  ///
  /// In en, this message translates to:
  /// **'Dream Gems'**
  String get resDreamGems;

  /// No description provided for @resEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get resEnergy;

  /// No description provided for @havenPlayerLevel.
  ///
  /// In en, this message translates to:
  /// **'Player Lv {level}'**
  String havenPlayerLevel(int level);

  /// No description provided for @havenYourTeam.
  ///
  /// In en, this message translates to:
  /// **'Your Team'**
  String get havenYourTeam;

  /// No description provided for @havenNoTeam.
  ///
  /// In en, this message translates to:
  /// **'No Dreamkeepers deployed yet. Tap to build your team.'**
  String get havenNoTeam;

  /// No description provided for @havenTeamPower.
  ///
  /// In en, this message translates to:
  /// **'Team Power {power}'**
  String havenTeamPower(int power);

  /// No description provided for @havenSeasonPass.
  ///
  /// In en, this message translates to:
  /// **'Season Pass'**
  String get havenSeasonPass;

  /// No description provided for @havenSeasonPassSemantic.
  ///
  /// In en, this message translates to:
  /// **'Season Pass, Tier {tier} of {total}'**
  String havenSeasonPassSemantic(int tier, int total);

  /// No description provided for @havenTier.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier}/{total}'**
  String havenTier(int tier, int total);

  /// No description provided for @havenGemsAmount.
  ///
  /// In en, this message translates to:
  /// **'{count} Gems'**
  String havenGemsAmount(int count);

  /// No description provided for @havenExpReady.
  ///
  /// In en, this message translates to:
  /// **'+{amount} EXP ready'**
  String havenExpReady(int amount);

  /// No description provided for @havenGoldReady.
  ///
  /// In en, this message translates to:
  /// **'+{amount} Gold ready'**
  String havenGoldReady(int amount);

  /// No description provided for @havenTapToCollect.
  ///
  /// In en, this message translates to:
  /// **'Tap to collect'**
  String get havenTapToCollect;

  /// No description provided for @havenDiscovered.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} Discovered'**
  String havenDiscovered(int count, int total);

  /// No description provided for @havenFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor {floor}/{max}'**
  String havenFloor(int floor, int max);

  /// No description provided for @havenWatchAdStatus.
  ///
  /// In en, this message translates to:
  /// **'+{gold} Gold, +{gems} Gems · {used}/{max} today'**
  String havenWatchAdStatus(int gold, int gems, int used, int max);

  /// No description provided for @havenPlusGold.
  ///
  /// In en, this message translates to:
  /// **'+{amount} Gold'**
  String havenPlusGold(int amount);

  /// No description provided for @havenPlusExp.
  ///
  /// In en, this message translates to:
  /// **'+{amount} EXP'**
  String havenPlusExp(int amount);

  /// No description provided for @goldFountainBlurb.
  ///
  /// In en, this message translates to:
  /// **'Generates {rate} gold/min while you\'re away · caps after 8h'**
  String goldFountainBlurb(int rate);

  /// No description provided for @goldFountainReady.
  ///
  /// In en, this message translates to:
  /// **'Gold ready to collect'**
  String get goldFountainReady;

  /// No description provided for @trainingGardenBlurb.
  ///
  /// In en, this message translates to:
  /// **'Grants {rate} EXP/min to your deployed team while you\'re away · caps after 8h'**
  String trainingGardenBlurb(int rate);

  /// No description provided for @trainingGardenPendingExp.
  ///
  /// In en, this message translates to:
  /// **'+{amount} EXP'**
  String trainingGardenPendingExp(int amount);

  /// No description provided for @trainingGardenNoTeam.
  ///
  /// In en, this message translates to:
  /// **'Deploy a team to put the garden to work.'**
  String get trainingGardenNoTeam;

  /// No description provided for @trainingGardenReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for your deployed team'**
  String get trainingGardenReady;

  /// No description provided for @trainingGardenLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get trainingGardenLevelUp;

  /// No description provided for @trainingGardenLevelChange.
  ///
  /// In en, this message translates to:
  /// **'Lv {from} → Lv {to}'**
  String trainingGardenLevelChange(int from, int to);

  /// No description provided for @loginDayOfCycle.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String loginDayOfCycle(int day, int total);

  /// No description provided for @loginClaimedTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Claimed — Day {day} tomorrow'**
  String loginClaimedTomorrow(int day);

  /// No description provided for @loginSeeYouTomorrow.
  ///
  /// In en, this message translates to:
  /// **'See You Tomorrow'**
  String get loginSeeYouTomorrow;

  /// No description provided for @loginDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String loginDayLabel(int day);

  /// No description provided for @rewardedAdClaimed.
  ///
  /// In en, this message translates to:
  /// **'Reward Claimed!'**
  String get rewardedAdClaimed;

  /// No description provided for @rewardedAdNice.
  ///
  /// In en, this message translates to:
  /// **'Nice!'**
  String get rewardedAdNice;

  /// No description provided for @rewardedAdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Ad Unavailable'**
  String get rewardedAdUnavailable;

  /// No description provided for @missionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missionsTitle;

  /// No description provided for @missionsResetBlurb.
  ///
  /// In en, this message translates to:
  /// **'Daily resets every day · Weekly resets every Monday'**
  String get missionsResetBlurb;

  /// No description provided for @missionsBattlePassBonus.
  ///
  /// In en, this message translates to:
  /// **'Battle Pass Bonus'**
  String get missionsBattlePassBonus;

  /// No description provided for @missionsWeeklyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Weekly Challenge'**
  String get missionsWeeklyChallenge;

  /// No description provided for @missionsWeeklyLocked.
  ///
  /// In en, this message translates to:
  /// **'Unlock Battle Pass Premium to access harder weekly challenges with bigger rewards.'**
  String get missionsWeeklyLocked;

  /// No description provided for @missionsRequiresPremium.
  ///
  /// In en, this message translates to:
  /// **'Requires Premium'**
  String get missionsRequiresPremium;

  /// No description provided for @shopBadgePopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get shopBadgePopular;

  /// No description provided for @shopBadgeBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get shopBadgeBestValue;

  /// No description provided for @shopPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased!'**
  String get shopPurchased;

  /// No description provided for @shopAdded.
  ///
  /// In en, this message translates to:
  /// **'Added!'**
  String get shopAdded;

  /// No description provided for @shopTrialTickets.
  ///
  /// In en, this message translates to:
  /// **'Trial Tickets'**
  String get shopTrialTickets;

  /// No description provided for @shopGoldExchange.
  ///
  /// In en, this message translates to:
  /// **'Gold Exchange'**
  String get shopGoldExchange;

  /// No description provided for @shopTicketsGranted.
  ///
  /// In en, this message translates to:
  /// **'+{count} Tickets'**
  String shopTicketsGranted(int count);

  /// No description provided for @campaignStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage}'**
  String campaignStageLabel(int stage);

  /// No description provided for @campaignBossStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Boss Stage {stage}'**
  String campaignBossStageLabel(int stage);

  /// No description provided for @campaignStageLockedSuffix.
  ///
  /// In en, this message translates to:
  /// **', locked'**
  String get campaignStageLockedSuffix;

  /// No description provided for @campaignStageClearedSuffix.
  ///
  /// In en, this message translates to:
  /// **', cleared'**
  String get campaignStageClearedSuffix;

  /// No description provided for @campaignStageClearedTitle.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage} — already cleared'**
  String campaignStageClearedTitle(int stage);

  /// No description provided for @campaignStageClearedBody.
  ///
  /// In en, this message translates to:
  /// **'Replay the battle for the same rewards, or skip straight to the payout.'**
  String get campaignStageClearedBody;

  /// No description provided for @campaignFightCost.
  ///
  /// In en, this message translates to:
  /// **'Fight ({cost} Energy)'**
  String campaignFightCost(int cost);

  /// No description provided for @campaignSweepCost.
  ///
  /// In en, this message translates to:
  /// **'Sweep — Instant Clear ({cost} Energy)'**
  String campaignSweepCost(int cost);

  /// No description provided for @campaignNotEnoughEnergyTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Enough Energy'**
  String get campaignNotEnoughEnergyTitle;

  /// No description provided for @campaignNotEnoughEnergyBody.
  ///
  /// In en, this message translates to:
  /// **'This stage costs {cost} Energy. You have {current}/{max}.'**
  String campaignNotEnoughEnergyBody(int cost, int current, int max);

  /// No description provided for @campaignRefillForGems.
  ///
  /// In en, this message translates to:
  /// **'Refill for {count} Gems'**
  String campaignRefillForGems(int count);

  /// No description provided for @campaignComplete.
  ///
  /// In en, this message translates to:
  /// **'You\'ve cleared every known dream. More worlds are on the way.'**
  String get campaignComplete;

  /// No description provided for @campaignEnergySemantic.
  ///
  /// In en, this message translates to:
  /// **'Energy {current} of {max}'**
  String campaignEnergySemantic(int current, int max);

  /// No description provided for @campaignStageSwept.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage} swept'**
  String campaignStageSwept(int stage);

  /// No description provided for @campaignSweepPayout.
  ///
  /// In en, this message translates to:
  /// **'+{gold} Gold · +{exp} EXP'**
  String campaignSweepPayout(int gold, int exp);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profilePlayerLevel.
  ///
  /// In en, this message translates to:
  /// **'Player Level {level}'**
  String profilePlayerLevel(int level);

  /// No description provided for @profileMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'Max level reached'**
  String get profileMaxLevel;

  /// No description provided for @profileExpToNext.
  ///
  /// In en, this message translates to:
  /// **'{current} / {next} EXP to next level'**
  String profileExpToNext(int current, int next);

  /// No description provided for @profileJourneySoFar.
  ///
  /// In en, this message translates to:
  /// **'Journey So Far'**
  String get profileJourneySoFar;

  /// No description provided for @profileStatDreamkeepers.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeepers'**
  String get profileStatDreamkeepers;

  /// No description provided for @profileStatStagesCleared.
  ///
  /// In en, this message translates to:
  /// **'Stages Cleared'**
  String get profileStatStagesCleared;

  /// No description provided for @navCodex.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeeper Codex'**
  String get navCodex;

  /// No description provided for @invTabDreamkeepers.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeepers'**
  String get invTabDreamkeepers;

  /// No description provided for @invTabItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get invTabItems;

  /// No description provided for @invSortLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get invSortLevel;

  /// No description provided for @invSortRarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get invSortRarity;

  /// No description provided for @invSortStars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get invSortStars;

  /// No description provided for @invSortAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get invSortAttack;

  /// No description provided for @invSortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort Dreamkeepers'**
  String get invSortTooltip;

  /// No description provided for @invTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a Dreamkeeper to view stats and fusion.'**
  String get invTapHint;

  /// No description provided for @invDeployedCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} deployed'**
  String invDeployedCount(int count, int max);

  /// No description provided for @invSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String invSelectedCount(int count);

  /// No description provided for @invSellGainGoldGems.
  ///
  /// In en, this message translates to:
  /// **'+{gold} Gold · +{gems} Gems'**
  String invSellGainGoldGems(int gold, int gems);

  /// No description provided for @invSellForGoldGems.
  ///
  /// In en, this message translates to:
  /// **'Sell for {gold} Gold + {gems} Gems'**
  String invSellForGoldGems(int gold, int gems);

  /// No description provided for @invSellForGold.
  ///
  /// In en, this message translates to:
  /// **'Sell for {gold} Gold'**
  String invSellForGold(int gold);

  /// No description provided for @invSellConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Sell 1 Dreamkeeper?} other{Sell {count} Dreamkeepers?}}'**
  String invSellConfirmTitle(int count);

  /// No description provided for @invSellConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone. Equipped gear is unequipped, not sold.'**
  String get invSellConfirmBody;

  /// No description provided for @invCreateTeam.
  ///
  /// In en, this message translates to:
  /// **'Create Team'**
  String get invCreateTeam;

  /// No description provided for @invNoItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Items Yet'**
  String get invNoItemsTitle;

  /// No description provided for @invNoItemsBody.
  ///
  /// In en, this message translates to:
  /// **'Clear a campaign stage to find equipment for your Dreamkeepers.'**
  String get invNoItemsBody;

  /// No description provided for @invGoToCampaign.
  ///
  /// In en, this message translates to:
  /// **'Go to Campaign'**
  String get invGoToCampaign;

  /// No description provided for @invItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{rarity} · Lv {level}/{max}'**
  String invItemSubtitle(String rarity, int level, int max);

  /// No description provided for @invItemWornBy.
  ///
  /// In en, this message translates to:
  /// **'Worn by {wearer}'**
  String invItemWornBy(String wearer);

  /// No description provided for @invItemInStorage.
  ///
  /// In en, this message translates to:
  /// **'In storage'**
  String get invItemInStorage;

  /// No description provided for @invItemSemanticWorn.
  ///
  /// In en, this message translates to:
  /// **'{name}, {rarity}, Lv {level}, worn by {wearer}'**
  String invItemSemanticWorn(
      String name, String rarity, int level, String wearer);

  /// No description provided for @invItemSemanticStored.
  ///
  /// In en, this message translates to:
  /// **'{name}, {rarity}, Lv {level}, in storage'**
  String invItemSemanticStored(String name, String rarity, int level);

  /// No description provided for @summonNew.
  ///
  /// In en, this message translates to:
  /// **'New!'**
  String get summonNew;

  /// No description provided for @summonDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get summonDuplicate;

  /// No description provided for @summonEquipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{slot} · Lv {level}'**
  String summonEquipSubtitle(String slot, int level);

  /// No description provided for @summonMultiTitle.
  ///
  /// In en, this message translates to:
  /// **'Summon x{count}'**
  String summonMultiTitle(int count);

  /// No description provided for @summonMultiBody.
  ///
  /// In en, this message translates to:
  /// **'Spend {cost} Gems for {count} pulls?'**
  String summonMultiBody(int cost, int count);

  /// No description provided for @summonAction.
  ///
  /// In en, this message translates to:
  /// **'Summon'**
  String get summonAction;

  /// No description provided for @summonNotEnoughGemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Enough Gems'**
  String get summonNotEnoughGemsTitle;

  /// No description provided for @summonNotEnoughGemsBody.
  ///
  /// In en, this message translates to:
  /// **'This costs {cost} Gems. You have {have}.'**
  String summonNotEnoughGemsBody(int cost, int have);

  /// No description provided for @summonGetGems.
  ///
  /// In en, this message translates to:
  /// **'Get Gems'**
  String get summonGetGems;

  /// No description provided for @summonModeDreamkeeper.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeeper'**
  String get summonModeDreamkeeper;

  /// No description provided for @summonModeEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get summonModeEquipment;

  /// No description provided for @summonBlurbDreamkeeper.
  ///
  /// In en, this message translates to:
  /// **'Summon a Dreamkeeper from the shrine\'s deep waters.'**
  String get summonBlurbDreamkeeper;

  /// No description provided for @summonBlurbEquipment.
  ///
  /// In en, this message translates to:
  /// **'Summon a piece of Equipment forged for your current stage.'**
  String get summonBlurbEquipment;

  /// No description provided for @summonSingleButton.
  ///
  /// In en, this message translates to:
  /// **'Summon ({cost} Gems)'**
  String summonSingleButton(int cost);

  /// No description provided for @summonMultiButton.
  ///
  /// In en, this message translates to:
  /// **'x{count} ({cost} Gems)'**
  String summonMultiButton(int count, int cost);

  /// No description provided for @summonInsufficientHint.
  ///
  /// In en, this message translates to:
  /// **'Not enough Gems for a pull ({needed} needed). You have {have}.'**
  String summonInsufficientHint(int needed, int have);

  /// No description provided for @summonOddsTitle.
  ///
  /// In en, this message translates to:
  /// **'Odds'**
  String get summonOddsTitle;

  /// No description provided for @summonEpicPity.
  ///
  /// In en, this message translates to:
  /// **'Epic+ pity'**
  String get summonEpicPity;

  /// No description provided for @summonLegendaryPity.
  ///
  /// In en, this message translates to:
  /// **'Legendary+ pity'**
  String get summonLegendaryPity;

  /// No description provided for @summonTapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to open'**
  String get summonTapToOpen;

  /// No description provided for @summonResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Summon Results'**
  String get summonResultsTitle;

  /// No description provided for @summonTapToRevealAll.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal all'**
  String get summonTapToRevealAll;

  /// No description provided for @bestiaryNotEncountered.
  ///
  /// In en, this message translates to:
  /// **'Not yet encountered.'**
  String get bestiaryNotEncountered;

  /// No description provided for @codexCollected.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} Collected'**
  String codexCollected(int count, int total);

  /// No description provided for @codexFilterByRole.
  ///
  /// In en, this message translates to:
  /// **'Filter by Role'**
  String get codexFilterByRole;

  /// No description provided for @codexAllRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get codexAllRoles;

  /// No description provided for @codexNotOwned.
  ///
  /// In en, this message translates to:
  /// **'Not Owned'**
  String get codexNotOwned;

  /// No description provided for @codexDetailClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get codexDetailClose;

  /// No description provided for @codexInYourCollection.
  ///
  /// In en, this message translates to:
  /// **'In Your Collection'**
  String get codexInYourCollection;

  /// No description provided for @codexOwnedTimes.
  ///
  /// In en, this message translates to:
  /// **'Owned ×{count}'**
  String codexOwnedTimes(int count);

  /// No description provided for @codexNotOwnedYet.
  ///
  /// In en, this message translates to:
  /// **'Not Owned Yet'**
  String get codexNotOwnedYet;

  /// No description provided for @codexNotOwnedHint.
  ///
  /// In en, this message translates to:
  /// **'Find this Dreamkeeper at the Summoning Shrine.'**
  String get codexNotOwnedHint;

  /// No description provided for @codexHowItFights.
  ///
  /// In en, this message translates to:
  /// **'How It Fights'**
  String get codexHowItFights;

  /// No description provided for @codexBaseStats.
  ///
  /// In en, this message translates to:
  /// **'Base Stats'**
  String get codexBaseStats;

  /// No description provided for @codexAbilityUltimate.
  ///
  /// In en, this message translates to:
  /// **'Ultimate'**
  String get codexAbilityUltimate;

  /// No description provided for @codexAbilityActiveSkill.
  ///
  /// In en, this message translates to:
  /// **'Active Skill'**
  String get codexAbilityActiveSkill;

  /// No description provided for @codexAbilityPassive.
  ///
  /// In en, this message translates to:
  /// **'Passive'**
  String get codexAbilityPassive;

  /// No description provided for @codexElementMatchups.
  ///
  /// In en, this message translates to:
  /// **'Element Matchups'**
  String get codexElementMatchups;

  /// No description provided for @codexMatchupBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced against every element — no bonus or penalty either way.'**
  String get codexMatchupBalanced;

  /// No description provided for @codexStrongAgainst.
  ///
  /// In en, this message translates to:
  /// **'Strong Against'**
  String get codexStrongAgainst;

  /// No description provided for @codexWeakAgainst.
  ///
  /// In en, this message translates to:
  /// **'Weak Against'**
  String get codexWeakAgainst;

  /// No description provided for @codexRoleMechanicTank.
  ///
  /// In en, this message translates to:
  /// **'High HP and Defense — built to endure. Both the Ultimate and Active Skill strike the enemy directly.'**
  String get codexRoleMechanicTank;

  /// No description provided for @codexRoleMechanicDamage.
  ///
  /// In en, this message translates to:
  /// **'High Attack. Both the Ultimate and Active Skill strike the enemy for extra damage.'**
  String get codexRoleMechanicDamage;

  /// No description provided for @codexRoleMechanicHealer.
  ///
  /// In en, this message translates to:
  /// **'The Ultimate heals the whole team at once; the Active Skill heals whichever ally is lowest on HP.'**
  String get codexRoleMechanicHealer;

  /// No description provided for @codexRoleMechanicSupport.
  ///
  /// In en, this message translates to:
  /// **'The Ultimate boosts the whole team\'s Attack for the rest of the battle; the Active Skill boosts its own Attack.'**
  String get codexRoleMechanicSupport;

  /// No description provided for @codexRoleMechanicControl.
  ///
  /// In en, this message translates to:
  /// **'The Ultimate strikes the enemy and briefly stuns it; the Active Skill is a quick strike.'**
  String get codexRoleMechanicControl;

  /// No description provided for @codexRoleMechanicGuardian.
  ///
  /// In en, this message translates to:
  /// **'The Ultimate shields the whole team; the Active Skill strikes the enemy and slows it.'**
  String get codexRoleMechanicGuardian;

  /// No description provided for @brDefeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Defeat...'**
  String get brDefeatTitle;

  /// No description provided for @brBossDefeatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss Defeated!'**
  String get brBossDefeatedTitle;

  /// No description provided for @brVictoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Victory!'**
  String get brVictoryTitle;

  /// No description provided for @brDefeatBody.
  ///
  /// In en, this message translates to:
  /// **'The team was overwhelmed. Level up or gear up before trying again.'**
  String get brDefeatBody;

  /// No description provided for @brPerfectClear.
  ///
  /// In en, this message translates to:
  /// **'Perfect Clear! +{gold} bonus Gold'**
  String brPerfectClear(int gold);

  /// No description provided for @brRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get brRewards;

  /// No description provided for @brExp.
  ///
  /// In en, this message translates to:
  /// **'EXP'**
  String get brExp;

  /// No description provided for @brWorldCompleted.
  ///
  /// In en, this message translates to:
  /// **'World {number} Completed!'**
  String brWorldCompleted(int number);

  /// No description provided for @brGemsGained.
  ///
  /// In en, this message translates to:
  /// **'+{count} Dream Gems'**
  String brGemsGained(int count);

  /// No description provided for @brAccountLevel.
  ///
  /// In en, this message translates to:
  /// **'Account Level {from} → {to}'**
  String brAccountLevel(int from, int to);

  /// No description provided for @brLevelUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get brLevelUpTitle;

  /// No description provided for @brLevelChange.
  ///
  /// In en, this message translates to:
  /// **'Lv.{from} → {to}'**
  String brLevelChange(int from, int to);

  /// No description provided for @brNewRecruit.
  ///
  /// In en, this message translates to:
  /// **'New Recruit!'**
  String get brNewRecruit;

  /// No description provided for @brNextBattle.
  ///
  /// In en, this message translates to:
  /// **'Next Battle'**
  String get brNextBattle;

  /// No description provided for @brReturnToDreamHaven.
  ///
  /// In en, this message translates to:
  /// **'Return to Dream Haven'**
  String get brReturnToDreamHaven;

  /// No description provided for @bpTierProgress.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier}/{total}'**
  String bpTierProgress(int tier, int total);

  /// No description provided for @bpSeasonXp.
  ///
  /// In en, this message translates to:
  /// **'Season XP'**
  String get bpSeasonXp;

  /// No description provided for @bpMaxTierReached.
  ///
  /// In en, this message translates to:
  /// **'Max Tier Reached'**
  String get bpMaxTierReached;

  /// No description provided for @bpXpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{needed} XP'**
  String bpXpProgress(int current, int needed);

  /// No description provided for @bpXpBlurb.
  ///
  /// In en, this message translates to:
  /// **'Win battles to earn Season XP — bosses grant more. Each tier unlocks a Free reward automatically; tap the arrow on a tier to claim it, or claim the matching Premium reward too once unlocked.'**
  String get bpXpBlurb;

  /// No description provided for @bpUnlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Track'**
  String get bpUnlockPremium;

  /// No description provided for @bpPremiumBlurb.
  ///
  /// In en, this message translates to:
  /// **'Claim the gold and gem rewards on every tier you\'ve already reached — no rush, they stay unlocked for the rest of the season.'**
  String get bpPremiumBlurb;

  /// No description provided for @bpClaimTierReward.
  ///
  /// In en, this message translates to:
  /// **'Claim tier reward'**
  String get bpClaimTierReward;

  /// No description provided for @arenaNoTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'No team deployed'**
  String get arenaNoTeamTitle;

  /// No description provided for @arenaNoTeamBody.
  ///
  /// In en, this message translates to:
  /// **'Deploy a team before entering the Endless Trial.'**
  String get arenaNoTeamBody;

  /// No description provided for @arenaNoTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Trial Tickets Left'**
  String get arenaNoTicketsTitle;

  /// No description provided for @arenaNoTicketsBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all your Endless Trial attempts for today. Come back tomorrow!'**
  String get arenaNoTicketsBody;

  /// No description provided for @arenaFloorProgress.
  ///
  /// In en, this message translates to:
  /// **'Floor {current}/{total}'**
  String arenaFloorProgress(int current, int total);

  /// No description provided for @arenaTicketsSemantic.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} Trial tickets remaining today'**
  String arenaTicketsSemantic(int count, int max);

  /// No description provided for @arenaBonusTickets.
  ///
  /// In en, this message translates to:
  /// **'+{count} bonus'**
  String arenaBonusTickets(int count);

  /// No description provided for @arenaTowerCleared.
  ///
  /// In en, this message translates to:
  /// **'Tower Cleared!'**
  String get arenaTowerCleared;

  /// No description provided for @arenaTowerClearedBody.
  ///
  /// In en, this message translates to:
  /// **'Every floor stays open below for farming gear.'**
  String get arenaTowerClearedBody;

  /// No description provided for @arenaFloorsRange.
  ///
  /// In en, this message translates to:
  /// **'Floors {from}–{to}'**
  String arenaFloorsRange(int from, int to);

  /// No description provided for @arenaFloorLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor {floor}'**
  String arenaFloorLabel(int floor);

  /// No description provided for @arenaOpponentLine.
  ///
  /// In en, this message translates to:
  /// **'Lv {level} · {name}'**
  String arenaOpponentLine(int level, String name);

  /// No description provided for @arenaFarm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get arenaFarm;

  /// No description provided for @arenaFight.
  ///
  /// In en, this message translates to:
  /// **'Fight'**
  String get arenaFight;

  /// No description provided for @arenaGearChance.
  ///
  /// In en, this message translates to:
  /// **'Gear chance'**
  String get arenaGearChance;

  /// No description provided for @arenaResultDefeat.
  ///
  /// In en, this message translates to:
  /// **'Defeat'**
  String get arenaResultDefeat;

  /// No description provided for @arenaTowerClearedResultBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve conquered all 100 floors of the Endless Trial.'**
  String get arenaTowerClearedResultBody;

  /// No description provided for @arenaMilestoneReward.
  ///
  /// In en, this message translates to:
  /// **'Milestone Reward!'**
  String get arenaMilestoneReward;

  /// No description provided for @arenaMilestoneBody.
  ///
  /// In en, this message translates to:
  /// **'A guaranteed Legendary reward for reaching this floor.'**
  String get arenaMilestoneBody;

  /// No description provided for @arenaNewTier.
  ///
  /// In en, this message translates to:
  /// **'New Tier!'**
  String get arenaNewTier;

  /// No description provided for @arenaFirstClearReward.
  ///
  /// In en, this message translates to:
  /// **'First Clear Reward'**
  String get arenaFirstClearReward;

  /// No description provided for @arenaStandardReward.
  ///
  /// In en, this message translates to:
  /// **'Standard Reward'**
  String get arenaStandardReward;

  /// No description provided for @arenaFightAgain.
  ///
  /// In en, this message translates to:
  /// **'Fight Again'**
  String get arenaFightAgain;

  /// No description provided for @eqDreamkeeperFallback.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeeper'**
  String get eqDreamkeeperFallback;

  /// No description provided for @eqItemFallback.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get eqItemFallback;

  /// No description provided for @eqLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String eqLevelLabel(int level);

  /// No description provided for @eqBench.
  ///
  /// In en, this message translates to:
  /// **'Bench'**
  String get eqBench;

  /// No description provided for @eqDeploy.
  ///
  /// In en, this message translates to:
  /// **'Deploy'**
  String get eqDeploy;

  /// No description provided for @eqUltimateDetail.
  ///
  /// In en, this message translates to:
  /// **'Ultimate · charges after {attacks} attacks'**
  String eqUltimateDetail(int attacks);

  /// No description provided for @eqActiveSkillDetail.
  ///
  /// In en, this message translates to:
  /// **'Active Skill · {seconds}s cooldown'**
  String eqActiveSkillDetail(int seconds);

  /// No description provided for @eqSkillPassive.
  ///
  /// In en, this message translates to:
  /// **'Passive'**
  String get eqSkillPassive;

  /// No description provided for @eqAutoEquip.
  ///
  /// In en, this message translates to:
  /// **'Auto-Equip Best Gear'**
  String get eqAutoEquip;

  /// No description provided for @eqMaxStars.
  ///
  /// In en, this message translates to:
  /// **'Max Stars Reached'**
  String get eqMaxStars;

  /// No description provided for @eqFusionProgress.
  ///
  /// In en, this message translates to:
  /// **'{banked}/{cost} banked · {available} available'**
  String eqFusionProgress(int banked, int cost, int available);

  /// No description provided for @eqFuseToStar.
  ///
  /// In en, this message translates to:
  /// **'Fuse to ★{stars}'**
  String eqFuseToStar(int stars);

  /// No description provided for @eqUnequip.
  ///
  /// In en, this message translates to:
  /// **'Unequip'**
  String get eqUnequip;

  /// No description provided for @eqNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items in inventory'**
  String get eqNoItems;

  /// No description provided for @eqItemWithRarity.
  ///
  /// In en, this message translates to:
  /// **'{name} ({rarity})'**
  String eqItemWithRarity(String name, String rarity);

  /// No description provided for @eqEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get eqEmpty;

  /// No description provided for @eqChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get eqChange;

  /// No description provided for @eqMaxLevel.
  ///
  /// In en, this message translates to:
  /// **'Max Level Reached'**
  String get eqMaxLevel;

  /// No description provided for @eqUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get eqUpgrade;

  /// No description provided for @fusionTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuse'**
  String get fusionTitle;

  /// No description provided for @fusionNoDuplicatesDreamkeeper.
  ///
  /// In en, this message translates to:
  /// **'No duplicate {name}s yet. Summon more to gather fusion fodder.'**
  String fusionNoDuplicatesDreamkeeper(String name);

  /// No description provided for @fusionNoDuplicatesItem.
  ///
  /// In en, this message translates to:
  /// **'No duplicate {name}s yet. Clear more stages to find fusion fodder.'**
  String fusionNoDuplicatesItem(String name);

  /// No description provided for @fusionSelectDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Select duplicates to fuse'**
  String get fusionSelectDuplicates;

  /// No description provided for @fusionProgressTowardStar.
  ///
  /// In en, this message translates to:
  /// **'{banked}/{cost} toward next star'**
  String fusionProgressTowardStar(int banked, int cost);

  /// No description provided for @fusionToStarGrants.
  ///
  /// In en, this message translates to:
  /// **'Fusing to ★{stars} grants'**
  String fusionToStarGrants(int stars);

  /// No description provided for @fusionStarUp.
  ///
  /// In en, this message translates to:
  /// **'Star Up!'**
  String get fusionStarUp;

  /// No description provided for @fusionFused.
  ///
  /// In en, this message translates to:
  /// **'Fused!'**
  String get fusionFused;

  /// No description provided for @fusionAction.
  ///
  /// In en, this message translates to:
  /// **'Fuse'**
  String get fusionAction;

  /// No description provided for @fusionAtMaxStars.
  ///
  /// In en, this message translates to:
  /// **'{name} is at max stars'**
  String fusionAtMaxStars(String name);

  /// No description provided for @fusionStarUpShowcase.
  ///
  /// In en, this message translates to:
  /// **'STAR UP!'**
  String get fusionStarUpShowcase;

  /// No description provided for @starRowSemantic.
  ///
  /// In en, this message translates to:
  /// **'{stars} of {max} stars'**
  String starRowSemantic(int stars, int max);

  /// No description provided for @battleArenaStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Endless Trial · Floor {floor}'**
  String battleArenaStageLabel(int floor);

  /// No description provided for @battleWorldBossLabel.
  ///
  /// In en, this message translates to:
  /// **'{world} · Boss'**
  String battleWorldBossLabel(String world);

  /// No description provided for @battleWorldStageLabel.
  ///
  /// In en, this message translates to:
  /// **'{world} · {stage}/{total}'**
  String battleWorldStageLabel(String world, int stage, int total);

  /// No description provided for @battleSpeedTo1x.
  ///
  /// In en, this message translates to:
  /// **'Battle speed 2x, tap for 1x'**
  String get battleSpeedTo1x;

  /// No description provided for @battleSpeedTo2x.
  ///
  /// In en, this message translates to:
  /// **'Battle speed 1x, tap for 2x'**
  String get battleSpeedTo2x;

  /// No description provided for @battleAutoOn.
  ///
  /// In en, this message translates to:
  /// **'Auto-Battle on'**
  String get battleAutoOn;

  /// No description provided for @battleAutoOff.
  ///
  /// In en, this message translates to:
  /// **'Auto-Battle off'**
  String get battleAutoOff;

  /// No description provided for @battleBossBadge.
  ///
  /// In en, this message translates to:
  /// **'BOSS'**
  String get battleBossBadge;

  /// No description provided for @battleActiveSkillLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Skill'**
  String get battleActiveSkillLabel;

  /// No description provided for @battleUltimateLabel.
  ///
  /// In en, this message translates to:
  /// **'Ultimate'**
  String get battleUltimateLabel;

  /// No description provided for @elementEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get elementEmber;

  /// No description provided for @elementTide.
  ///
  /// In en, this message translates to:
  /// **'Tide'**
  String get elementTide;

  /// No description provided for @elementBloom.
  ///
  /// In en, this message translates to:
  /// **'Bloom'**
  String get elementBloom;

  /// No description provided for @elementLunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar'**
  String get elementLunar;

  /// No description provided for @elementAstral.
  ///
  /// In en, this message translates to:
  /// **'Astral'**
  String get elementAstral;

  /// No description provided for @roleTank.
  ///
  /// In en, this message translates to:
  /// **'Tank'**
  String get roleTank;

  /// No description provided for @roleDamage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get roleDamage;

  /// No description provided for @roleSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get roleSupport;

  /// No description provided for @roleHealer.
  ///
  /// In en, this message translates to:
  /// **'Healer'**
  String get roleHealer;

  /// No description provided for @roleControl.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get roleControl;

  /// No description provided for @roleGuardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get roleGuardian;

  /// No description provided for @rarityCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get rarityCommon;

  /// No description provided for @rarityUncommon.
  ///
  /// In en, this message translates to:
  /// **'Uncommon'**
  String get rarityUncommon;

  /// No description provided for @rarityRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get rarityRare;

  /// No description provided for @rarityEpic.
  ///
  /// In en, this message translates to:
  /// **'Epic'**
  String get rarityEpic;

  /// No description provided for @rarityLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get rarityLegendary;

  /// No description provided for @rarityMythic.
  ///
  /// In en, this message translates to:
  /// **'Mythic'**
  String get rarityMythic;

  /// No description provided for @rarityExclusive.
  ///
  /// In en, this message translates to:
  /// **'Exclusive'**
  String get rarityExclusive;

  /// No description provided for @slotWeapon.
  ///
  /// In en, this message translates to:
  /// **'Weapon'**
  String get slotWeapon;

  /// No description provided for @slotCharm.
  ///
  /// In en, this message translates to:
  /// **'Charm'**
  String get slotCharm;

  /// No description provided for @slotCloak.
  ///
  /// In en, this message translates to:
  /// **'Cloak'**
  String get slotCloak;

  /// No description provided for @slotRing.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get slotRing;

  /// No description provided for @arenaTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get arenaTierBronze;

  /// No description provided for @arenaTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get arenaTierSilver;

  /// No description provided for @arenaTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get arenaTierGold;

  /// No description provided for @arenaTierPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get arenaTierPlatinum;

  /// No description provided for @arenaTierDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get arenaTierDiamond;

  /// No description provided for @arenaZoneBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze Halls'**
  String get arenaZoneBronze;

  /// No description provided for @arenaZoneSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver Vault'**
  String get arenaZoneSilver;

  /// No description provided for @arenaZoneGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Sanctum'**
  String get arenaZoneGold;

  /// No description provided for @arenaZonePlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum Ascent'**
  String get arenaZonePlatinum;

  /// No description provided for @arenaZoneDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond Summit'**
  String get arenaZoneDiamond;

  /// No description provided for @dk_ember_fox_name.
  ///
  /// In en, this message translates to:
  /// **'Ember Fox'**
  String get dk_ember_fox_name;

  /// No description provided for @dk_ember_fox_flavor.
  ///
  /// In en, this message translates to:
  /// **'Born from a candle\'s last flicker before dawn.'**
  String get dk_ember_fox_flavor;

  /// No description provided for @dk_ember_fox_ult.
  ///
  /// In en, this message translates to:
  /// **'Wildfire Pounce'**
  String get dk_ember_fox_ult;

  /// No description provided for @dk_ember_fox_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A blazing leap that scorches the target.'**
  String get dk_ember_fox_ultDesc;

  /// No description provided for @dk_ember_fox_skill.
  ///
  /// In en, this message translates to:
  /// **'Ember Nip'**
  String get dk_ember_fox_skill;

  /// No description provided for @dk_ember_fox_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A quick, scorching nip at the nearest foe.'**
  String get dk_ember_fox_skillDesc;

  /// No description provided for @dk_ember_fox_pass.
  ///
  /// In en, this message translates to:
  /// **'Kindled Spirit'**
  String get dk_ember_fox_pass;

  /// No description provided for @dk_ember_fox_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Slightly bolder in a fight.'**
  String get dk_ember_fox_passDesc;

  /// No description provided for @dk_moon_hare_name.
  ///
  /// In en, this message translates to:
  /// **'Moon Hare'**
  String get dk_moon_hare_name;

  /// No description provided for @dk_moon_hare_flavor.
  ///
  /// In en, this message translates to:
  /// **'Follows travelers who fall asleep beneath the open sky.'**
  String get dk_moon_hare_flavor;

  /// No description provided for @dk_moon_hare_ult.
  ///
  /// In en, this message translates to:
  /// **'Moonlit Blessing'**
  String get dk_moon_hare_ult;

  /// No description provided for @dk_moon_hare_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Bathes the whole team in restorative moonlight.'**
  String get dk_moon_hare_ultDesc;

  /// No description provided for @dk_moon_hare_skill.
  ///
  /// In en, this message translates to:
  /// **'Soothing Touch'**
  String get dk_moon_hare_skill;

  /// No description provided for @dk_moon_hare_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A gentle pulse of moonlight for the ally who needs it most.'**
  String get dk_moon_hare_skillDesc;

  /// No description provided for @dk_moon_hare_pass.
  ///
  /// In en, this message translates to:
  /// **'Gentle Glow'**
  String get dk_moon_hare_pass;

  /// No description provided for @dk_moon_hare_passDesc.
  ///
  /// In en, this message translates to:
  /// **'A quiet, steadying presence.'**
  String get dk_moon_hare_passDesc;

  /// No description provided for @dk_forest_spirit_name.
  ///
  /// In en, this message translates to:
  /// **'Forest Spirit'**
  String get dk_forest_spirit_name;

  /// No description provided for @dk_forest_spirit_flavor.
  ///
  /// In en, this message translates to:
  /// **'Grown from the dream of a forgotten garden.'**
  String get dk_forest_spirit_flavor;

  /// No description provided for @dk_forest_spirit_ult.
  ///
  /// In en, this message translates to:
  /// **'Verdant Chorus'**
  String get dk_forest_spirit_ult;

  /// No description provided for @dk_forest_spirit_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Rallies the team with a surge of vitality.'**
  String get dk_forest_spirit_ultDesc;

  /// No description provided for @dk_forest_spirit_skill.
  ///
  /// In en, this message translates to:
  /// **'Bramble Ward'**
  String get dk_forest_spirit_skill;

  /// No description provided for @dk_forest_spirit_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'Wraps itself in hardy brambles, growing bolder.'**
  String get dk_forest_spirit_skillDesc;

  /// No description provided for @dk_forest_spirit_pass.
  ///
  /// In en, this message translates to:
  /// **'Rooted Calm'**
  String get dk_forest_spirit_pass;

  /// No description provided for @dk_forest_spirit_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Steady footing, steady mind.'**
  String get dk_forest_spirit_passDesc;

  /// No description provided for @dk_crystal_golem_name.
  ///
  /// In en, this message translates to:
  /// **'Crystal Golem'**
  String get dk_crystal_golem_name;

  /// No description provided for @dk_crystal_golem_flavor.
  ///
  /// In en, this message translates to:
  /// **'Formed where a tidal dream froze mid-wave.'**
  String get dk_crystal_golem_flavor;

  /// No description provided for @dk_crystal_golem_ult.
  ///
  /// In en, this message translates to:
  /// **'Bulwark Slam'**
  String get dk_crystal_golem_ult;

  /// No description provided for @dk_crystal_golem_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A ground-shaking blow that staggers the foe.'**
  String get dk_crystal_golem_ultDesc;

  /// No description provided for @dk_crystal_golem_skill.
  ///
  /// In en, this message translates to:
  /// **'Guard Slam'**
  String get dk_crystal_golem_skill;

  /// No description provided for @dk_crystal_golem_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A heavy but unhurried blow.'**
  String get dk_crystal_golem_skillDesc;

  /// No description provided for @dk_crystal_golem_pass.
  ///
  /// In en, this message translates to:
  /// **'Crystalline Hide'**
  String get dk_crystal_golem_pass;

  /// No description provided for @dk_crystal_golem_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Refracts a portion of incoming force.'**
  String get dk_crystal_golem_passDesc;

  /// No description provided for @dk_star_wolf_name.
  ///
  /// In en, this message translates to:
  /// **'Star Wolf'**
  String get dk_star_wolf_name;

  /// No description provided for @dk_star_wolf_flavor.
  ///
  /// In en, this message translates to:
  /// **'Runs the paths between falling stars.'**
  String get dk_star_wolf_flavor;

  /// No description provided for @dk_star_wolf_ult.
  ///
  /// In en, this message translates to:
  /// **'Starfall Howl'**
  String get dk_star_wolf_ult;

  /// No description provided for @dk_star_wolf_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A resonant howl that freezes the enemy in place.'**
  String get dk_star_wolf_ultDesc;

  /// No description provided for @dk_star_wolf_skill.
  ///
  /// In en, this message translates to:
  /// **'Quick Bite'**
  String get dk_star_wolf_skill;

  /// No description provided for @dk_star_wolf_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A fast snap before the foe can react.'**
  String get dk_star_wolf_skillDesc;

  /// No description provided for @dk_star_wolf_pass.
  ///
  /// In en, this message translates to:
  /// **'Night Vision'**
  String get dk_star_wolf_pass;

  /// No description provided for @dk_star_wolf_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Never misses a step in the dark.'**
  String get dk_star_wolf_passDesc;

  /// No description provided for @dk_thorn_viper_name.
  ///
  /// In en, this message translates to:
  /// **'Thorn Viper'**
  String get dk_thorn_viper_name;

  /// No description provided for @dk_thorn_viper_flavor.
  ///
  /// In en, this message translates to:
  /// **'Coils through brambles that grow only in restless dreams.'**
  String get dk_thorn_viper_flavor;

  /// No description provided for @dk_thorn_viper_ult.
  ///
  /// In en, this message translates to:
  /// **'Venom Fang'**
  String get dk_thorn_viper_ult;

  /// No description provided for @dk_thorn_viper_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A precise strike laced with dream-thorn poison.'**
  String get dk_thorn_viper_ultDesc;

  /// No description provided for @dk_thorn_viper_skill.
  ///
  /// In en, this message translates to:
  /// **'Puncture'**
  String get dk_thorn_viper_skill;

  /// No description provided for @dk_thorn_viper_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A jabbing strike aimed at the weak points.'**
  String get dk_thorn_viper_skillDesc;

  /// No description provided for @dk_thorn_viper_pass.
  ///
  /// In en, this message translates to:
  /// **'Toxic Coating'**
  String get dk_thorn_viper_pass;

  /// No description provided for @dk_thorn_viper_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Fangs that never quite stop stinging.'**
  String get dk_thorn_viper_passDesc;

  /// No description provided for @dk_tide_serpent_name.
  ///
  /// In en, this message translates to:
  /// **'Tide Serpent'**
  String get dk_tide_serpent_name;

  /// No description provided for @dk_tide_serpent_flavor.
  ///
  /// In en, this message translates to:
  /// **'Slips between waves too quick for waking eyes to follow.'**
  String get dk_tide_serpent_flavor;

  /// No description provided for @dk_tide_serpent_ult.
  ///
  /// In en, this message translates to:
  /// **'Riptide Coil'**
  String get dk_tide_serpent_ult;

  /// No description provided for @dk_tide_serpent_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Wraps the foe in a crushing spiral of water.'**
  String get dk_tide_serpent_ultDesc;

  /// No description provided for @dk_tide_serpent_skill.
  ///
  /// In en, this message translates to:
  /// **'Snap Coil'**
  String get dk_tide_serpent_skill;

  /// No description provided for @dk_tide_serpent_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A sudden lash of its coiled body.'**
  String get dk_tide_serpent_skillDesc;

  /// No description provided for @dk_tide_serpent_pass.
  ///
  /// In en, this message translates to:
  /// **'Slippery Scales'**
  String get dk_tide_serpent_pass;

  /// No description provided for @dk_tide_serpent_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Hard to pin down, harder to catch.'**
  String get dk_tide_serpent_passDesc;

  /// No description provided for @dk_ember_phoenix_name.
  ///
  /// In en, this message translates to:
  /// **'Ember Phoenix'**
  String get dk_ember_phoenix_name;

  /// No description provided for @dk_ember_phoenix_flavor.
  ///
  /// In en, this message translates to:
  /// **'Rises anew each time a dreamer refuses to give up.'**
  String get dk_ember_phoenix_flavor;

  /// No description provided for @dk_ember_phoenix_ult.
  ///
  /// In en, this message translates to:
  /// **'Rebirth Flame'**
  String get dk_ember_phoenix_ult;

  /// No description provided for @dk_ember_phoenix_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A blazing rebirth that mends every wound in the team.'**
  String get dk_ember_phoenix_ultDesc;

  /// No description provided for @dk_ember_phoenix_skill.
  ///
  /// In en, this message translates to:
  /// **'Warm Feather'**
  String get dk_ember_phoenix_skill;

  /// No description provided for @dk_ember_phoenix_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'Sheds a single ember-warm feather over an ally.'**
  String get dk_ember_phoenix_skillDesc;

  /// No description provided for @dk_ember_phoenix_pass.
  ///
  /// In en, this message translates to:
  /// **'Eternal Ember'**
  String get dk_ember_phoenix_pass;

  /// No description provided for @dk_ember_phoenix_passDesc.
  ///
  /// In en, this message translates to:
  /// **'A flame that refuses to be the last one out.'**
  String get dk_ember_phoenix_passDesc;

  /// No description provided for @dk_lunar_owl_name.
  ///
  /// In en, this message translates to:
  /// **'Lunar Owl'**
  String get dk_lunar_owl_name;

  /// No description provided for @dk_lunar_owl_flavor.
  ///
  /// In en, this message translates to:
  /// **'Watches from branches that exist only under a full moon.'**
  String get dk_lunar_owl_flavor;

  /// No description provided for @dk_lunar_owl_ult.
  ///
  /// In en, this message translates to:
  /// **'Silent Talons'**
  String get dk_lunar_owl_ult;

  /// No description provided for @dk_lunar_owl_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A soundless dive that leaves the target reeling.'**
  String get dk_lunar_owl_ultDesc;

  /// No description provided for @dk_lunar_owl_skill.
  ///
  /// In en, this message translates to:
  /// **'Swift Peck'**
  String get dk_lunar_owl_skill;

  /// No description provided for @dk_lunar_owl_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A precise strike from above.'**
  String get dk_lunar_owl_skillDesc;

  /// No description provided for @dk_lunar_owl_pass.
  ///
  /// In en, this message translates to:
  /// **'Keen Eyes'**
  String get dk_lunar_owl_pass;

  /// No description provided for @dk_lunar_owl_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Sees every opening before it appears.'**
  String get dk_lunar_owl_passDesc;

  /// No description provided for @dk_astral_sentinel_name.
  ///
  /// In en, this message translates to:
  /// **'Astral Sentinel'**
  String get dk_astral_sentinel_name;

  /// No description provided for @dk_astral_sentinel_flavor.
  ///
  /// In en, this message translates to:
  /// **'Stands guard at the border between dream and stars.'**
  String get dk_astral_sentinel_flavor;

  /// No description provided for @dk_astral_sentinel_ult.
  ///
  /// In en, this message translates to:
  /// **'Starward Bulwark'**
  String get dk_astral_sentinel_ult;

  /// No description provided for @dk_astral_sentinel_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Calls down a wall of starlight to guard the team.'**
  String get dk_astral_sentinel_ultDesc;

  /// No description provided for @dk_astral_sentinel_skill.
  ///
  /// In en, this message translates to:
  /// **'Brace'**
  String get dk_astral_sentinel_skill;

  /// No description provided for @dk_astral_sentinel_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'Plants itself firm and strikes back.'**
  String get dk_astral_sentinel_skillDesc;

  /// No description provided for @dk_astral_sentinel_pass.
  ///
  /// In en, this message translates to:
  /// **'Astral Ward'**
  String get dk_astral_sentinel_pass;

  /// No description provided for @dk_astral_sentinel_passDesc.
  ///
  /// In en, this message translates to:
  /// **'A quiet shimmer that deflects the worst of it.'**
  String get dk_astral_sentinel_passDesc;

  /// No description provided for @dk_coral_warden_name.
  ///
  /// In en, this message translates to:
  /// **'Coral Warden'**
  String get dk_coral_warden_name;

  /// No description provided for @dk_coral_warden_flavor.
  ///
  /// In en, this message translates to:
  /// **'Grew from a reef that only blooms in deep sleep.'**
  String get dk_coral_warden_flavor;

  /// No description provided for @dk_coral_warden_ult.
  ///
  /// In en, this message translates to:
  /// **'Tidal Chorus'**
  String get dk_coral_warden_ult;

  /// No description provided for @dk_coral_warden_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A rolling wave of encouragement washes over the team.'**
  String get dk_coral_warden_ultDesc;

  /// No description provided for @dk_coral_warden_skill.
  ///
  /// In en, this message translates to:
  /// **'Encourage'**
  String get dk_coral_warden_skill;

  /// No description provided for @dk_coral_warden_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A steadying word that stiffens resolve.'**
  String get dk_coral_warden_skillDesc;

  /// No description provided for @dk_coral_warden_pass.
  ///
  /// In en, this message translates to:
  /// **'Reef Guard'**
  String get dk_coral_warden_pass;

  /// No description provided for @dk_coral_warden_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Grew tough where the currents are roughest.'**
  String get dk_coral_warden_passDesc;

  /// No description provided for @dk_cinder_sprite_name.
  ///
  /// In en, this message translates to:
  /// **'Cinder Sprite'**
  String get dk_cinder_sprite_name;

  /// No description provided for @dk_cinder_sprite_flavor.
  ///
  /// In en, this message translates to:
  /// **'A spark that never quite burns out, no matter the dark.'**
  String get dk_cinder_sprite_flavor;

  /// No description provided for @dk_cinder_sprite_ult.
  ///
  /// In en, this message translates to:
  /// **'Spark Rally'**
  String get dk_cinder_sprite_ult;

  /// No description provided for @dk_cinder_sprite_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A shower of warm sparks lifts the whole team\'s spirit.'**
  String get dk_cinder_sprite_ultDesc;

  /// No description provided for @dk_cinder_sprite_skill.
  ///
  /// In en, this message translates to:
  /// **'Warm Spark Jab'**
  String get dk_cinder_sprite_skill;

  /// No description provided for @dk_cinder_sprite_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A friendly spark that lifts the spirit.'**
  String get dk_cinder_sprite_skillDesc;

  /// No description provided for @dk_cinder_sprite_pass.
  ///
  /// In en, this message translates to:
  /// **'Warm Spark'**
  String get dk_cinder_sprite_pass;

  /// No description provided for @dk_cinder_sprite_passDesc.
  ///
  /// In en, this message translates to:
  /// **'A spark that never quite burns out, no matter the dark.'**
  String get dk_cinder_sprite_passDesc;

  /// No description provided for @dk_flicker_pup_name.
  ///
  /// In en, this message translates to:
  /// **'Flicker Pup'**
  String get dk_flicker_pup_name;

  /// No description provided for @dk_flicker_pup_flavor.
  ///
  /// In en, this message translates to:
  /// **'Hatched from the last spark of a dream that almost went out.'**
  String get dk_flicker_pup_flavor;

  /// No description provided for @dk_flicker_pup_ult.
  ///
  /// In en, this message translates to:
  /// **'Candle Charge'**
  String get dk_flicker_pup_ult;

  /// No description provided for @dk_flicker_pup_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A clumsy but eager charge wreathed in flickering flame.'**
  String get dk_flicker_pup_ultDesc;

  /// No description provided for @dk_flicker_pup_skill.
  ///
  /// In en, this message translates to:
  /// **'Warm Nip'**
  String get dk_flicker_pup_skill;

  /// No description provided for @dk_flicker_pup_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A playful nip that\'s hotter than it looks.'**
  String get dk_flicker_pup_skillDesc;

  /// No description provided for @dk_flicker_pup_pass.
  ///
  /// In en, this message translates to:
  /// **'Restless Spark'**
  String get dk_flicker_pup_pass;

  /// No description provided for @dk_flicker_pup_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Too excitable to ever stay still for long.'**
  String get dk_flicker_pup_passDesc;

  /// No description provided for @dk_ripple_minnow_name.
  ///
  /// In en, this message translates to:
  /// **'Ripple Minnow'**
  String get dk_ripple_minnow_name;

  /// No description provided for @dk_ripple_minnow_flavor.
  ///
  /// In en, this message translates to:
  /// **'Swims in the shallow end of dreams too small for anything bigger.'**
  String get dk_ripple_minnow_flavor;

  /// No description provided for @dk_ripple_minnow_ult.
  ///
  /// In en, this message translates to:
  /// **'Shoal Surge'**
  String get dk_ripple_minnow_ult;

  /// No description provided for @dk_ripple_minnow_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A rush of small fish that steadies the whole team.'**
  String get dk_ripple_minnow_ultDesc;

  /// No description provided for @dk_ripple_minnow_skill.
  ///
  /// In en, this message translates to:
  /// **'Nudge'**
  String get dk_ripple_minnow_skill;

  /// No description provided for @dk_ripple_minnow_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A gentle push in the right direction.'**
  String get dk_ripple_minnow_skillDesc;

  /// No description provided for @dk_ripple_minnow_pass.
  ///
  /// In en, this message translates to:
  /// **'Safety in Numbers'**
  String get dk_ripple_minnow_pass;

  /// No description provided for @dk_ripple_minnow_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Never truly alone, even when it looks that way.'**
  String get dk_ripple_minnow_passDesc;

  /// No description provided for @dk_sprout_cub_name.
  ///
  /// In en, this message translates to:
  /// **'Sprout Cub'**
  String get dk_sprout_cub_name;

  /// No description provided for @dk_sprout_cub_flavor.
  ///
  /// In en, this message translates to:
  /// **'A seedling dream that decided to grow claws instead of leaves.'**
  String get dk_sprout_cub_flavor;

  /// No description provided for @dk_sprout_cub_ult.
  ///
  /// In en, this message translates to:
  /// **'Stubborn Root'**
  String get dk_sprout_cub_ult;

  /// No description provided for @dk_sprout_cub_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Plants itself down and simply refuses to move.'**
  String get dk_sprout_cub_ultDesc;

  /// No description provided for @dk_sprout_cub_skill.
  ///
  /// In en, this message translates to:
  /// **'Headbutt'**
  String get dk_sprout_cub_skill;

  /// No description provided for @dk_sprout_cub_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'An earnest, clumsy charge.'**
  String get dk_sprout_cub_skillDesc;

  /// No description provided for @dk_sprout_cub_pass.
  ///
  /// In en, this message translates to:
  /// **'Thick Bark'**
  String get dk_sprout_cub_pass;

  /// No description provided for @dk_sprout_cub_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Young, but already tougher than it looks.'**
  String get dk_sprout_cub_passDesc;

  /// No description provided for @dk_nightling_name.
  ///
  /// In en, this message translates to:
  /// **'Nightling'**
  String get dk_nightling_name;

  /// No description provided for @dk_nightling_flavor.
  ///
  /// In en, this message translates to:
  /// **'A scrap of night that broke off before the dream was finished.'**
  String get dk_nightling_flavor;

  /// No description provided for @dk_nightling_ult.
  ///
  /// In en, this message translates to:
  /// **'Small Shadow'**
  String get dk_nightling_ult;

  /// No description provided for @dk_nightling_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Slips a sliver of dark across the enemy\'s eyes.'**
  String get dk_nightling_ultDesc;

  /// No description provided for @dk_nightling_skill.
  ///
  /// In en, this message translates to:
  /// **'Flicker Step'**
  String get dk_nightling_skill;

  /// No description provided for @dk_nightling_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A quick sidestep into darkness and back.'**
  String get dk_nightling_skillDesc;

  /// No description provided for @dk_nightling_pass.
  ///
  /// In en, this message translates to:
  /// **'Half-Seen'**
  String get dk_nightling_pass;

  /// No description provided for @dk_nightling_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Never quite where you expect it to be.'**
  String get dk_nightling_passDesc;

  /// No description provided for @dk_stardust_moth_name.
  ///
  /// In en, this message translates to:
  /// **'Stardust Moth'**
  String get dk_stardust_moth_name;

  /// No description provided for @dk_stardust_moth_flavor.
  ///
  /// In en, this message translates to:
  /// **'Drawn to any dream still bright enough to see.'**
  String get dk_stardust_moth_flavor;

  /// No description provided for @dk_stardust_moth_ult.
  ///
  /// In en, this message translates to:
  /// **'Dust Trail'**
  String get dk_stardust_moth_ult;

  /// No description provided for @dk_stardust_moth_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Sheds a fine, healing dust over the team.'**
  String get dk_stardust_moth_ultDesc;

  /// No description provided for @dk_stardust_moth_skill.
  ///
  /// In en, this message translates to:
  /// **'Wing Flutter'**
  String get dk_stardust_moth_skill;

  /// No description provided for @dk_stardust_moth_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A soft flutter that eases an ally\'s pain.'**
  String get dk_stardust_moth_skillDesc;

  /// No description provided for @dk_stardust_moth_pass.
  ///
  /// In en, this message translates to:
  /// **'Drawn to Light'**
  String get dk_stardust_moth_pass;

  /// No description provided for @dk_stardust_moth_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Follows whatever light is left in the fight.'**
  String get dk_stardust_moth_passDesc;

  /// No description provided for @dk_cinder_badger_name.
  ///
  /// In en, this message translates to:
  /// **'Cinder Badger'**
  String get dk_cinder_badger_name;

  /// No description provided for @dk_cinder_badger_flavor.
  ///
  /// In en, this message translates to:
  /// **'Digs its den where a hearth-fire dream burned down to embers.'**
  String get dk_cinder_badger_flavor;

  /// No description provided for @dk_cinder_badger_ult.
  ///
  /// In en, this message translates to:
  /// **'Coal Dig'**
  String get dk_cinder_badger_ult;

  /// No description provided for @dk_cinder_badger_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Burrows in and erupts with banked heat.'**
  String get dk_cinder_badger_ultDesc;

  /// No description provided for @dk_cinder_badger_skill.
  ///
  /// In en, this message translates to:
  /// **'Stubborn Charge'**
  String get dk_cinder_badger_skill;

  /// No description provided for @dk_cinder_badger_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'Lowers its head and simply pushes through.'**
  String get dk_cinder_badger_skillDesc;

  /// No description provided for @dk_cinder_badger_pass.
  ///
  /// In en, this message translates to:
  /// **'Banked Heat'**
  String get dk_cinder_badger_pass;

  /// No description provided for @dk_cinder_badger_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Runs warmer the longer a fight drags on.'**
  String get dk_cinder_badger_passDesc;

  /// No description provided for @dk_pearl_otter_name.
  ///
  /// In en, this message translates to:
  /// **'Pearl Otter'**
  String get dk_pearl_otter_name;

  /// No description provided for @dk_pearl_otter_flavor.
  ///
  /// In en, this message translates to:
  /// **'Collects pearls from dreams too calm to ever make waves.'**
  String get dk_pearl_otter_flavor;

  /// No description provided for @dk_pearl_otter_ult.
  ///
  /// In en, this message translates to:
  /// **'Pearl Tide'**
  String get dk_pearl_otter_ult;

  /// No description provided for @dk_pearl_otter_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A wave of luminous pearls mends the team\'s wounds.'**
  String get dk_pearl_otter_ultDesc;

  /// No description provided for @dk_pearl_otter_skill.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get dk_pearl_otter_skill;

  /// No description provided for @dk_pearl_otter_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A quick, fussy grooming pass over an ally.'**
  String get dk_pearl_otter_skillDesc;

  /// No description provided for @dk_pearl_otter_pass.
  ///
  /// In en, this message translates to:
  /// **'Buoyant'**
  String get dk_pearl_otter_pass;

  /// No description provided for @dk_pearl_otter_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Always finds a way to stay afloat.'**
  String get dk_pearl_otter_passDesc;

  /// No description provided for @dk_comet_fox_name.
  ///
  /// In en, this message translates to:
  /// **'Comet Fox'**
  String get dk_comet_fox_name;

  /// No description provided for @dk_comet_fox_flavor.
  ///
  /// In en, this message translates to:
  /// **'Chases the tail of an actual comet through the dream sky and usually wins.'**
  String get dk_comet_fox_flavor;

  /// No description provided for @dk_comet_fox_ult.
  ///
  /// In en, this message translates to:
  /// **'Streaking Dash'**
  String get dk_comet_fox_ult;

  /// No description provided for @dk_comet_fox_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A blinding dash that leaves a trail of light.'**
  String get dk_comet_fox_ultDesc;

  /// No description provided for @dk_comet_fox_skill.
  ///
  /// In en, this message translates to:
  /// **'Tail Flash'**
  String get dk_comet_fox_skill;

  /// No description provided for @dk_comet_fox_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A quick flick of a glowing tail.'**
  String get dk_comet_fox_skillDesc;

  /// No description provided for @dk_comet_fox_pass.
  ///
  /// In en, this message translates to:
  /// **'Trailing Light'**
  String get dk_comet_fox_pass;

  /// No description provided for @dk_comet_fox_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Leaves the air shimmering just from passing through.'**
  String get dk_comet_fox_passDesc;

  /// No description provided for @dk_bramble_lynx_name.
  ///
  /// In en, this message translates to:
  /// **'Bramble Lynx'**
  String get dk_bramble_lynx_name;

  /// No description provided for @dk_bramble_lynx_flavor.
  ///
  /// In en, this message translates to:
  /// **'Stalks the hedgerows of a garden dream no one remembers planting.'**
  String get dk_bramble_lynx_flavor;

  /// No description provided for @dk_bramble_lynx_ult.
  ///
  /// In en, this message translates to:
  /// **'Thicket Pounce'**
  String get dk_bramble_lynx_ult;

  /// No description provided for @dk_bramble_lynx_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Vanishes into brush and strikes from an angle no one expects.'**
  String get dk_bramble_lynx_ultDesc;

  /// No description provided for @dk_bramble_lynx_skill.
  ///
  /// In en, this message translates to:
  /// **'Claw Rake'**
  String get dk_bramble_lynx_skill;

  /// No description provided for @dk_bramble_lynx_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A fast, low rake across the legs.'**
  String get dk_bramble_lynx_skillDesc;

  /// No description provided for @dk_bramble_lynx_pass.
  ///
  /// In en, this message translates to:
  /// **'Thorned Coat'**
  String get dk_bramble_lynx_pass;

  /// No description provided for @dk_bramble_lynx_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Grew its fur through a hedge of brambles.'**
  String get dk_bramble_lynx_passDesc;

  /// No description provided for @dk_shade_panther_name.
  ///
  /// In en, this message translates to:
  /// **'Shade Panther'**
  String get dk_shade_panther_name;

  /// No description provided for @dk_shade_panther_flavor.
  ///
  /// In en, this message translates to:
  /// **'Hunts on the nights the moon forgets to rise at all.'**
  String get dk_shade_panther_flavor;

  /// No description provided for @dk_shade_panther_ult.
  ///
  /// In en, this message translates to:
  /// **'Moonless Strike'**
  String get dk_shade_panther_ult;

  /// No description provided for @dk_shade_panther_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A strike timed to the one moment no light reaches it.'**
  String get dk_shade_panther_ultDesc;

  /// No description provided for @dk_shade_panther_skill.
  ///
  /// In en, this message translates to:
  /// **'Silent Pounce'**
  String get dk_shade_panther_skill;

  /// No description provided for @dk_shade_panther_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'Crosses the distance before the sound catches up.'**
  String get dk_shade_panther_skillDesc;

  /// No description provided for @dk_shade_panther_pass.
  ///
  /// In en, this message translates to:
  /// **'Unseen'**
  String get dk_shade_panther_pass;

  /// No description provided for @dk_shade_panther_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Blends into whatever shadow it\'s standing in.'**
  String get dk_shade_panther_passDesc;

  /// No description provided for @dk_nova_falcon_name.
  ///
  /// In en, this message translates to:
  /// **'Nova Falcon'**
  String get dk_nova_falcon_name;

  /// No description provided for @dk_nova_falcon_flavor.
  ///
  /// In en, this message translates to:
  /// **'Nests at the peak of a mountain that only exists at the top of a dream.'**
  String get dk_nova_falcon_flavor;

  /// No description provided for @dk_nova_falcon_ult.
  ///
  /// In en, this message translates to:
  /// **'Nova Dive'**
  String get dk_nova_falcon_ult;

  /// No description provided for @dk_nova_falcon_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A screaming dive trailing a burst of starlight.'**
  String get dk_nova_falcon_ultDesc;

  /// No description provided for @dk_nova_falcon_skill.
  ///
  /// In en, this message translates to:
  /// **'Wing Cut'**
  String get dk_nova_falcon_skill;

  /// No description provided for @dk_nova_falcon_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A sharp turn that clips the target mid-flight.'**
  String get dk_nova_falcon_skillDesc;

  /// No description provided for @dk_nova_falcon_pass.
  ///
  /// In en, this message translates to:
  /// **'Updraft'**
  String get dk_nova_falcon_pass;

  /// No description provided for @dk_nova_falcon_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Rides currents that only it can feel.'**
  String get dk_nova_falcon_passDesc;

  /// No description provided for @dk_magma_titan_name.
  ///
  /// In en, this message translates to:
  /// **'Magma Titan'**
  String get dk_magma_titan_name;

  /// No description provided for @dk_magma_titan_flavor.
  ///
  /// In en, this message translates to:
  /// **'Stands where a mountain-sized dream slowly finished melting.'**
  String get dk_magma_titan_flavor;

  /// No description provided for @dk_magma_titan_ult.
  ///
  /// In en, this message translates to:
  /// **'Molten Fist'**
  String get dk_magma_titan_ult;

  /// No description provided for @dk_magma_titan_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A slow, unstoppable punch of liquid rock.'**
  String get dk_magma_titan_ultDesc;

  /// No description provided for @dk_magma_titan_skill.
  ///
  /// In en, this message translates to:
  /// **'Heat Wall'**
  String get dk_magma_titan_skill;

  /// No description provided for @dk_magma_titan_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'Radiates enough heat to make the whole front line flinch.'**
  String get dk_magma_titan_skillDesc;

  /// No description provided for @dk_magma_titan_pass.
  ///
  /// In en, this message translates to:
  /// **'Molten Core'**
  String get dk_magma_titan_pass;

  /// No description provided for @dk_magma_titan_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Never quite cools down enough to be safe to touch.'**
  String get dk_magma_titan_passDesc;

  /// No description provided for @dk_verdant_stag_name.
  ///
  /// In en, this message translates to:
  /// **'Verdant Stag'**
  String get dk_verdant_stag_name;

  /// No description provided for @dk_verdant_stag_flavor.
  ///
  /// In en, this message translates to:
  /// **'Wears a crown grown from a forest\'s oldest, gentlest dream.'**
  String get dk_verdant_stag_flavor;

  /// No description provided for @dk_verdant_stag_ult.
  ///
  /// In en, this message translates to:
  /// **'Antler Bloom'**
  String get dk_verdant_stag_ult;

  /// No description provided for @dk_verdant_stag_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Flowers burst from its antlers, lifting the whole team.'**
  String get dk_verdant_stag_ultDesc;

  /// No description provided for @dk_verdant_stag_skill.
  ///
  /// In en, this message translates to:
  /// **'Proud Charge'**
  String get dk_verdant_stag_skill;

  /// No description provided for @dk_verdant_stag_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A dignified, unhurried charge.'**
  String get dk_verdant_stag_skillDesc;

  /// No description provided for @dk_verdant_stag_pass.
  ///
  /// In en, this message translates to:
  /// **'Old Growth'**
  String get dk_verdant_stag_pass;

  /// No description provided for @dk_verdant_stag_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Carries the calm of a forest that\'s stood for ages.'**
  String get dk_verdant_stag_passDesc;

  /// No description provided for @dk_abyssal_kraken_name.
  ///
  /// In en, this message translates to:
  /// **'Abyssal Kraken'**
  String get dk_abyssal_kraken_name;

  /// No description provided for @dk_abyssal_kraken_flavor.
  ///
  /// In en, this message translates to:
  /// **'Rose once from a dream so deep even the tide forgot it was there.'**
  String get dk_abyssal_kraken_flavor;

  /// No description provided for @dk_abyssal_kraken_ult.
  ///
  /// In en, this message translates to:
  /// **'Deep Grasp'**
  String get dk_abyssal_kraken_ult;

  /// No description provided for @dk_abyssal_kraken_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Coils dragged up from the trench close around the target.'**
  String get dk_abyssal_kraken_ultDesc;

  /// No description provided for @dk_abyssal_kraken_skill.
  ///
  /// In en, this message translates to:
  /// **'Tentacle Lash'**
  String get dk_abyssal_kraken_skill;

  /// No description provided for @dk_abyssal_kraken_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A heavy lash from somewhere just out of sight.'**
  String get dk_abyssal_kraken_skillDesc;

  /// No description provided for @dk_abyssal_kraken_pass.
  ///
  /// In en, this message translates to:
  /// **'Trench Pressure'**
  String get dk_abyssal_kraken_pass;

  /// No description provided for @dk_abyssal_kraken_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Hits harder the deeper the fight goes.'**
  String get dk_abyssal_kraken_passDesc;

  /// No description provided for @dk_leviathan_queen_name.
  ///
  /// In en, this message translates to:
  /// **'Leviathan Queen'**
  String get dk_leviathan_queen_name;

  /// No description provided for @dk_leviathan_queen_flavor.
  ///
  /// In en, this message translates to:
  /// **'Rules every current in the dream ocean, and every current knows it.'**
  String get dk_leviathan_queen_flavor;

  /// No description provided for @dk_leviathan_queen_ult.
  ///
  /// In en, this message translates to:
  /// **'Tidal Crown'**
  String get dk_leviathan_queen_ult;

  /// No description provided for @dk_leviathan_queen_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Calls up a crown of water that crashes down on every foe.'**
  String get dk_leviathan_queen_ultDesc;

  /// No description provided for @dk_leviathan_queen_skill.
  ///
  /// In en, this message translates to:
  /// **'Regal Wave'**
  String get dk_leviathan_queen_skill;

  /// No description provided for @dk_leviathan_queen_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A slow, commanding push of current.'**
  String get dk_leviathan_queen_skillDesc;

  /// No description provided for @dk_leviathan_queen_pass.
  ///
  /// In en, this message translates to:
  /// **'Sovereign Tide'**
  String get dk_leviathan_queen_pass;

  /// No description provided for @dk_leviathan_queen_passDesc.
  ///
  /// In en, this message translates to:
  /// **'The ocean itself seems to defer to her.'**
  String get dk_leviathan_queen_passDesc;

  /// No description provided for @dk_world_tree_warden_name.
  ///
  /// In en, this message translates to:
  /// **'World Tree Warden'**
  String get dk_world_tree_warden_name;

  /// No description provided for @dk_world_tree_warden_flavor.
  ///
  /// In en, this message translates to:
  /// **'Grew from the very first seed a dreamer ever planted.'**
  String get dk_world_tree_warden_flavor;

  /// No description provided for @dk_world_tree_warden_ult.
  ///
  /// In en, this message translates to:
  /// **'Root of Ages'**
  String get dk_world_tree_warden_ult;

  /// No description provided for @dk_world_tree_warden_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Draws on a root older than the forest to mend the whole team.'**
  String get dk_world_tree_warden_ultDesc;

  /// No description provided for @dk_world_tree_warden_skill.
  ///
  /// In en, this message translates to:
  /// **'Sap Blessing'**
  String get dk_world_tree_warden_skill;

  /// No description provided for @dk_world_tree_warden_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A slow, warm trickle of restorative sap.'**
  String get dk_world_tree_warden_skillDesc;

  /// No description provided for @dk_world_tree_warden_pass.
  ///
  /// In en, this message translates to:
  /// **'Ancient Roots'**
  String get dk_world_tree_warden_pass;

  /// No description provided for @dk_world_tree_warden_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Reaches deeper than any dream has ever needed.'**
  String get dk_world_tree_warden_passDesc;

  /// No description provided for @dk_celestial_dragon_name.
  ///
  /// In en, this message translates to:
  /// **'Celestial Dragon'**
  String get dk_celestial_dragon_name;

  /// No description provided for @dk_celestial_dragon_flavor.
  ///
  /// In en, this message translates to:
  /// **'The last dream every dreamer has, if they dream long enough.'**
  String get dk_celestial_dragon_flavor;

  /// No description provided for @dk_celestial_dragon_ult.
  ///
  /// In en, this message translates to:
  /// **'Starfire Cataclysm'**
  String get dk_celestial_dragon_ult;

  /// No description provided for @dk_celestial_dragon_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Breathes out the light of a dying galaxy.'**
  String get dk_celestial_dragon_ultDesc;

  /// No description provided for @dk_celestial_dragon_skill.
  ///
  /// In en, this message translates to:
  /// **'Comet Bite'**
  String get dk_celestial_dragon_skill;

  /// No description provided for @dk_celestial_dragon_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A bite that still carries the heat of falling through the sky.'**
  String get dk_celestial_dragon_skillDesc;

  /// No description provided for @dk_celestial_dragon_pass.
  ///
  /// In en, this message translates to:
  /// **'Living Constellation'**
  String get dk_celestial_dragon_pass;

  /// No description provided for @dk_celestial_dragon_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Made of the same stuff as the stars it flies among.'**
  String get dk_celestial_dragon_passDesc;

  /// No description provided for @dk_eclipse_empress_name.
  ///
  /// In en, this message translates to:
  /// **'Eclipse Empress'**
  String get dk_eclipse_empress_name;

  /// No description provided for @dk_eclipse_empress_flavor.
  ///
  /// In en, this message translates to:
  /// **'Rules the space between one dream ending and the next beginning.'**
  String get dk_eclipse_empress_flavor;

  /// No description provided for @dk_eclipse_empress_ult.
  ///
  /// In en, this message translates to:
  /// **'Total Eclipse'**
  String get dk_eclipse_empress_ult;

  /// No description provided for @dk_eclipse_empress_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Blots out every light at once, leaving the enemy nowhere to hide.'**
  String get dk_eclipse_empress_ultDesc;

  /// No description provided for @dk_eclipse_empress_skill.
  ///
  /// In en, this message translates to:
  /// **'Crescent Edict'**
  String get dk_eclipse_empress_skill;

  /// No description provided for @dk_eclipse_empress_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A single, absolute command carved in moonlight.'**
  String get dk_eclipse_empress_skillDesc;

  /// No description provided for @dk_eclipse_empress_pass.
  ///
  /// In en, this message translates to:
  /// **'Sovereign of Shadow'**
  String get dk_eclipse_empress_pass;

  /// No description provided for @dk_eclipse_empress_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Every dark corner of the dream answers to her.'**
  String get dk_eclipse_empress_passDesc;

  /// No description provided for @dk_igo_name.
  ///
  /// In en, this message translates to:
  /// **'Igo'**
  String get dk_igo_name;

  /// No description provided for @dk_igo_flavor.
  ///
  /// In en, this message translates to:
  /// **'Not a creature of the dream at all — Igo is one of only two humans who ever stayed in Dream Haven for good, an outsider who chose to become its shield. The Dreamkeepers call him Dreamwalker, never one of their own, and he wouldn\'t have it any other way.'**
  String get dk_igo_flavor;

  /// No description provided for @dk_igo_ult.
  ///
  /// In en, this message translates to:
  /// **'Flutwand'**
  String get dk_igo_ult;

  /// No description provided for @dk_igo_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Raises a protective wall of water around the whole team.'**
  String get dk_igo_ultDesc;

  /// No description provided for @dk_igo_skill.
  ///
  /// In en, this message translates to:
  /// **'Strömungsriss'**
  String get dk_igo_skill;

  /// No description provided for @dk_igo_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A tearing current that damages and slows the enemy.'**
  String get dk_igo_skillDesc;

  /// No description provided for @dk_igo_pass.
  ///
  /// In en, this message translates to:
  /// **'Gezeitenwache'**
  String get dk_igo_pass;

  /// No description provided for @dk_igo_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Once per battle, refuses to fall and surges back at 30% HP.'**
  String get dk_igo_passDesc;

  /// No description provided for @dk_ames_name.
  ///
  /// In en, this message translates to:
  /// **'Ames'**
  String get dk_ames_name;

  /// No description provided for @dk_ames_flavor.
  ///
  /// In en, this message translates to:
  /// **'Ames walked into Dream Haven once and simply never left — the second of the two humans who made this place home for good. No creature of dream burns quite like she does; the fire is entirely, stubbornly hers.'**
  String get dk_ames_flavor;

  /// No description provided for @dk_ames_ult.
  ///
  /// In en, this message translates to:
  /// **'Glutschnitt'**
  String get dk_ames_ult;

  /// No description provided for @dk_ames_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'A single devastating cut of white-hot flame.'**
  String get dk_ames_ultDesc;

  /// No description provided for @dk_ames_skill.
  ///
  /// In en, this message translates to:
  /// **'Aschesturm'**
  String get dk_ames_skill;

  /// No description provided for @dk_ames_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A burning strike that keeps the enemy smoldering.'**
  String get dk_ames_skillDesc;

  /// No description provided for @dk_ames_pass.
  ///
  /// In en, this message translates to:
  /// **'Feuertaufe'**
  String get dk_ames_pass;

  /// No description provided for @dk_ames_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Hits harder the closer she comes to falling — up to +60% attack near death.'**
  String get dk_ames_passDesc;

  /// No description provided for @dk_olf_name.
  ///
  /// In en, this message translates to:
  /// **'Olf'**
  String get dk_olf_name;

  /// No description provided for @dk_olf_ember_flavor.
  ///
  /// In en, this message translates to:
  /// **'Every save starts with an Olf. Nobody\'s quite sure why he insists on the tunic.'**
  String get dk_olf_ember_flavor;

  /// No description provided for @dk_olf_ember_ult.
  ///
  /// In en, this message translates to:
  /// **'Wobbly Flame Lunge'**
  String get dk_olf_ember_ult;

  /// No description provided for @dk_olf_ember_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Charges in swinging his twig sword, somehow catching fire on the way.'**
  String get dk_olf_ember_ultDesc;

  /// No description provided for @dk_olf_ember_skill.
  ///
  /// In en, this message translates to:
  /// **'Hot-Headed Jab'**
  String get dk_olf_ember_skill;

  /// No description provided for @dk_olf_ember_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A jab thrown with more enthusiasm than technique.'**
  String get dk_olf_ember_skillDesc;

  /// No description provided for @dk_olf_pass.
  ///
  /// In en, this message translates to:
  /// **'Too Dumb to Be Scared'**
  String get dk_olf_pass;

  /// No description provided for @dk_olf_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t know enough to flinch.'**
  String get dk_olf_passDesc;

  /// No description provided for @dk_olf_tide_flavor.
  ///
  /// In en, this message translates to:
  /// **'Chose Tide because puddles seemed friendlier than the alternative.'**
  String get dk_olf_tide_flavor;

  /// No description provided for @dk_olf_tide_ult.
  ///
  /// In en, this message translates to:
  /// **'Bellyflop Splash'**
  String get dk_olf_tide_ult;

  /// No description provided for @dk_olf_tide_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Cannonballs in, mostly to see what happens.'**
  String get dk_olf_tide_ultDesc;

  /// No description provided for @dk_olf_tide_skill.
  ///
  /// In en, this message translates to:
  /// **'Puddle Poke'**
  String get dk_olf_tide_skill;

  /// No description provided for @dk_olf_tide_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'Pokes the nearest foe with his twig sword, dripping.'**
  String get dk_olf_tide_skillDesc;

  /// No description provided for @dk_olf_bloom_flavor.
  ///
  /// In en, this message translates to:
  /// **'His sword and his element are, technically, the same plant.'**
  String get dk_olf_bloom_flavor;

  /// No description provided for @dk_olf_bloom_ult.
  ///
  /// In en, this message translates to:
  /// **'Overgrown Tantrum'**
  String get dk_olf_bloom_ult;

  /// No description provided for @dk_olf_bloom_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Flails wildly through the underbrush he mostly grew himself.'**
  String get dk_olf_bloom_ultDesc;

  /// No description provided for @dk_olf_bloom_skill.
  ///
  /// In en, this message translates to:
  /// **'Twig Sword Thwack'**
  String get dk_olf_bloom_skill;

  /// No description provided for @dk_olf_bloom_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A thwack from the twig sword — which is, appropriately, also a twig.'**
  String get dk_olf_bloom_skillDesc;

  /// No description provided for @dk_olf_lunar_flavor.
  ///
  /// In en, this message translates to:
  /// **'Picked Lunar because he liked staying up. He is always tired.'**
  String get dk_olf_lunar_flavor;

  /// No description provided for @dk_olf_lunar_ult.
  ///
  /// In en, this message translates to:
  /// **'Moonstruck Stumble'**
  String get dk_olf_lunar_ult;

  /// No description provided for @dk_olf_lunar_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Trips over his own feet directly into the enemy, somehow on purpose.'**
  String get dk_olf_lunar_ultDesc;

  /// No description provided for @dk_olf_lunar_skill.
  ///
  /// In en, this message translates to:
  /// **'Sleepy Swipe'**
  String get dk_olf_lunar_skill;

  /// No description provided for @dk_olf_lunar_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A swipe thrown half-asleep, which is most of the time.'**
  String get dk_olf_lunar_skillDesc;

  /// No description provided for @dk_olf_astral_flavor.
  ///
  /// In en, this message translates to:
  /// **'Believes the stars picked him. The stars have not commented.'**
  String get dk_olf_astral_flavor;

  /// No description provided for @dk_olf_astral_ult.
  ///
  /// In en, this message translates to:
  /// **'Starry-Eyed Charge'**
  String get dk_olf_astral_ult;

  /// No description provided for @dk_olf_astral_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'Charges in staring at the sky instead of the enemy.'**
  String get dk_olf_astral_ultDesc;

  /// No description provided for @dk_olf_astral_skill.
  ///
  /// In en, this message translates to:
  /// **'Lucky Jab'**
  String get dk_olf_astral_skill;

  /// No description provided for @dk_olf_astral_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A jab he definitely meant to land.'**
  String get dk_olf_astral_skillDesc;

  /// No description provided for @dk_olf_ultimate_flavor.
  ///
  /// In en, this message translates to:
  /// **'The other Olf isn\'t sure how this happened either.'**
  String get dk_olf_ultimate_flavor;

  /// No description provided for @dk_olf_ultimate_ult.
  ///
  /// In en, this message translates to:
  /// **'Unlikely Hero\'s Flame Lunge'**
  String get dk_olf_ultimate_ult;

  /// No description provided for @dk_olf_ultimate_ultDesc.
  ///
  /// In en, this message translates to:
  /// **'The same wobbly lunge — somehow, this time, it actually connects.'**
  String get dk_olf_ultimate_ultDesc;

  /// No description provided for @dk_olf_ultimate_skill.
  ///
  /// In en, this message translates to:
  /// **'Suspiciously Competent Jab'**
  String get dk_olf_ultimate_skill;

  /// No description provided for @dk_olf_ultimate_skillDesc.
  ///
  /// In en, this message translates to:
  /// **'A jab that lands exactly where he meant it to. He looks as surprised as you.'**
  String get dk_olf_ultimate_skillDesc;

  /// No description provided for @dk_olf_ultimate_pass.
  ///
  /// In en, this message translates to:
  /// **'Secretly Built Different'**
  String get dk_olf_ultimate_pass;

  /// No description provided for @dk_olf_ultimate_passDesc.
  ///
  /// In en, this message translates to:
  /// **'Somehow, against all odds, this Olf turned out unfairly strong.'**
  String get dk_olf_ultimate_passDesc;

  /// No description provided for @world1Name.
  ///
  /// In en, this message translates to:
  /// **'Whispering Meadow'**
  String get world1Name;

  /// No description provided for @world1Desc.
  ///
  /// In en, this message translates to:
  /// **'A quiet, sunlit field where the first dreams take root.'**
  String get world1Desc;

  /// No description provided for @world1Boss.
  ///
  /// In en, this message translates to:
  /// **'The Unraveling'**
  String get world1Boss;

  /// No description provided for @world2Name.
  ///
  /// In en, this message translates to:
  /// **'Moonlit Forest'**
  String get world2Name;

  /// No description provided for @world2Desc.
  ///
  /// In en, this message translates to:
  /// **'A dark wood lit only by luminous, dreaming flora.'**
  String get world2Desc;

  /// No description provided for @world2Boss.
  ///
  /// In en, this message translates to:
  /// **'Nightmare Warden'**
  String get world2Boss;

  /// No description provided for @world3Name.
  ///
  /// In en, this message translates to:
  /// **'Crystal Caverns'**
  String get world3Name;

  /// No description provided for @world3Desc.
  ///
  /// In en, this message translates to:
  /// **'Frozen tides given form beneath the waking world.'**
  String get world3Desc;

  /// No description provided for @world3Boss.
  ///
  /// In en, this message translates to:
  /// **'Crystal Sentinel'**
  String get world3Boss;

  /// No description provided for @world4Name.
  ///
  /// In en, this message translates to:
  /// **'Starfall Peaks'**
  String get world4Name;

  /// No description provided for @world4Desc.
  ///
  /// In en, this message translates to:
  /// **'Floating mountains and meteor fields around an ancient star temple.'**
  String get world4Desc;

  /// No description provided for @world4Boss.
  ///
  /// In en, this message translates to:
  /// **'Aetherion, the Fallen Star'**
  String get world4Boss;

  /// No description provided for @world5Name.
  ///
  /// In en, this message translates to:
  /// **'The Forgotten Dream'**
  String get world5Name;

  /// No description provided for @world5Desc.
  ///
  /// In en, this message translates to:
  /// **'Broken buildings and floating ruins lost in a surreal, dense fog.'**
  String get world5Desc;

  /// No description provided for @world5Boss.
  ///
  /// In en, this message translates to:
  /// **'Morvane, Dream Eater'**
  String get world5Boss;

  /// No description provided for @world6Name.
  ///
  /// In en, this message translates to:
  /// **'Emberheart Wastes'**
  String get world6Name;

  /// No description provided for @world6Desc.
  ///
  /// In en, this message translates to:
  /// **'Vast volcanoes and lakes of lava beneath a sky choked with ash.'**
  String get world6Desc;

  /// No description provided for @world6Boss.
  ///
  /// In en, this message translates to:
  /// **'Ignivar, Lord of Ash'**
  String get world6Boss;

  /// No description provided for @world7Name.
  ///
  /// In en, this message translates to:
  /// **'Tidal Abyss'**
  String get world7Name;

  /// No description provided for @world7Desc.
  ///
  /// In en, this message translates to:
  /// **'Sunken temples and coral forests deep in a trench no light reaches.'**
  String get world7Desc;

  /// No description provided for @world7Boss.
  ///
  /// In en, this message translates to:
  /// **'Thalassor, Abyssal King'**
  String get world7Boss;

  /// No description provided for @world8Name.
  ///
  /// In en, this message translates to:
  /// **'Eternal Bloom'**
  String get world8Name;

  /// No description provided for @world8Desc.
  ///
  /// In en, this message translates to:
  /// **'A colossal magical jungle of root tunnels and glowing, oversized flora.'**
  String get world8Desc;

  /// No description provided for @world8Boss.
  ///
  /// In en, this message translates to:
  /// **'Verdantor, Ancient Root'**
  String get world8Boss;

  /// No description provided for @world9Name.
  ///
  /// In en, this message translates to:
  /// **'Realm of Eclipse'**
  String get world9Name;

  /// No description provided for @world9Desc.
  ///
  /// In en, this message translates to:
  /// **'A land locked in permanent eclipse beneath a vast, watching moon.'**
  String get world9Desc;

  /// No description provided for @world9Boss.
  ///
  /// In en, this message translates to:
  /// **'Noctyra, Queen of Night'**
  String get world9Boss;

  /// No description provided for @world10Name.
  ///
  /// In en, this message translates to:
  /// **'Celestial Dream'**
  String get world10Name;

  /// No description provided for @world10Desc.
  ///
  /// In en, this message translates to:
  /// **'Cosmic islands and starlit temples at the very center of the Dream realm.'**
  String get world10Desc;

  /// No description provided for @world10Boss.
  ///
  /// In en, this message translates to:
  /// **'Elyndor, The Dream Sovereign'**
  String get world10Boss;

  /// No description provided for @world11Name.
  ///
  /// In en, this message translates to:
  /// **'Echoing Meadow'**
  String get world11Name;

  /// No description provided for @world11Desc.
  ///
  /// In en, this message translates to:
  /// **'The Whispering Meadow dreams itself again — the same creatures returned, grown feral and strong.'**
  String get world11Desc;

  /// No description provided for @world11Boss.
  ///
  /// In en, this message translates to:
  /// **'The Unraveling, Awakened'**
  String get world11Boss;

  /// No description provided for @world12Name.
  ///
  /// In en, this message translates to:
  /// **'Shadowed Forest'**
  String get world12Name;

  /// No description provided for @world12Desc.
  ///
  /// In en, this message translates to:
  /// **'A darker echo of the Moonlit Forest, where old nightmares have grown teeth.'**
  String get world12Desc;

  /// No description provided for @world12Boss.
  ///
  /// In en, this message translates to:
  /// **'Nightmare Warden, Reborn'**
  String get world12Boss;

  /// No description provided for @world13Name.
  ///
  /// In en, this message translates to:
  /// **'Deep Crystal Caverns'**
  String get world13Name;

  /// No description provided for @world13Desc.
  ///
  /// In en, this message translates to:
  /// **'The Crystal Caverns run deeper now, and the cold within has sharpened.'**
  String get world13Desc;

  /// No description provided for @world13Boss.
  ///
  /// In en, this message translates to:
  /// **'Crystal Sentinel, Unbroken'**
  String get world13Boss;

  /// No description provided for @world14Name.
  ///
  /// In en, this message translates to:
  /// **'Starfall Reignited'**
  String get world14Name;

  /// No description provided for @world14Desc.
  ///
  /// In en, this message translates to:
  /// **'The meteor fields of Starfall Peaks blaze again, brighter and far more dangerous.'**
  String get world14Desc;

  /// No description provided for @world14Boss.
  ///
  /// In en, this message translates to:
  /// **'Aetherion, the Star Undying'**
  String get world14Boss;

  /// No description provided for @world15Name.
  ///
  /// In en, this message translates to:
  /// **'Dream Beyond Forgetting'**
  String get world15Name;

  /// No description provided for @world15Desc.
  ///
  /// In en, this message translates to:
  /// **'The Forgotten Dream loops back on itself, its fog thicker than before.'**
  String get world15Desc;

  /// No description provided for @world15Boss.
  ///
  /// In en, this message translates to:
  /// **'Morvane, the Endless Hunger'**
  String get world15Boss;

  /// No description provided for @world16Name.
  ///
  /// In en, this message translates to:
  /// **'Emberheart Inferno'**
  String get world16Name;

  /// No description provided for @world16Desc.
  ///
  /// In en, this message translates to:
  /// **'The wastes burn hotter still, and the ash titans return renewed.'**
  String get world16Desc;

  /// No description provided for @world16Boss.
  ///
  /// In en, this message translates to:
  /// **'Ignivar, Lord of the Deep Ash'**
  String get world16Boss;

  /// No description provided for @world17Name.
  ///
  /// In en, this message translates to:
  /// **'The Abyss Unbound'**
  String get world17Name;

  /// No description provided for @world17Desc.
  ///
  /// In en, this message translates to:
  /// **'The Tidal Abyss opens wider, and its oldest depths stir once more.'**
  String get world17Desc;

  /// No description provided for @world17Boss.
  ///
  /// In en, this message translates to:
  /// **'Thalassor, the Endless Tide'**
  String get world17Boss;

  /// No description provided for @world18Name.
  ///
  /// In en, this message translates to:
  /// **'Bloom Everlasting'**
  String get world18Name;

  /// No description provided for @world18Desc.
  ///
  /// In en, this message translates to:
  /// **'Eternal Bloom grows without end, its roots stronger than any dreamer remembers.'**
  String get world18Desc;

  /// No description provided for @world18Boss.
  ///
  /// In en, this message translates to:
  /// **'Verdantor, the Root Eternal'**
  String get world18Boss;

  /// No description provided for @world19Name.
  ///
  /// In en, this message translates to:
  /// **'Eclipse Undying'**
  String get world19Name;

  /// No description provided for @world19Desc.
  ///
  /// In en, this message translates to:
  /// **'The Realm of Eclipse falls dark again, and its court has grown far more fierce.'**
  String get world19Desc;

  /// No description provided for @world19Boss.
  ///
  /// In en, this message translates to:
  /// **'Noctyra, the Endless Night'**
  String get world19Boss;

  /// No description provided for @world20Name.
  ///
  /// In en, this message translates to:
  /// **'Celestial Requiem'**
  String get world20Name;

  /// No description provided for @world20Desc.
  ///
  /// In en, this message translates to:
  /// **'The Celestial Dream sings once more, its cosmic guardians returned in greater strength.'**
  String get world20Desc;

  /// No description provided for @world20Boss.
  ///
  /// In en, this message translates to:
  /// **'Elyndor, the Last Sovereign'**
  String get world20Boss;

  /// No description provided for @world21Name.
  ///
  /// In en, this message translates to:
  /// **'Meadow\'s Final Dream'**
  String get world21Name;

  /// No description provided for @world21Desc.
  ///
  /// In en, this message translates to:
  /// **'A third dreaming of the meadow, wilder and far harder to wake from.'**
  String get world21Desc;

  /// No description provided for @world21Boss.
  ///
  /// In en, this message translates to:
  /// **'The Unraveling, Eternal'**
  String get world21Boss;

  /// No description provided for @world22Name.
  ///
  /// In en, this message translates to:
  /// **'The Last Moonlit Forest'**
  String get world22Name;

  /// No description provided for @world22Desc.
  ///
  /// In en, this message translates to:
  /// **'The forest dreams a final time, its shadows deeper than any before.'**
  String get world22Desc;

  /// No description provided for @world22Boss.
  ///
  /// In en, this message translates to:
  /// **'Nightmare Warden, Undying'**
  String get world22Boss;

  /// No description provided for @world23Name.
  ///
  /// In en, this message translates to:
  /// **'Caverns of Endless Crystal'**
  String get world23Name;

  /// No description provided for @world23Desc.
  ///
  /// In en, this message translates to:
  /// **'The caverns crystallize further still, hardening into something almost eternal.'**
  String get world23Desc;

  /// No description provided for @world23Boss.
  ///
  /// In en, this message translates to:
  /// **'Crystal Sentinel, Absolute'**
  String get world23Boss;

  /// No description provided for @world24Name.
  ///
  /// In en, this message translates to:
  /// **'Starfall\'s End'**
  String get world24Name;

  /// No description provided for @world24Desc.
  ///
  /// In en, this message translates to:
  /// **'The star temple\'s final fall, brighter and more violent than the sky can hold.'**
  String get world24Desc;

  /// No description provided for @world24Boss.
  ///
  /// In en, this message translates to:
  /// **'Aetherion, the Fallen Sun'**
  String get world24Boss;

  /// No description provided for @world25Name.
  ///
  /// In en, this message translates to:
  /// **'The Dream That Never Wakes'**
  String get world25Name;

  /// No description provided for @world25Desc.
  ///
  /// In en, this message translates to:
  /// **'The Forgotten Dream folds in on itself one last time, and nothing wakes from it easily.'**
  String get world25Desc;

  /// No description provided for @world25Boss.
  ///
  /// In en, this message translates to:
  /// **'Morvane, the Final Hunger'**
  String get world25Boss;

  /// No description provided for @world26Name.
  ///
  /// In en, this message translates to:
  /// **'Emberheart\'s Last Fire'**
  String get world26Name;

  /// No description provided for @world26Desc.
  ///
  /// In en, this message translates to:
  /// **'The wastes\' final blaze, hot enough to reshape the ash fields entirely.'**
  String get world26Desc;

  /// No description provided for @world26Boss.
  ///
  /// In en, this message translates to:
  /// **'Ignivar, the Last Ember'**
  String get world26Boss;

  /// No description provided for @world27Name.
  ///
  /// In en, this message translates to:
  /// **'The Abyss Eternal'**
  String get world27Name;

  /// No description provided for @world27Desc.
  ///
  /// In en, this message translates to:
  /// **'The trench has no bottom left to find, and what lives there has waited a long time.'**
  String get world27Desc;

  /// No description provided for @world27Boss.
  ///
  /// In en, this message translates to:
  /// **'Thalassor, Sovereign of the Deep'**
  String get world27Boss;

  /// No description provided for @world28Name.
  ///
  /// In en, this message translates to:
  /// **'The Bloom That Never Fades'**
  String get world28Name;

  /// No description provided for @world28Desc.
  ///
  /// In en, this message translates to:
  /// **'Eternal Bloom reaches its final, endless growth.'**
  String get world28Desc;

  /// No description provided for @world28Boss.
  ///
  /// In en, this message translates to:
  /// **'Verdantor, the World Tree\'s Heart'**
  String get world28Boss;

  /// No description provided for @world29Name.
  ///
  /// In en, this message translates to:
  /// **'The Eclipse Absolute'**
  String get world29Name;

  /// No description provided for @world29Desc.
  ///
  /// In en, this message translates to:
  /// **'Darkness reaches its final form, and its ruler has never been stronger.'**
  String get world29Desc;

  /// No description provided for @world29Boss.
  ///
  /// In en, this message translates to:
  /// **'Noctyra, Empress of Shadow'**
  String get world29Boss;

  /// No description provided for @world30Name.
  ///
  /// In en, this message translates to:
  /// **'The Final Dream'**
  String get world30Name;

  /// No description provided for @world30Desc.
  ///
  /// In en, this message translates to:
  /// **'The last dream the Dreamkeepers will ever need to wake from.'**
  String get world30Desc;

  /// No description provided for @world30Boss.
  ///
  /// In en, this message translates to:
  /// **'Elyndor, the Dreaming God'**
  String get world30Boss;

  /// No description provided for @monBrambleStalker.
  ///
  /// In en, this message translates to:
  /// **'Bramble Stalker'**
  String get monBrambleStalker;

  /// No description provided for @monBrambleStalkerLore.
  ///
  /// In en, this message translates to:
  /// **'Creeps through the tall grass, thorns bristling at the first sign of a footstep.'**
  String get monBrambleStalkerLore;

  /// No description provided for @monDustWisp.
  ///
  /// In en, this message translates to:
  /// **'Dust Wisp'**
  String get monDustWisp;

  /// No description provided for @monDustWispLore.
  ///
  /// In en, this message translates to:
  /// **'A loose knot of drifting pollen and static, harmless until it swarms.'**
  String get monDustWispLore;

  /// No description provided for @monMeadowSprite.
  ///
  /// In en, this message translates to:
  /// **'Meadow Sprite'**
  String get monMeadowSprite;

  /// No description provided for @monMeadowSpriteLore.
  ///
  /// In en, this message translates to:
  /// **'Small, quick, and fiercely territorial over its patch of clover.'**
  String get monMeadowSpriteLore;

  /// No description provided for @monSunpetalGuardian.
  ///
  /// In en, this message translates to:
  /// **'Sunpetal Guardian'**
  String get monSunpetalGuardian;

  /// No description provided for @monSunpetalGuardianLore.
  ///
  /// In en, this message translates to:
  /// **'Blooms once at dawn and stands watch over the meadow until dusk.'**
  String get monSunpetalGuardianLore;

  /// No description provided for @monGloomHound.
  ///
  /// In en, this message translates to:
  /// **'Gloom Hound'**
  String get monGloomHound;

  /// No description provided for @monGloomHoundLore.
  ///
  /// In en, this message translates to:
  /// **'Hunts in the space between shadows, never quite where you last saw it.'**
  String get monGloomHoundLore;

  /// No description provided for @monHollowShade.
  ///
  /// In en, this message translates to:
  /// **'Hollow Shade'**
  String get monHollowShade;

  /// No description provided for @monHollowShadeLore.
  ///
  /// In en, this message translates to:
  /// **'Wears the shape of a forgotten dream, hollow at the center.'**
  String get monHollowShadeLore;

  /// No description provided for @monNightWisp.
  ///
  /// In en, this message translates to:
  /// **'Night Wisp'**
  String get monNightWisp;

  /// No description provided for @monNightWispLore.
  ///
  /// In en, this message translates to:
  /// **'A cold ember of moonlight that flickers whenever it\'s watched.'**
  String get monNightWispLore;

  /// No description provided for @monThornbackProwler.
  ///
  /// In en, this message translates to:
  /// **'Thornback Prowler'**
  String get monThornbackProwler;

  /// No description provided for @monThornbackProwlerLore.
  ///
  /// In en, this message translates to:
  /// **'Silent on the forest floor, its spines the only warning it gives.'**
  String get monThornbackProwlerLore;

  /// No description provided for @monRiftCrawler.
  ///
  /// In en, this message translates to:
  /// **'Rift Crawler'**
  String get monRiftCrawler;

  /// No description provided for @monRiftCrawlerLore.
  ///
  /// In en, this message translates to:
  /// **'Skitters along cracks in the cavern walls where light doesn\'t quite reach.'**
  String get monRiftCrawlerLore;

  /// No description provided for @monFrostWisp.
  ///
  /// In en, this message translates to:
  /// **'Frost Wisp'**
  String get monFrostWisp;

  /// No description provided for @monFrostWispLore.
  ///
  /// In en, this message translates to:
  /// **'Breathes out a thin, glittering cold that clings to whatever it touches.'**
  String get monFrostWispLore;

  /// No description provided for @monCavernSerpent.
  ///
  /// In en, this message translates to:
  /// **'Cavern Serpent'**
  String get monCavernSerpent;

  /// No description provided for @monCavernSerpentLore.
  ///
  /// In en, this message translates to:
  /// **'Coils through the underground tides, patient and impossibly long.'**
  String get monCavernSerpentLore;

  /// No description provided for @monCrystalWisp.
  ///
  /// In en, this message translates to:
  /// **'Crystal Wisp'**
  String get monCrystalWisp;

  /// No description provided for @monCrystalWispLore.
  ///
  /// In en, this message translates to:
  /// **'Refracts every sound in the cavern into a faint, discordant chime.'**
  String get monCrystalWispLore;

  /// No description provided for @monStarfang.
  ///
  /// In en, this message translates to:
  /// **'Starfang'**
  String get monStarfang;

  /// No description provided for @monStarfangLore.
  ///
  /// In en, this message translates to:
  /// **'A shard of an old star given teeth, prowling the meteor fields.'**
  String get monStarfangLore;

  /// No description provided for @monCometpaw.
  ///
  /// In en, this message translates to:
  /// **'Cometpaw'**
  String get monCometpaw;

  /// No description provided for @monCometpawLore.
  ///
  /// In en, this message translates to:
  /// **'Leaves a trail of dying light with every leap between floating peaks.'**
  String get monCometpawLore;

  /// No description provided for @monAstralwing.
  ///
  /// In en, this message translates to:
  /// **'Astralwing'**
  String get monAstralwing;

  /// No description provided for @monAstralwingLore.
  ///
  /// In en, this message translates to:
  /// **'Circles the star temple ruins on wings woven from old constellations.'**
  String get monAstralwingLore;

  /// No description provided for @monStardustling.
  ///
  /// In en, this message translates to:
  /// **'Stardustling'**
  String get monStardustling;

  /// No description provided for @monStardustlingLore.
  ///
  /// In en, this message translates to:
  /// **'Small and glittering, it scatters into motes when startled.'**
  String get monStardustlingLore;

  /// No description provided for @monCosmobite.
  ///
  /// In en, this message translates to:
  /// **'Cosmobite'**
  String get monCosmobite;

  /// No description provided for @monCosmobiteLore.
  ///
  /// In en, this message translates to:
  /// **'Its bite carries a cold, distant chill from beyond the sky.'**
  String get monCosmobiteLore;

  /// No description provided for @monNebulaclaw.
  ///
  /// In en, this message translates to:
  /// **'Nebulaclaw'**
  String get monNebulaclaw;

  /// No description provided for @monNebulaclawLore.
  ///
  /// In en, this message translates to:
  /// **'Claws wreathed in drifting cosmic haze, silent as vacuum.'**
  String get monNebulaclawLore;

  /// No description provided for @monStarhorn.
  ///
  /// In en, this message translates to:
  /// **'Starhorn'**
  String get monStarhorn;

  /// No description provided for @monStarhornLore.
  ///
  /// In en, this message translates to:
  /// **'Charges the crystal spires of Starfall Peaks head-first.'**
  String get monStarhornLore;

  /// No description provided for @monCometscale.
  ///
  /// In en, this message translates to:
  /// **'Cometscale'**
  String get monCometscale;

  /// No description provided for @monCometscaleLore.
  ///
  /// In en, this message translates to:
  /// **'Scales that shed light long after the creature has moved on.'**
  String get monCometscaleLore;

  /// No description provided for @monMoonfang.
  ///
  /// In en, this message translates to:
  /// **'Moonfang'**
  String get monMoonfang;

  /// No description provided for @monMoonfangLore.
  ///
  /// In en, this message translates to:
  /// **'Wanders the broken buildings, howling at a moon no one else remembers.'**
  String get monMoonfangLore;

  /// No description provided for @monDuskhorn.
  ///
  /// In en, this message translates to:
  /// **'Duskhorn'**
  String get monDuskhorn;

  /// No description provided for @monDuskhornLore.
  ///
  /// In en, this message translates to:
  /// **'Charges out of the dense fog before its silhouette ever resolves.'**
  String get monDuskhornLore;

  /// No description provided for @monNightclaw.
  ///
  /// In en, this message translates to:
  /// **'Nightclaw'**
  String get monNightclaw;

  /// No description provided for @monNightclawLore.
  ///
  /// In en, this message translates to:
  /// **'Claws that leave no mark, only the memory of having been cut.'**
  String get monNightclawLore;

  /// No description provided for @monShadowtail.
  ///
  /// In en, this message translates to:
  /// **'Shadowtail'**
  String get monShadowtail;

  /// No description provided for @monShadowtailLore.
  ///
  /// In en, this message translates to:
  /// **'Its tail lags a full second behind the rest of its body.'**
  String get monShadowtailLore;

  /// No description provided for @monEclipsepaw.
  ///
  /// In en, this message translates to:
  /// **'Eclipsepaw'**
  String get monEclipsepaw;

  /// No description provided for @monEclipsepawLore.
  ///
  /// In en, this message translates to:
  /// **'Steps between floating ruin-fragments as if they were solid ground.'**
  String get monEclipsepawLore;

  /// No description provided for @monDreamstalker.
  ///
  /// In en, this message translates to:
  /// **'Dreamstalker'**
  String get monDreamstalker;

  /// No description provided for @monDreamstalkerLore.
  ///
  /// In en, this message translates to:
  /// **'Follows dreamers through the fog long after they\'ve woken.'**
  String get monDreamstalkerLore;

  /// No description provided for @monMoonscale.
  ///
  /// In en, this message translates to:
  /// **'Moonscale'**
  String get monMoonscale;

  /// No description provided for @monMoonscaleLore.
  ///
  /// In en, this message translates to:
  /// **'Scales that dim and brighten with a moon phase all their own.'**
  String get monMoonscaleLore;

  /// No description provided for @monGloomfang.
  ///
  /// In en, this message translates to:
  /// **'Gloomfang'**
  String get monGloomfang;

  /// No description provided for @monGloomfangLore.
  ///
  /// In en, this message translates to:
  /// **'A last echo of the dream this ruined city used to be.'**
  String get monGloomfangLore;

  /// No description provided for @monCinderfang.
  ///
  /// In en, this message translates to:
  /// **'Cinderfang'**
  String get monCinderfang;

  /// No description provided for @monCinderfangLore.
  ///
  /// In en, this message translates to:
  /// **'Prowls the ash fields, jaws glowing faintly with banked heat.'**
  String get monCinderfangLore;

  /// No description provided for @monAshclaw.
  ///
  /// In en, this message translates to:
  /// **'Ashclaw'**
  String get monAshclaw;

  /// No description provided for @monAshclawLore.
  ///
  /// In en, this message translates to:
  /// **'Leaves smoldering prints across the black volcanic rock.'**
  String get monAshclawLore;

  /// No description provided for @monFlamehorn.
  ///
  /// In en, this message translates to:
  /// **'Flamehorn'**
  String get monFlamehorn;

  /// No description provided for @monFlamehornLore.
  ///
  /// In en, this message translates to:
  /// **'Charges lava lakes head-on without slowing.'**
  String get monFlamehornLore;

  /// No description provided for @monScorchling.
  ///
  /// In en, this message translates to:
  /// **'Scorchling'**
  String get monScorchling;

  /// No description provided for @monScorchlingLore.
  ///
  /// In en, this message translates to:
  /// **'Small, quick, and always a little too close to catching fire.'**
  String get monScorchlingLore;

  /// No description provided for @monEmbermaw.
  ///
  /// In en, this message translates to:
  /// **'Embermaw'**
  String get monEmbermaw;

  /// No description provided for @monEmbermawLore.
  ///
  /// In en, this message translates to:
  /// **'Its bite carries the heat of a coal that never quite cools.'**
  String get monEmbermawLore;

  /// No description provided for @monBlazetail.
  ///
  /// In en, this message translates to:
  /// **'Blazetail'**
  String get monBlazetail;

  /// No description provided for @monBlazetailLore.
  ///
  /// In en, this message translates to:
  /// **'A whip-crack tail that leaves a line of fire in the ash.'**
  String get monBlazetailLore;

  /// No description provided for @monMagmabite.
  ///
  /// In en, this message translates to:
  /// **'Magmabite'**
  String get monMagmabite;

  /// No description provided for @monMagmabiteLore.
  ///
  /// In en, this message translates to:
  /// **'Bites clean through cooled rock crust in search of the wastes\' heat.'**
  String get monMagmabiteLore;

  /// No description provided for @monCharhound.
  ///
  /// In en, this message translates to:
  /// **'Charhound'**
  String get monCharhound;

  /// No description provided for @monCharhoundLore.
  ///
  /// In en, this message translates to:
  /// **'Hunts in the choking ash clouds by scent alone.'**
  String get monCharhoundLore;

  /// No description provided for @monPyrewing.
  ///
  /// In en, this message translates to:
  /// **'Pyrewing'**
  String get monPyrewing;

  /// No description provided for @monPyrewingLore.
  ///
  /// In en, this message translates to:
  /// **'Circles the burning ruins on wings of drifting ember.'**
  String get monPyrewingLore;

  /// No description provided for @monInferclaw.
  ///
  /// In en, this message translates to:
  /// **'Inferclaw'**
  String get monInferclaw;

  /// No description provided for @monInferclawLore.
  ///
  /// In en, this message translates to:
  /// **'Claws still hot from the lava lake it just crawled out of.'**
  String get monInferclawLore;

  /// No description provided for @monCoalback.
  ///
  /// In en, this message translates to:
  /// **'Coalback'**
  String get monCoalback;

  /// No description provided for @monCoalbackLore.
  ///
  /// In en, this message translates to:
  /// **'A ridged spine that glows brighter the angrier it gets.'**
  String get monCoalbackLore;

  /// No description provided for @monSearscale.
  ///
  /// In en, this message translates to:
  /// **'Searscale'**
  String get monSearscale;

  /// No description provided for @monSearscaleLore.
  ///
  /// In en, this message translates to:
  /// **'Scales that scald anything that gets too close.'**
  String get monSearscaleLore;

  /// No description provided for @monFlarefang.
  ///
  /// In en, this message translates to:
  /// **'Flarefang'**
  String get monFlarefang;

  /// No description provided for @monFlarefangLore.
  ///
  /// In en, this message translates to:
  /// **'A sudden burst of light and teeth from the ash cloud.'**
  String get monFlarefangLore;

  /// No description provided for @monBurnpaw.
  ///
  /// In en, this message translates to:
  /// **'Burnpaw'**
  String get monBurnpaw;

  /// No description provided for @monBurnpawLore.
  ///
  /// In en, this message translates to:
  /// **'Leaves scorched pawprints wherever it walks.'**
  String get monBurnpawLore;

  /// No description provided for @monIgnisprite.
  ///
  /// In en, this message translates to:
  /// **'Ignisprite'**
  String get monIgnisprite;

  /// No description provided for @monIgnispriteLore.
  ///
  /// In en, this message translates to:
  /// **'A tiny fire-spirit born from a stray cinder off Ignivar\'s own flame.'**
  String get monIgnispriteLore;

  /// No description provided for @monAshenox.
  ///
  /// In en, this message translates to:
  /// **'Ashenox'**
  String get monAshenox;

  /// No description provided for @monAshenoxLore.
  ///
  /// In en, this message translates to:
  /// **'Wears a coat of drifting ash over skin still smoldering beneath.'**
  String get monAshenoxLore;

  /// No description provided for @monMistfin.
  ///
  /// In en, this message translates to:
  /// **'Mistfin'**
  String get monMistfin;

  /// No description provided for @monMistfinLore.
  ///
  /// In en, this message translates to:
  /// **'Slips through the coral forest wrapped in a veil of cold mist.'**
  String get monMistfinLore;

  /// No description provided for @monTideclaw.
  ///
  /// In en, this message translates to:
  /// **'Tideclaw'**
  String get monTideclaw;

  /// No description provided for @monTideclawLore.
  ///
  /// In en, this message translates to:
  /// **'Claws that pull with the force of a rising tide.'**
  String get monTideclawLore;

  /// No description provided for @monRipplefang.
  ///
  /// In en, this message translates to:
  /// **'Ripplefang'**
  String get monRipplefang;

  /// No description provided for @monRipplefangLore.
  ///
  /// In en, this message translates to:
  /// **'Every bite sends a ring of current rippling outward.'**
  String get monRipplefangLore;

  /// No description provided for @monAquabite.
  ///
  /// In en, this message translates to:
  /// **'Aquabite'**
  String get monAquabite;

  /// No description provided for @monAquabiteLore.
  ///
  /// In en, this message translates to:
  /// **'Small and quick, darting between sunken temple pillars.'**
  String get monAquabiteLore;

  /// No description provided for @monWavepup.
  ///
  /// In en, this message translates to:
  /// **'Wavepup'**
  String get monWavepup;

  /// No description provided for @monWavepupLore.
  ///
  /// In en, this message translates to:
  /// **'Young and playful, riding the abyss\'s slow deep currents.'**
  String get monWavepupLore;

  /// No description provided for @monRainscale.
  ///
  /// In en, this message translates to:
  /// **'Rainscale'**
  String get monRainscale;

  /// No description provided for @monRainscaleLore.
  ///
  /// In en, this message translates to:
  /// **'Scales that weep a constant, cold trickle of seawater.'**
  String get monRainscaleLore;

  /// No description provided for @monDeepfin.
  ///
  /// In en, this message translates to:
  /// **'Deepfin'**
  String get monDeepfin;

  /// No description provided for @monDeepfinLore.
  ///
  /// In en, this message translates to:
  /// **'Never surfaces — the trench is the only home it has known.'**
  String get monDeepfinLore;

  /// No description provided for @monBrookling.
  ///
  /// In en, this message translates to:
  /// **'Brookling'**
  String get monBrookling;

  /// No description provided for @monBrooklingLore.
  ///
  /// In en, this message translates to:
  /// **'A trickle of a creature that pools into something larger when threatened.'**
  String get monBrooklingLore;

  /// No description provided for @monFrostgill.
  ///
  /// In en, this message translates to:
  /// **'Frostgill'**
  String get monFrostgill;

  /// No description provided for @monFrostgillLore.
  ///
  /// In en, this message translates to:
  /// **'Gills that chill the water for a body length in every direction.'**
  String get monFrostgillLore;

  /// No description provided for @monStormfin.
  ///
  /// In en, this message translates to:
  /// **'Stormfin'**
  String get monStormfin;

  /// No description provided for @monStormfinLore.
  ///
  /// In en, this message translates to:
  /// **'Churns the water into a squall wherever it swims.'**
  String get monStormfinLore;

  /// No description provided for @monPearlmaw.
  ///
  /// In en, this message translates to:
  /// **'Pearlmaw'**
  String get monPearlmaw;

  /// No description provided for @monPearlmawLore.
  ///
  /// In en, this message translates to:
  /// **'Its jaw glints with a lifetime of swallowed pearls.'**
  String get monPearlmawLore;

  /// No description provided for @monSplashpaw.
  ///
  /// In en, this message translates to:
  /// **'Splashpaw'**
  String get monSplashpaw;

  /// No description provided for @monSplashpawLore.
  ///
  /// In en, this message translates to:
  /// **'Bounds along the sunken temple floor in bursts of current.'**
  String get monSplashpawLore;

  /// No description provided for @monDrownscale.
  ///
  /// In en, this message translates to:
  /// **'Drownscale'**
  String get monDrownscale;

  /// No description provided for @monDrownscaleLore.
  ///
  /// In en, this message translates to:
  /// **'Legend says it once pulled an entire temple beneath the waves.'**
  String get monDrownscaleLore;

  /// No description provided for @monRiverfang.
  ///
  /// In en, this message translates to:
  /// **'Riverfang'**
  String get monRiverfang;

  /// No description provided for @monRiverfangLore.
  ///
  /// In en, this message translates to:
  /// **'Older than the abyss itself, or so the coral forest tells it.'**
  String get monRiverfangLore;

  /// No description provided for @monMistcrawler.
  ///
  /// In en, this message translates to:
  /// **'Mistcrawler'**
  String get monMistcrawler;

  /// No description provided for @monMistcrawlerLore.
  ///
  /// In en, this message translates to:
  /// **'Crawls along the trench floor where no light has ever reached.'**
  String get monMistcrawlerLore;

  /// No description provided for @monAbyssfin.
  ///
  /// In en, this message translates to:
  /// **'Abyssfin'**
  String get monAbyssfin;

  /// No description provided for @monAbyssfinLore.
  ///
  /// In en, this message translates to:
  /// **'The deepest-dwelling of Thalassor\'s countless subjects.'**
  String get monAbyssfinLore;

  /// No description provided for @monThornpaw.
  ///
  /// In en, this message translates to:
  /// **'Thornpaw'**
  String get monThornpaw;

  /// No description provided for @monThornpawLore.
  ///
  /// In en, this message translates to:
  /// **'Pads silently through root tunnels wider than any road.'**
  String get monThornpawLore;

  /// No description provided for @monMossfang.
  ///
  /// In en, this message translates to:
  /// **'Mossfang'**
  String get monMossfang;

  /// No description provided for @monMossfangLore.
  ///
  /// In en, this message translates to:
  /// **'So thickly covered in moss it looks like part of the jungle floor.'**
  String get monMossfangLore;

  /// No description provided for @monLeafling.
  ///
  /// In en, this message translates to:
  /// **'Leafling'**
  String get monLeafling;

  /// No description provided for @monLeaflingLore.
  ///
  /// In en, this message translates to:
  /// **'Small and quick, camouflaged among the oversized canopy.'**
  String get monLeaflingLore;

  /// No description provided for @monRootclaw.
  ///
  /// In en, this message translates to:
  /// **'Rootclaw'**
  String get monRootclaw;

  /// No description provided for @monRootclawLore.
  ///
  /// In en, this message translates to:
  /// **'Claws grown from a root that never stopped reaching.'**
  String get monRootclawLore;

  /// No description provided for @monVinebeast.
  ///
  /// In en, this message translates to:
  /// **'Vinebeast'**
  String get monVinebeast;

  /// No description provided for @monVinebeastLore.
  ///
  /// In en, this message translates to:
  /// **'Trails living vine behind it as it moves through the undergrowth.'**
  String get monVinebeastLore;

  /// No description provided for @monBloomtail.
  ///
  /// In en, this message translates to:
  /// **'Bloomtail'**
  String get monBloomtail;

  /// No description provided for @monBloomtailLore.
  ///
  /// In en, this message translates to:
  /// **'A flowering tail that opens only when it senses a threat.'**
  String get monBloomtailLore;

  /// No description provided for @monPetalhorn.
  ///
  /// In en, this message translates to:
  /// **'Petalhorn'**
  String get monPetalhorn;

  /// No description provided for @monPetalhornLore.
  ///
  /// In en, this message translates to:
  /// **'Charges beneath an oversized, brilliantly colored bloom.'**
  String get monPetalhornLore;

  /// No description provided for @monBarkhide.
  ///
  /// In en, this message translates to:
  /// **'Barkhide'**
  String get monBarkhide;

  /// No description provided for @monBarkhideLore.
  ///
  /// In en, this message translates to:
  /// **'Skin as tough and gnarled as the jungle\'s oldest trees.'**
  String get monBarkhideLore;

  /// No description provided for @monSporeling.
  ///
  /// In en, this message translates to:
  /// **'Sporeling'**
  String get monSporeling;

  /// No description provided for @monSporelingLore.
  ///
  /// In en, this message translates to:
  /// **'Releases a faint cloud of spores whenever it\'s startled.'**
  String get monSporelingLore;

  /// No description provided for @monWildthorn.
  ///
  /// In en, this message translates to:
  /// **'Wildthorn'**
  String get monWildthorn;

  /// No description provided for @monWildthornLore.
  ///
  /// In en, this message translates to:
  /// **'A tangle of thorn and muscle native only to Eternal Bloom.'**
  String get monWildthornLore;

  /// No description provided for @monFernfang.
  ///
  /// In en, this message translates to:
  /// **'Fernfang'**
  String get monFernfang;

  /// No description provided for @monFernfangLore.
  ///
  /// In en, this message translates to:
  /// **'Bites through the thick canopy vines with practiced ease.'**
  String get monFernfangLore;

  /// No description provided for @monBrambleback.
  ///
  /// In en, this message translates to:
  /// **'Brambleback'**
  String get monBrambleback;

  /// No description provided for @monBramblebackLore.
  ///
  /// In en, this message translates to:
  /// **'A spine of interlocking brambles no predator wants to test.'**
  String get monBramblebackLore;

  /// No description provided for @monRootmaw.
  ///
  /// In en, this message translates to:
  /// **'Rootmaw'**
  String get monRootmaw;

  /// No description provided for @monRootmawLore.
  ///
  /// In en, this message translates to:
  /// **'Waits beneath the tunnel floor for something to walk overhead.'**
  String get monRootmawLore;

  /// No description provided for @monSeedlingBeast.
  ///
  /// In en, this message translates to:
  /// **'Seedling Beast'**
  String get monSeedlingBeast;

  /// No description provided for @monSeedlingBeastLore.
  ///
  /// In en, this message translates to:
  /// **'Young, but already larger than most fully grown Bloom creatures.'**
  String get monSeedlingBeastLore;

  /// No description provided for @monIvyclaw.
  ///
  /// In en, this message translates to:
  /// **'Ivyclaw'**
  String get monIvyclaw;

  /// No description provided for @monIvyclawLore.
  ///
  /// In en, this message translates to:
  /// **'Ivy grows over its claws between meals, then sheds when it hunts.'**
  String get monIvyclawLore;

  /// No description provided for @monThornbloom.
  ///
  /// In en, this message translates to:
  /// **'Thornbloom'**
  String get monThornbloom;

  /// No description provided for @monThornbloomLore.
  ///
  /// In en, this message translates to:
  /// **'The jungle\'s oldest bloom given claws, close kin to Verdantor.'**
  String get monThornbloomLore;

  /// No description provided for @monNightshade.
  ///
  /// In en, this message translates to:
  /// **'Nightshade'**
  String get monNightshade;

  /// No description provided for @monNightshadeLore.
  ///
  /// In en, this message translates to:
  /// **'Grows only where Noctyra\'s permanent eclipse falls darkest.'**
  String get monNightshadeLore;

  /// No description provided for @monLunawing.
  ///
  /// In en, this message translates to:
  /// **'Lunawing'**
  String get monLunawing;

  /// No description provided for @monLunawingLore.
  ///
  /// In en, this message translates to:
  /// **'Circles the watching moon on wings that never cast a shadow.'**
  String get monLunawingLore;

  /// No description provided for @monDarkpelt.
  ///
  /// In en, this message translates to:
  /// **'Darkpelt'**
  String get monDarkpelt;

  /// No description provided for @monDarkpeltLore.
  ///
  /// In en, this message translates to:
  /// **'A coat so black it swallows the eclipse\'s faint light entirely.'**
  String get monDarkpeltLore;

  /// No description provided for @monCrescentclaw.
  ///
  /// In en, this message translates to:
  /// **'Crescentclaw'**
  String get monCrescentclaw;

  /// No description provided for @monCrescentclawLore.
  ///
  /// In en, this message translates to:
  /// **'Claws curved like the sliver of moon this realm never quite sees.'**
  String get monCrescentclawLore;

  /// No description provided for @monVoidpaw.
  ///
  /// In en, this message translates to:
  /// **'Voidpaw'**
  String get monVoidpaw;

  /// No description provided for @monVoidpawLore.
  ///
  /// In en, this message translates to:
  /// **'Steps leave no print — the eclipse realm forgets it was ever there.'**
  String get monVoidpawLore;

  /// No description provided for @monDuskscale.
  ///
  /// In en, this message translates to:
  /// **'Duskscale'**
  String get monDuskscale;

  /// No description provided for @monDuskscaleLore.
  ///
  /// In en, this message translates to:
  /// **'Scales caught permanently between day and night.'**
  String get monDuskscaleLore;

  /// No description provided for @monNightmareBeast.
  ///
  /// In en, this message translates to:
  /// **'Nightmare Beast'**
  String get monNightmareBeast;

  /// No description provided for @monNightmareBeastLore.
  ///
  /// In en, this message translates to:
  /// **'One of Noctyra\'s own court, given form from the realm\'s endless dark.'**
  String get monNightmareBeastLore;

  /// No description provided for @monGalaxipaw.
  ///
  /// In en, this message translates to:
  /// **'Galaxipaw'**
  String get monGalaxipaw;

  /// No description provided for @monGalaxipawLore.
  ///
  /// In en, this message translates to:
  /// **'Each pawprint briefly holds a swirl of tiny stars.'**
  String get monGalaxipawLore;

  /// No description provided for @monMeteorfang.
  ///
  /// In en, this message translates to:
  /// **'Meteorfang'**
  String get monMeteorfang;

  /// No description provided for @monMeteorfangLore.
  ///
  /// In en, this message translates to:
  /// **'Fell to the cosmic islands still burning at the edges.'**
  String get monMeteorfangLore;

  /// No description provided for @monCelestling.
  ///
  /// In en, this message translates to:
  /// **'Celestling'**
  String get monCelestling;

  /// No description provided for @monCelestlingLore.
  ///
  /// In en, this message translates to:
  /// **'Small, but drawn from the same light as Elyndor itself.'**
  String get monCelestlingLore;

  /// No description provided for @monVoidstar.
  ///
  /// In en, this message translates to:
  /// **'Voidstar'**
  String get monVoidstar;

  /// No description provided for @monVoidstarLore.
  ///
  /// In en, this message translates to:
  /// **'A star gone dark, still pulling everything nearby toward it.'**
  String get monVoidstarLore;

  /// No description provided for @monNebulabeast.
  ///
  /// In en, this message translates to:
  /// **'Nebulabeast'**
  String get monNebulabeast;

  /// No description provided for @monNebulabeastLore.
  ///
  /// In en, this message translates to:
  /// **'Drifts between the starlit temples wrapped in cosmic haze.'**
  String get monNebulabeastLore;

  /// No description provided for @monStarlightClaw.
  ///
  /// In en, this message translates to:
  /// **'Starlight Claw'**
  String get monStarlightClaw;

  /// No description provided for @monStarlightClawLore.
  ///
  /// In en, this message translates to:
  /// **'Claws that glow with borrowed light from a galaxy long gone.'**
  String get monStarlightClawLore;

  /// No description provided for @monAstralmaw.
  ///
  /// In en, this message translates to:
  /// **'Astralmaw'**
  String get monAstralmaw;

  /// No description provided for @monAstralmawLore.
  ///
  /// In en, this message translates to:
  /// **'Guards the center of the Dream realm alongside its sovereign.'**
  String get monAstralmawLore;

  /// No description provided for @monBoss1Ult.
  ///
  /// In en, this message translates to:
  /// **'Unraveling Bloom'**
  String get monBoss1Ult;

  /// No description provided for @monBoss1UltDesc.
  ///
  /// In en, this message translates to:
  /// **'The meadow itself lashes out in bloom and fire.'**
  String get monBoss1UltDesc;

  /// No description provided for @monBoss1Lore.
  ///
  /// In en, this message translates to:
  /// **'Once the meadow\'s oldest bloom, now unraveling into thorn and flame with every dream it consumes.'**
  String get monBoss1Lore;

  /// No description provided for @monBoss2Ult.
  ///
  /// In en, this message translates to:
  /// **'Nightmare Grasp'**
  String get monBoss2Ult;

  /// No description provided for @monBoss2UltDesc.
  ///
  /// In en, this message translates to:
  /// **'Shadows claw in from every direction at once.'**
  String get monBoss2UltDesc;

  /// No description provided for @monBoss2Lore.
  ///
  /// In en, this message translates to:
  /// **'Keeper of the forest\'s deepest gloom, it grows more furious the closer it comes to falling.'**
  String get monBoss2Lore;

  /// No description provided for @monBoss3Ult.
  ///
  /// In en, this message translates to:
  /// **'Sentinel\'s Judgment'**
  String get monBoss3Ult;

  /// No description provided for @monBoss3UltDesc.
  ///
  /// In en, this message translates to:
  /// **'A crushing wave of crystallized force.'**
  String get monBoss3UltDesc;

  /// No description provided for @monBoss3Lore.
  ///
  /// In en, this message translates to:
  /// **'A living crystal grown around a dream too heavy to wake from, shielded on every side.'**
  String get monBoss3Lore;

  /// No description provided for @monBoss4Ult.
  ///
  /// In en, this message translates to:
  /// **'Starfall Cataclysm'**
  String get monBoss4Ult;

  /// No description provided for @monBoss4UltDesc.
  ///
  /// In en, this message translates to:
  /// **'A meteor storm crashes down from the shattered sky.'**
  String get monBoss4UltDesc;

  /// No description provided for @monBoss4Lore.
  ///
  /// In en, this message translates to:
  /// **'A star that fell from the heavens eons ago, still burning with the light of its old sky.'**
  String get monBoss4Lore;

  /// No description provided for @monBoss5Ult.
  ///
  /// In en, this message translates to:
  /// **'Nightmare Feast'**
  String get monBoss5Ult;

  /// No description provided for @monBoss5UltDesc.
  ///
  /// In en, this message translates to:
  /// **'Consumes the last of its prey\'s waking thoughts.'**
  String get monBoss5UltDesc;

  /// No description provided for @monBoss5Lore.
  ///
  /// In en, this message translates to:
  /// **'An ancient thing that feeds on forgotten dreams, growing fatter with every one it swallows.'**
  String get monBoss5Lore;

  /// No description provided for @monBoss6Ult.
  ///
  /// In en, this message translates to:
  /// **'Ashfall Reckoning'**
  String get monBoss6Ult;

  /// No description provided for @monBoss6UltDesc.
  ///
  /// In en, this message translates to:
  /// **'A tidal wave of molten rock and cinder.'**
  String get monBoss6UltDesc;

  /// No description provided for @monBoss6Lore.
  ///
  /// In en, this message translates to:
  /// **'A titan of fire that slept beneath the wastes for a thousand years, now awake and furious.'**
  String get monBoss6Lore;

  /// No description provided for @monBoss7Ult.
  ///
  /// In en, this message translates to:
  /// **'Abyssal Tide'**
  String get monBoss7Ult;

  /// No description provided for @monBoss7UltDesc.
  ///
  /// In en, this message translates to:
  /// **'A crushing wave from the deepest trench.'**
  String get monBoss7UltDesc;

  /// No description provided for @monBoss7Lore.
  ///
  /// In en, this message translates to:
  /// **'Ruler of the deepest trench in the Tidal Abyss, its court are things that never see the surface.'**
  String get monBoss7Lore;

  /// No description provided for @monBoss8Ult.
  ///
  /// In en, this message translates to:
  /// **'Rootbound Judgment'**
  String get monBoss8Ult;

  /// No description provided for @monBoss8UltDesc.
  ///
  /// In en, this message translates to:
  /// **'The forest floor erupts in thorn and vine.'**
  String get monBoss8UltDesc;

  /// No description provided for @monBoss8Lore.
  ///
  /// In en, this message translates to:
  /// **'A root older than the forest itself, slumbering beneath Eternal Bloom since before memory.'**
  String get monBoss8Lore;

  /// No description provided for @monBoss9Ult.
  ///
  /// In en, this message translates to:
  /// **'Eclipse Reign'**
  String get monBoss9Ult;

  /// No description provided for @monBoss9UltDesc.
  ///
  /// In en, this message translates to:
  /// **'Shadow and light strike as one.'**
  String get monBoss9UltDesc;

  /// No description provided for @monBoss9Lore.
  ///
  /// In en, this message translates to:
  /// **'Sovereign of the permanent eclipse, she rules the realm equally in shadow and stolen light.'**
  String get monBoss9Lore;

  /// No description provided for @monBoss10Ult.
  ///
  /// In en, this message translates to:
  /// **'Sovereign\'s Dominion'**
  String get monBoss10Ult;

  /// No description provided for @monBoss10UltDesc.
  ///
  /// In en, this message translates to:
  /// **'Every star in the sky answers its call at once.'**
  String get monBoss10UltDesc;

  /// No description provided for @monBoss10Lore.
  ///
  /// In en, this message translates to:
  /// **'Ruler of the highest dream, and the last, greatest guardian the Dreamkeepers must face.'**
  String get monBoss10Lore;

  /// No description provided for @shopGemsSmallName.
  ///
  /// In en, this message translates to:
  /// **'Handful of Gems'**
  String get shopGemsSmallName;

  /// No description provided for @shopGemsSmallDesc.
  ///
  /// In en, this message translates to:
  /// **'A small top-up.'**
  String get shopGemsSmallDesc;

  /// No description provided for @shopGemsMediumName.
  ///
  /// In en, this message translates to:
  /// **'Pouch of Gems'**
  String get shopGemsMediumName;

  /// No description provided for @shopGemsMediumDesc.
  ///
  /// In en, this message translates to:
  /// **'Good value for regular summoning.'**
  String get shopGemsMediumDesc;

  /// No description provided for @shopGemsLargeName.
  ///
  /// In en, this message translates to:
  /// **'Chest of Gems'**
  String get shopGemsLargeName;

  /// No description provided for @shopGemsLargeDesc.
  ///
  /// In en, this message translates to:
  /// **'Best value per gem.'**
  String get shopGemsLargeDesc;

  /// No description provided for @shopGemsMegaName.
  ///
  /// In en, this message translates to:
  /// **'Vault of Gems'**
  String get shopGemsMegaName;

  /// No description provided for @shopGemsMegaDesc.
  ///
  /// In en, this message translates to:
  /// **'For serious Dream Haven builders.'**
  String get shopGemsMegaDesc;

  /// No description provided for @shopGoldSmallName.
  ///
  /// In en, this message translates to:
  /// **'Gold Pouch'**
  String get shopGoldSmallName;

  /// No description provided for @shopGoldSmallDesc.
  ///
  /// In en, this message translates to:
  /// **'Exchange gems for gold.'**
  String get shopGoldSmallDesc;

  /// No description provided for @shopGoldLargeName.
  ///
  /// In en, this message translates to:
  /// **'Gold Chest'**
  String get shopGoldLargeName;

  /// No description provided for @shopGoldLargeDesc.
  ///
  /// In en, this message translates to:
  /// **'Better exchange rate.'**
  String get shopGoldLargeDesc;

  /// No description provided for @shopStarterPackName.
  ///
  /// In en, this message translates to:
  /// **'Dreamkeeper Starter Pack'**
  String get shopStarterPackName;

  /// No description provided for @shopStarterPackDesc.
  ///
  /// In en, this message translates to:
  /// **'One-time bonus for new Dream Haven builders: gold and gems to get your roster going.'**
  String get shopStarterPackDesc;

  /// No description provided for @shopVipPassName.
  ///
  /// In en, this message translates to:
  /// **'VIP Pass'**
  String get shopVipPassName;

  /// No description provided for @shopVipPassDesc.
  ///
  /// In en, this message translates to:
  /// **'Removes rewarded-ad prompts for good — a permanent, one-time thank-you for supporting Dream Haven.'**
  String get shopVipPassDesc;

  /// No description provided for @shopTicketSmallName.
  ///
  /// In en, this message translates to:
  /// **'Trial Ticket Pack'**
  String get shopTicketSmallName;

  /// No description provided for @shopTicketSmallDesc.
  ///
  /// In en, this message translates to:
  /// **'5 extra Endless Trial attempts, on top of your free daily tickets.'**
  String get shopTicketSmallDesc;

  /// No description provided for @shopTicketLargeName.
  ///
  /// In en, this message translates to:
  /// **'Trial Ticket Bundle'**
  String get shopTicketLargeName;

  /// No description provided for @shopTicketLargeDesc.
  ///
  /// In en, this message translates to:
  /// **'15 extra Endless Trial attempts — better value for a serious climb.'**
  String get shopTicketLargeDesc;

  /// No description provided for @shopExclusiveIgoDesc.
  ///
  /// In en, this message translates to:
  /// **'The tide\'s own guardian — permanently joins your roster at max level and max stars.'**
  String get shopExclusiveIgoDesc;

  /// No description provided for @shopExclusiveAmesDesc.
  ///
  /// In en, this message translates to:
  /// **'Ember given human form — permanently joins your roster at max level and max stars.'**
  String get shopExclusiveAmesDesc;

  /// No description provided for @achFirstSummonTitle.
  ///
  /// In en, this message translates to:
  /// **'First Summon'**
  String get achFirstSummonTitle;

  /// No description provided for @achFirstSummonDetail.
  ///
  /// In en, this message translates to:
  /// **'Summon your first Dreamkeeper.'**
  String get achFirstSummonDetail;

  /// No description provided for @achFirstLegendaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Legendary!'**
  String get achFirstLegendaryTitle;

  /// No description provided for @achFirstLegendaryDetail.
  ///
  /// In en, this message translates to:
  /// **'Recruit a Legendary Dreamkeeper.'**
  String get achFirstLegendaryDetail;

  /// No description provided for @achCollector5Title.
  ///
  /// In en, this message translates to:
  /// **'Growing Collection'**
  String get achCollector5Title;

  /// No description provided for @achCollector5Detail.
  ///
  /// In en, this message translates to:
  /// **'Own 5 different Dreamkeepers.'**
  String get achCollector5Detail;

  /// No description provided for @achCollector10Title.
  ///
  /// In en, this message translates to:
  /// **'Dream Team'**
  String get achCollector10Title;

  /// No description provided for @achCollector10Detail.
  ///
  /// In en, this message translates to:
  /// **'Own 10 different Dreamkeepers.'**
  String get achCollector10Detail;

  /// No description provided for @achFirstBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss Slayer'**
  String get achFirstBossTitle;

  /// No description provided for @achFirstBossDetail.
  ///
  /// In en, this message translates to:
  /// **'Defeat your first Boss.'**
  String get achFirstBossDetail;

  /// No description provided for @achStarUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Star Power'**
  String get achStarUpTitle;

  /// No description provided for @achStarUpDetail.
  ///
  /// In en, this message translates to:
  /// **'Fuse a Dreamkeeper to raise its stars.'**
  String get achStarUpDetail;

  /// No description provided for @achMaxStarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fully Ascended'**
  String get achMaxStarsTitle;

  /// No description provided for @achMaxStarsDetail.
  ///
  /// In en, this message translates to:
  /// **'Raise a Dreamkeeper to max stars.'**
  String get achMaxStarsDetail;

  /// No description provided for @achFullTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Squad Goals'**
  String get achFullTeamTitle;

  /// No description provided for @achFullTeamDetail.
  ///
  /// In en, this message translates to:
  /// **'Deploy a full team of {size}.'**
  String achFullTeamDetail(int size);

  /// No description provided for @achPerfectClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Untouchable'**
  String get achPerfectClearTitle;

  /// No description provided for @achPerfectClearDetail.
  ///
  /// In en, this message translates to:
  /// **'Win a battle without taking damage.'**
  String get achPerfectClearDetail;

  /// No description provided for @achAccountLevel10Title.
  ///
  /// In en, this message translates to:
  /// **'Rising Dreamer'**
  String get achAccountLevel10Title;

  /// No description provided for @achAccountLevel10Detail.
  ///
  /// In en, this message translates to:
  /// **'Reach Account Level 10.'**
  String get achAccountLevel10Detail;

  /// No description provided for @achGoldHoarderTitle.
  ///
  /// In en, this message translates to:
  /// **'Gold Hoarder'**
  String get achGoldHoarderTitle;

  /// No description provided for @achGoldHoarderDetail.
  ///
  /// In en, this message translates to:
  /// **'Hold 5,000 Gold at once.'**
  String get achGoldHoarderDetail;

  /// No description provided for @achMonsterHunterTitle.
  ///
  /// In en, this message translates to:
  /// **'Monster Hunter'**
  String get achMonsterHunterTitle;

  /// No description provided for @achMonsterHunterDetail.
  ///
  /// In en, this message translates to:
  /// **'Discover 10 different monsters.'**
  String get achMonsterHunterDetail;

  /// No description provided for @achWeekStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Dedicated Dreamer'**
  String get achWeekStreakTitle;

  /// No description provided for @achWeekStreakDetail.
  ///
  /// In en, this message translates to:
  /// **'Claim all 7 days of a Login Streak.'**
  String get achWeekStreakDetail;

  /// No description provided for @missionWinBattle.
  ///
  /// In en, this message translates to:
  /// **'Clear a Stage'**
  String get missionWinBattle;

  /// No description provided for @missionPerformSummon.
  ///
  /// In en, this message translates to:
  /// **'Summon a Dreamkeeper'**
  String get missionPerformSummon;

  /// No description provided for @missionCollectBuilding.
  ///
  /// In en, this message translates to:
  /// **'Collect from a Building'**
  String get missionCollectBuilding;

  /// No description provided for @missionUpgradeEquipment.
  ///
  /// In en, this message translates to:
  /// **'Upgrade a Piece of Gear'**
  String get missionUpgradeEquipment;

  /// No description provided for @missionSpendInShop.
  ///
  /// In en, this message translates to:
  /// **'Visit the Shop'**
  String get missionSpendInShop;

  /// No description provided for @missionDefeatBoss.
  ///
  /// In en, this message translates to:
  /// **'Defeat a Boss'**
  String get missionDefeatBoss;

  /// No description provided for @missionDeployFullTeam.
  ///
  /// In en, this message translates to:
  /// **'Field a Full Team'**
  String get missionDeployFullTeam;

  /// No description provided for @missionPremiumBonusStages.
  ///
  /// In en, this message translates to:
  /// **'Clear 3 Stages'**
  String get missionPremiumBonusStages;

  /// No description provided for @missionPremiumBonusSummons.
  ///
  /// In en, this message translates to:
  /// **'Summon 3 Dreamkeepers'**
  String get missionPremiumBonusSummons;

  /// No description provided for @weeklyClearStages.
  ///
  /// In en, this message translates to:
  /// **'Clear 15 Stages'**
  String get weeklyClearStages;

  /// No description provided for @weeklyDefeatBosses.
  ///
  /// In en, this message translates to:
  /// **'Defeat 5 Bosses'**
  String get weeklyDefeatBosses;

  /// No description provided for @weeklyPerformSummons.
  ///
  /// In en, this message translates to:
  /// **'Summon 5 Dreamkeepers'**
  String get weeklyPerformSummons;

  /// No description provided for @weeklyUpgradeEquipment.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Gear 8 Times'**
  String get weeklyUpgradeEquipment;

  /// No description provided for @weeklyVisitShop.
  ///
  /// In en, this message translates to:
  /// **'Visit the Shop 3 Times'**
  String get weeklyVisitShop;

  /// No description provided for @blShieldShatters.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s shield shatters!'**
  String blShieldShatters(String name);

  /// No description provided for @blRefusesToFall.
  ///
  /// In en, this message translates to:
  /// **'{name} refuses to fall, surging back with the tide!'**
  String blRefusesToFall(String name);

  /// No description provided for @blHits.
  ///
  /// In en, this message translates to:
  /// **'{attacker} hits {target} for {amount}.'**
  String blHits(String attacker, String target, int amount);

  /// No description provided for @blFalls.
  ///
  /// In en, this message translates to:
  /// **'{name} falls.'**
  String blFalls(String name);

  /// No description provided for @blUnleashesUltimate.
  ///
  /// In en, this message translates to:
  /// **'{name} unleashes {ultimate}!'**
  String blUnleashesUltimate(String name, String ultimate);

  /// No description provided for @blFrozenStill.
  ///
  /// In en, this message translates to:
  /// **'{name} is frozen still!'**
  String blFrozenStill(String name);

  /// No description provided for @blMoonlightHeal.
  ///
  /// In en, this message translates to:
  /// **'The team is bathed in moonlight, healing for {amount}.'**
  String blMoonlightHeal(int amount);

  /// No description provided for @blEmpowersTeam.
  ///
  /// In en, this message translates to:
  /// **'{name} empowers the whole team!'**
  String blEmpowersTeam(String name);

  /// No description provided for @blWallOfWater.
  ///
  /// In en, this message translates to:
  /// **'{name} raises a wall of water around the team!'**
  String blWallOfWater(String name);

  /// No description provided for @blUsesSkill.
  ///
  /// In en, this message translates to:
  /// **'{name} uses {skill}.'**
  String blUsesSkill(String name, String skill);

  /// No description provided for @blSoothed.
  ///
  /// In en, this message translates to:
  /// **'{name} is soothed for {amount}.'**
  String blSoothed(String name, int amount);

  /// No description provided for @blSteelsThemself.
  ///
  /// In en, this message translates to:
  /// **'{name} steels themself.'**
  String blSteelsThemself(String name);

  /// No description provided for @blCaughtInCurrent.
  ///
  /// In en, this message translates to:
  /// **'{name} is caught in the current, slowed!'**
  String blCaughtInCurrent(String name);

  /// No description provided for @blHiddenReserves.
  ///
  /// In en, this message translates to:
  /// **'{name} calls on hidden reserves, healing for {amount}!'**
  String blHiddenReserves(String name, int amount);

  /// No description provided for @blRage.
  ///
  /// In en, this message translates to:
  /// **'{name} flies into a rage, striking harder!'**
  String blRage(String name);

  /// No description provided for @blDrainsResolve.
  ///
  /// In en, this message translates to:
  /// **'{name} drains the team\'s resolve!'**
  String blDrainsResolve(String name);

  /// No description provided for @blFreshShieldRoots.
  ///
  /// In en, this message translates to:
  /// **'{name} grows a fresh shield of roots!'**
  String blFreshShieldRoots(String name);

  /// No description provided for @blLightToShadow.
  ///
  /// In en, this message translates to:
  /// **'{name} turns from light to shadow!'**
  String blLightToShadow(String name);

  /// No description provided for @blSovereignForm.
  ///
  /// In en, this message translates to:
  /// **'{name} awakens its final, sovereign form!'**
  String blSovereignForm(String name);

  /// No description provided for @blVictory.
  ///
  /// In en, this message translates to:
  /// **'Victory!'**
  String get blVictory;

  /// No description provided for @blDefeat.
  ///
  /// In en, this message translates to:
  /// **'Defeat...'**
  String get blDefeat;

  /// No description provided for @mechHealed.
  ///
  /// In en, this message translates to:
  /// **'Healed!'**
  String get mechHealed;

  /// No description provided for @mechEnraged.
  ///
  /// In en, this message translates to:
  /// **'Enraged!'**
  String get mechEnraged;

  /// No description provided for @mechShielded.
  ///
  /// In en, this message translates to:
  /// **'Shielded!'**
  String get mechShielded;

  /// No description provided for @mechDrained.
  ///
  /// In en, this message translates to:
  /// **'Drained!'**
  String get mechDrained;

  /// No description provided for @mechPhaseShift.
  ///
  /// In en, this message translates to:
  /// **'Phase Shift!'**
  String get mechPhaseShift;

  /// No description provided for @mechAwakened.
  ///
  /// In en, this message translates to:
  /// **'Awakened!'**
  String get mechAwakened;

  /// No description provided for @notifDailyMissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Missions'**
  String get notifDailyMissionsTitle;

  /// No description provided for @notifDailyMissionsBody.
  ///
  /// In en, this message translates to:
  /// **'New daily missions are ready in Dream Haven.'**
  String get notifDailyMissionsBody;

  /// No description provided for @notifLoginBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Login Bonus'**
  String get notifLoginBonusTitle;

  /// No description provided for @notifLoginBonusBody.
  ///
  /// In en, this message translates to:
  /// **'Your login streak reward is waiting in Dream Haven.'**
  String get notifLoginBonusBody;

  /// No description provided for @notifGoldFountainTitle.
  ///
  /// In en, this message translates to:
  /// **'Gold Fountain is full!'**
  String get notifGoldFountainTitle;

  /// No description provided for @notifGoldFountainBody.
  ///
  /// In en, this message translates to:
  /// **'Come collect your gold before it caps out.'**
  String get notifGoldFountainBody;

  /// No description provided for @notifTrainingGardenTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Garden is full!'**
  String get notifTrainingGardenTitle;

  /// No description provided for @notifTrainingGardenBody.
  ///
  /// In en, this message translates to:
  /// **'Your team has EXP waiting to be collected.'**
  String get notifTrainingGardenBody;

  /// No description provided for @codexUltimateDetail.
  ///
  /// In en, this message translates to:
  /// **'Charges after {attacks} attacks · ×{power} power'**
  String codexUltimateDetail(int attacks, String power);

  /// No description provided for @codexActiveSkillDetail.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s cooldown · ×{power} power'**
  String codexActiveSkillDetail(int seconds, String power);

  /// No description provided for @codexTwinBondCategory.
  ///
  /// In en, this message translates to:
  /// **'Twin Bond'**
  String get codexTwinBondCategory;

  /// No description provided for @codexTwinBondDescIgo.
  ///
  /// In en, this message translates to:
  /// **'Twin Bond: +75% ATK/DEF — only active while Ames is also in the battle formation.'**
  String get codexTwinBondDescIgo;

  /// No description provided for @codexTwinBondDescAmes.
  ///
  /// In en, this message translates to:
  /// **'Twin Bond: +75% ATK/DEF — only active while Igo is also in the battle formation.'**
  String get codexTwinBondDescAmes;

  /// No description provided for @codexTwinBondActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get codexTwinBondActive;

  /// No description provided for @codexTwinBondInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get codexTwinBondInactive;

  /// No description provided for @codexPassiveAlwaysActive.
  ///
  /// In en, this message translates to:
  /// **'Always active'**
  String get codexPassiveAlwaysActive;

  /// No description provided for @commonCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected!'**
  String get commonCollected;

  /// No description provided for @achUnlockedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get achUnlockedLabel;

  /// No description provided for @teamDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Main Team'**
  String get teamDefaultName;

  /// No description provided for @arenaRivalNightblade.
  ///
  /// In en, this message translates to:
  /// **'Team Nightblade'**
  String get arenaRivalNightblade;

  /// No description provided for @arenaRivalStarshadow.
  ///
  /// In en, this message translates to:
  /// **'Team Starshadow'**
  String get arenaRivalStarshadow;

  /// No description provided for @arenaRivalEmbermane.
  ///
  /// In en, this message translates to:
  /// **'Team Embermane'**
  String get arenaRivalEmbermane;

  /// No description provided for @arenaRivalRiverghost.
  ///
  /// In en, this message translates to:
  /// **'Team Riverghost'**
  String get arenaRivalRiverghost;

  /// No description provided for @arenaRivalRootbond.
  ///
  /// In en, this message translates to:
  /// **'Team Rootbond'**
  String get arenaRivalRootbond;

  /// No description provided for @arenaRivalCrescent.
  ///
  /// In en, this message translates to:
  /// **'Team Crescent'**
  String get arenaRivalCrescent;

  /// No description provided for @arenaRivalAshcrown.
  ///
  /// In en, this message translates to:
  /// **'Team Ashcrown'**
  String get arenaRivalAshcrown;

  /// No description provided for @arenaRivalDeepcall.
  ///
  /// In en, this message translates to:
  /// **'Team Deepcall'**
  String get arenaRivalDeepcall;

  /// No description provided for @arenaRivalLightbreaker.
  ///
  /// In en, this message translates to:
  /// **'Team Lightbreaker'**
  String get arenaRivalLightbreaker;

  /// No description provided for @arenaRivalStormeye.
  ///
  /// In en, this message translates to:
  /// **'Team Stormeye'**
  String get arenaRivalStormeye;

  /// No description provided for @rebirthTitle.
  ///
  /// In en, this message translates to:
  /// **'Rebirth'**
  String get rebirthTitle;

  /// No description provided for @rebirthBlurb.
  ///
  /// In en, this message translates to:
  /// **'Reset the Endless Trial tower to bank Soul Points, then spend them on permanent account-wide bonuses.'**
  String get rebirthBlurb;

  /// No description provided for @rebirthSoulPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Soul Points'**
  String get rebirthSoulPointsLabel;

  /// No description provided for @rebirthCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Rebirths performed: {count}'**
  String rebirthCountLabel(int count);

  /// No description provided for @rebirthButton.
  ///
  /// In en, this message translates to:
  /// **'Rebirth now'**
  String get rebirthButton;

  /// No description provided for @rebirthGainPreview.
  ///
  /// In en, this message translates to:
  /// **'This Rebirth banks +{points} Soul Points'**
  String rebirthGainPreview(int points);

  /// No description provided for @rebirthResetWarning.
  ///
  /// In en, this message translates to:
  /// **'The Trial tower resets to floor 1. Your roster, gold, gems and gear all stay.'**
  String get rebirthResetWarning;

  /// No description provided for @rebirthRequirementNotMet.
  ///
  /// In en, this message translates to:
  /// **'Reach floor {floor} of the Endless Trial to unlock Rebirth.'**
  String rebirthRequirementNotMet(int floor);

  /// No description provided for @rebirthUpgradesTitle.
  ///
  /// In en, this message translates to:
  /// **'Soul Upgrades'**
  String get rebirthUpgradesTitle;

  /// No description provided for @rebirthUpgradeRank.
  ///
  /// In en, this message translates to:
  /// **'Rank {current}/{max}'**
  String rebirthUpgradeRank(int current, int max);

  /// No description provided for @rebirthUpgradeCost.
  ///
  /// In en, this message translates to:
  /// **'{cost} SP'**
  String rebirthUpgradeCost(int cost);

  /// No description provided for @rebirthMaxed.
  ///
  /// In en, this message translates to:
  /// **'Maxed out'**
  String get rebirthMaxed;

  /// No description provided for @rebirthEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prestige for permanent bonuses'**
  String get rebirthEntrySubtitle;

  /// No description provided for @rebirthConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Perform Rebirth?'**
  String get rebirthConfirmTitle;

  /// No description provided for @soulUpgradeGoldFindName.
  ///
  /// In en, this message translates to:
  /// **'Gold Find'**
  String get soulUpgradeGoldFindName;

  /// No description provided for @soulUpgradeGoldFindDetail.
  ///
  /// In en, this message translates to:
  /// **'+4% gold from all sources per rank'**
  String get soulUpgradeGoldFindDetail;

  /// No description provided for @soulUpgradeExpBoostName.
  ///
  /// In en, this message translates to:
  /// **'EXP Boost'**
  String get soulUpgradeExpBoostName;

  /// No description provided for @soulUpgradeExpBoostDetail.
  ///
  /// In en, this message translates to:
  /// **'+4% EXP from all sources per rank'**
  String get soulUpgradeExpBoostDetail;

  /// No description provided for @soulUpgradeDamageName.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get soulUpgradeDamageName;

  /// No description provided for @soulUpgradeDamageDetail.
  ///
  /// In en, this message translates to:
  /// **'+2% team damage per rank'**
  String get soulUpgradeDamageDetail;

  /// No description provided for @soulUpgradeOfflineName.
  ///
  /// In en, this message translates to:
  /// **'Offline Rewards'**
  String get soulUpgradeOfflineName;

  /// No description provided for @soulUpgradeOfflineDetail.
  ///
  /// In en, this message translates to:
  /// **'+10% offline building rewards per rank'**
  String get soulUpgradeOfflineDetail;

  /// No description provided for @navDungeons.
  ///
  /// In en, this message translates to:
  /// **'Dungeons'**
  String get navDungeons;

  /// No description provided for @dungeonWhisperwoodName.
  ///
  /// In en, this message translates to:
  /// **'Whisperwood'**
  String get dungeonWhisperwoodName;

  /// No description provided for @dungeonWhisperwoodBlurb.
  ///
  /// In en, this message translates to:
  /// **'A hushed forest of drifting spores. A gentle first delve.'**
  String get dungeonWhisperwoodBlurb;

  /// No description provided for @dungeonGloomvaultName.
  ///
  /// In en, this message translates to:
  /// **'Gloomvault'**
  String get dungeonGloomvaultName;

  /// No description provided for @dungeonGloomvaultBlurb.
  ///
  /// In en, this message translates to:
  /// **'Moonlit halls beneath the old keep. The dark bites back.'**
  String get dungeonGloomvaultBlurb;

  /// No description provided for @dungeonStarspireName.
  ///
  /// In en, this message translates to:
  /// **'Starspire'**
  String get dungeonStarspireName;

  /// No description provided for @dungeonStarspireBlurb.
  ///
  /// In en, this message translates to:
  /// **'A tower that pierces the night sky. Only the strongest teams return.'**
  String get dungeonStarspireBlurb;

  /// No description provided for @dungeonBossName.
  ///
  /// In en, this message translates to:
  /// **'{name} Warden'**
  String dungeonBossName(String name);

  /// No description provided for @dungeonWaveEnemyName.
  ///
  /// In en, this message translates to:
  /// **'Wave {wave} Pack'**
  String dungeonWaveEnemyName(int wave);

  /// No description provided for @blNextWave.
  ///
  /// In en, this message translates to:
  /// **'A new wave closes in — {name}!'**
  String blNextWave(String name);

  /// No description provided for @dungeonBattleLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} · Wave {current}/{total}'**
  String dungeonBattleLabel(String name, int current, int total);

  /// No description provided for @dungeonKeysTitle.
  ///
  /// In en, this message translates to:
  /// **'Dungeon Keys'**
  String get dungeonKeysTitle;

  /// No description provided for @dungeonKeysBlurb.
  ///
  /// In en, this message translates to:
  /// **'One key per run. Refills daily.'**
  String get dungeonKeysBlurb;

  /// No description provided for @dungeonNoKeysTitle.
  ///
  /// In en, this message translates to:
  /// **'Out of keys'**
  String get dungeonNoKeysTitle;

  /// No description provided for @dungeonNoKeysBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all your Dungeon Keys today. Come back tomorrow.'**
  String get dungeonNoKeysBody;

  /// No description provided for @dungeonRecommendedLevel.
  ///
  /// In en, this message translates to:
  /// **'Recommended team Lv {level}'**
  String dungeonRecommendedLevel(int level);

  /// No description provided for @dungeonRewardItem.
  ///
  /// In en, this message translates to:
  /// **'Gear'**
  String get dungeonRewardItem;

  /// No description provided for @dungeonEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get dungeonEnter;

  /// No description provided for @dungeonFarmRun.
  ///
  /// In en, this message translates to:
  /// **'Farm run'**
  String get dungeonFarmRun;

  /// No description provided for @dungeonResultDefeat.
  ///
  /// In en, this message translates to:
  /// **'Defeated'**
  String get dungeonResultDefeat;

  /// No description provided for @dungeonFirstClearTitle.
  ///
  /// In en, this message translates to:
  /// **'First Clear!'**
  String get dungeonFirstClearTitle;

  /// No description provided for @dungeonFirstClearBody.
  ///
  /// In en, this message translates to:
  /// **'You cleared this dungeon for the first time — bonus reward granted.'**
  String get dungeonFirstClearBody;

  /// No description provided for @dungeonFirstClearReward.
  ///
  /// In en, this message translates to:
  /// **'FIRST-CLEAR REWARD'**
  String get dungeonFirstClearReward;

  /// No description provided for @dungeonFarmReward.
  ///
  /// In en, this message translates to:
  /// **'FARM REWARD'**
  String get dungeonFarmReward;

  /// No description provided for @dungeonBackToHub.
  ///
  /// In en, this message translates to:
  /// **'Back to Dungeons'**
  String get dungeonBackToHub;

  /// No description provided for @havenDungeonKeys.
  ///
  /// In en, this message translates to:
  /// **'{remaining}/{max} keys'**
  String havenDungeonKeys(int remaining, int max);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
