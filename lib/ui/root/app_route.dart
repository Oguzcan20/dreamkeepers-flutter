import '../../state/game_state.dart';

/// Every screen `RootView` can show. Mirrors Swift's `AppRoute` enum
/// (UI/Root/RootView.swift) exactly, as a Dart 3 sealed class hierarchy
/// instead of an enum with associated values (Dart enums can't carry a
/// payload the way Swift's `case result(BattleResultSummary)` can) — switch
/// on it with a `switch` type-pattern for exhaustiveness checking, the same
/// safety Swift's own exhaustive `switch route` gets from the compiler.
sealed class AppRoute {
  const AppRoute();
}

class MainMenuRoute extends AppRoute {
  const MainMenuRoute();
}

class DreamHavenRoute extends AppRoute {
  const DreamHavenRoute();
}

class TeamRoute extends AppRoute {
  const TeamRoute();
}

class CampaignRoute extends AppRoute {
  const CampaignRoute();
}

class SummonRoute extends AppRoute {
  const SummonRoute();
}

class ShopRoute extends AppRoute {
  const ShopRoute();
}

class SettingsRoute extends AppRoute {
  const SettingsRoute();
}

class ProfileRoute extends AppRoute {
  const ProfileRoute();
}

class ObservatoryRoute extends AppRoute {
  const ObservatoryRoute();
}

class BattlePassRoute extends AppRoute {
  const BattlePassRoute();
}

class CodexRoute extends AppRoute {
  const CodexRoute();
}

class BattleRoute extends AppRoute {
  const BattleRoute();
}

class BattleResultRoute extends AppRoute {
  final BattleResultSummary summary;
  const BattleResultRoute(this.summary);
}

class ArenaRoute extends AppRoute {
  const ArenaRoute();
}

class ArenaBattleRoute extends AppRoute {
  /// Which floor to fight — Dart has no analog of Swift's `RootView`-hoisted
  /// `activeArenaEngine` `@State`, so the floor rides along on the route
  /// itself instead, the same way [ArenaResultRoute] carries its summary.
  final int floor;
  const ArenaBattleRoute(this.floor);
}

class ArenaResultRoute extends AppRoute {
  final ArenaBattleResultSummary summary;
  const ArenaResultRoute(this.summary);
}
