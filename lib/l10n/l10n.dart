import 'dart:ui';

import 'gen/app_localizations.dart';
import 'gen/app_localizations_en.dart';

export 'gen/app_localizations.dart';

/// Locales the game ships translations for. English is the fallback for
/// any unset or unsupported preference.
const List<Locale> kSupportedLocales = [Locale('en'), Locale('de')];

/// Global handle on the active translations for code that has no
/// `BuildContext` — game-logic strings (local notifications, reward
/// toasts) produced deep inside `GameState` and the progression systems.
/// Widgets keep using `AppLocalizations.of(context)`.
///
/// Assigned once by `main()` before `runApp` and never reassigned: a
/// language change forces a full app restart (see `SettingsView`), so the
/// value here stays correct for the whole life of the process.
late AppLocalizations L;

/// Always-English translations, regardless of the player's chosen language.
/// Hand-illustrated art (`assets/art/`) is bundled and named once, in
/// English, at authoring time — it never gets a per-locale re-shoot. So
/// every catalog entry keeps a second, locale-invariant `artName` resolved
/// through this instance instead of `L`, and every `DreamkeeperArt`/
/// `MonsterArt`/`ArenaArt` lookup (directly, or via `Combatant.
/// portraitOverrideName`) must use that `artName`, never the localized
/// `name` — otherwise every entry whose translated name differs from its
/// English one (most of them, once a non-English locale is active) silently
/// loses its art to the icon-badge fallback.
// ignore: non_constant_identifier_names
final AppLocalizations LEn = AppLocalizationsEn();

/// Resolves the stored `preferredLanguage` ("de" / "en" / null) to a
/// concrete [Locale]. `null` means "follow the device language" (mirrors
/// Swift's `.autoupdatingCurrent`); anything unsupported falls back to
/// English.
Locale resolvePreferredLocale(String? languageCode) {
  if (languageCode != null) {
    for (final locale in kSupportedLocales) {
      if (locale.languageCode == languageCode) return locale;
    }
    return const Locale('en');
  }
  final system = PlatformDispatcher.instance.locale;
  for (final locale in kSupportedLocales) {
    if (locale.languageCode == system.languageCode) return locale;
  }
  return const Locale('en');
}

Future<void> loadGlobalLocalizations(Locale locale) async {
  L = await AppLocalizations.delegate.load(locale);
}
