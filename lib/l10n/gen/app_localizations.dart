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
