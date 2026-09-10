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
}
