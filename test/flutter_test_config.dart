import 'dart:async';

import 'package:dreamkeepers/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Runs once before the whole test suite. `main()` assigns the global [L]
/// before `runApp`; the test harness never calls `main()`, so any
/// game-logic string that reads `L` (catalog names, `displayName` getters,
/// reward toasts) would hit a `LateInitializationError` without this.
/// English matches every existing widget test's default locale.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadGlobalLocalizations(const Locale('en'));
  await testMain();
}
