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

  @override
  String get mainMenuTagline =>
      'Ein gemütliches Fantasy-Rollenspiel für ein paar ruhige Minuten zwischendurch.';

  @override
  String get mainMenuPlay => 'Spielen';

  @override
  String get mainMenuSettings => 'Einstellungen';

  @override
  String get loadingHeader => 'LÄDT …';

  @override
  String get loadingTipLabel => 'TIPP: ';

  @override
  String get loadingAdTitle => 'Anzeige wird geladen …';

  @override
  String get loadingTip1 =>
      'Kombiniere Elemente für einen Vorteil gegen starke Gegner.';

  @override
  String get loadingTip2 =>
      'Verschmilz doppelte Traumhüter, um ihren Sternerang zu erhöhen.';

  @override
  String get loadingTip3 =>
      'Verbessere Ausrüstung im Inventar, um die Werte deines Teams zu steigern.';

  @override
  String get loadingTip4 =>
      'Hol dir Offline-Belohnungen aus dem Goldbrunnen und dem Trainingsgarten.';

  @override
  String get loadingTip5 =>
      'Schließe tägliche Missionen für zusätzliches Gold und Edelsteine ab.';

  @override
  String get loadingTip6 =>
      'Setze bis zu fünf Traumhüter pro Team ein — achte auf deine Elemente.';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingLetsGo => 'Los geht\'s!';

  @override
  String get onboardingSummoningTitle => 'Beschwörungsschrein';

  @override
  String get onboardingSummoningBody =>
      'Gib Traum-Edelsteine im Beschwörungsschrein aus, um neue Traumhüter zu rekrutieren. Die Chancen werden offen angezeigt — keine versteckten Mechaniken. Eine 10x-Beschwörung enthält immer einen Bonuszug gratis.';

  @override
  String get onboardingFusionTitle => 'Verschmelzung';

  @override
  String get onboardingFusionBody =>
      'Einen Traumhüter zu beschwören, den du schon besitzt, ist nicht verschwendet — das Duplikat wandert direkt in dein Inventar. Verschmilz Duplikate dort mit diesem Traumhüter, um seine Sternestufe zu erhöhen und ihn stärker zu machen.';

  @override
  String get onboardingTeamTitle => 'Team';

  @override
  String get onboardingTeamBody =>
      'Stelle im Inventar ein Team aus deinem Kader zusammen. Nur eingesetzte Traumhüter kämpfen im Kampf und trainieren im Trainingsgarten — halte dein bestes Team bereit.';

  @override
  String get onboardingCampaignTitle => 'Kampagne';

  @override
  String get onboardingCampaignBody =>
      'Schick dein Team in die Kampagne, um Abschnitte zu bestehen, Gold und EP zu verdienen und Bosse zu besiegen. Boss-Siege rekrutieren deinen nächsten Traumhüter automatisch.';

  @override
  String get starterElementTitle => 'Wähle Olfs Element';

  @override
  String get starterElementSubtitle =>
      'Das bleibt für immer bei ihm — nimm, was sich richtig anfühlt.';

  @override
  String get navDreamHaven => 'Traumhafen';

  @override
  String get achievementUnlockedBanner => 'ERFOLG FREIGESCHALTET';

  @override
  String get achievementsSheetTitle => 'Erfolge';

  @override
  String achievementsUnlockedCount(int unlocked, int total) {
    return '$unlocked/$total freigeschaltet';
  }

  @override
  String get cardTwinBond => 'Zwillingsbund';
}
