import 'package:flutter_test/flutter_test.dart';

import 'package:dreamkeepers/progression/rebirth_system.dart';

void main() {
  group('RebirthSystem.soulPointsForFloor', () {
    test('floor 1 banks nothing', () {
      expect(RebirthSystem.soulPointsForFloor(1), 0);
    });

    test('one Soul Point per five floors climbed', () {
      expect(RebirthSystem.soulPointsForFloor(6), 1);
      expect(RebirthSystem.soulPointsForFloor(50), 9);
      expect(RebirthSystem.soulPointsForFloor(100), 19);
    });

    test('is monotonic across the whole tower', () {
      var previous = -1;
      for (var floor = 1; floor <= 101; floor++) {
        final value = RebirthSystem.soulPointsForFloor(floor);
        expect(value, greaterThanOrEqualTo(previous));
        previous = value;
      }
    });
  });

  group('RebirthSystem.effectMultiplier', () {
    test('rank 0 is a no-op for every track', () {
      for (final u in SoulUpgrade.values) {
        expect(RebirthSystem.effectMultiplier(u, 0), 1.0);
      }
    });

    test('scales linearly by effectPerRank', () {
      expect(RebirthSystem.effectMultiplier(SoulUpgrade.goldFind, 3), closeTo(1.12, 1e-9));
      expect(RebirthSystem.effectMultiplier(SoulUpgrade.damage, 5), closeTo(1.10, 1e-9));
      expect(RebirthSystem.effectMultiplier(SoulUpgrade.offlineRewards, 2), closeTo(1.20, 1e-9));
    });

    test('clamps to the track max rank', () {
      final maxed = RebirthSystem.effectMultiplier(
          SoulUpgrade.offlineRewards, RebirthSystem.maxRank(SoulUpgrade.offlineRewards));
      expect(RebirthSystem.effectMultiplier(SoulUpgrade.offlineRewards, 999), maxed);
    });
  });

  group('RebirthSystem.costForRank', () {
    test('escalates with each rank', () {
      final costs = [
        for (var rank = 1; rank <= RebirthSystem.maxRank(SoulUpgrade.goldFind); rank++)
          RebirthSystem.costForRank(SoulUpgrade.goldFind, rank)
      ];
      for (var i = 1; i < costs.length; i++) {
        expect(costs[i], greaterThan(costs[i - 1]));
      }
    });

    test('first rank costs the track base cost', () {
      expect(RebirthSystem.costForRank(SoulUpgrade.goldFind, 1), 2);
      expect(RebirthSystem.costForRank(SoulUpgrade.damage, 1), 3);
    });
  });
}
