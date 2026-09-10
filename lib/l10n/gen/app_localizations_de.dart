// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonRestartNow => 'Jetzt neu starten';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonClose => 'Schließen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsBack => 'Zurück';

  @override
  String get settingsSoundEffects => 'Soundeffekte';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsNotificationsBlurb =>
      'Werde benachrichtigt, wenn der Goldbrunnen oder der Trainingsgarten voll ist, bei täglichen Missionen und wenn dein Login-Bonus bereitsteht.';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsAccountBlurb =>
      'Melde dich an, damit dein Fortschritt geräteübergreifend erkennbar bleibt.';

  @override
  String get settingsSignInWithGoogle => 'Mit Google anmelden';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsSignedIn => 'Angemeldet';

  @override
  String get settingsDefaultPlayerName => 'Traumhüter';

  @override
  String get settingsPlayGames => 'Play Games';

  @override
  String get settingsNotSignedIn => 'Nicht angemeldet';

  @override
  String get settingsLeaderboard => 'Bestenliste';

  @override
  String get settingsSignIn => 'Anmelden';

  @override
  String get settingsYourData => 'Deine Daten';

  @override
  String get settingsYourDataBlurb =>
      'Der Fortschritt wird auf diesem Gerät gespeichert und, sofern ein Cloud-Konto verfügbar ist, privat mit deinen anderen Geräten synchronisiert. Dreamkeepers sammelt oder teilt keine personenbezogenen Daten.';

  @override
  String get settingsResetProgress => 'Fortschritt zurücksetzen';

  @override
  String get settingsResetTitle => 'Gesamten Fortschritt zurücksetzen?';

  @override
  String get settingsResetBody =>
      'Dadurch werden deine Traumhüter, dein Gold, deine Edelsteine und dein Kampagnenfortschritt gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String settingsVersionLine(String version) {
    return 'Dreamkeepers · v$version';
  }

  @override
  String get settingsLanguageRestartTitle => 'Neustart erforderlich';

  @override
  String get settingsLanguageRestartBody =>
      'Das Spiel muss neu starten, um die neue Sprache zu übernehmen. Es wird jetzt geschlossen — öffne es erneut, um weiterzuspielen.';
}
