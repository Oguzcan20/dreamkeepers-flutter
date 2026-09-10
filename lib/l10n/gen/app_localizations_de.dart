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
  String get commonOk => 'OK';

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
  String get commonSell => 'Verkaufen';

  @override
  String get commonAll => 'Alle';

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

  @override
  String campaignStageLabel(int stage) {
    return 'Abschnitt $stage';
  }

  @override
  String campaignBossStageLabel(int stage) {
    return 'Boss-Abschnitt $stage';
  }

  @override
  String get campaignStageLockedSuffix => ', gesperrt';

  @override
  String get campaignStageClearedSuffix => ', abgeschlossen';

  @override
  String campaignStageClearedTitle(int stage) {
    return 'Abschnitt $stage — bereits abgeschlossen';
  }

  @override
  String get campaignStageClearedBody =>
      'Wiederhole den Kampf für dieselben Belohnungen oder springe direkt zur Auszahlung.';

  @override
  String campaignFightCost(int cost) {
    return 'Kämpfen ($cost Energie)';
  }

  @override
  String campaignSweepCost(int cost) {
    return 'Sofort räumen ($cost Energie)';
  }

  @override
  String get campaignNotEnoughEnergyTitle => 'Nicht genug Energie';

  @override
  String campaignNotEnoughEnergyBody(int cost, int current, int max) {
    return 'Dieser Abschnitt kostet $cost Energie. Du hast $current/$max.';
  }

  @override
  String campaignRefillForGems(int count) {
    return 'Für $count Edelsteine auffüllen';
  }

  @override
  String get campaignComplete =>
      'Du hast jeden bekannten Traum bezwungen. Weitere Welten folgen bald.';

  @override
  String campaignEnergySemantic(int current, int max) {
    return 'Energie $current von $max';
  }

  @override
  String campaignStageSwept(int stage) {
    return 'Abschnitt $stage geräumt';
  }

  @override
  String campaignSweepPayout(int gold, int exp) {
    return '+$gold Gold · +$exp EP';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String profilePlayerLevel(int level) {
    return 'Spielerlevel $level';
  }

  @override
  String get profileMaxLevel => 'Maximallevel erreicht';

  @override
  String profileExpToNext(int current, int next) {
    return '$current / $next EP bis zum nächsten Level';
  }

  @override
  String get profileJourneySoFar => 'Bisherige Reise';

  @override
  String get profileStatDreamkeepers => 'Traumhüter';

  @override
  String get profileStatStagesCleared => 'Abschnitte geschafft';

  @override
  String get navCodex => 'Traumhüter-Kodex';

  @override
  String get invTabDreamkeepers => 'Traumhüter';

  @override
  String get invTabItems => 'Gegenstände';

  @override
  String get invSortLevel => 'Level';

  @override
  String get invSortRarity => 'Seltenheit';

  @override
  String get invSortStars => 'Sterne';

  @override
  String get invSortAttack => 'Angriff';

  @override
  String get invSortTooltip => 'Traumhüter sortieren';

  @override
  String get invTapHint =>
      'Tippe einen Traumhüter an, um Werte und Verschmelzung zu sehen.';

  @override
  String invDeployedCount(int count, int max) {
    return '$count/$max eingesetzt';
  }

  @override
  String invSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String invSellGainGoldGems(int gold, int gems) {
    return '+$gold Gold · +$gems Edelsteine';
  }

  @override
  String invSellForGoldGems(int gold, int gems) {
    return 'Für $gold Gold + $gems Edelsteine verkaufen';
  }

  @override
  String invSellForGold(int gold) {
    return 'Für $gold Gold verkaufen';
  }

  @override
  String invSellConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Traumhüter verkaufen?',
      one: '1 Traumhüter verkaufen?',
    );
    return '$_temp0';
  }

  @override
  String get invSellConfirmBody =>
      'Das lässt sich nicht rückgängig machen. Ausgerüstete Gegenstände werden abgelegt, nicht verkauft.';

  @override
  String get invCreateTeam => 'Team erstellen';

  @override
  String get invNoItemsTitle => 'Noch keine Gegenstände';

  @override
  String get invNoItemsBody =>
      'Schließe einen Kampagnenabschnitt ab, um Ausrüstung für deine Traumhüter zu finden.';

  @override
  String get invGoToCampaign => 'Zur Kampagne';

  @override
  String invItemSubtitle(String rarity, int level, int max) {
    return '$rarity · Lv $level/$max';
  }

  @override
  String invItemWornBy(String wearer) {
    return 'Getragen von $wearer';
  }

  @override
  String get invItemInStorage => 'Im Lager';

  @override
  String invItemSemanticWorn(
      String name, String rarity, int level, String wearer) {
    return '$name, $rarity, Lv $level, getragen von $wearer';
  }

  @override
  String invItemSemanticStored(String name, String rarity, int level) {
    return '$name, $rarity, Lv $level, im Lager';
  }

  @override
  String get summonNew => 'Neu!';

  @override
  String get summonDuplicate => 'Duplikat';

  @override
  String summonEquipSubtitle(String slot, int level) {
    return '$slot · Lv $level';
  }

  @override
  String summonMultiTitle(int count) {
    return 'Beschwörung x$count';
  }

  @override
  String summonMultiBody(int cost, int count) {
    return '$cost Edelsteine für $count Züge ausgeben?';
  }

  @override
  String get summonAction => 'Beschwören';

  @override
  String get summonNotEnoughGemsTitle => 'Nicht genug Edelsteine';

  @override
  String summonNotEnoughGemsBody(int cost, int have) {
    return 'Das kostet $cost Edelsteine. Du hast $have.';
  }

  @override
  String get summonGetGems => 'Edelsteine holen';

  @override
  String get summonModeDreamkeeper => 'Traumhüter';

  @override
  String get summonModeEquipment => 'Ausrüstung';

  @override
  String get summonBlurbDreamkeeper =>
      'Beschwöre einen Traumhüter aus den tiefen Wassern des Schreins.';

  @override
  String get summonBlurbEquipment =>
      'Beschwöre ein Ausrüstungsstück, geschmiedet für deinen aktuellen Abschnitt.';

  @override
  String summonSingleButton(int cost) {
    return 'Beschwören ($cost Edelsteine)';
  }

  @override
  String summonMultiButton(int count, int cost) {
    return 'x$count ($cost Edelsteine)';
  }

  @override
  String summonInsufficientHint(int needed, int have) {
    return 'Nicht genug Edelsteine für einen Zug ($needed nötig). Du hast $have.';
  }

  @override
  String get summonOddsTitle => 'Chancen';

  @override
  String get summonEpicPity => 'Episch+ Garantie';

  @override
  String get summonLegendaryPity => 'Legendär+ Garantie';

  @override
  String get summonTapToOpen => 'Zum Öffnen tippen';

  @override
  String get summonResultsTitle => 'Beschwörungsergebnisse';

  @override
  String get summonTapToRevealAll => 'Tippen, um alle aufzudecken';

  @override
  String get bestiaryNotEncountered => 'Noch nicht angetroffen.';

  @override
  String codexCollected(int count, int total) {
    return '$count/$total gesammelt';
  }

  @override
  String get codexFilterByRole => 'Nach Rolle filtern';

  @override
  String get codexAllRoles => 'Alle Rollen';

  @override
  String get codexNotOwned => 'Nicht im Besitz';

  @override
  String get codexDetailClose => 'Schließen';

  @override
  String get codexInYourCollection => 'In deiner Sammlung';

  @override
  String codexOwnedTimes(int count) {
    return 'Im Besitz ×$count';
  }

  @override
  String get codexNotOwnedYet => 'Noch nicht im Besitz';

  @override
  String get codexNotOwnedHint =>
      'Finde diesen Traumhüter im Beschwörungsschrein.';

  @override
  String get codexHowItFights => 'Kampfweise';

  @override
  String get codexBaseStats => 'Grundwerte';

  @override
  String get codexAbilityUltimate => 'Ultimativ';

  @override
  String get codexAbilityActiveSkill => 'Aktive Fähigkeit';

  @override
  String get codexAbilityPassive => 'Passiv';

  @override
  String get codexElementMatchups => 'Elementarvergleich';

  @override
  String get codexMatchupBalanced =>
      'Ausgeglichen gegen jedes Element — weder Bonus noch Malus.';

  @override
  String get codexStrongAgainst => 'Stark gegen';

  @override
  String get codexWeakAgainst => 'Schwach gegen';

  @override
  String get codexRoleMechanicTank =>
      'Hohe HP und Verteidigung — zum Standhalten gebaut. Ultimativ und aktive Fähigkeit treffen den Gegner direkt.';

  @override
  String get codexRoleMechanicDamage =>
      'Hoher Angriff. Ultimativ und aktive Fähigkeit treffen den Gegner für zusätzlichen Schaden.';

  @override
  String get codexRoleMechanicHealer =>
      'Das Ultimativ heilt das ganze Team auf einmal; die aktive Fähigkeit heilt den Verbündeten mit den wenigsten HP.';

  @override
  String get codexRoleMechanicSupport =>
      'Das Ultimativ erhöht den Angriff des ganzen Teams für den Rest des Kampfes; die aktive Fähigkeit erhöht den eigenen Angriff.';

  @override
  String get codexRoleMechanicControl =>
      'Das Ultimativ trifft den Gegner und betäubt ihn kurz; die aktive Fähigkeit ist ein schneller Schlag.';

  @override
  String get codexRoleMechanicGuardian =>
      'Das Ultimativ schützt das ganze Team mit einem Schild; die aktive Fähigkeit trifft den Gegner und verlangsamt ihn.';

  @override
  String get brDefeatTitle => 'Niederlage …';

  @override
  String get brBossDefeatedTitle => 'Boss besiegt!';

  @override
  String get brVictoryTitle => 'Sieg!';

  @override
  String get brDefeatBody =>
      'Das Team wurde überwältigt. Steigere Level oder Ausrüstung, bevor du es erneut versuchst.';

  @override
  String brPerfectClear(int gold) {
    return 'Perfekter Sieg! +$gold Bonus-Gold';
  }

  @override
  String get brRewards => 'Belohnungen';

  @override
  String get brExp => 'EP';

  @override
  String brWorldCompleted(int number) {
    return 'Welt $number abgeschlossen!';
  }

  @override
  String brGemsGained(int count) {
    return '+$count Traum-Edelsteine';
  }

  @override
  String brAccountLevel(int from, int to) {
    return 'Kontostufe $from → $to';
  }

  @override
  String get brLevelUpTitle => 'Stufenaufstieg!';

  @override
  String brLevelChange(int from, int to) {
    return 'Lv.$from → $to';
  }

  @override
  String get brNewRecruit => 'Neuzugang!';

  @override
  String get brNextBattle => 'Nächster Kampf';

  @override
  String get brReturnToDreamHaven => 'Zurück zum Traumhafen';

  @override
  String bpTierProgress(int tier, int total) {
    return 'Stufe $tier/$total';
  }

  @override
  String get bpSeasonXp => 'Season-EP';

  @override
  String get bpMaxTierReached => 'Höchste Stufe erreicht';

  @override
  String bpXpProgress(int current, int needed) {
    return '$current/$needed EP';
  }

  @override
  String get bpXpBlurb =>
      'Gewinne Kämpfe, um Season-EP zu verdienen — Bosse geben mehr. Jede Stufe schaltet automatisch eine kostenlose Belohnung frei; tippe auf den Pfeil einer Stufe, um sie abzuholen, oder hole die passende Premium-Belohnung ab, sobald sie freigeschaltet ist.';

  @override
  String get bpUnlockPremium => 'Premium-Pfad freischalten';

  @override
  String get bpPremiumBlurb =>
      'Hole die Gold- und Edelstein-Belohnungen jeder bereits erreichten Stufe ab — kein Zeitdruck, sie bleiben für den Rest der Season freigeschaltet.';

  @override
  String get bpClaimTierReward => 'Stufenbelohnung abholen';

  @override
  String get arenaNoTeamTitle => 'Kein Team aufgestellt';

  @override
  String get arenaNoTeamBody =>
      'Stelle ein Team auf, bevor du Die Endlose Prüfung betrittst.';

  @override
  String get arenaNoTicketsTitle => 'Keine Prüfungs-Tickets übrig';

  @override
  String get arenaNoTicketsBody =>
      'Du hast heute alle Versuche der Endlosen Prüfung aufgebraucht. Komm morgen wieder!';

  @override
  String arenaFloorProgress(int current, int total) {
    return 'Etage $current/$total';
  }

  @override
  String arenaTicketsSemantic(int count, int max) {
    return '$count von $max Prüfungs-Tickets heute übrig';
  }

  @override
  String arenaBonusTickets(int count) {
    return '+$count Bonus';
  }

  @override
  String get arenaTowerCleared => 'Turm bezwungen!';

  @override
  String get arenaTowerClearedBody =>
      'Jede Etage darunter bleibt zum Ausrüstungsfarmen offen.';

  @override
  String arenaFloorsRange(int from, int to) {
    return 'Etagen $from–$to';
  }

  @override
  String arenaFloorLabel(int floor) {
    return 'Etage $floor';
  }

  @override
  String arenaOpponentLine(int level, String name) {
    return 'Lv $level · $name';
  }

  @override
  String get arenaFarm => 'Farmen';

  @override
  String get arenaFight => 'Kämpfen';

  @override
  String get arenaGearChance => 'Ausrüstungschance';

  @override
  String get arenaResultDefeat => 'Niederlage';

  @override
  String get arenaTowerClearedResultBody =>
      'Du hast alle 100 Etagen der Endlosen Prüfung bezwungen.';

  @override
  String get arenaMilestoneReward => 'Meilenstein-Belohnung!';

  @override
  String get arenaMilestoneBody =>
      'Eine garantierte legendäre Belohnung für das Erreichen dieser Etage.';

  @override
  String get arenaNewTier => 'Neue Liga!';

  @override
  String get arenaFirstClearReward => 'Erstabschluss-Belohnung';

  @override
  String get arenaStandardReward => 'Standard-Belohnung';

  @override
  String get arenaFightAgain => 'Erneut kämpfen';

  @override
  String get eqDreamkeeperFallback => 'Traumhüter';

  @override
  String get eqItemFallback => 'Gegenstand';

  @override
  String eqLevelLabel(int level) {
    return 'Level $level';
  }

  @override
  String get eqBench => 'Auf die Bank';

  @override
  String get eqDeploy => 'Einsetzen';

  @override
  String eqUltimateDetail(int attacks) {
    return 'Ultimativ · lädt nach $attacks Angriffen';
  }

  @override
  String eqActiveSkillDetail(int seconds) {
    return 'Aktive Fähigkeit · $seconds s Abklingzeit';
  }

  @override
  String get eqSkillPassive => 'Passiv';

  @override
  String get eqAutoEquip => 'Beste Ausrüstung anlegen';

  @override
  String get eqMaxStars => 'Maximale Sterne erreicht';

  @override
  String eqFusionProgress(int banked, int cost, int available) {
    return '$banked/$cost angespart · $available verfügbar';
  }

  @override
  String eqFuseToStar(int stars) {
    return 'Verschmelzen zu ★$stars';
  }

  @override
  String get eqUnequip => 'Ablegen';

  @override
  String get eqNoItems => 'Keine Gegenstände im Inventar';

  @override
  String eqItemWithRarity(String name, String rarity) {
    return '$name ($rarity)';
  }

  @override
  String get eqEmpty => 'Leer';

  @override
  String get eqChange => 'Ändern';

  @override
  String get eqMaxLevel => 'Maximale Stufe erreicht';

  @override
  String get eqUpgrade => 'Verbessern';

  @override
  String get fusionTitle => 'Verschmelzen';

  @override
  String fusionNoDuplicatesDreamkeeper(String name) {
    return 'Noch keine Duplikate von $name. Beschwöre mehr, um Verschmelzungsmaterial zu sammeln.';
  }

  @override
  String fusionNoDuplicatesItem(String name) {
    return 'Noch keine Duplikate von $name. Schließe mehr Abschnitte ab, um Verschmelzungsmaterial zu finden.';
  }

  @override
  String get fusionSelectDuplicates => 'Duplikate zum Verschmelzen auswählen';

  @override
  String fusionProgressTowardStar(int banked, int cost) {
    return '$banked/$cost zum nächsten Stern';
  }

  @override
  String fusionToStarGrants(int stars) {
    return 'Verschmelzen zu ★$stars bringt';
  }

  @override
  String get fusionStarUp => 'Sternaufstieg!';

  @override
  String get fusionFused => 'Verschmolzen!';

  @override
  String get fusionAction => 'Verschmelzen';

  @override
  String fusionAtMaxStars(String name) {
    return '$name hat die maximale Sternzahl';
  }

  @override
  String get fusionStarUpShowcase => 'STERNAUFSTIEG!';

  @override
  String starRowSemantic(int stars, int max) {
    return '$stars von $max Sternen';
  }

  @override
  String battleArenaStageLabel(int floor) {
    return 'Die Endlose Prüfung · Etage $floor';
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
  String get battleSpeedTo1x => 'Kampftempo 2x, tippen für 1x';

  @override
  String get battleSpeedTo2x => 'Kampftempo 1x, tippen für 2x';

  @override
  String get battleAutoOn => 'Auto-Kampf an';

  @override
  String get battleAutoOff => 'Auto-Kampf aus';

  @override
  String get battleBossBadge => 'BOSS';

  @override
  String get battleActiveSkillLabel => 'Aktive Fähigkeit';

  @override
  String get battleUltimateLabel => 'Ultimativ';

  @override
  String get elementEmber => 'Glut';

  @override
  String get elementTide => 'Flut';

  @override
  String get elementBloom => 'Blüte';

  @override
  String get elementLunar => 'Lunar';

  @override
  String get elementAstral => 'Astral';

  @override
  String get roleTank => 'Tank';

  @override
  String get roleDamage => 'Schaden';

  @override
  String get roleSupport => 'Unterstützung';

  @override
  String get roleHealer => 'Heiler';

  @override
  String get roleControl => 'Kontrolle';

  @override
  String get roleGuardian => 'Wächter';

  @override
  String get rarityCommon => 'Gewöhnlich';

  @override
  String get rarityUncommon => 'Ungewöhnlich';

  @override
  String get rarityRare => 'Selten';

  @override
  String get rarityEpic => 'Episch';

  @override
  String get rarityLegendary => 'Legendär';

  @override
  String get rarityMythic => 'Mythisch';

  @override
  String get rarityExclusive => 'Exklusiv';

  @override
  String get slotWeapon => 'Waffe';

  @override
  String get slotCharm => 'Talisman';

  @override
  String get slotCloak => 'Umhang';

  @override
  String get slotRing => 'Ring';
}
