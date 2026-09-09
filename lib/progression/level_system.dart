/// Pure, testable EXP/leveling rules. Kept independent of persistence and UI
/// so it can be unit tested and reused for both Dreamkeepers and the Player.
/// Mirrors GameCore/Progression/LevelSystem.swift exactly.
class LevelSystem {
  static const maxLevel = 50;

  /// Dream EXP required to advance from `level` to `level + 1`.
  static int expToNextLevel(int level) {
    if (level >= maxLevel) return 0x7FFFFFFFFFFFFFFF;
    return 20 + level * 15;
  }

  /// Applies gained EXP, resolving as many level-ups as the EXP allows.
  static LevelUpResult applyExp(int gained, {required int level, required int exp}) {
    var lvl = level;
    var xp = exp + gained;
    var levelsGained = 0;

    while (lvl < maxLevel) {
      final required = expToNextLevel(lvl);
      if (xp < required) break;
      xp -= required;
      lvl += 1;
      levelsGained += 1;
    }

    if (lvl >= maxLevel) xp = 0;

    return LevelUpResult(finalLevel: lvl, finalExp: xp, levelsGained: levelsGained);
  }
}

class LevelUpResult {
  final int finalLevel;
  final int finalExp;
  final int levelsGained;

  const LevelUpResult({
    required this.finalLevel,
    required this.finalExp,
    required this.levelsGained,
  });

  @override
  bool operator ==(Object other) =>
      other is LevelUpResult &&
      finalLevel == other.finalLevel &&
      finalExp == other.finalExp &&
      levelsGained == other.levelsGained;

  @override
  int get hashCode => Object.hash(finalLevel, finalExp, levelsGained);
}
