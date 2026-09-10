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
  String get commonCollect => 'Abholen';

  @override
  String get commonClaim => 'Einlösen';

  @override
  String get commonClaimed => 'Eingelöst';

  @override
  String get commonContinue => 'Weiter';

  @override
  String get commonBack => 'Zurück';

  @override
  String commonAmountGold(int count) {
    return '$count Gold';
  }

  @override
  String commonAmountGems(int count) {
    return '$count Edelsteine';
  }

  @override
  String get commonCollectedExclaim => 'Abgeholt!';

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

  @override
  String get navShop => 'Shop';

  @override
  String get navDailyMissions => 'Tägliche Missionen';

  @override
  String get navDailyLoginBonus => 'Tägliche Login-Belohnung';

  @override
  String get navSummoningShrine => 'Beschwörungsschrein';

  @override
  String get navTrainingGarden => 'Trainingsgarten';

  @override
  String get navGoldFountain => 'Goldbrunnen';

  @override
  String get navObservatory => 'Traum-Observatorium';

  @override
  String get navEndlessTrial => 'Die Endlose Prüfung';

  @override
  String get navWatchAd => 'Anzeige ansehen';

  @override
  String get navInventory => 'Inventar';

  @override
  String get navCampaign => 'Kampagne';

  @override
  String get resGold => 'Gold';

  @override
  String get resDreamGems => 'Traum-Edelsteine';

  @override
  String get resEnergy => 'Energie';

  @override
  String havenPlayerLevel(int level) {
    return 'Spieler Lv $level';
  }

  @override
  String get havenYourTeam => 'Dein Team';

  @override
  String get havenNoTeam =>
      'Noch keine Traumhüter eingesetzt. Tippen, um dein Team aufzustellen.';

  @override
  String havenTeamPower(int power) {
    return 'Teamstärke $power';
  }

  @override
  String get havenSeasonPass => 'Season Pass';

  @override
  String havenSeasonPassSemantic(int tier, int total) {
    return 'Season Pass, Stufe $tier von $total';
  }

  @override
  String havenTier(int tier, int total) {
    return 'Stufe $tier/$total';
  }

  @override
  String havenGemsAmount(int count) {
    return '$count Edelsteine';
  }

  @override
  String havenExpReady(int amount) {
    return '+$amount EP bereit';
  }

  @override
  String havenGoldReady(int amount) {
    return '+$amount Gold bereit';
  }

  @override
  String get havenTapToCollect => 'Zum Abholen tippen';

  @override
  String havenDiscovered(int count, int total) {
    return '$count/$total entdeckt';
  }

  @override
  String havenFloor(int floor, int max) {
    return 'Etage $floor/$max';
  }

  @override
  String havenWatchAdStatus(int gold, int gems, int used, int max) {
    return '+$gold Gold, +$gems Edelsteine · $used/$max heute';
  }

  @override
  String havenPlusGold(int amount) {
    return '+$amount Gold';
  }

  @override
  String havenPlusExp(int amount) {
    return '+$amount EP';
  }

  @override
  String goldFountainBlurb(int rate) {
    return 'Erzeugt $rate Gold/Min, während du weg bist · Obergrenze nach 8 Std.';
  }

  @override
  String get goldFountainReady => 'Gold zum Abholen bereit';

  @override
  String trainingGardenBlurb(int rate) {
    return 'Gewährt deinem eingesetzten Team $rate EP/Min, während du weg bist · Obergrenze nach 8 Std.';
  }

  @override
  String trainingGardenPendingExp(int amount) {
    return '+$amount EP';
  }

  @override
  String get trainingGardenNoTeam =>
      'Setze ein Team ein, damit der Garten arbeitet.';

  @override
  String get trainingGardenReady => 'Bereit für dein eingesetztes Team';

  @override
  String get trainingGardenLevelUp => 'Stufenaufstieg!';

  @override
  String trainingGardenLevelChange(int from, int to) {
    return 'Lv $from → Lv $to';
  }

  @override
  String loginDayOfCycle(int day, int total) {
    return 'Tag $day von $total';
  }

  @override
  String loginClaimedTomorrow(int day) {
    return 'Eingelöst — Tag $day morgen';
  }

  @override
  String get loginSeeYouTomorrow => 'Bis morgen';

  @override
  String loginDayLabel(int day) {
    return 'Tag $day';
  }

  @override
  String get rewardedAdClaimed => 'Belohnung eingelöst!';

  @override
  String get rewardedAdNice => 'Super!';

  @override
  String get rewardedAdUnavailable => 'Anzeige nicht verfügbar';

  @override
  String get missionsTitle => 'Missionen';

  @override
  String get missionsResetBlurb =>
      'Täglich setzt jeden Tag zurück · Wöchentlich jeden Montag';

  @override
  String get missionsBattlePassBonus => 'Season-Pass-Bonus';

  @override
  String get missionsWeeklyChallenge => 'Wöchentliche Herausforderung';

  @override
  String get missionsWeeklyLocked =>
      'Schalte Season Pass Premium frei, um schwerere wöchentliche Herausforderungen mit größeren Belohnungen zu erhalten.';

  @override
  String get missionsRequiresPremium => 'Erfordert Premium';

  @override
  String get shopBadgePopular => 'Beliebt';

  @override
  String get shopBadgeBestValue => 'Bestes Angebot';

  @override
  String get shopPurchased => 'Gekauft!';

  @override
  String get shopAdded => 'Hinzugefügt!';

  @override
  String get shopTrialTickets => 'Prüfungs-Tickets';

  @override
  String get shopGoldExchange => 'Goldtausch';

  @override
  String shopTicketsGranted(int count) {
    return '+$count Tickets';
  }
}
