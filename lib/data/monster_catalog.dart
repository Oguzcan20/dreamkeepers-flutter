import '../combat/combatant.dart';
import '../l10n/l10n.dart';
import '../models/rarity.dart';
import '../models/role.dart';
import '../models/skill.dart';
import '../models/world.dart';
import 'world_catalog.dart';

/// A single regular-encounter species. Pure flavor + a light stat/role tag —
/// `EnemyFactory` keeps all the scaling math, so adding a monster is always
/// just appending a line here, never touching gameplay code.
class MonsterKind {
  final String name;
  final String symbol;
  final String lore;
  final Role role;
  final Rarity rarity;

  const MonsterKind({
    required this.name,
    required this.symbol,
    required this.lore,
    this.role = Role.damage,
    this.rarity = Rarity.common,
  });
}

/// A unique boss identity for a world's final stage.
class BossKind {
  final String symbol;
  final UltimateSkill ultimate;
  final BossMechanic mechanic;
  final String lore;

  const BossKind({
    required this.symbol,
    required this.ultimate,
    required this.mechanic,
    required this.lore,
  });
}

/// Per-world regular enemy rosters and unique boss identities, keyed by
/// `World.id`. Pure flavor data — EnemyFactory keeps all the scaling math,
/// and nothing here ever branches on a specific monster's identity. Mirrors
/// GameCore/Data/MonsterCatalog.swift exactly.
class MonsterCatalog {
  static final Map<int, List<MonsterKind>> _regularsByWorld = {
    1: [
      MonsterKind(name: L.monBrambleStalker, symbol: "leaf.fill", lore: L.monBrambleStalkerLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monDustWisp, symbol: "wind", lore: L.monDustWispLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monMeadowSprite, symbol: "ladybug.fill", lore: L.monMeadowSpriteLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monSunpetalGuardian, symbol: "sun.max.fill", lore: L.monSunpetalGuardianLore, role: Role.damage, rarity: Rarity.common),
    ],
    2: [
      MonsterKind(name: L.monGloomHound, symbol: "moon.fill", lore: L.monGloomHoundLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monHollowShade, symbol: "theatermask.and.paintbrush.fill", lore: L.monHollowShadeLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monNightWisp, symbol: "sparkle", lore: L.monNightWispLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monThornbackProwler, symbol: "pawprint.fill", lore: L.monThornbackProwlerLore, role: Role.damage, rarity: Rarity.common),
    ],
    3: [
      MonsterKind(name: L.monRiftCrawler, symbol: "hexagon.fill", lore: L.monRiftCrawlerLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monFrostWisp, symbol: "snowflake", lore: L.monFrostWispLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monCavernSerpent, symbol: "tropicalstorm", lore: L.monCavernSerpentLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monCrystalWisp, symbol: "diamond.fill", lore: L.monCrystalWispLore, role: Role.damage, rarity: Rarity.common),
    ],
    4: [
      MonsterKind(name: L.monStarfang, symbol: "sparkles", lore: L.monStarfangLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monCometpaw, symbol: "sparkle", lore: L.monCometpawLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monAstralwing, symbol: "hexagon.fill", lore: L.monAstralwingLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monStardustling, symbol: "diamond.fill", lore: L.monStardustlingLore, role: Role.healer, rarity: Rarity.uncommon),
      MonsterKind(name: L.monCosmobite, symbol: "sparkles", lore: L.monCosmobiteLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monNebulaclaw, symbol: "sparkle", lore: L.monNebulaclawLore, role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: L.monStarhorn, symbol: "hexagon.fill", lore: L.monStarhornLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monCometscale, symbol: "diamond.fill", lore: L.monCometscaleLore, role: Role.control, rarity: Rarity.uncommon),
    ],
    5: [
      MonsterKind(name: L.monMoonfang, symbol: "moon.fill", lore: L.monMoonfangLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monDuskhorn, symbol: "moon.stars.fill", lore: L.monDuskhornLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monNightclaw, symbol: "theatermask.and.paintbrush.fill", lore: L.monNightclawLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monShadowtail, symbol: "moon.fill", lore: L.monShadowtailLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monEclipsepaw, symbol: "moon.stars.fill", lore: L.monEclipsepawLore, role: Role.control, rarity: Rarity.rare),
      MonsterKind(name: L.monDreamstalker, symbol: "theatermask.and.paintbrush.fill", lore: L.monDreamstalkerLore, role: Role.support, rarity: Rarity.uncommon),
      MonsterKind(name: L.monMoonscale, symbol: "moon.fill", lore: L.monMoonscaleLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monGloomfang, symbol: "moon.stars.fill", lore: L.monGloomfangLore, role: Role.damage, rarity: Rarity.uncommon),
    ],
    6: [
      MonsterKind(name: L.monCinderfang, symbol: "flame.fill", lore: L.monCinderfangLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monAshclaw, symbol: "sun.max.fill", lore: L.monAshclawLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monFlamehorn, symbol: "bolt.fill", lore: L.monFlamehornLore, role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: L.monScorchling, symbol: "flame.fill", lore: L.monScorchlingLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monEmbermaw, symbol: "sun.max.fill", lore: L.monEmbermawLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monBlazetail, symbol: "bolt.fill", lore: L.monBlazetailLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monMagmabite, symbol: "flame.fill", lore: L.monMagmabiteLore, role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: L.monCharhound, symbol: "sun.max.fill", lore: L.monCharhoundLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monPyrewing, symbol: "bolt.fill", lore: L.monPyrewingLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monInferclaw, symbol: "flame.fill", lore: L.monInferclawLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monCoalback, symbol: "sun.max.fill", lore: L.monCoalbackLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monSearscale, symbol: "bolt.fill", lore: L.monSearscaleLore, role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: L.monFlarefang, symbol: "flame.fill", lore: L.monFlarefangLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monBurnpaw, symbol: "sun.max.fill", lore: L.monBurnpawLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monIgnisprite, symbol: "bolt.fill", lore: L.monIgnispriteLore, role: Role.healer, rarity: Rarity.rare),
      MonsterKind(name: L.monAshenox, symbol: "flame.fill", lore: L.monAshenoxLore, role: Role.tank, rarity: Rarity.uncommon),
    ],
    7: [
      MonsterKind(name: L.monMistfin, symbol: "drop.fill", lore: L.monMistfinLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monTideclaw, symbol: "snowflake", lore: L.monTideclawLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monRipplefang, symbol: "tropicalstorm", lore: L.monRipplefangLore, role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: L.monAquabite, symbol: "drop.fill", lore: L.monAquabiteLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monWavepup, symbol: "snowflake", lore: L.monWavepupLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monRainscale, symbol: "tropicalstorm", lore: L.monRainscaleLore, role: Role.healer, rarity: Rarity.uncommon),
      MonsterKind(name: L.monDeepfin, symbol: "drop.fill", lore: L.monDeepfinLore, role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: L.monBrookling, symbol: "snowflake", lore: L.monBrooklingLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monFrostgill, symbol: "tropicalstorm", lore: L.monFrostgillLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monStormfin, symbol: "drop.fill", lore: L.monStormfinLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monPearlmaw, symbol: "snowflake", lore: L.monPearlmawLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monSplashpaw, symbol: "tropicalstorm", lore: L.monSplashpawLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monDrownscale, symbol: "drop.fill", lore: L.monDrownscaleLore, role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: L.monRiverfang, symbol: "snowflake", lore: L.monRiverfangLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monMistcrawler, symbol: "tropicalstorm", lore: L.monMistcrawlerLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monAbyssfin, symbol: "drop.fill", lore: L.monAbyssfinLore, role: Role.damage, rarity: Rarity.uncommon),
    ],
    8: [
      MonsterKind(name: L.monThornpaw, symbol: "leaf.fill", lore: L.monThornpawLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monMossfang, symbol: "ladybug.fill", lore: L.monMossfangLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monLeafling, symbol: "wind", lore: L.monLeaflingLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monRootclaw, symbol: "leaf.fill", lore: L.monRootclawLore, role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: L.monVinebeast, symbol: "ladybug.fill", lore: L.monVinebeastLore, role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: L.monBloomtail, symbol: "wind", lore: L.monBloomtailLore, role: Role.control, rarity: Rarity.common),
      MonsterKind(name: L.monPetalhorn, symbol: "leaf.fill", lore: L.monPetalhornLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monBarkhide, symbol: "ladybug.fill", lore: L.monBarkhideLore, role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: L.monSporeling, symbol: "wind", lore: L.monSporelingLore, role: Role.healer, rarity: Rarity.uncommon),
      MonsterKind(name: L.monWildthorn, symbol: "leaf.fill", lore: L.monWildthornLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monFernfang, symbol: "ladybug.fill", lore: L.monFernfangLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monBrambleback, symbol: "wind", lore: L.monBramblebackLore, role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: L.monRootmaw, symbol: "leaf.fill", lore: L.monRootmawLore, role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: L.monSeedlingBeast, symbol: "ladybug.fill", lore: L.monSeedlingBeastLore, role: Role.support, rarity: Rarity.common),
      MonsterKind(name: L.monIvyclaw, symbol: "wind", lore: L.monIvyclawLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monThornbloom, symbol: "leaf.fill", lore: L.monThornbloomLore, role: Role.damage, rarity: Rarity.uncommon),
    ],
    9: [
      MonsterKind(name: L.monNightshade, symbol: "theatermask.and.paintbrush.fill", lore: L.monNightshadeLore, role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: L.monLunawing, symbol: "moon.fill", lore: L.monLunawingLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monDarkpelt, symbol: "moon.stars.fill", lore: L.monDarkpeltLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monCrescentclaw, symbol: "theatermask.and.paintbrush.fill", lore: L.monCrescentclawLore, role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: L.monVoidpaw, symbol: "moon.fill", lore: L.monVoidpawLore, role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: L.monDuskscale, symbol: "moon.stars.fill", lore: L.monDuskscaleLore, role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: L.monNightmareBeast, symbol: "theatermask.and.paintbrush.fill", lore: L.monNightmareBeastLore, role: Role.damage, rarity: Rarity.rare),
    ],
    10: [
      MonsterKind(name: L.monGalaxipaw, symbol: "sparkles", lore: L.monGalaxipawLore, role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: L.monMeteorfang, symbol: "sparkle", lore: L.monMeteorfangLore, role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: L.monCelestling, symbol: "hexagon.fill", lore: L.monCelestlingLore, role: Role.support, rarity: Rarity.uncommon),
      MonsterKind(name: L.monVoidstar, symbol: "diamond.fill", lore: L.monVoidstarLore, role: Role.control, rarity: Rarity.rare),
      MonsterKind(name: L.monNebulabeast, symbol: "sparkles", lore: L.monNebulabeastLore, role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: L.monStarlightClaw, symbol: "sparkle", lore: L.monStarlightClawLore, role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: L.monAstralmaw, symbol: "hexagon.fill", lore: L.monAstralmawLore, role: Role.tank, rarity: Rarity.legendary),
    ],
  };

  static final Map<int, BossKind> _bossesByWorld = {
    1: BossKind(
      symbol: "flame.fill",
      ultimate: UltimateSkill(
        name: L.monBoss1Ult,
        description: L.monBoss1UltDesc,
        damageMultiplier: 1.8,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.selfHeal,
      lore: L.monBoss1Lore,
    ),
    2: BossKind(
      symbol: "moon.stars.fill",
      ultimate: UltimateSkill(
        name: L.monBoss2Ult,
        description: L.monBoss2UltDesc,
        damageMultiplier: 2.0,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.enrage,
      lore: L.monBoss2Lore,
    ),
    3: BossKind(
      symbol: "diamond.fill",
      ultimate: UltimateSkill(
        name: L.monBoss3Ult,
        description: L.monBoss3UltDesc,
        damageMultiplier: 1.9,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.shield,
      lore: L.monBoss3Lore,
    ),
    4: BossKind(
      symbol: "star.fill",
      ultimate: UltimateSkill(
        name: L.monBoss4Ult,
        description: L.monBoss4UltDesc,
        damageMultiplier: 1.9,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.shield,
      lore: L.monBoss4Lore,
    ),
    5: BossKind(
      symbol: "moon.stars.fill",
      ultimate: UltimateSkill(
        name: L.monBoss5Ult,
        description: L.monBoss5UltDesc,
        damageMultiplier: 1.85,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.drain,
      lore: L.monBoss5Lore,
    ),
    6: BossKind(
      symbol: "flame.fill",
      ultimate: UltimateSkill(
        name: L.monBoss6Ult,
        description: L.monBoss6UltDesc,
        damageMultiplier: 2.0,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.enrage,
      lore: L.monBoss6Lore,
    ),
    7: BossKind(
      symbol: "tropicalstorm",
      ultimate: UltimateSkill(
        name: L.monBoss7Ult,
        description: L.monBoss7UltDesc,
        damageMultiplier: 1.85,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.selfHeal,
      lore: L.monBoss7Lore,
    ),
    8: BossKind(
      symbol: "leaf.fill",
      ultimate: UltimateSkill(
        name: L.monBoss8Ult,
        description: L.monBoss8UltDesc,
        damageMultiplier: 1.9,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.regenShield,
      lore: L.monBoss8Lore,
    ),
    9: BossKind(
      symbol: "moon.fill",
      ultimate: UltimateSkill(
        name: L.monBoss9Ult,
        description: L.monBoss9UltDesc,
        damageMultiplier: 2.0,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.phaseShift,
      lore: L.monBoss9Lore,
    ),
    10: BossKind(
      symbol: "sparkles",
      ultimate: UltimateSkill(
        name: L.monBoss10Ult,
        description: L.monBoss10UltDesc,
        damageMultiplier: 2.2,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.sovereign,
      lore: L.monBoss10Lore,
    ),
  };

  /// Worlds 11-30 are a second and third "dreaming" of worlds 1-10 — same
  /// monsters and boss identity, far stronger stats (`World.difficultyMultiplier`)
  /// — rather than 20 more hand-authored rosters. Any world beyond the
  /// original 10 maps back to whichever of the first 10 it echoes.
  static int _sourceWorldID(int worldID) {
    if (worldID <= 10) return worldID;
    return ((worldID - 1) % 10) + 1;
  }

  static MonsterKind regularMonster(int worldID, int stage) {
    final list = _regularsByWorld[_sourceWorldID(worldID)] ?? _regularsByWorld[1]!;
    return list[stage % list.length];
  }

  static BossKind boss(int worldID) {
    return _bossesByWorld[_sourceWorldID(worldID)] ?? _bossesByWorld[1]!;
  }

  /// All monster kinds for a world (regulars first, boss last) — the
  /// Bestiary's source of truth for what a world's codex page contains.
  static List<MonsterEntry> allEntries(int worldID) {
    final sourceID = _sourceWorldID(worldID);
    final regulars = (_regularsByWorld[sourceID] ?? [])
        .map((m) => MonsterEntry(
              name: m.name,
              symbol: m.symbol,
              lore: m.lore,
              isBoss: false,
              rarity: m.rarity,
            ))
        .toList();
    World? world;
    for (final w in WorldCatalog.worlds) {
      if (w.id == worldID) {
        world = w;
        break;
      }
    }
    final boss = _bossesByWorld[sourceID];
    if (boss != null) {
      regulars.add(MonsterEntry(
        name: world?.bossName ?? 'Boss',
        symbol: boss.symbol,
        lore: boss.lore,
        isBoss: true,
        rarity: Rarity.legendary,
      ));
    }
    return regulars;
  }
}

/// Dart substitute for Swift's named tuple return type used by
/// `MonsterCatalog.allEntries`.
class MonsterEntry {
  final String name;
  final String symbol;
  final String lore;
  final bool isBoss;
  final Rarity rarity;

  const MonsterEntry({
    required this.name,
    required this.symbol,
    required this.lore,
    required this.isBoss,
    required this.rarity,
  });
}
