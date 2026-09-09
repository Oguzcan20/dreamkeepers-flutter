/// Shared duplicate-fusion math for both Dreamkeepers and Equipment: instead
/// of instantly converting a duplicate pull/drop into a star, every
/// duplicate becomes its own real inventory copy, and the player manually
/// picks which ones to feed into a fusion (see GameState.fuseDreamkeeper).
/// Star N costs 4*N duplicates, so reaching max star costs 4+8+12+16+20 = 60
/// duplicates total across the five tiers.
/// Mirrors GameCore/Progression/StarFusionSystem.swift exactly.
class StarFusionSystem {
  static const maxStars = 5;

  /// Duplicates required to fuse from `tier - 1` stars up to `tier` stars.
  /// `tier` is 1-indexed (the star level being fused *into*).
  static int duplicatesRequired(int tier) => tier * 4;

  /// Whether `stars` at `duplicatesOwned` can fuse one tier higher.
  static bool canFuse({required int stars, required int duplicatesOwned}) {
    if (stars >= maxStars) return false;
    return duplicatesOwned >= duplicatesRequired(stars + 1);
  }

  /// Banks `newDuplicates` onto `progress` and resolves as many tier-ups as
  /// the combined total supports (usually zero or one, but a big batch — or
  /// progress already sitting close to the threshold — can clear more than
  /// one at once).
  static (int stars, int progress) applyFusion({
    required int newDuplicates,
    required int stars,
    required int progress,
  }) {
    var s = stars;
    var p = progress + newDuplicates;
    while (s < maxStars && p >= duplicatesRequired(s + 1)) {
      p -= duplicatesRequired(s + 1);
      s += 1;
    }
    return (s, p);
  }

  /// Per-star stat multiplier, matching the existing 6%-of-base-per-star
  /// bonus so equipment fusion feels consistent with Dreamkeeper fusion.
  static const statBonusPerStar = 0.06;
}
