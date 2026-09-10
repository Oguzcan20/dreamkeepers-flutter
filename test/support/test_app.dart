import 'package:flutter/material.dart';

import 'package:dreamkeepers/l10n/l10n.dart';

/// `MaterialApp` wrapper for widget tests that carries the same
/// localization delegates as `main.dart`, so `AppLocalizations.of(context)`
/// resolves the strings instead of throwing on a missing scope. Defaults
/// to English; pass `locale: const Locale('de')` to exercise German.
Widget testApp(Widget home, {Locale locale = const Locale('en')}) => MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    );
