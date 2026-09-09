import '../combat/combatant.dart';
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
  static const Map<int, List<MonsterKind>> _regularsByWorld = {
    1: [
      MonsterKind(name: "Bramble Stalker", symbol: "leaf.fill", lore: "Creeps through the tall grass, thorns bristling at the first sign of a footstep.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Dust Wisp", symbol: "wind", lore: "A loose knot of drifting pollen and static, harmless until it swarms.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Meadow Sprite", symbol: "ladybug.fill", lore: "Small, quick, and fiercely territorial over its patch of clover.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Sunpetal Guardian", symbol: "sun.max.fill", lore: "Blooms once at dawn and stands watch over the meadow until dusk.", role: Role.damage, rarity: Rarity.common),
    ],
    2: [
      MonsterKind(name: "Gloom Hound", symbol: "moon.fill", lore: "Hunts in the space between shadows, never quite where you last saw it.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Hollow Shade", symbol: "theatermask.and.paintbrush.fill", lore: "Wears the shape of a forgotten dream, hollow at the center.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Night Wisp", symbol: "sparkle", lore: "A cold ember of moonlight that flickers whenever it's watched.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Thornback Prowler", symbol: "pawprint.fill", lore: "Silent on the forest floor, its spines the only warning it gives.", role: Role.damage, rarity: Rarity.common),
    ],
    3: [
      MonsterKind(name: "Rift Crawler", symbol: "hexagon.fill", lore: "Skitters along cracks in the cavern walls where light doesn't quite reach.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Frost Wisp", symbol: "snowflake", lore: "Breathes out a thin, glittering cold that clings to whatever it touches.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Cavern Serpent", symbol: "tropicalstorm", lore: "Coils through the underground tides, patient and impossibly long.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Crystal Wisp", symbol: "diamond.fill", lore: "Refracts every sound in the cavern into a faint, discordant chime.", role: Role.damage, rarity: Rarity.common),
    ],
    4: [
      MonsterKind(name: "Starfang", symbol: "sparkles", lore: "A shard of an old star given teeth, prowling the meteor fields.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Cometpaw", symbol: "sparkle", lore: "Leaves a trail of dying light with every leap between floating peaks.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Astralwing", symbol: "hexagon.fill", lore: "Circles the star temple ruins on wings woven from old constellations.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Stardustling", symbol: "diamond.fill", lore: "Small and glittering, it scatters into motes when startled.", role: Role.healer, rarity: Rarity.uncommon),
      MonsterKind(name: "Cosmobite", symbol: "sparkles", lore: "Its bite carries a cold, distant chill from beyond the sky.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Nebulaclaw", symbol: "sparkle", lore: "Claws wreathed in drifting cosmic haze, silent as vacuum.", role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: "Starhorn", symbol: "hexagon.fill", lore: "Charges the crystal spires of Starfall Peaks head-first.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Cometscale", symbol: "diamond.fill", lore: "Scales that shed light long after the creature has moved on.", role: Role.control, rarity: Rarity.uncommon),
    ],
    5: [
      MonsterKind(name: "Moonfang", symbol: "moon.fill", lore: "Wanders the broken buildings, howling at a moon no one else remembers.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Duskhorn", symbol: "moon.stars.fill", lore: "Charges out of the dense fog before its silhouette ever resolves.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Nightclaw", symbol: "theatermask.and.paintbrush.fill", lore: "Claws that leave no mark, only the memory of having been cut.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Shadowtail", symbol: "moon.fill", lore: "Its tail lags a full second behind the rest of its body.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Eclipsepaw", symbol: "moon.stars.fill", lore: "Steps between floating ruin-fragments as if they were solid ground.", role: Role.control, rarity: Rarity.rare),
      MonsterKind(name: "Dreamstalker", symbol: "theatermask.and.paintbrush.fill", lore: "Follows dreamers through the fog long after they've woken.", role: Role.support, rarity: Rarity.uncommon),
      MonsterKind(name: "Moonscale", symbol: "moon.fill", lore: "Scales that dim and brighten with a moon phase all their own.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Gloomfang", symbol: "moon.stars.fill", lore: "A last echo of the dream this ruined city used to be.", role: Role.damage, rarity: Rarity.uncommon),
    ],
    6: [
      MonsterKind(name: "Cinderfang", symbol: "flame.fill", lore: "Prowls the ash fields, jaws glowing faintly with banked heat.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Ashclaw", symbol: "sun.max.fill", lore: "Leaves smoldering prints across the black volcanic rock.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Flamehorn", symbol: "bolt.fill", lore: "Charges lava lakes head-on without slowing.", role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: "Scorchling", symbol: "flame.fill", lore: "Small, quick, and always a little too close to catching fire.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Embermaw", symbol: "sun.max.fill", lore: "Its bite carries the heat of a coal that never quite cools.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Blazetail", symbol: "bolt.fill", lore: "A whip-crack tail that leaves a line of fire in the ash.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Magmabite", symbol: "flame.fill", lore: "Bites clean through cooled rock crust in search of the wastes' heat.", role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: "Charhound", symbol: "sun.max.fill", lore: "Hunts in the choking ash clouds by scent alone.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Pyrewing", symbol: "bolt.fill", lore: "Circles the burning ruins on wings of drifting ember.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Inferclaw", symbol: "flame.fill", lore: "Claws still hot from the lava lake it just crawled out of.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Coalback", symbol: "sun.max.fill", lore: "A ridged spine that glows brighter the angrier it gets.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Searscale", symbol: "bolt.fill", lore: "Scales that scald anything that gets too close.", role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: "Flarefang", symbol: "flame.fill", lore: "A sudden burst of light and teeth from the ash cloud.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Burnpaw", symbol: "sun.max.fill", lore: "Leaves scorched pawprints wherever it walks.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Ignisprite", symbol: "bolt.fill", lore: "A tiny fire-spirit born from a stray cinder off Ignivar's own flame.", role: Role.healer, rarity: Rarity.rare),
      MonsterKind(name: "Ashenox", symbol: "flame.fill", lore: "Wears a coat of drifting ash over skin still smoldering beneath.", role: Role.tank, rarity: Rarity.uncommon),
    ],
    7: [
      MonsterKind(name: "Mistfin", symbol: "drop.fill", lore: "Slips through the coral forest wrapped in a veil of cold mist.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Tideclaw", symbol: "snowflake", lore: "Claws that pull with the force of a rising tide.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Ripplefang", symbol: "tropicalstorm", lore: "Every bite sends a ring of current rippling outward.", role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: "Aquabite", symbol: "drop.fill", lore: "Small and quick, darting between sunken temple pillars.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Wavepup", symbol: "snowflake", lore: "Young and playful, riding the abyss's slow deep currents.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Rainscale", symbol: "tropicalstorm", lore: "Scales that weep a constant, cold trickle of seawater.", role: Role.healer, rarity: Rarity.uncommon),
      MonsterKind(name: "Deepfin", symbol: "drop.fill", lore: "Never surfaces \u2014 the trench is the only home it has known.", role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: "Brookling", symbol: "snowflake", lore: "A trickle of a creature that pools into something larger when threatened.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Frostgill", symbol: "tropicalstorm", lore: "Gills that chill the water for a body length in every direction.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Stormfin", symbol: "drop.fill", lore: "Churns the water into a squall wherever it swims.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Pearlmaw", symbol: "snowflake", lore: "Its jaw glints with a lifetime of swallowed pearls.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Splashpaw", symbol: "tropicalstorm", lore: "Bounds along the sunken temple floor in bursts of current.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Drownscale", symbol: "drop.fill", lore: "Legend says it once pulled an entire temple beneath the waves.", role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: "Riverfang", symbol: "snowflake", lore: "Older than the abyss itself, or so the coral forest tells it.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Mistcrawler", symbol: "tropicalstorm", lore: "Crawls along the trench floor where no light has ever reached.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Abyssfin", symbol: "drop.fill", lore: "The deepest-dwelling of Thalassor's countless subjects.", role: Role.damage, rarity: Rarity.uncommon),
    ],
    8: [
      MonsterKind(name: "Thornpaw", symbol: "leaf.fill", lore: "Pads silently through root tunnels wider than any road.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Mossfang", symbol: "ladybug.fill", lore: "So thickly covered in moss it looks like part of the jungle floor.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Leafling", symbol: "wind", lore: "Small and quick, camouflaged among the oversized canopy.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Rootclaw", symbol: "leaf.fill", lore: "Claws grown from a root that never stopped reaching.", role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: "Vinebeast", symbol: "ladybug.fill", lore: "Trails living vine behind it as it moves through the undergrowth.", role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: "Bloomtail", symbol: "wind", lore: "A flowering tail that opens only when it senses a threat.", role: Role.control, rarity: Rarity.common),
      MonsterKind(name: "Petalhorn", symbol: "leaf.fill", lore: "Charges beneath an oversized, brilliantly colored bloom.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Barkhide", symbol: "ladybug.fill", lore: "Skin as tough and gnarled as the jungle's oldest trees.", role: Role.tank, rarity: Rarity.rare),
      MonsterKind(name: "Sporeling", symbol: "wind", lore: "Releases a faint cloud of spores whenever it's startled.", role: Role.healer, rarity: Rarity.uncommon),
      MonsterKind(name: "Wildthorn", symbol: "leaf.fill", lore: "A tangle of thorn and muscle native only to Eternal Bloom.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Fernfang", symbol: "ladybug.fill", lore: "Bites through the thick canopy vines with practiced ease.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Brambleback", symbol: "wind", lore: "A spine of interlocking brambles no predator wants to test.", role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: "Rootmaw", symbol: "leaf.fill", lore: "Waits beneath the tunnel floor for something to walk overhead.", role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: "Seedling Beast", symbol: "ladybug.fill", lore: "Young, but already larger than most fully grown Bloom creatures.", role: Role.support, rarity: Rarity.common),
      MonsterKind(name: "Ivyclaw", symbol: "wind", lore: "Ivy grows over its claws between meals, then sheds when it hunts.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Thornbloom", symbol: "leaf.fill", lore: "The jungle's oldest bloom given claws, close kin to Verdantor.", role: Role.damage, rarity: Rarity.uncommon),
    ],
    9: [
      MonsterKind(name: "Nightshade", symbol: "theatermask.and.paintbrush.fill", lore: "Grows only where Noctyra's permanent eclipse falls darkest.", role: Role.damage, rarity: Rarity.common),
      MonsterKind(name: "Lunawing", symbol: "moon.fill", lore: "Circles the watching moon on wings that never cast a shadow.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Darkpelt", symbol: "moon.stars.fill", lore: "A coat so black it swallows the eclipse's faint light entirely.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Crescentclaw", symbol: "theatermask.and.paintbrush.fill", lore: "Claws curved like the sliver of moon this realm never quite sees.", role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: "Voidpaw", symbol: "moon.fill", lore: "Steps leave no print \u2014 the eclipse realm forgets it was ever there.", role: Role.control, rarity: Rarity.uncommon),
      MonsterKind(name: "Duskscale", symbol: "moon.stars.fill", lore: "Scales caught permanently between day and night.", role: Role.tank, rarity: Rarity.common),
      MonsterKind(name: "Nightmare Beast", symbol: "theatermask.and.paintbrush.fill", lore: "One of Noctyra's own court, given form from the realm's endless dark.", role: Role.damage, rarity: Rarity.rare),
    ],
    10: [
      MonsterKind(name: "Galaxipaw", symbol: "sparkles", lore: "Each pawprint briefly holds a swirl of tiny stars.", role: Role.damage, rarity: Rarity.uncommon),
      MonsterKind(name: "Meteorfang", symbol: "sparkle", lore: "Fell to the cosmic islands still burning at the edges.", role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: "Celestling", symbol: "hexagon.fill", lore: "Small, but drawn from the same light as Elyndor itself.", role: Role.support, rarity: Rarity.uncommon),
      MonsterKind(name: "Voidstar", symbol: "diamond.fill", lore: "A star gone dark, still pulling everything nearby toward it.", role: Role.control, rarity: Rarity.rare),
      MonsterKind(name: "Nebulabeast", symbol: "sparkles", lore: "Drifts between the starlit temples wrapped in cosmic haze.", role: Role.tank, rarity: Rarity.uncommon),
      MonsterKind(name: "Starlight Claw", symbol: "sparkle", lore: "Claws that glow with borrowed light from a galaxy long gone.", role: Role.damage, rarity: Rarity.rare),
      MonsterKind(name: "Astralmaw", symbol: "hexagon.fill", lore: "Guards the center of the Dream realm alongside its sovereign.", role: Role.tank, rarity: Rarity.legendary),
    ],
  };

  static final Map<int, BossKind> _bossesByWorld = {
    1: BossKind(
      symbol: "flame.fill",
      ultimate: const UltimateSkill(
        name: "Unraveling Bloom",
        description: "The meadow itself lashes out in bloom and fire.",
        damageMultiplier: 1.8,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.selfHeal,
      lore: "Once the meadow's oldest bloom, now unraveling into thorn and flame with every dream it consumes.",
    ),
    2: BossKind(
      symbol: "moon.stars.fill",
      ultimate: const UltimateSkill(
        name: "Nightmare Grasp",
        description: "Shadows claw in from every direction at once.",
        damageMultiplier: 2.0,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.enrage,
      lore: "Keeper of the forest's deepest gloom, it grows more furious the closer it comes to falling.",
    ),
    3: BossKind(
      symbol: "diamond.fill",
      ultimate: const UltimateSkill(
        name: "Sentinel's Judgment",
        description: "A crushing wave of crystallized force.",
        damageMultiplier: 1.9,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.shield,
      lore: "A living crystal grown around a dream too heavy to wake from, shielded on every side.",
    ),
    4: BossKind(
      symbol: "star.fill",
      ultimate: const UltimateSkill(
        name: "Starfall Cataclysm",
        description: "A meteor storm crashes down from the shattered sky.",
        damageMultiplier: 1.9,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.shield,
      lore: "A star that fell from the heavens eons ago, still burning with the light of its old sky.",
    ),
    5: BossKind(
      symbol: "moon.stars.fill",
      ultimate: const UltimateSkill(
        name: "Nightmare Feast",
        description: "Consumes the last of its prey's waking thoughts.",
        damageMultiplier: 1.85,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.drain,
      lore: "An ancient thing that feeds on forgotten dreams, growing fatter with every one it swallows.",
    ),
    6: BossKind(
      symbol: "flame.fill",
      ultimate: const UltimateSkill(
        name: "Ashfall Reckoning",
        description: "A tidal wave of molten rock and cinder.",
        damageMultiplier: 2.0,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.enrage,
      lore: "A titan of fire that slept beneath the wastes for a thousand years, now awake and furious.",
    ),
    7: BossKind(
      symbol: "tropicalstorm",
      ultimate: const UltimateSkill(
        name: "Abyssal Tide",
        description: "A crushing wave from the deepest trench.",
        damageMultiplier: 1.85,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.selfHeal,
      lore: "Ruler of the deepest trench in the Tidal Abyss, its court are things that never see the surface.",
    ),
    8: BossKind(
      symbol: "leaf.fill",
      ultimate: const UltimateSkill(
        name: "Rootbound Judgment",
        description: "The forest floor erupts in thorn and vine.",
        damageMultiplier: 1.9,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.regenShield,
      lore: "A root older than the forest itself, slumbering beneath Eternal Bloom since before memory.",
    ),
    9: BossKind(
      symbol: "moon.fill",
      ultimate: const UltimateSkill(
        name: "Eclipse Reign",
        description: "Shadow and light strike as one.",
        damageMultiplier: 2.0,
        attacksToCharge: 4,
      ),
      mechanic: BossMechanic.phaseShift,
      lore: "Sovereign of the permanent eclipse, she rules the realm equally in shadow and stolen light.",
    ),
    10: BossKind(
      symbol: "sparkles",
      ultimate: const UltimateSkill(
        name: "Sovereign's Dominion",
        description: "Every star in the sky answers its call at once.",
        damageMultiplier: 2.2,
        attacksToCharge: 5,
      ),
      mechanic: BossMechanic.sovereign,
      lore: "Ruler of the highest dream, and the last, greatest guardian the Dreamkeepers must face.",
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
