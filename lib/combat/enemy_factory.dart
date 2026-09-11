import 'package:uuid/uuid.dart';

import '../data/monster_catalog.dart';
import '../data/world_catalog.dart';
import '../models/element.dart';
import '../models/rarity.dart';
import '../models/role.dart';
import '../models/skill.dart';
import '../models/world.dart';
import 'combatant.dart';

const _uuid = Uuid();

/// Procedural single-enemy encounters, themed by the stage's World. Hand-
/// authored encounter tables can replace this later without touching
/// BattleEngine — both just produce a `Combatant`. Mirrors
/// GameCore/Combat/EnemyFactory.swift exactly.
class EnemyFactory {
  /// Modest stat bump for rarer regular monsters, same philosophy as
  /// `EquipmentFactory.rollRarity`'s multiplier — flavor becomes a real,
  /// if small, mechanical difference rather than pure cosmetics.
  static double _rarityMultiplier(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return 1.0;
      case Rarity.uncommon:
        return 1.08;
      case Rarity.rare:
        return 1.18;
      case Rarity.epic:
        return 1.3;
      case Rarity.legendary:
        return 1.45;
      case Rarity.mythic:
        return 1.6;
      case Rarity.exclusive:
        return 1.6; // Enemies never actually roll .exclusive; kept for switch exhaustiveness.
    }
  }

  static Combatant enemy(int stage) {
    final world = WorldCatalog.world(stage);
    final isBoss = stage % World.stagesPerWorld == 0;
    // Linear per-stage growth stacked with a per-world tier multiplier, so
    // difficulty jumps feel tiered instead of only smoothly linear across
    // all 150 stages.
    final scale = (1.0 + (stage - 1) * 0.22) * world.difficultyMultiplier;
    final bossScale = isBoss ? 1.6 : 1.0;

    final String name;
    // Locale-invariant English counterpart of `name`, fed to
    // `Combatant.portraitOverrideName` so `MonsterArt` lookup keeps working
    // outside English — see `LEn` in `l10n.dart`.
    final String artName;
    final String symbol;
    final Role role;
    final GameElement element;
    final UltimateSkill? ultimate;
    final BossMechanic? mechanic;
    final double rarityScale;

    if (isBoss) {
      final boss = MonsterCatalog.boss(world.id);
      name = world.bossName;
      artName = world.artBossName;
      symbol = boss.symbol;
      role = Role.tank;
      element = world.elementBias[stage % world.elementBias.length];
      ultimate = boss.ultimate;
      mechanic = boss.mechanic;
      rarityScale = 1.0;
    } else {
      final monster = MonsterCatalog.regularMonster(world.id, stage);
      name = monster.name;
      artName = monster.artName;
      symbol = monster.symbol;
      role = monster.role;
      element = world.elementBias[stage % world.elementBias.length];
      ultimate = null;
      mechanic = null;
      rarityScale = _rarityMultiplier(monster.rarity);
    }

    final totalScale = scale * bossScale * rarityScale;
    return Combatant(
      id: _uuid.v4(),
      name: name,
      element: element,
      role: role,
      isPlayer: false,
      isBoss: isBoss,
      maxHP: (60 * totalScale).roundToDouble(),
      currentHP: (60 * totalScale).roundToDouble(),
      attack: (11 * totalScale).roundToDouble(),
      defense: (5 * totalScale).roundToDouble(),
      speed: (45 + stage).roundToDouble(),
      ultimate: ultimate,
      symbol: symbol,
      mechanic: mechanic,
      shieldCharges: mechanic == BossMechanic.shield ? 3 : 0,
      portraitOverrideName: artName,
    );
  }
}
