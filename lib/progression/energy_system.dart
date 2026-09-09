/// Stamina gate on how many stages can be fought or swept back-to-back.
/// Regenerates passively over real time, tops up from missions/login
/// rewards, or can be bought outright with Dream Gems a limited number of
/// times per day. Pure, testable math — GameState owns the persisted clock
/// and gem spend. Mirrors GameCore/Progression/EnergySystem.swift exactly.
class EnergySystem {
  static const maxEnergy = 100;

  /// Cost per stage attempt — a normal fight and a Sweep pay the same for
  /// a given stage, since both grant identical rewards for it. Boss stages
  /// (last stage of a world) cost double a normal stage.
  static const normalStageCost = 5;
  static const bossStageCost = 10;

  /// Convenience for call sites that already know whether the stage is a
  /// boss stage (`stage % World.stagesPerWorld == 0`).
  static int stageCost({required bool isBoss}) =>
      isBoss ? bossStageCost : normalStageCost;

  /// Seconds for one point of Energy to regenerate. 100 max / 5 cost means
  /// a full bar covers 20 normal stages (or 10 boss stages).
  static const regenIntervalSeconds = 180;

  static const energyPerRefill = 30;
  static const maxRefillsPerDay = 5;

  /// Gem cost climbs with each refill already bought today (resets at
  /// midnight) — keeps the first top-up cheap while discouraging buying
  /// the whole day's energy in one go.
  static int refillGemCost(int refillsUsedToday) => 20 + refillsUsedToday * 10;
}
