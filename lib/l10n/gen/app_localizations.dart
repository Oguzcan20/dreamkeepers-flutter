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
