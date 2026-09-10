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

  @override
  String get arenaTierBronze => 'Bronze';

  @override
  String get arenaTierSilver => 'Silber';

  @override
  String get arenaTierGold => 'Gold';

  @override
  String get arenaTierPlatinum => 'Platin';

  @override
  String get arenaTierDiamond => 'Diamant';

  @override
  String get arenaZoneBronze => 'Bronzehallen';

  @override
  String get arenaZoneSilver => 'Silberkammer';

  @override
  String get arenaZoneGold => 'Goldsanktum';

  @override
  String get arenaZonePlatinum => 'Platinaufstieg';

  @override
  String get arenaZoneDiamond => 'Diamantgipfel';

  @override
  String get dk_ember_fox_name => 'Glutfuchs';

  @override
  String get dk_ember_fox_flavor =>
      'Geboren aus dem letzten Flackern einer Kerze vor der Morgendämmerung.';

  @override
  String get dk_ember_fox_ult => 'Flammensprung';

  @override
  String get dk_ember_fox_ultDesc =>
      'Ein lodernder Satz, der das Ziel versengt.';

  @override
  String get dk_ember_fox_skill => 'Glutbiss';

  @override
  String get dk_ember_fox_skillDesc =>
      'Ein schneller, sengender Biss nach dem nächsten Feind.';

  @override
  String get dk_ember_fox_pass => 'Entfachter Geist';

  @override
  String get dk_ember_fox_passDesc => 'Im Kampf etwas mutiger.';

  @override
  String get dk_moon_hare_name => 'Mondhase';

  @override
  String get dk_moon_hare_flavor =>
      'Folgt Reisenden, die unter freiem Himmel einschlafen.';

  @override
  String get dk_moon_hare_ult => 'Mondlicht-Segen';

  @override
  String get dk_moon_hare_ultDesc =>
      'Badet das ganze Team in heilendem Mondlicht.';

  @override
  String get dk_moon_hare_skill => 'Sanfte Berührung';

  @override
  String get dk_moon_hare_skillDesc =>
      'Ein sanfter Mondlichtpuls für den Verbündeten, der ihn am nötigsten braucht.';

  @override
  String get dk_moon_hare_pass => 'Sanftes Leuchten';

  @override
  String get dk_moon_hare_passDesc => 'Eine ruhige, festigende Gegenwart.';

  @override
  String get dk_forest_spirit_name => 'Waldgeist';

  @override
  String get dk_forest_spirit_flavor =>
      'Gewachsen aus dem Traum eines vergessenen Gartens.';

  @override
  String get dk_forest_spirit_ult => 'Grünender Chor';

  @override
  String get dk_forest_spirit_ultDesc =>
      'Sammelt das Team mit einem Schub an Lebenskraft.';

  @override
  String get dk_forest_spirit_skill => 'Dornenschutz';

  @override
  String get dk_forest_spirit_skillDesc =>
      'Hüllt sich in zähe Dornen und wird kühner.';

  @override
  String get dk_forest_spirit_pass => 'Verwurzelte Ruhe';

  @override
  String get dk_forest_spirit_passDesc => 'Fester Stand, fester Sinn.';

  @override
  String get dk_crystal_golem_name => 'Kristallgolem';

  @override
  String get dk_crystal_golem_flavor =>
      'Entstanden, wo ein Gezeitentraum mitten in der Welle erstarrte.';

  @override
  String get dk_crystal_golem_ult => 'Bollwerk-Schlag';

  @override
  String get dk_crystal_golem_ultDesc =>
      'Ein bodenerschütternder Hieb, der den Feind ins Wanken bringt.';

  @override
  String get dk_crystal_golem_skill => 'Schildschlag';

  @override
  String get dk_crystal_golem_skillDesc =>
      'Ein schwerer, aber gemächlicher Hieb.';

  @override
  String get dk_crystal_golem_pass => 'Kristallhaut';

  @override
  String get dk_crystal_golem_passDesc =>
      'Bricht einen Teil der einkommenden Wucht.';

  @override
  String get dk_star_wolf_name => 'Sternenwolf';

  @override
  String get dk_star_wolf_flavor =>
      'Läuft die Pfade zwischen fallenden Sternen.';

  @override
  String get dk_star_wolf_ult => 'Sternenfall-Heulen';

  @override
  String get dk_star_wolf_ultDesc =>
      'Ein durchdringendes Heulen, das den Feind an Ort und Stelle einfriert.';

  @override
  String get dk_star_wolf_skill => 'Schneller Biss';

  @override
  String get dk_star_wolf_skillDesc =>
      'Ein rascher Schnapper, bevor der Feind reagieren kann.';

  @override
  String get dk_star_wolf_pass => 'Nachtsicht';

  @override
  String get dk_star_wolf_passDesc => 'Verfehlt im Dunkeln nie einen Schritt.';

  @override
  String get dk_thorn_viper_name => 'Dornenviper';

  @override
  String get dk_thorn_viper_flavor =>
      'Windet sich durch Dornen, die nur in unruhigen Träumen wachsen.';

  @override
  String get dk_thorn_viper_ult => 'Giftzahn';

  @override
  String get dk_thorn_viper_ultDesc =>
      'Ein präziser Stoß, durchsetzt mit Traumdorn-Gift.';

  @override
  String get dk_thorn_viper_skill => 'Durchstich';

  @override
  String get dk_thorn_viper_skillDesc =>
      'Ein stechender Hieb auf die Schwachstellen.';

  @override
  String get dk_thorn_viper_pass => 'Giftschicht';

  @override
  String get dk_thorn_viper_passDesc =>
      'Zähne, die nie ganz aufhören zu brennen.';

  @override
  String get dk_tide_serpent_name => 'Gezeitenschlange';

  @override
  String get dk_tide_serpent_flavor =>
      'Gleitet zwischen Wellen hindurch, zu schnell für wache Augen.';

  @override
  String get dk_tide_serpent_ult => 'Sog-Windung';

  @override
  String get dk_tide_serpent_ultDesc =>
      'Umschlingt den Feind mit einer zermalmenden Wasserspirale.';

  @override
  String get dk_tide_serpent_skill => 'Peitschenwindung';

  @override
  String get dk_tide_serpent_skillDesc =>
      'Ein plötzlicher Schlag des gewundenen Körpers.';

  @override
  String get dk_tide_serpent_pass => 'Glitschige Schuppen';

  @override
  String get dk_tide_serpent_passDesc =>
      'Schwer festzunageln, schwerer zu fangen.';

  @override
  String get dk_ember_phoenix_name => 'Glutphönix';

  @override
  String get dk_ember_phoenix_flavor =>
      'Erhebt sich neu, jedes Mal wenn ein Träumer nicht aufgeben will.';

  @override
  String get dk_ember_phoenix_ult => 'Wiedergeburts-Flamme';

  @override
  String get dk_ember_phoenix_ultDesc =>
      'Eine lodernde Wiedergeburt, die jede Wunde im Team heilt.';

  @override
  String get dk_ember_phoenix_skill => 'Warme Feder';

  @override
  String get dk_ember_phoenix_skillDesc =>
      'Lässt eine einzelne glutwarme Feder über einem Verbündeten fallen.';

  @override
  String get dk_ember_phoenix_pass => 'Ewige Glut';

  @override
  String get dk_ember_phoenix_passDesc =>
      'Eine Flamme, die sich weigert, als letzte zu erlöschen.';

  @override
  String get dk_lunar_owl_name => 'Mondeule';

  @override
  String get dk_lunar_owl_flavor =>
      'Wacht von Ästen aus, die nur bei Vollmond existieren.';

  @override
  String get dk_lunar_owl_ult => 'Lautlose Klauen';

  @override
  String get dk_lunar_owl_ultDesc =>
      'Ein geräuschloser Sturzflug, der das Ziel taumeln lässt.';

  @override
  String get dk_lunar_owl_skill => 'Schneller Hieb';

  @override
  String get dk_lunar_owl_skillDesc => 'Ein präziser Schlag von oben.';

  @override
  String get dk_lunar_owl_pass => 'Scharfe Augen';

  @override
  String get dk_lunar_owl_passDesc => 'Sieht jede Lücke, bevor sie entsteht.';

  @override
  String get dk_astral_sentinel_name => 'Astralwächter';

  @override
  String get dk_astral_sentinel_flavor =>
      'Hält Wache an der Grenze zwischen Traum und Sternen.';

  @override
  String get dk_astral_sentinel_ult => 'Sternwärts-Bollwerk';

  @override
  String get dk_astral_sentinel_ultDesc =>
      'Ruft eine Wand aus Sternenlicht herab, um das Team zu schützen.';

  @override
  String get dk_astral_sentinel_skill => 'Wappnen';

  @override
  String get dk_astral_sentinel_skillDesc =>
      'Stellt sich fest hin und schlägt zurück.';

  @override
  String get dk_astral_sentinel_pass => 'Astralschutz';

  @override
  String get dk_astral_sentinel_passDesc =>
      'Ein leises Schimmern, das das Schlimmste ablenkt.';

  @override
  String get dk_coral_warden_name => 'Korallenwächter';

  @override
  String get dk_coral_warden_flavor =>
      'Gewachsen aus einem Riff, das nur im Tiefschlaf blüht.';

  @override
  String get dk_coral_warden_ult => 'Gezeitenchor';

  @override
  String get dk_coral_warden_ultDesc =>
      'Eine rollende Welle der Ermutigung überspült das Team.';

  @override
  String get dk_coral_warden_skill => 'Ermutigen';

  @override
  String get dk_coral_warden_skillDesc =>
      'Ein festigendes Wort, das die Entschlossenheit stärkt.';

  @override
  String get dk_coral_warden_pass => 'Riffwache';

  @override
  String get dk_coral_warden_passDesc =>
      'Wurde zäh, wo die Strömungen am rauesten sind.';

  @override
  String get dk_cinder_sprite_name => 'Aschekobold';

  @override
  String get dk_cinder_sprite_flavor =>
      'Ein Funke, der nie ganz erlischt, egal wie dunkel es wird.';

  @override
  String get dk_cinder_sprite_ult => 'Funkensammlung';

  @override
  String get dk_cinder_sprite_ultDesc =>
      'Ein Schauer warmer Funken hebt die Stimmung des ganzen Teams.';

  @override
  String get dk_cinder_sprite_skill => 'Warmer Funkenstoß';

  @override
  String get dk_cinder_sprite_skillDesc =>
      'Ein freundlicher Funke, der die Stimmung hebt.';

  @override
  String get dk_cinder_sprite_pass => 'Warmer Funke';

  @override
  String get dk_cinder_sprite_passDesc =>
      'Ein Funke, der nie ganz erlischt, egal wie dunkel es wird.';

  @override
  String get dk_flicker_pup_name => 'Flackerwelpe';

  @override
  String get dk_flicker_pup_flavor =>
      'Geschlüpft aus dem letzten Funken eines Traums, der fast erloschen wäre.';

  @override
  String get dk_flicker_pup_ult => 'Kerzensturm';

  @override
  String get dk_flicker_pup_ultDesc =>
      'Ein tollpatschiger, aber eifriger Ansturm, umhüllt von flackernder Flamme.';

  @override
  String get dk_flicker_pup_skill => 'Warmer Biss';

  @override
  String get dk_flicker_pup_skillDesc =>
      'Ein spielerischer Biss, heißer als er aussieht.';

  @override
  String get dk_flicker_pup_pass => 'Rastloser Funke';

  @override
  String get dk_flicker_pup_passDesc =>
      'Zu aufgeregt, um je lange still zu halten.';

  @override
  String get dk_ripple_minnow_name => 'Kräuselfischchen';

  @override
  String get dk_ripple_minnow_flavor =>
      'Schwimmt im flachen Teil von Träumen, zu klein für alles Größere.';

  @override
  String get dk_ripple_minnow_ult => 'Schwarmwoge';

  @override
  String get dk_ripple_minnow_ultDesc =>
      'Ein Ansturm kleiner Fische, der das ganze Team festigt.';

  @override
  String get dk_ripple_minnow_skill => 'Anstupsen';

  @override
  String get dk_ripple_minnow_skillDesc =>
      'Ein sanfter Schubs in die richtige Richtung.';

  @override
  String get dk_ripple_minnow_pass => 'Sicherheit in der Menge';

  @override
  String get dk_ripple_minnow_passDesc =>
      'Nie wirklich allein, auch wenn es so aussieht.';

  @override
  String get dk_sprout_cub_name => 'Sprossjunges';

  @override
  String get dk_sprout_cub_flavor =>
      'Ein Keimlingstraum, der beschloss, Klauen statt Blätter zu treiben.';

  @override
  String get dk_sprout_cub_ult => 'Sture Wurzel';

  @override
  String get dk_sprout_cub_ultDesc =>
      'Verankert sich am Boden und weigert sich schlicht, sich zu bewegen.';

  @override
  String get dk_sprout_cub_skill => 'Kopfstoß';

  @override
  String get dk_sprout_cub_skillDesc => 'Ein ernster, tollpatschiger Ansturm.';

  @override
  String get dk_sprout_cub_pass => 'Dicke Borke';

  @override
  String get dk_sprout_cub_passDesc =>
      'Jung, aber schon zäher als es aussieht.';

  @override
  String get dk_nightling_name => 'Nachtling';

  @override
  String get dk_nightling_flavor =>
      'Ein Fetzen Nacht, der abbrach, bevor der Traum fertig war.';

  @override
  String get dk_nightling_ult => 'Kleiner Schatten';

  @override
  String get dk_nightling_ultDesc =>
      'Schiebt einen Splitter Dunkelheit über die Augen des Feindes.';

  @override
  String get dk_nightling_skill => 'Flackerschritt';

  @override
  String get dk_nightling_skillDesc =>
      'Ein rascher Seitschritt in die Dunkelheit und zurück.';

  @override
  String get dk_nightling_pass => 'Halb gesehen';

  @override
  String get dk_nightling_passDesc => 'Nie ganz dort, wo man es erwartet.';

  @override
  String get dk_stardust_moth_name => 'Sternenstaubmotte';

  @override
  String get dk_stardust_moth_flavor =>
      'Angezogen von jedem Traum, der noch hell genug zum Sehen ist.';

  @override
  String get dk_stardust_moth_ult => 'Staubspur';

  @override
  String get dk_stardust_moth_ultDesc =>
      'Lässt einen feinen, heilenden Staub über dem Team rieseln.';

  @override
  String get dk_stardust_moth_skill => 'Flügelschlag';

  @override
  String get dk_stardust_moth_skillDesc =>
      'Ein sanftes Flattern, das den Schmerz eines Verbündeten lindert.';

  @override
  String get dk_stardust_moth_pass => 'Zum Licht gezogen';

  @override
  String get dk_stardust_moth_passDesc =>
      'Folgt jedem Licht, das im Kampf noch übrig ist.';

  @override
  String get dk_cinder_badger_name => 'Aschedachs';

  @override
  String get dk_cinder_badger_flavor =>
      'Gräbt seinen Bau, wo ein Herdfeuertraum zu Glut niederbrannte.';

  @override
  String get dk_cinder_badger_ult => 'Kohlegrabung';

  @override
  String get dk_cinder_badger_ultDesc =>
      'Wühlt sich ein und bricht mit gestauter Hitze hervor.';

  @override
  String get dk_cinder_badger_skill => 'Sturer Ansturm';

  @override
  String get dk_cinder_badger_skillDesc =>
      'Senkt den Kopf und schiebt sich einfach durch.';

  @override
  String get dk_cinder_badger_pass => 'Gestaute Hitze';

  @override
  String get dk_cinder_badger_passDesc =>
      'Läuft heißer, je länger ein Kampf sich zieht.';

  @override
  String get dk_pearl_otter_name => 'Perlenotter';

  @override
  String get dk_pearl_otter_flavor =>
      'Sammelt Perlen aus Träumen, zu ruhig, um je Wellen zu schlagen.';

  @override
  String get dk_pearl_otter_ult => 'Perlengezeiten';

  @override
  String get dk_pearl_otter_ultDesc =>
      'Eine Woge leuchtender Perlen heilt die Wunden des Teams.';

  @override
  String get dk_pearl_otter_skill => 'Polieren';

  @override
  String get dk_pearl_otter_skillDesc =>
      'Ein rascher, penibler Putzgang über einen Verbündeten.';

  @override
  String get dk_pearl_otter_pass => 'Auftrieb';

  @override
  String get dk_pearl_otter_passDesc =>
      'Findet immer einen Weg, oben zu bleiben.';

  @override
  String get dk_comet_fox_name => 'Kometenfuchs';

  @override
  String get dk_comet_fox_flavor =>
      'Jagt den Schweif eines echten Kometen durch den Traumhimmel und gewinnt meistens.';

  @override
  String get dk_comet_fox_ult => 'Leuchtsprint';

  @override
  String get dk_comet_fox_ultDesc =>
      'Ein blendender Sprint, der eine Lichtspur hinterlässt.';

  @override
  String get dk_comet_fox_skill => 'Schweifblitz';

  @override
  String get dk_comet_fox_skillDesc =>
      'Ein rasches Schnippen eines glühenden Schweifs.';

  @override
  String get dk_comet_fox_pass => 'Nachziehendes Licht';

  @override
  String get dk_comet_fox_passDesc =>
      'Lässt die Luft schimmern, allein vom Hindurchziehen.';

  @override
  String get dk_bramble_lynx_name => 'Dornenluchs';

  @override
  String get dk_bramble_lynx_flavor =>
      'Pirscht durch die Hecken eines Gartentraums, an dessen Pflanzung sich niemand erinnert.';

  @override
  String get dk_bramble_lynx_ult => 'Dickichtsprung';

  @override
  String get dk_bramble_lynx_ultDesc =>
      'Verschwindet ins Gebüsch und schlägt aus einem Winkel zu, den niemand erwartet.';

  @override
  String get dk_bramble_lynx_skill => 'Klauenhieb';

  @override
  String get dk_bramble_lynx_skillDesc =>
      'Ein schneller, tiefer Hieb über die Beine.';

  @override
  String get dk_bramble_lynx_pass => 'Dornenfell';

  @override
  String get dk_bramble_lynx_passDesc =>
      'Ließ sein Fell durch eine Dornenhecke wachsen.';

  @override
  String get dk_shade_panther_name => 'Schattenpanther';

  @override
  String get dk_shade_panther_flavor =>
      'Jagt in den Nächten, in denen der Mond ganz vergisst aufzugehen.';

  @override
  String get dk_shade_panther_ult => 'Mondloser Schlag';

  @override
  String get dk_shade_panther_ultDesc =>
      'Ein Schlag, getimt auf den einen Moment, in dem ihn kein Licht erreicht.';

  @override
  String get dk_shade_panther_skill => 'Lautloser Sprung';

  @override
  String get dk_shade_panther_skillDesc =>
      'Überbrückt die Distanz, bevor der Schall aufholt.';

  @override
  String get dk_shade_panther_pass => 'Ungesehen';

  @override
  String get dk_shade_panther_passDesc =>
      'Verschmilzt mit jedem Schatten, in dem es steht.';

  @override
  String get dk_nova_falcon_name => 'Novafalke';

  @override
  String get dk_nova_falcon_flavor =>
      'Nistet auf der Spitze eines Bergs, der nur an der Spitze eines Traums existiert.';

  @override
  String get dk_nova_falcon_ult => 'Nova-Sturzflug';

  @override
  String get dk_nova_falcon_ultDesc =>
      'Ein kreischender Sturzflug mit einem Schweif aus Sternenlicht.';

  @override
  String get dk_nova_falcon_skill => 'Flügelschnitt';

  @override
  String get dk_nova_falcon_skillDesc =>
      'Eine scharfe Wendung, die das Ziel im Flug streift.';

  @override
  String get dk_nova_falcon_pass => 'Aufwind';

  @override
  String get dk_nova_falcon_passDesc =>
      'Reitet Strömungen, die nur er spüren kann.';

  @override
  String get dk_magma_titan_name => 'Magmatitan';

  @override
  String get dk_magma_titan_flavor =>
      'Steht dort, wo ein berggroßer Traum langsam fertig schmolz.';

  @override
  String get dk_magma_titan_ult => 'Geschmolzene Faust';

  @override
  String get dk_magma_titan_ultDesc =>
      'Ein langsamer, unaufhaltsamer Hieb aus flüssigem Gestein.';

  @override
  String get dk_magma_titan_skill => 'Hitzewand';

  @override
  String get dk_magma_titan_skillDesc =>
      'Strahlt genug Hitze ab, dass die ganze Frontlinie zurückzuckt.';

  @override
  String get dk_magma_titan_pass => 'Geschmolzener Kern';

  @override
  String get dk_magma_titan_passDesc =>
      'Kühlt nie genug ab, um sicher berührbar zu sein.';

  @override
  String get dk_verdant_stag_name => 'Grünhirsch';

  @override
  String get dk_verdant_stag_flavor =>
      'Trägt eine Krone, gewachsen aus dem ältesten, sanftesten Traum eines Waldes.';

  @override
  String get dk_verdant_stag_ult => 'Geweihblüte';

  @override
  String get dk_verdant_stag_ultDesc =>
      'Blüten brechen aus seinem Geweih und heben das ganze Team.';

  @override
  String get dk_verdant_stag_skill => 'Stolzer Ansturm';

  @override
  String get dk_verdant_stag_skillDesc =>
      'Ein würdevoller, gemächlicher Ansturm.';

  @override
  String get dk_verdant_stag_pass => 'Alter Bestand';

  @override
  String get dk_verdant_stag_passDesc =>
      'Trägt die Ruhe eines Waldes in sich, der seit Ewigkeiten steht.';

  @override
  String get dk_abyssal_kraken_name => 'Abgrundkrake';

  @override
  String get dk_abyssal_kraken_flavor =>
      'Stieg einst aus einem Traum so tief, dass selbst die Gezeiten ihn vergaßen.';

  @override
  String get dk_abyssal_kraken_ult => 'Tiefengriff';

  @override
  String get dk_abyssal_kraken_ultDesc =>
      'Aus dem Graben heraufgezogene Windungen schließen sich um das Ziel.';

  @override
  String get dk_abyssal_kraken_skill => 'Tentakelhieb';

  @override
  String get dk_abyssal_kraken_skillDesc =>
      'Ein schwerer Hieb aus dem gerade eben Unsichtbaren.';

  @override
  String get dk_abyssal_kraken_pass => 'Grabendruck';

  @override
  String get dk_abyssal_kraken_passDesc =>
      'Schlägt härter, je tiefer der Kampf geht.';

  @override
  String get dk_leviathan_queen_name => 'Leviathan-Königin';

  @override
  String get dk_leviathan_queen_flavor =>
      'Beherrscht jede Strömung im Traumozean, und jede Strömung weiß es.';

  @override
  String get dk_leviathan_queen_ult => 'Gezeitenkrone';

  @override
  String get dk_leviathan_queen_ultDesc =>
      'Ruft eine Krone aus Wasser herauf, die auf jeden Feind niederkracht.';

  @override
  String get dk_leviathan_queen_skill => 'Königliche Welle';

  @override
  String get dk_leviathan_queen_skillDesc =>
      'Ein langsamer, gebieterischer Strömungsstoß.';

  @override
  String get dk_leviathan_queen_pass => 'Herrschergezeiten';

  @override
  String get dk_leviathan_queen_passDesc =>
      'Der Ozean selbst scheint sich ihr zu beugen.';

  @override
  String get dk_world_tree_warden_name => 'Weltenbaum-Wächter';

  @override
  String get dk_world_tree_warden_flavor =>
      'Gewachsen aus dem allerersten Samen, den je ein Träumer pflanzte.';

  @override
  String get dk_world_tree_warden_ult => 'Wurzel der Zeitalter';

  @override
  String get dk_world_tree_warden_ultDesc =>
      'Schöpft aus einer Wurzel älter als der Wald, um das ganze Team zu heilen.';

  @override
  String get dk_world_tree_warden_skill => 'Harzsegen';

  @override
  String get dk_world_tree_warden_skillDesc =>
      'Ein langsames, warmes Rinnsal heilenden Harzes.';

  @override
  String get dk_world_tree_warden_pass => 'Uralte Wurzeln';

  @override
  String get dk_world_tree_warden_passDesc =>
      'Reicht tiefer, als je ein Traum es gebraucht hat.';

  @override
  String get dk_celestial_dragon_name => 'Himmelsdrache';

  @override
  String get dk_celestial_dragon_flavor =>
      'Der letzte Traum, den jeder Träumer hat, wenn er lange genug träumt.';

  @override
  String get dk_celestial_dragon_ult => 'Sternenfeuer-Kataklysmus';

  @override
  String get dk_celestial_dragon_ultDesc =>
      'Atmet das Licht einer sterbenden Galaxie aus.';

  @override
  String get dk_celestial_dragon_skill => 'Kometenbiss';

  @override
  String get dk_celestial_dragon_skillDesc =>
      'Ein Biss, der noch die Hitze des Sturzes durch den Himmel trägt.';

  @override
  String get dk_celestial_dragon_pass => 'Lebendes Sternbild';

  @override
  String get dk_celestial_dragon_passDesc =>
      'Aus demselben Stoff wie die Sterne, zwischen denen er fliegt.';

  @override
  String get dk_eclipse_empress_name => 'Finsternis-Kaiserin';

  @override
  String get dk_eclipse_empress_flavor =>
      'Herrscht über den Raum zwischen dem Ende eines Traums und dem Beginn des nächsten.';

  @override
  String get dk_eclipse_empress_ult => 'Totale Finsternis';

  @override
  String get dk_eclipse_empress_ultDesc =>
      'Löscht jedes Licht auf einmal aus und lässt dem Feind kein Versteck.';

  @override
  String get dk_eclipse_empress_skill => 'Sichel-Erlass';

  @override
  String get dk_eclipse_empress_skillDesc =>
      'Ein einziger, absoluter Befehl, in Mondlicht gemeißelt.';

  @override
  String get dk_eclipse_empress_pass => 'Herrscherin der Schatten';

  @override
  String get dk_eclipse_empress_passDesc =>
      'Jeder dunkle Winkel des Traums gehorcht ihr.';

  @override
  String get dk_igo_name => 'Igo';

  @override
  String get dk_igo_flavor =>
      'Überhaupt kein Geschöpf des Traums — Igo ist einer von nur zwei Menschen, die je für immer im Traumhafen blieben, ein Außenseiter, der sich entschied, dessen Schild zu werden. Die Traumhüter nennen ihn Traumwandler, nie einen der Ihren, und ihm wäre es nicht anders recht.';

  @override
  String get dk_igo_ult => 'Flutwand';

  @override
  String get dk_igo_ultDesc =>
      'Errichtet eine schützende Wasserwand um das ganze Team.';

  @override
  String get dk_igo_skill => 'Strömungsriss';

  @override
  String get dk_igo_skillDesc =>
      'Eine reißende Strömung, die den Feind verletzt und verlangsamt.';

  @override
  String get dk_igo_pass => 'Gezeitenwache';

  @override
  String get dk_igo_passDesc =>
      'Einmal pro Kampf weigert er sich zu fallen und kehrt mit 30% HP zurück.';

  @override
  String get dk_ames_name => 'Ames';

  @override
  String get dk_ames_flavor =>
      'Ames kam einst in den Traumhafen und ging schlicht nie wieder — die zweite der beiden Menschen, die diesen Ort für immer zur Heimat machten. Kein Traumgeschöpf brennt so wie sie; das Feuer gehört ganz und stur ihr allein.';

  @override
  String get dk_ames_ult => 'Glutschnitt';

  @override
  String get dk_ames_ultDesc =>
      'Ein einziger verheerender Schnitt weißglühender Flamme.';

  @override
  String get dk_ames_skill => 'Aschesturm';

  @override
  String get dk_ames_skillDesc =>
      'Ein brennender Schlag, der den Feind weiter schwelen lässt.';

  @override
  String get dk_ames_pass => 'Feuertaufe';

  @override
  String get dk_ames_passDesc =>
      'Schlägt härter, je näher sie dem Fallen kommt — bis zu +60% Angriff nahe dem Tod.';

  @override
  String get dk_olf_name => 'Olf';

  @override
  String get dk_olf_ember_flavor =>
      'Jeder Spielstand beginnt mit einem Olf. Keiner weiß so recht, warum er auf der Tunika besteht.';

  @override
  String get dk_olf_ember_ult => 'Wackliger Flammenstoß';

  @override
  String get dk_olf_ember_ultDesc =>
      'Stürmt herein und schwingt sein Zweigschwert — und fängt unterwegs irgendwie Feuer.';

  @override
  String get dk_olf_ember_skill => 'Hitzköpfiger Hieb';

  @override
  String get dk_olf_ember_skillDesc =>
      'Ein Hieb, geworfen mit mehr Begeisterung als Technik.';

  @override
  String get dk_olf_pass => 'Zu dumm für Angst';

  @override
  String get dk_olf_passDesc => 'Weiß nicht genug, um zusammenzuzucken.';

  @override
  String get dk_olf_tide_flavor =>
      'Wählte Flut, weil Pfützen freundlicher schienen als die Alternative.';

  @override
  String get dk_olf_tide_ult => 'Bauchklatscher';

  @override
  String get dk_olf_tide_ultDesc =>
      'Springt als Bombe hinein, hauptsächlich um zu sehen, was passiert.';

  @override
  String get dk_olf_tide_skill => 'Pfützenstupser';

  @override
  String get dk_olf_tide_skillDesc =>
      'Stupst den nächsten Feind mit seinem Zweigschwert an, tropfend.';

  @override
  String get dk_olf_bloom_flavor =>
      'Sein Schwert und sein Element sind, streng genommen, dieselbe Pflanze.';

  @override
  String get dk_olf_bloom_ult => 'Wuchernder Wutanfall';

  @override
  String get dk_olf_bloom_ultDesc =>
      'Schlägt wild durch das Gestrüpp, das er größtenteils selbst gezogen hat.';

  @override
  String get dk_olf_bloom_skill => 'Zweigschwert-Klatsch';

  @override
  String get dk_olf_bloom_skillDesc =>
      'Ein Klatsch mit dem Zweigschwert — das passenderweise auch ein Zweig ist.';

  @override
  String get dk_olf_lunar_flavor =>
      'Wählte Mond, weil er gern lange aufblieb. Er ist ständig müde.';

  @override
  String get dk_olf_lunar_ult => 'Mondsüchtiges Stolpern';

  @override
  String get dk_olf_lunar_ultDesc =>
      'Stolpert über die eigenen Füße direkt in den Feind, irgendwie mit Absicht.';

  @override
  String get dk_olf_lunar_skill => 'Schläfriger Hieb';

  @override
  String get dk_olf_lunar_skillDesc =>
      'Ein Hieb, halb im Schlaf geworfen, also meistens.';

  @override
  String get dk_olf_astral_flavor =>
      'Glaubt, die Sterne hätten ihn erwählt. Die Sterne haben sich nicht geäußert.';

  @override
  String get dk_olf_astral_ult => 'Sternäugiger Ansturm';

  @override
  String get dk_olf_astral_ultDesc =>
      'Stürmt herein und starrt in den Himmel statt auf den Feind.';

  @override
  String get dk_olf_astral_skill => 'Glückstreffer';

  @override
  String get dk_olf_astral_skillDesc =>
      'Ein Hieb, den er ganz sicher landen wollte.';

  @override
  String get dk_olf_ultimate_flavor =>
      'Der andere Olf weiß auch nicht, wie das passiert ist.';

  @override
  String get dk_olf_ultimate_ult => 'Flammenstoß des unwahrscheinlichen Helden';

  @override
  String get dk_olf_ultimate_ultDesc =>
      'Derselbe wacklige Stoß — der diesmal irgendwie tatsächlich trifft.';

  @override
  String get dk_olf_ultimate_skill => 'Verdächtig kompetenter Hieb';

  @override
  String get dk_olf_ultimate_skillDesc =>
      'Ein Hieb, der genau dort landet, wo er sollte. Er schaut so überrascht wie du.';

  @override
  String get dk_olf_ultimate_pass => 'Heimlich anders gebaut';

  @override
  String get dk_olf_ultimate_passDesc =>
      'Irgendwie, allen Widrigkeiten zum Trotz, wurde dieser Olf unfair stark.';

  @override
  String get world1Name => 'Flüsternde Wiese';

  @override
  String get world1Desc =>
      'Ein stilles, sonniges Feld, wo die ersten Träume Wurzeln schlagen.';

  @override
  String get world1Boss => 'Die Entwirrung';

  @override
  String get world2Name => 'Mondbeschienener Wald';

  @override
  String get world2Desc =>
      'Ein dunkler Wald, nur erhellt von leuchtender, träumender Flora.';

  @override
  String get world2Boss => 'Albtraumwächter';

  @override
  String get world3Name => 'Kristallhöhlen';

  @override
  String get world3Desc =>
      'Gefrorene Gezeiten, die unter der wachen Welt Gestalt annehmen.';

  @override
  String get world3Boss => 'Kristallwächter';

  @override
  String get world4Name => 'Sternenfall-Gipfel';

  @override
  String get world4Desc =>
      'Schwebende Berge und Meteoritenfelder um einen uralten Sternentempel.';

  @override
  String get world4Boss => 'Aetherion, der Gefallene Stern';

  @override
  String get world5Name => 'Der Vergessene Traum';

  @override
  String get world5Desc =>
      'Zerbrochene Gebäude und schwebende Ruinen, verloren in surrealem, dichtem Nebel.';

  @override
  String get world5Boss => 'Morvane, Traumfresser';

  @override
  String get world6Name => 'Glutherz-Ödland';

  @override
  String get world6Desc =>
      'Weite Vulkane und Lavaseen unter einem von Asche erstickten Himmel.';

  @override
  String get world6Boss => 'Ignivar, Herr der Asche';

  @override
  String get world7Name => 'Gezeitenabgrund';

  @override
  String get world7Desc =>
      'Versunkene Tempel und Korallenwälder tief in einem Graben, den kein Licht erreicht.';

  @override
  String get world7Boss => 'Thalassor, Abgrundkönig';

  @override
  String get world8Name => 'Ewige Blüte';

  @override
  String get world8Desc =>
      'Ein kolossaler magischer Dschungel aus Wurzeltunneln und leuchtender, überdimensionaler Flora.';

  @override
  String get world8Boss => 'Verdantor, Uralte Wurzel';

  @override
  String get world9Name => 'Reich der Finsternis';

  @override
  String get world9Desc =>
      'Ein Land in ewiger Finsternis unter einem gewaltigen, wachenden Mond.';

  @override
  String get world9Boss => 'Noctyra, Königin der Nacht';

  @override
  String get world10Name => 'Himmlischer Traum';

  @override
  String get world10Desc =>
      'Kosmische Inseln und sternenbeschienene Tempel im Zentrum des Traumreichs.';

  @override
  String get world10Boss => 'Elyndor, der Traumherrscher';

  @override
  String get world11Name => 'Widerhallende Wiese';

  @override
  String get world11Desc =>
      'Die Flüsternde Wiese träumt sich erneut — dieselben Geschöpfe zurück, wild und stark geworden.';

  @override
  String get world11Boss => 'Die Entwirrung, Erwacht';

  @override
  String get world12Name => 'Beschatteter Wald';

  @override
  String get world12Desc =>
      'Ein dunkleres Echo des Mondbeschienenen Waldes, wo alte Albträume Zähne bekommen haben.';

  @override
  String get world12Boss => 'Albtraumwächter, Wiedergeboren';

  @override
  String get world13Name => 'Tiefe Kristallhöhlen';

  @override
  String get world13Desc =>
      'Die Kristallhöhlen reichen nun tiefer, und die Kälte darin ist schärfer geworden.';

  @override
  String get world13Boss => 'Kristallwächter, Ungebrochen';

  @override
  String get world14Name => 'Sternenfall Entfacht';

  @override
  String get world14Desc =>
      'Die Meteoritenfelder der Sternenfall-Gipfel lodern erneut, heller und weit gefährlicher.';

  @override
  String get world14Boss => 'Aetherion, der Unsterbliche Stern';

  @override
  String get world15Name => 'Traum jenseits des Vergessens';

  @override
  String get world15Desc =>
      'Der Vergessene Traum schließt sich zur Schleife, sein Nebel dichter als zuvor.';

  @override
  String get world15Boss => 'Morvane, der Endlose Hunger';

  @override
  String get world16Name => 'Glutherz-Inferno';

  @override
  String get world16Desc =>
      'Das Ödland brennt noch heißer, und die Aschetitanen kehren erneuert zurück.';

  @override
  String get world16Boss => 'Ignivar, Herr der Tiefen Asche';

  @override
  String get world17Name => 'Der Entfesselte Abgrund';

  @override
  String get world17Desc =>
      'Der Gezeitenabgrund öffnet sich weiter, und seine ältesten Tiefen regen sich erneut.';

  @override
  String get world17Boss => 'Thalassor, die Endlose Flut';

  @override
  String get world18Name => 'Immerwährende Blüte';

  @override
  String get world18Desc =>
      'Die Ewige Blüte wächst ohne Ende, ihre Wurzeln stärker, als sich ein Träumer erinnert.';

  @override
  String get world18Boss => 'Verdantor, die Ewige Wurzel';

  @override
  String get world19Name => 'Unsterbliche Finsternis';

  @override
  String get world19Desc =>
      'Das Reich der Finsternis wird erneut dunkel, und sein Hofstaat ist weit grimmiger geworden.';

  @override
  String get world19Boss => 'Noctyra, die Endlose Nacht';

  @override
  String get world20Name => 'Himmlisches Requiem';

  @override
  String get world20Desc =>
      'Der Himmlische Traum singt erneut, seine kosmischen Wächter mit größerer Stärke zurück.';

  @override
  String get world20Boss => 'Elyndor, der Letzte Herrscher';

  @override
  String get world21Name => 'Der Letzte Traum der Wiese';

  @override
  String get world21Desc =>
      'Ein drittes Träumen der Wiese, wilder und weit schwerer, daraus zu erwachen.';

  @override
  String get world21Boss => 'Die Entwirrung, Ewig';

  @override
  String get world22Name => 'Der Letzte Mondbeschienene Wald';

  @override
  String get world22Desc =>
      'Der Wald träumt ein letztes Mal, seine Schatten tiefer als je zuvor.';

  @override
  String get world22Boss => 'Albtraumwächter, Unsterblich';

  @override
  String get world23Name => 'Höhlen des Endlosen Kristalls';

  @override
  String get world23Desc =>
      'Die Höhlen kristallisieren noch weiter und erhärten zu etwas fast Ewigem.';

  @override
  String get world23Boss => 'Kristallwächter, Absolut';

  @override
  String get world24Name => 'Sternenfalls Ende';

  @override
  String get world24Desc =>
      'Der letzte Sturz des Sternentempels, heller und heftiger, als der Himmel fassen kann.';

  @override
  String get world24Boss => 'Aetherion, die Gefallene Sonne';

  @override
  String get world25Name => 'Der Traum, der nie erwacht';

  @override
  String get world25Desc =>
      'Der Vergessene Traum faltet sich ein letztes Mal in sich selbst, und nichts erwacht daraus leicht.';

  @override
  String get world25Boss => 'Morvane, der Letzte Hunger';

  @override
  String get world26Name => 'Glutherz\' Letztes Feuer';

  @override
  String get world26Desc =>
      'Der letzte Brand des Ödlands, heiß genug, um die Aschefelder gänzlich neu zu formen.';

  @override
  String get world26Boss => 'Ignivar, die Letzte Glut';

  @override
  String get world27Name => 'Der Ewige Abgrund';

  @override
  String get world27Desc =>
      'Der Graben hat keinen Grund mehr zu finden, und was dort lebt, hat lange gewartet.';

  @override
  String get world27Boss => 'Thalassor, Herrscher der Tiefe';

  @override
  String get world28Name => 'Die Blüte, die nie verwelkt';

  @override
  String get world28Desc =>
      'Die Ewige Blüte erreicht ihr letztes, endloses Wachstum.';

  @override
  String get world28Boss => 'Verdantor, das Herz des Weltenbaums';

  @override
  String get world29Name => 'Die Absolute Finsternis';

  @override
  String get world29Desc =>
      'Die Dunkelheit erreicht ihre endgültige Form, und ihre Herrscherin war nie stärker.';

  @override
  String get world29Boss => 'Noctyra, Kaiserin der Schatten';

  @override
  String get world30Name => 'Der Letzte Traum';

  @override
  String get world30Desc =>
      'Der letzte Traum, aus dem die Traumhüter je erwachen müssen.';

  @override
  String get world30Boss => 'Elyndor, der Träumende Gott';

  @override
  String get monBrambleStalker => 'Dornenpirscher';

  @override
  String get monBrambleStalkerLore =>
      'Kriecht durchs hohe Gras, Dornen gesträubt beim ersten Anzeichen eines Schritts.';

  @override
  String get monDustWisp => 'Staubwisp';

  @override
  String get monDustWispLore =>
      'Ein loser Knoten aus treibendem Pollen und Statik, harmlos bis er schwärmt.';

  @override
  String get monMeadowSprite => 'Wiesenkobold';

  @override
  String get monMeadowSpriteLore =>
      'Klein, schnell und heftig territorial über seinem Kleefleck.';

  @override
  String get monSunpetalGuardian => 'Sonnenblüten-Wächter';

  @override
  String get monSunpetalGuardianLore =>
      'Blüht einmal im Morgengrauen und hält Wache über die Wiese bis zur Dämmerung.';

  @override
  String get monGloomHound => 'Düsterhund';

  @override
  String get monGloomHoundLore =>
      'Jagt im Raum zwischen den Schatten, nie ganz dort, wo du es zuletzt sahst.';

  @override
  String get monHollowShade => 'Hohler Schatten';

  @override
  String get monHollowShadeLore =>
      'Trägt die Gestalt eines vergessenen Traums, hohl im Kern.';

  @override
  String get monNightWisp => 'Nachtwisp';

  @override
  String get monNightWispLore =>
      'Eine kalte Glut aus Mondlicht, die flackert, sobald man sie ansieht.';

  @override
  String get monThornbackProwler => 'Dornrücken-Schleicher';

  @override
  String get monThornbackProwlerLore =>
      'Lautlos auf dem Waldboden, seine Stacheln die einzige Warnung.';

  @override
  String get monRiftCrawler => 'Spaltkriecher';

  @override
  String get monRiftCrawlerLore =>
      'Huscht entlang der Risse in den Höhlenwänden, wo das Licht nicht ganz hinreicht.';

  @override
  String get monFrostWisp => 'Frostwisp';

  @override
  String get monFrostWispLore =>
      'Haucht eine dünne, glitzernde Kälte aus, die an allem haftet, was sie berührt.';

  @override
  String get monCavernSerpent => 'Höhlenschlange';

  @override
  String get monCavernSerpentLore =>
      'Windet sich durch die unterirdischen Gezeiten, geduldig und unmöglich lang.';

  @override
  String get monCrystalWisp => 'Kristallwisp';

  @override
  String get monCrystalWispLore =>
      'Bricht jeden Laut in der Höhle in ein leises, missklingendes Läuten.';

  @override
  String get monStarfang => 'Sternzahn';

  @override
  String get monStarfangLore =>
      'Ein Splitter eines alten Sterns mit Zähnen, der die Meteoritenfelder durchstreift.';

  @override
  String get monCometpaw => 'Kometenpfote';

  @override
  String get monCometpawLore =>
      'Hinterlässt mit jedem Sprung zwischen schwebenden Gipfeln eine Spur sterbenden Lichts.';

  @override
  String get monAstralwing => 'Astralschwinge';

  @override
  String get monAstralwingLore =>
      'Umkreist die Ruinen des Sternentempels auf Flügeln aus alten Sternbildern.';

  @override
  String get monStardustling => 'Sternenstäubling';

  @override
  String get monStardustlingLore =>
      'Klein und glitzernd, zerstiebt es in Funken, wenn es erschreckt wird.';

  @override
  String get monCosmobite => 'Kosmobiss';

  @override
  String get monCosmobiteLore =>
      'Sein Biss trägt eine kalte, ferne Kühle von jenseits des Himmels.';

  @override
  String get monNebulaclaw => 'Nebelklaue';

  @override
  String get monNebulaclawLore =>
      'Klauen umhüllt von treibendem kosmischem Dunst, lautlos wie das Vakuum.';

  @override
  String get monStarhorn => 'Sternhorn';

  @override
  String get monStarhornLore =>
      'Rammt die Kristallspitzen der Sternenfall-Gipfel mit dem Kopf voran.';

  @override
  String get monCometscale => 'Kometenschuppe';

  @override
  String get monCometscaleLore =>
      'Schuppen, die noch lange Licht abgeben, nachdem das Wesen weitergezogen ist.';

  @override
  String get monMoonfang => 'Mondzahn';

  @override
  String get monMoonfangLore =>
      'Wandert durch die zerbrochenen Gebäude und heult einen Mond an, an den sich sonst niemand erinnert.';

  @override
  String get monDuskhorn => 'Dämmerhorn';

  @override
  String get monDuskhornLore =>
      'Stürmt aus dem dichten Nebel, bevor seine Silhouette je klar wird.';

  @override
  String get monNightclaw => 'Nachtklaue';

  @override
  String get monNightclawLore =>
      'Klauen, die keine Spur hinterlassen, nur die Erinnerung ans Geschnittenwerden.';

  @override
  String get monShadowtail => 'Schattenschweif';

  @override
  String get monShadowtailLore =>
      'Sein Schweif hinkt dem Rest seines Körpers eine ganze Sekunde hinterher.';

  @override
  String get monEclipsepaw => 'Finsternispfote';

  @override
  String get monEclipsepawLore =>
      'Schreitet zwischen schwebenden Ruinenbrocken, als wären sie fester Boden.';

  @override
  String get monDreamstalker => 'Traumpirscher';

  @override
  String get monDreamstalkerLore =>
      'Folgt Träumern durch den Nebel, lange nachdem sie erwacht sind.';

  @override
  String get monMoonscale => 'Mondschuppe';

  @override
  String get monMoonscaleLore =>
      'Schuppen, die mit einer eigenen Mondphase verblassen und aufleuchten.';

  @override
  String get monGloomfang => 'Düsterzahn';

  @override
  String get monGloomfangLore =>
      'Ein letztes Echo des Traums, der diese zerstörte Stadt einst war.';

  @override
  String get monCinderfang => 'Aschezahn';

  @override
  String get monCinderfangLore =>
      'Durchstreift die Aschefelder, die Kiefer glimmen schwach von gestauter Hitze.';

  @override
  String get monAshclaw => 'Ascheklaue';

  @override
  String get monAshclawLore =>
      'Hinterlässt schwelende Abdrücke über dem schwarzen Vulkangestein.';

  @override
  String get monFlamehorn => 'Flammenhorn';

  @override
  String get monFlamehornLore =>
      'Stürmt Lavaseen frontal an, ohne langsamer zu werden.';

  @override
  String get monScorchling => 'Sengling';

  @override
  String get monScorchlingLore =>
      'Klein, schnell und immer ein wenig zu nah dran, Feuer zu fangen.';

  @override
  String get monEmbermaw => 'Glutrachen';

  @override
  String get monEmbermawLore =>
      'Sein Biss trägt die Hitze einer Kohle, die nie ganz abkühlt.';

  @override
  String get monBlazetail => 'Lohschweif';

  @override
  String get monBlazetailLore =>
      'Ein peitschender Schweif, der eine Feuerlinie in der Asche hinterlässt.';

  @override
  String get monMagmabite => 'Magmabiss';

  @override
  String get monMagmabiteLore =>
      'Beißt sich glatt durch abgekühlte Gesteinskruste auf der Suche nach der Hitze des Ödlands.';

  @override
  String get monCharhound => 'Kohlehund';

  @override
  String get monCharhoundLore =>
      'Jagt in den erstickenden Aschewolken allein nach Geruch.';

  @override
  String get monPyrewing => 'Scheiterschwinge';

  @override
  String get monPyrewingLore =>
      'Umkreist die brennenden Ruinen auf Flügeln aus treibender Glut.';

  @override
  String get monInferclaw => 'Infernoklaue';

  @override
  String get monInferclawLore =>
      'Klauen noch heiß vom Lavasee, aus dem es gerade gekrochen ist.';

  @override
  String get monCoalback => 'Kohlerücken';

  @override
  String get monCoalbackLore =>
      'Ein gezackter Kamm, der heller glüht, je wütender es wird.';

  @override
  String get monSearscale => 'Brandschuppe';

  @override
  String get monSearscaleLore =>
      'Schuppen, die alles verbrühen, was zu nahe kommt.';

  @override
  String get monFlarefang => 'Flammenzahn';

  @override
  String get monFlarefangLore =>
      'Ein plötzlicher Ausbruch aus Licht und Zähnen aus der Aschewolke.';

  @override
  String get monBurnpaw => 'Brandpfote';

  @override
  String get monBurnpawLore =>
      'Hinterlässt versengte Pfotenabdrücke, wohin es auch geht.';

  @override
  String get monIgnisprite => 'Ignikobold';

  @override
  String get monIgnispriteLore =>
      'Ein winziger Feuergeist, geboren aus einem verirrten Funken von Ignivars eigener Flamme.';

  @override
  String get monAshenox => 'Aschenox';

  @override
  String get monAshenoxLore =>
      'Trägt einen Mantel aus treibender Asche über Haut, die darunter noch schwelt.';

  @override
  String get monMistfin => 'Nebelflosse';

  @override
  String get monMistfinLore =>
      'Gleitet durch den Korallenwald, gehüllt in einen Schleier aus kaltem Nebel.';

  @override
  String get monTideclaw => 'Gezeitenklaue';

  @override
  String get monTideclawLore =>
      'Klauen, die mit der Kraft einer steigenden Flut ziehen.';

  @override
  String get monRipplefang => 'Kräuselzahn';

  @override
  String get monRipplefangLore =>
      'Jeder Biss sendet einen Ring aus Strömung nach außen.';

  @override
  String get monAquabite => 'Aquabiss';

  @override
  String get monAquabiteLore =>
      'Klein und schnell, huscht zwischen den Säulen versunkener Tempel hindurch.';

  @override
  String get monWavepup => 'Wellenwelpe';

  @override
  String get monWavepupLore =>
      'Jung und verspielt, reitet die langsamen Tiefenströmungen des Abgrunds.';

  @override
  String get monRainscale => 'Regenschuppe';

  @override
  String get monRainscaleLore =>
      'Schuppen, die ein stetes, kaltes Rinnsal Meerwasser weinen.';

  @override
  String get monDeepfin => 'Tiefenflosse';

  @override
  String get monDeepfinLore =>
      'Taucht nie auf — der Graben ist das einzige Zuhause, das es kennt.';

  @override
  String get monBrookling => 'Bächling';

  @override
  String get monBrooklingLore =>
      'Ein Rinnsal von einem Wesen, das sich zu etwas Größerem sammelt, wenn es bedroht wird.';

  @override
  String get monFrostgill => 'Frostkieme';

  @override
  String get monFrostgillLore =>
      'Kiemen, die das Wasser eine Körperlänge weit in jede Richtung kühlen.';

  @override
  String get monStormfin => 'Sturmflosse';

  @override
  String get monStormfinLore =>
      'Wühlt das Wasser zu einer Bö auf, wohin es auch schwimmt.';

  @override
  String get monPearlmaw => 'Perlrachen';

  @override
  String get monPearlmawLore =>
      'Sein Kiefer glänzt von einem Leben voll verschluckter Perlen.';

  @override
  String get monSplashpaw => 'Spritzpfote';

  @override
  String get monSplashpawLore =>
      'Hüpft in Strömungsstößen über den Boden des versunkenen Tempels.';

  @override
  String get monDrownscale => 'Ertrinkschuppe';

  @override
  String get monDrownscaleLore =>
      'Die Legende sagt, es zog einst einen ganzen Tempel unter die Wellen.';

  @override
  String get monRiverfang => 'Flusszahn';

  @override
  String get monRiverfangLore =>
      'Älter als der Abgrund selbst, so erzählt es der Korallenwald.';

  @override
  String get monMistcrawler => 'Nebelkriecher';

  @override
  String get monMistcrawlerLore =>
      'Kriecht über den Grabenboden, wo nie Licht hingelangt ist.';

  @override
  String get monAbyssfin => 'Abgrundflosse';

  @override
  String get monAbyssfinLore =>
      'Der am tiefsten lebende von Thalassors zahllosen Untertanen.';

  @override
  String get monThornpaw => 'Dornpfote';

  @override
  String get monThornpawLore =>
      'Schreitet lautlos durch Wurzeltunnel, breiter als jede Straße.';

  @override
  String get monMossfang => 'Mooszahn';

  @override
  String get monMossfangLore =>
      'So dicht mit Moos bedeckt, dass es wie ein Teil des Dschungelbodens aussieht.';

  @override
  String get monLeafling => 'Blattling';

  @override
  String get monLeaflingLore =>
      'Klein und schnell, getarnt im überdimensionalen Blätterdach.';

  @override
  String get monRootclaw => 'Wurzelklaue';

  @override
  String get monRootclawLore =>
      'Klauen, gewachsen aus einer Wurzel, die nie aufhörte zu greifen.';

  @override
  String get monVinebeast => 'Rankenbestie';

  @override
  String get monVinebeastLore =>
      'Zieht lebende Ranken hinter sich her, während es durchs Unterholz zieht.';

  @override
  String get monBloomtail => 'Blütenschweif';

  @override
  String get monBloomtailLore =>
      'Ein blühender Schweif, der sich nur öffnet, wenn er eine Bedrohung wittert.';

  @override
  String get monPetalhorn => 'Blütenblatthorn';

  @override
  String get monPetalhornLore =>
      'Stürmt unter einer überdimensionalen, leuchtend bunten Blüte an.';

  @override
  String get monBarkhide => 'Rindenhaut';

  @override
  String get monBarkhideLore =>
      'Haut so zäh und knorrig wie die ältesten Bäume des Dschungels.';

  @override
  String get monSporeling => 'Sporling';

  @override
  String get monSporelingLore =>
      'Setzt eine feine Sporenwolke frei, sobald es erschreckt wird.';

  @override
  String get monWildthorn => 'Wilddorn';

  @override
  String get monWildthornLore =>
      'Ein Gewirr aus Dorn und Muskel, heimisch nur in der Ewigen Blüte.';

  @override
  String get monFernfang => 'Farnzahn';

  @override
  String get monFernfangLore =>
      'Beißt sich mit geübter Leichtigkeit durch die dicken Ranken des Blätterdachs.';

  @override
  String get monBrambleback => 'Dornrücken';

  @override
  String get monBramblebackLore =>
      'Ein Kamm aus ineinander verzahnten Dornen, den kein Räuber testen will.';

  @override
  String get monRootmaw => 'Wurzelrachen';

  @override
  String get monRootmawLore =>
      'Wartet unter dem Tunnelboden darauf, dass etwas darüber läuft.';

  @override
  String get monSeedlingBeast => 'Keimlingsbestie';

  @override
  String get monSeedlingBeastLore =>
      'Jung, aber schon größer als die meisten ausgewachsenen Blüte-Geschöpfe.';

  @override
  String get monIvyclaw => 'Efeuklaue';

  @override
  String get monIvyclawLore =>
      'Efeu wächst zwischen den Mahlzeiten über seine Klauen und fällt ab, wenn es jagt.';

  @override
  String get monThornbloom => 'Dornblüte';

  @override
  String get monThornbloomLore =>
      'Die älteste Blüte des Dschungels mit Klauen, nahe verwandt mit Verdantor.';

  @override
  String get monNightshade => 'Nachtschatten';

  @override
  String get monNightshadeLore =>
      'Wächst nur dort, wo Noctyras ewige Finsternis am dunkelsten fällt.';

  @override
  String get monLunawing => 'Lunaschwinge';

  @override
  String get monLunawingLore =>
      'Umkreist den wachenden Mond auf Flügeln, die nie einen Schatten werfen.';

  @override
  String get monDarkpelt => 'Dunkelpelz';

  @override
  String get monDarkpeltLore =>
      'Ein Fell so schwarz, dass es das schwache Licht der Finsternis ganz verschluckt.';

  @override
  String get monCrescentclaw => 'Sichelklaue';

  @override
  String get monCrescentclawLore =>
      'Klauen gebogen wie die Mondsichel, die dieses Reich nie ganz zu sehen bekommt.';

  @override
  String get monVoidpaw => 'Leerepfote';

  @override
  String get monVoidpawLore =>
      'Schritte hinterlassen keine Spur — das Finsternisreich vergisst, dass es je da war.';

  @override
  String get monDuskscale => 'Dämmerschuppe';

  @override
  String get monDuskscaleLore =>
      'Schuppen, für immer gefangen zwischen Tag und Nacht.';

  @override
  String get monNightmareBeast => 'Albtraumbestie';

  @override
  String get monNightmareBeastLore =>
      'Eine von Noctyras eigenem Hofstaat, geformt aus der endlosen Dunkelheit des Reichs.';

  @override
  String get monGalaxipaw => 'Galaxiepfote';

  @override
  String get monGalaxipawLore =>
      'Jeder Pfotenabdruck hält kurz einen Wirbel winziger Sterne.';

  @override
  String get monMeteorfang => 'Meteorzahn';

  @override
  String get monMeteorfangLore =>
      'Fiel auf die kosmischen Inseln, an den Rändern noch brennend.';

  @override
  String get monCelestling => 'Himmling';

  @override
  String get monCelestlingLore =>
      'Klein, aber aus demselben Licht geschöpft wie Elyndor selbst.';

  @override
  String get monVoidstar => 'Leerestern';

  @override
  String get monVoidstarLore =>
      'Ein erloschener Stern, der noch alles in seiner Nähe zu sich zieht.';

  @override
  String get monNebulabeast => 'Nebelbestie';

  @override
  String get monNebulabeastLore =>
      'Treibt zwischen den sternenbeschienenen Tempeln, gehüllt in kosmischen Dunst.';

  @override
  String get monStarlightClaw => 'Sternenlichtklaue';

  @override
  String get monStarlightClawLore =>
      'Klauen, die mit geliehenem Licht einer längst vergangenen Galaxie glühen.';

  @override
  String get monAstralmaw => 'Astralrachen';

  @override
  String get monAstralmawLore =>
      'Bewacht das Zentrum des Traumreichs an der Seite seines Herrschers.';

  @override
  String get monBoss1Ult => 'Entwirrende Blüte';

  @override
  String get monBoss1UltDesc =>
      'Die Wiese selbst schlägt in Blüte und Feuer aus.';

  @override
  String get monBoss1Lore =>
      'Einst die älteste Blüte der Wiese, entwirrt sie sich nun mit jedem Traum, den sie verschlingt, zu Dorn und Flamme.';

  @override
  String get monBoss2Ult => 'Albtraumgriff';

  @override
  String get monBoss2UltDesc =>
      'Schatten greifen aus allen Richtungen zugleich.';

  @override
  String get monBoss2Lore =>
      'Hüter der tiefsten Düsternis des Waldes, wird es umso wütender, je näher es dem Fallen kommt.';

  @override
  String get monBoss3Ult => 'Urteil des Wächters';

  @override
  String get monBoss3UltDesc => 'Eine zermalmende Woge kristallisierter Wucht.';

  @override
  String get monBoss3Lore =>
      'Ein lebender Kristall, gewachsen um einen Traum, zu schwer, um daraus zu erwachen, von allen Seiten geschützt.';

  @override
  String get monBoss4Ult => 'Sternenfall-Kataklysmus';

  @override
  String get monBoss4UltDesc =>
      'Ein Meteoritensturm kracht aus dem zersplitterten Himmel herab.';

  @override
  String get monBoss4Lore =>
      'Ein Stern, der vor Äonen vom Himmel fiel und noch mit dem Licht seines alten Himmels brennt.';

  @override
  String get monBoss5Ult => 'Albtraum-Festmahl';

  @override
  String get monBoss5UltDesc =>
      'Verschlingt die letzten wachen Gedanken seiner Beute.';

  @override
  String get monBoss5Lore =>
      'Ein uraltes Wesen, das sich von vergessenen Träumen nährt und mit jedem, den es verschluckt, feister wird.';

  @override
  String get monBoss6Ult => 'Aschefall-Abrechnung';

  @override
  String get monBoss6UltDesc =>
      'Eine Flutwelle aus geschmolzenem Gestein und Glut.';

  @override
  String get monBoss6Lore =>
      'Ein Titan aus Feuer, der tausend Jahre unter dem Ödland schlief, nun wach und rasend.';

  @override
  String get monBoss7Ult => 'Abgrundflut';

  @override
  String get monBoss7UltDesc =>
      'Eine zermalmende Woge aus dem tiefsten Graben.';

  @override
  String get monBoss7Lore =>
      'Herrscher des tiefsten Grabens im Gezeitenabgrund, sein Hofstaat sind Wesen, die nie die Oberfläche sehen.';

  @override
  String get monBoss8Ult => 'Wurzelgebundenes Urteil';

  @override
  String get monBoss8UltDesc => 'Der Waldboden bricht in Dorn und Ranke auf.';

  @override
  String get monBoss8Lore =>
      'Eine Wurzel älter als der Wald selbst, schlummernd unter der Ewigen Blüte seit vor aller Erinnerung.';

  @override
  String get monBoss9Ult => 'Herrschaft der Finsternis';

  @override
  String get monBoss9UltDesc => 'Schatten und Licht schlagen als eins zu.';

  @override
  String get monBoss9Lore =>
      'Herrscherin der ewigen Finsternis, sie regiert das Reich zu gleichen Teilen in Schatten und gestohlenem Licht.';

  @override
  String get monBoss10Ult => 'Herrschaft des Souveräns';

  @override
  String get monBoss10UltDesc =>
      'Jeder Stern am Himmel folgt seinem Ruf zugleich.';

  @override
  String get monBoss10Lore =>
      'Herrscher des höchsten Traums und der letzte, größte Wächter, dem die Traumhüter gegenübertreten müssen.';

  @override
  String get shopGemsSmallName => 'Handvoll Edelsteine';

  @override
  String get shopGemsSmallDesc => 'Ein kleines Aufstocken.';

  @override
  String get shopGemsMediumName => 'Beutel voll Edelsteine';

  @override
  String get shopGemsMediumDesc => 'Guter Wert für regelmäßiges Beschwören.';

  @override
  String get shopGemsLargeName => 'Truhe voll Edelsteine';

  @override
  String get shopGemsLargeDesc => 'Bester Wert pro Edelstein.';

  @override
  String get shopGemsMegaName => 'Tresor voll Edelsteine';

  @override
  String get shopGemsMegaDesc => 'Für ernsthafte Traumhafen-Baumeister.';

  @override
  String get shopGoldSmallName => 'Goldbeutel';

  @override
  String get shopGoldSmallDesc => 'Tausche Edelsteine gegen Gold.';

  @override
  String get shopGoldLargeName => 'Goldtruhe';

  @override
  String get shopGoldLargeDesc => 'Besserer Wechselkurs.';

  @override
  String get shopStarterPackName => 'Traumhüter-Starterpaket';

  @override
  String get shopStarterPackDesc =>
      'Einmaliger Bonus für neue Traumhafen-Baumeister: Gold und Edelsteine, um deinen Kader in Gang zu bringen.';

  @override
  String get shopVipPassName => 'VIP-Pass';

  @override
  String get shopVipPassDesc =>
      'Entfernt Belohnungsanzeigen-Aufforderungen für immer — ein dauerhaftes, einmaliges Dankeschön für die Unterstützung des Traumhafens.';

  @override
  String get shopTicketSmallName => 'Prüfungs-Ticketpaket';

  @override
  String get shopTicketSmallDesc =>
      '5 zusätzliche Versuche in der Endlosen Prüfung, zusätzlich zu deinen kostenlosen Tagestickets.';

  @override
  String get shopTicketLargeName => 'Prüfungs-Ticketbündel';

  @override
  String get shopTicketLargeDesc =>
      '15 zusätzliche Versuche in der Endlosen Prüfung — besserer Wert für einen ernsthaften Aufstieg.';

  @override
  String get shopExclusiveIgoDesc =>
      'Der Wächter der Flut selbst — tritt dauerhaft mit maximalem Level und maximalen Sternen deinem Kader bei.';

  @override
  String get shopExclusiveAmesDesc =>
      'Glut in Menschengestalt — tritt dauerhaft mit maximalem Level und maximalen Sternen deinem Kader bei.';

  @override
  String get achFirstSummonTitle => 'Erste Beschwörung';

  @override
  String get achFirstSummonDetail => 'Beschwöre deinen ersten Traumhüter.';

  @override
  String get achFirstLegendaryTitle => 'Legendär!';

  @override
  String get achFirstLegendaryDetail =>
      'Rekrutiere einen legendären Traumhüter.';

  @override
  String get achCollector5Title => 'Wachsende Sammlung';

  @override
  String get achCollector5Detail => 'Besitze 5 verschiedene Traumhüter.';

  @override
  String get achCollector10Title => 'Traumteam';

  @override
  String get achCollector10Detail => 'Besitze 10 verschiedene Traumhüter.';

  @override
  String get achFirstBossTitle => 'Bossbezwinger';

  @override
  String get achFirstBossDetail => 'Besiege deinen ersten Boss.';

  @override
  String get achStarUpTitle => 'Sternenkraft';

  @override
  String get achStarUpDetail =>
      'Verschmilz einen Traumhüter, um seine Sterne zu erhöhen.';

  @override
  String get achMaxStarsTitle => 'Voll aufgestiegen';

  @override
  String get achMaxStarsDetail =>
      'Bring einen Traumhüter auf die maximale Sternzahl.';

  @override
  String get achFullTeamTitle => 'Perfekte Truppe';

  @override
  String achFullTeamDetail(int size) {
    return 'Setze ein volles Team von $size ein.';
  }

  @override
  String get achPerfectClearTitle => 'Unberührbar';

  @override
  String get achPerfectClearDetail =>
      'Gewinne einen Kampf, ohne Schaden zu nehmen.';

  @override
  String get achAccountLevel10Title => 'Aufstrebender Träumer';

  @override
  String get achAccountLevel10Detail => 'Erreiche Kontostufe 10.';

  @override
  String get achGoldHoarderTitle => 'Goldhamster';

  @override
  String get achGoldHoarderDetail => 'Halte 5.000 Gold auf einmal.';

  @override
  String get achMonsterHunterTitle => 'Monsterjäger';

  @override
  String get achMonsterHunterDetail => 'Entdecke 10 verschiedene Monster.';

  @override
  String get achWeekStreakTitle => 'Treuer Träumer';

  @override
  String get achWeekStreakDetail => 'Löse alle 7 Tage einer Login-Serie ein.';

  @override
  String get missionWinBattle => 'Einen Abschnitt bestehen';

  @override
  String get missionPerformSummon => 'Einen Traumhüter beschwören';

  @override
  String get missionCollectBuilding => 'Von einem Gebäude abholen';

  @override
  String get missionUpgradeEquipment => 'Ein Ausrüstungsteil verbessern';

  @override
  String get missionSpendInShop => 'Den Shop besuchen';

  @override
  String get missionDefeatBoss => 'Einen Boss besiegen';

  @override
  String get missionDeployFullTeam => 'Ein volles Team aufstellen';

  @override
  String get missionPremiumBonusStages => '3 Abschnitte bestehen';

  @override
  String get missionPremiumBonusSummons => '3 Traumhüter beschwören';

  @override
  String get weeklyClearStages => '15 Abschnitte bestehen';

  @override
  String get weeklyDefeatBosses => '5 Bosse besiegen';

  @override
  String get weeklyPerformSummons => '5 Traumhüter beschwören';

  @override
  String get weeklyUpgradeEquipment => 'Ausrüstung 8-mal verbessern';

  @override
  String get weeklyVisitShop => 'Den Shop 3-mal besuchen';

  @override
  String blShieldShatters(String name) {
    return '${name}s Schild zerbricht!';
  }

  @override
  String blRefusesToFall(String name) {
    return '$name weigert sich zu fallen und kehrt mit der Flut zurück!';
  }

  @override
  String blHits(String attacker, String target, int amount) {
    return '$attacker trifft $target für $amount.';
  }

  @override
  String blFalls(String name) {
    return '$name fällt.';
  }

  @override
  String blUnleashesUltimate(String name, String ultimate) {
    return '$name entfesselt $ultimate!';
  }

  @override
  String blFrozenStill(String name) {
    return '$name erstarrt bewegungslos!';
  }

  @override
  String blMoonlightHeal(int amount) {
    return 'Das Team wird in Mondlicht gebadet und heilt $amount.';
  }

  @override
  String blEmpowersTeam(String name) {
    return '$name stärkt das ganze Team!';
  }

  @override
  String blWallOfWater(String name) {
    return '$name errichtet eine Wasserwand um das Team!';
  }

  @override
  String blUsesSkill(String name, String skill) {
    return '$name setzt $skill ein.';
  }

  @override
  String blSoothed(String name, int amount) {
    return '$name wird um $amount besänftigt.';
  }

  @override
  String blSteelsThemself(String name) {
    return '$name wappnet sich.';
  }

  @override
  String blCaughtInCurrent(String name) {
    return '$name wird von der Strömung erfasst und verlangsamt!';
  }

  @override
  String blHiddenReserves(String name, int amount) {
    return '$name greift auf verborgene Reserven zurück und heilt $amount!';
  }

  @override
  String blRage(String name) {
    return '$name gerät in Rage und schlägt härter zu!';
  }

  @override
  String blDrainsResolve(String name) {
    return '$name raubt dem Team die Entschlossenheit!';
  }

  @override
  String blFreshShieldRoots(String name) {
    return '$name lässt einen frischen Schild aus Wurzeln wachsen!';
  }

  @override
  String blLightToShadow(String name) {
    return '$name wechselt von Licht zu Schatten!';
  }

  @override
  String blSovereignForm(String name) {
    return '$name erweckt seine finale, herrscherliche Gestalt!';
  }

  @override
  String get blVictory => 'Sieg!';

  @override
  String get blDefeat => 'Niederlage...';

  @override
  String get mechHealed => 'Geheilt!';

  @override
  String get mechEnraged => 'Wütend!';

  @override
  String get mechShielded => 'Abgeschirmt!';

  @override
  String get mechDrained => 'Entzogen!';

  @override
  String get mechPhaseShift => 'Phasenwechsel!';

  @override
  String get mechAwakened => 'Erwacht!';

  @override
  String get notifDailyMissionsTitle => 'Tägliche Missionen';

  @override
  String get notifDailyMissionsBody =>
      'Neue tägliche Missionen warten im Traumhafen.';

  @override
  String get notifLoginBonusTitle => 'Tägliche Login-Belohnung';

  @override
  String get notifLoginBonusBody =>
      'Deine Login-Streak-Belohnung wartet im Traumhafen.';

  @override
  String get notifGoldFountainTitle => 'Der Goldbrunnen ist voll!';

  @override
  String get notifGoldFountainBody =>
      'Hol dir dein Gold ab, bevor es überläuft.';

  @override
  String get notifTrainingGardenTitle => 'Der Trainingsgarten ist voll!';

  @override
  String get notifTrainingGardenBody =>
      'Dein Team hat EP, die abgeholt werden können.';

  @override
  String codexUltimateDetail(int attacks, String power) {
    return 'Lädt nach $attacks Angriffen · ×$power Stärke';
  }

  @override
  String codexActiveSkillDetail(int seconds, String power) {
    return '$seconds s Abklingzeit · ×$power Stärke';
  }

  @override
  String get codexTwinBondCategory => 'Zwillingsbund';

  @override
  String get codexTwinBondDescIgo =>
      'Zwillingsbund: +75% ATK/DEF — nur aktiv, wenn Ames ebenfalls in der Kampfformation steht.';

  @override
  String get codexTwinBondDescAmes =>
      'Zwillingsbund: +75% ATK/DEF — nur aktiv, wenn Igo ebenfalls in der Kampfformation steht.';

  @override
  String get codexTwinBondActive => 'Aktiv';

  @override
  String get codexTwinBondInactive => 'Inaktiv';

  @override
  String get codexPassiveAlwaysActive => 'Immer aktiv';

  @override
  String get commonCollected => 'Eingesammelt!';

  @override
  String get achUnlockedLabel => 'Freigeschaltet';

  @override
  String get teamDefaultName => 'Hauptteam';

  @override
  String get arenaRivalNightblade => 'Team Nachtklinge';

  @override
  String get arenaRivalStarshadow => 'Team Sternenschatten';

  @override
  String get arenaRivalEmbermane => 'Team Glutmähne';

  @override
  String get arenaRivalRiverghost => 'Team Flussgeist';

  @override
  String get arenaRivalRootbond => 'Team Wurzelbund';

  @override
  String get arenaRivalCrescent => 'Team Mondsichel';

  @override
  String get arenaRivalAshcrown => 'Team Aschekrone';

  @override
  String get arenaRivalDeepcall => 'Team Tiefenruf';

  @override
  String get arenaRivalLightbreaker => 'Team Lichtbrecher';

  @override
  String get arenaRivalStormeye => 'Team Sturmauge';

  @override
  String get rebirthTitle => 'Wiedergeburt';

  @override
  String get rebirthBlurb =>
      'Setze den Turm der Endlosprüfung zurück, um Seelenpunkte zu sammeln, und gib sie für dauerhafte kontoweite Boni aus.';

  @override
  String get rebirthSoulPointsLabel => 'Seelenpunkte';

  @override
  String rebirthCountLabel(int count) {
    return 'Durchgeführte Wiedergeburten: $count';
  }

  @override
  String get rebirthButton => 'Jetzt wiedergeboren werden';

  @override
  String rebirthGainPreview(int points) {
    return 'Diese Wiedergeburt bringt +$points Seelenpunkte';
  }

  @override
  String get rebirthResetWarning =>
      'Der Prüfungsturm wird auf Etage 1 zurückgesetzt. Dein Team, Gold, Edelsteine und die Ausrüstung bleiben erhalten.';

  @override
  String rebirthRequirementNotMet(int floor) {
    return 'Erreiche Etage $floor der Endlosprüfung, um die Wiedergeburt freizuschalten.';
  }

  @override
  String get rebirthUpgradesTitle => 'Seelen-Verbesserungen';

  @override
  String rebirthUpgradeRank(int current, int max) {
    return 'Rang $current/$max';
  }

  @override
  String rebirthUpgradeCost(int cost) {
    return '$cost SP';
  }

  @override
  String get rebirthMaxed => 'Maximum erreicht';

  @override
  String get rebirthEntrySubtitle => 'Prestige für dauerhafte Boni';

  @override
  String get rebirthConfirmTitle => 'Wiedergeburt durchführen?';

  @override
  String get soulUpgradeGoldFindName => 'Goldfund';

  @override
  String get soulUpgradeGoldFindDetail => '+4% Gold aus allen Quellen pro Rang';

  @override
  String get soulUpgradeExpBoostName => 'EP-Schub';

  @override
  String get soulUpgradeExpBoostDetail => '+4% EP aus allen Quellen pro Rang';

  @override
  String get soulUpgradeDamageName => 'Schaden';

  @override
  String get soulUpgradeDamageDetail => '+2% Teamschaden pro Rang';

  @override
  String get soulUpgradeOfflineName => 'Offline-Belohnungen';

  @override
  String get soulUpgradeOfflineDetail =>
      '+10% Offline-Gebäudebelohnungen pro Rang';

  @override
  String get navDungeons => 'Schlünde';

  @override
  String get dungeonWhisperwoodName => 'Flüsterwald';

  @override
  String get dungeonWhisperwoodBlurb =>
      'Ein stiller Wald aus treibenden Sporen. Ein sanfter erster Abstieg.';

  @override
  String get dungeonGloomvaultName => 'Düstergruft';

  @override
  String get dungeonGloomvaultBlurb =>
      'Mondbeschienene Hallen unter der alten Feste. Die Dunkelheit beißt zurück.';

  @override
  String get dungeonStarspireName => 'Sternenspitze';

  @override
  String get dungeonStarspireBlurb =>
      'Ein Turm, der den Nachthimmel durchbohrt. Nur die stärksten Teams kehren zurück.';

  @override
  String dungeonBossName(String name) {
    return '$name-Wächter';
  }

  @override
  String dungeonWaveEnemyName(int wave) {
    return 'Welle-$wave-Meute';
  }

  @override
  String blNextWave(String name) {
    return 'Eine neue Welle rückt an – $name!';
  }

  @override
  String dungeonBattleLabel(String name, int current, int total) {
    return '$name · Welle $current/$total';
  }

  @override
  String get dungeonKeysTitle => 'Dungeon-Schlüssel';

  @override
  String get dungeonKeysBlurb =>
      'Ein Schlüssel pro Lauf. Füllt sich täglich auf.';

  @override
  String get dungeonNoKeysTitle => 'Keine Schlüssel mehr';

  @override
  String get dungeonNoKeysBody =>
      'Du hast heute alle Dungeon-Schlüssel verbraucht. Komm morgen wieder.';

  @override
  String dungeonRecommendedLevel(int level) {
    return 'Empfohlenes Team-Lv $level';
  }

  @override
  String get dungeonRewardItem => 'Ausrüstung';

  @override
  String get dungeonEnter => 'Betreten';

  @override
  String get dungeonFarmRun => 'Farm-Lauf';

  @override
  String get dungeonResultDefeat => 'Besiegt';

  @override
  String get dungeonFirstClearTitle => 'Erster Abschluss!';

  @override
  String get dungeonFirstClearBody =>
      'Du hast diesen Schlund zum ersten Mal abgeschlossen – Bonusbelohnung erhalten.';

  @override
  String get dungeonFirstClearReward => 'ERSTABSCHLUSS-BELOHNUNG';

  @override
  String get dungeonFarmReward => 'FARM-BELOHNUNG';

  @override
  String get dungeonBackToHub => 'Zurück zu den Schlünden';

  @override
  String havenDungeonKeys(int remaining, int max) {
    return '$remaining/$max Schlüssel';
  }
}
