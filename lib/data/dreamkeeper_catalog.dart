import '../l10n/l10n.dart';
import '../models/dreamkeeper.dart';
import '../models/element.dart';
import '../models/rarity.dart';
import '../models/role.dart';
import '../models/skill.dart';
import '../models/stats.dart';

/// Read-only content catalog. Adding a Dreamkeeper means appending one
/// `DreamkeeperDefinition` here — nothing in combat or the UI needs to
/// change. Mirrors GameCore/Data/DreamkeeperCatalog.swift exactly.
class DreamkeeperCatalog {
  final List<DreamkeeperDefinition> definitions;
  final Map<String, DreamkeeperDefinition> _byID;

  DreamkeeperCatalog(this.definitions)
      : _byID = {for (final d in definitions) d.id: d};

  DreamkeeperDefinition? definition(String id) => _byID[id];

  static final DreamkeeperCatalog starter = DreamkeeperCatalog([
    DreamkeeperDefinition(
      id: "ember_fox",
      name: L.dk_ember_fox_name,
      artName: LEn.dk_ember_fox_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 90, attack: 16, defense: 6, speed: 52),
      growthPerLevel: const Stats(hp: 7, attack: 1.4, defense: 0.4, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_ember_fox_ult,
          description: L.dk_ember_fox_ultDesc,
          damageMultiplier: 2.2,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_ember_fox_skill,
          description: L.dk_ember_fox_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_ember_fox_pass,
          description: L.dk_ember_fox_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 0, speed: 0)),
      symbol: "hare.fill",
      flavorText: L.dk_ember_fox_flavor,
    ),
    DreamkeeperDefinition(
      id: "moon_hare",
      name: L.dk_moon_hare_name,
      artName: LEn.dk_moon_hare_name,
      element: GameElement.lunar,
      role: Role.healer,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 100, attack: 10, defense: 7, speed: 48),
      growthPerLevel: const Stats(hp: 8, attack: 0.8, defense: 0.5, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_moon_hare_ult,
          description: L.dk_moon_hare_ultDesc,
          damageMultiplier: 2.6,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_moon_hare_skill,
          description: L.dk_moon_hare_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_moon_hare_pass,
          description: L.dk_moon_hare_passDesc,
          statBonus: const Stats(hp: 6, attack: 0, defense: 0, speed: 0)),
      symbol: "moon.stars.fill",
      flavorText: L.dk_moon_hare_flavor,
    ),
    DreamkeeperDefinition(
      id: "forest_spirit",
      name: L.dk_forest_spirit_name,
      artName: LEn.dk_forest_spirit_name,
      element: GameElement.bloom,
      role: Role.support,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 95, attack: 12, defense: 8, speed: 44),
      growthPerLevel:
          const Stats(hp: 7.5, attack: 1.0, defense: 0.5, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_forest_spirit_ult,
          description: L.dk_forest_spirit_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_forest_spirit_skill,
          description: L.dk_forest_spirit_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_forest_spirit_pass,
          description: L.dk_forest_spirit_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 2, speed: 0)),
      symbol: "leaf.fill",
      flavorText: L.dk_forest_spirit_flavor,
    ),
    DreamkeeperDefinition(
      id: "crystal_golem",
      name: L.dk_crystal_golem_name,
      artName: LEn.dk_crystal_golem_name,
      element: GameElement.tide,
      role: Role.tank,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 160, attack: 9, defense: 16, speed: 30),
      growthPerLevel:
          const Stats(hp: 12, attack: 0.6, defense: 1.2, speed: 0.2),
      ultimate: UltimateSkill(
          name: L.dk_crystal_golem_ult,
          description: L.dk_crystal_golem_ultDesc,
          damageMultiplier: 1.9,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_crystal_golem_skill,
          description: L.dk_crystal_golem_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 8),
      passive: PassiveTrait(
          name: L.dk_crystal_golem_pass,
          description: L.dk_crystal_golem_passDesc,
          statBonus: const Stats(hp: 10, attack: 0, defense: 2, speed: 0)),
      symbol: "diamond.fill",
      flavorText: L.dk_crystal_golem_flavor,
    ),
    DreamkeeperDefinition(
      id: "star_wolf",
      name: L.dk_star_wolf_name,
      artName: LEn.dk_star_wolf_name,
      element: GameElement.astral,
      role: Role.control,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 105, attack: 14, defense: 9, speed: 58),
      growthPerLevel: const Stats(hp: 8, attack: 1.2, defense: 0.6, speed: 0.6),
      ultimate: UltimateSkill(
          name: L.dk_star_wolf_ult,
          description: L.dk_star_wolf_ultDesc,
          damageMultiplier: 1.7,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_star_wolf_skill,
          description: L.dk_star_wolf_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_star_wolf_pass,
          description: L.dk_star_wolf_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 0, speed: 3)),
      symbol: "pawprint.fill",
      flavorText: L.dk_star_wolf_flavor,
    ),
    DreamkeeperDefinition(
      id: "thorn_viper",
      name: L.dk_thorn_viper_name,
      artName: LEn.dk_thorn_viper_name,
      element: GameElement.bloom,
      role: Role.damage,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 85, attack: 17, defense: 5, speed: 55),
      growthPerLevel:
          const Stats(hp: 6.5, attack: 1.5, defense: 0.35, speed: 0.55),
      ultimate: UltimateSkill(
          name: L.dk_thorn_viper_ult,
          description: L.dk_thorn_viper_ultDesc,
          damageMultiplier: 2.3,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_thorn_viper_skill,
          description: L.dk_thorn_viper_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_thorn_viper_pass,
          description: L.dk_thorn_viper_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 0, speed: 0)),
      symbol: "lizard.fill",
      flavorText: L.dk_thorn_viper_flavor,
    ),
    DreamkeeperDefinition(
      id: "tide_serpent",
      name: L.dk_tide_serpent_name,
      artName: LEn.dk_tide_serpent_name,
      element: GameElement.tide,
      role: Role.damage,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 80, attack: 14, defense: 5, speed: 50),
      growthPerLevel:
          const Stats(hp: 6, attack: 1.2, defense: 0.35, speed: 0.45),
      ultimate: UltimateSkill(
          name: L.dk_tide_serpent_ult,
          description: L.dk_tide_serpent_ultDesc,
          damageMultiplier: 2.0,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_tide_serpent_skill,
          description: L.dk_tide_serpent_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_tide_serpent_pass,
          description: L.dk_tide_serpent_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 0, speed: 2)),
      symbol: "fish.fill",
      flavorText: L.dk_tide_serpent_flavor,
    ),
    DreamkeeperDefinition(
      id: "ember_phoenix",
      name: L.dk_ember_phoenix_name,
      artName: LEn.dk_ember_phoenix_name,
      element: GameElement.ember,
      role: Role.healer,
      rarity: Rarity.legendary,
      baseStats: const Stats(hp: 130, attack: 15, defense: 9, speed: 50),
      growthPerLevel:
          const Stats(hp: 10, attack: 1.1, defense: 0.6, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_ember_phoenix_ult,
          description: L.dk_ember_phoenix_ultDesc,
          damageMultiplier: 3.2,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_ember_phoenix_skill,
          description: L.dk_ember_phoenix_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_ember_phoenix_pass,
          description: L.dk_ember_phoenix_passDesc,
          statBonus: const Stats(hp: 12, attack: 2, defense: 0, speed: 0)),
      symbol: "bird.fill",
      flavorText: L.dk_ember_phoenix_flavor,
    ),
    DreamkeeperDefinition(
      id: "lunar_owl",
      name: L.dk_lunar_owl_name,
      artName: LEn.dk_lunar_owl_name,
      element: GameElement.lunar,
      role: Role.control,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 95, attack: 13, defense: 8, speed: 60),
      growthPerLevel:
          const Stats(hp: 7, attack: 1.1, defense: 0.5, speed: 0.65),
      ultimate: UltimateSkill(
          name: L.dk_lunar_owl_ult,
          description: L.dk_lunar_owl_ultDesc,
          damageMultiplier: 1.8,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_lunar_owl_skill,
          description: L.dk_lunar_owl_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_lunar_owl_pass,
          description: L.dk_lunar_owl_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 0, speed: 3)),
      symbol: "eye.fill",
      flavorText: L.dk_lunar_owl_flavor,
    ),
    DreamkeeperDefinition(
      id: "astral_sentinel",
      name: L.dk_astral_sentinel_name,
      artName: LEn.dk_astral_sentinel_name,
      element: GameElement.astral,
      role: Role.tank,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 150, attack: 10, defense: 15, speed: 34),
      growthPerLevel:
          const Stats(hp: 11, attack: 0.7, defense: 1.1, speed: 0.25),
      ultimate: UltimateSkill(
          name: L.dk_astral_sentinel_ult,
          description: L.dk_astral_sentinel_ultDesc,
          damageMultiplier: 1.7,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_astral_sentinel_skill,
          description: L.dk_astral_sentinel_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 8),
      passive: PassiveTrait(
          name: L.dk_astral_sentinel_pass,
          description: L.dk_astral_sentinel_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 3, speed: 0)),
      symbol: "shield.lefthalf.filled",
      flavorText: L.dk_astral_sentinel_flavor,
    ),
    DreamkeeperDefinition(
      id: "coral_warden",
      name: L.dk_coral_warden_name,
      artName: LEn.dk_coral_warden_name,
      element: GameElement.tide,
      role: Role.support,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 92, attack: 11, defense: 8, speed: 42),
      growthPerLevel:
          const Stats(hp: 7, attack: 0.9, defense: 0.5, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_coral_warden_ult,
          description: L.dk_coral_warden_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_coral_warden_skill,
          description: L.dk_coral_warden_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_coral_warden_pass,
          description: L.dk_coral_warden_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 2, speed: 0)),
      symbol: "water.waves",
      flavorText: L.dk_coral_warden_flavor,
    ),
    DreamkeeperDefinition(
      id: "cinder_sprite",
      name: L.dk_cinder_sprite_name,
      artName: LEn.dk_cinder_sprite_name,
      element: GameElement.ember,
      role: Role.support,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 82, attack: 12, defense: 6, speed: 46),
      growthPerLevel:
          const Stats(hp: 6.5, attack: 1.0, defense: 0.4, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_cinder_sprite_ult,
          description: L.dk_cinder_sprite_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_cinder_sprite_skill,
          description: L.dk_cinder_sprite_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_cinder_sprite_pass,
          description: L.dk_cinder_sprite_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 0, speed: 0)),
      symbol: "flame.circle.fill",
      flavorText: L.dk_cinder_sprite_flavor,
    ),
    DreamkeeperDefinition(
      id: "flicker_pup",
      name: L.dk_flicker_pup_name,
      artName: LEn.dk_flicker_pup_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 65, attack: 11, defense: 4, speed: 46),
      growthPerLevel: const Stats(hp: 5, attack: 0.9, defense: 0.3, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_flicker_pup_ult,
          description: L.dk_flicker_pup_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_flicker_pup_skill,
          description: L.dk_flicker_pup_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_flicker_pup_pass,
          description: L.dk_flicker_pup_passDesc,
          statBonus: const Stats(hp: 0, attack: 1, defense: 0, speed: 1)),
      symbol: "pawprint.fill",
      flavorText: L.dk_flicker_pup_flavor,
    ),
    DreamkeeperDefinition(
      id: "ripple_minnow",
      name: L.dk_ripple_minnow_name,
      artName: LEn.dk_ripple_minnow_name,
      element: GameElement.tide,
      role: Role.support,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 70, attack: 8, defense: 6, speed: 36),
      growthPerLevel: const Stats(hp: 5, attack: 0.6, defense: 0.4, speed: 0.3),
      ultimate: UltimateSkill(
          name: L.dk_ripple_minnow_ult,
          description: L.dk_ripple_minnow_ultDesc,
          damageMultiplier: 1.3,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_ripple_minnow_skill,
          description: L.dk_ripple_minnow_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_ripple_minnow_pass,
          description: L.dk_ripple_minnow_passDesc,
          statBonus: const Stats(hp: 4, attack: 0, defense: 0, speed: 0)),
      symbol: "fish.fill",
      flavorText: L.dk_ripple_minnow_flavor,
    ),
    DreamkeeperDefinition(
      id: "sprout_cub",
      name: L.dk_sprout_cub_name,
      artName: LEn.dk_sprout_cub_name,
      element: GameElement.bloom,
      role: Role.tank,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 95, attack: 6, defense: 9, speed: 24),
      growthPerLevel: const Stats(hp: 7, attack: 0.4, defense: 0.6, speed: 0.2),
      ultimate: UltimateSkill(
          name: L.dk_sprout_cub_ult,
          description: L.dk_sprout_cub_ultDesc,
          damageMultiplier: 1.3,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_sprout_cub_skill,
          description: L.dk_sprout_cub_skillDesc,
          effectMultiplier: 1.1,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_sprout_cub_pass,
          description: L.dk_sprout_cub_passDesc,
          statBonus: const Stats(hp: 5, attack: 0, defense: 1, speed: 0)),
      symbol: "tortoise.fill",
      flavorText: L.dk_sprout_cub_flavor,
    ),
    DreamkeeperDefinition(
      id: "nightling",
      name: L.dk_nightling_name,
      artName: LEn.dk_nightling_name,
      element: GameElement.lunar,
      role: Role.control,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 68, attack: 9, defense: 5, speed: 48),
      growthPerLevel:
          const Stats(hp: 5, attack: 0.7, defense: 0.35, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_nightling_ult,
          description: L.dk_nightling_ultDesc,
          damageMultiplier: 1.4,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_nightling_skill,
          description: L.dk_nightling_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_nightling_pass,
          description: L.dk_nightling_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 0, speed: 2)),
      symbol: "moon.fill",
      flavorText: L.dk_nightling_flavor,
    ),
    DreamkeeperDefinition(
      id: "stardust_moth",
      name: L.dk_stardust_moth_name,
      artName: LEn.dk_stardust_moth_name,
      element: GameElement.astral,
      role: Role.healer,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 72, attack: 7, defense: 5, speed: 40),
      growthPerLevel:
          const Stats(hp: 5, attack: 0.5, defense: 0.35, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_stardust_moth_ult,
          description: L.dk_stardust_moth_ultDesc,
          damageMultiplier: 1.4,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_stardust_moth_skill,
          description: L.dk_stardust_moth_skillDesc,
          effectMultiplier: 1.15,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_stardust_moth_pass,
          description: L.dk_stardust_moth_passDesc,
          statBonus: const Stats(hp: 3, attack: 0, defense: 0, speed: 0)),
      symbol: "sparkle",
      flavorText: L.dk_stardust_moth_flavor,
    ),
    DreamkeeperDefinition(
      id: "cinder_badger",
      name: L.dk_cinder_badger_name,
      artName: LEn.dk_cinder_badger_name,
      element: GameElement.ember,
      role: Role.tank,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 112, attack: 8, defense: 11, speed: 28),
      growthPerLevel:
          const Stats(hp: 8, attack: 0.6, defense: 0.75, speed: 0.3),
      ultimate: UltimateSkill(
          name: L.dk_cinder_badger_ult,
          description: L.dk_cinder_badger_ultDesc,
          damageMultiplier: 1.7,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_cinder_badger_skill,
          description: L.dk_cinder_badger_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_cinder_badger_pass,
          description: L.dk_cinder_badger_passDesc,
          statBonus: const Stats(hp: 6, attack: 0, defense: 1, speed: 0)),
      symbol: "pawprint.fill",
      flavorText: L.dk_cinder_badger_flavor,
    ),
    DreamkeeperDefinition(
      id: "pearl_otter",
      name: L.dk_pearl_otter_name,
      artName: LEn.dk_pearl_otter_name,
      element: GameElement.tide,
      role: Role.healer,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 88, attack: 9, defense: 6, speed: 44),
      growthPerLevel:
          const Stats(hp: 6.5, attack: 0.7, defense: 0.45, speed: 0.38),
      ultimate: UltimateSkill(
          name: L.dk_pearl_otter_ult,
          description: L.dk_pearl_otter_ultDesc,
          damageMultiplier: 2.0,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_pearl_otter_skill,
          description: L.dk_pearl_otter_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_pearl_otter_pass,
          description: L.dk_pearl_otter_passDesc,
          statBonus: const Stats(hp: 5, attack: 0, defense: 0, speed: 0)),
      symbol: "drop.fill",
      flavorText: L.dk_pearl_otter_flavor,
    ),
    DreamkeeperDefinition(
      id: "comet_fox",
      name: L.dk_comet_fox_name,
      artName: LEn.dk_comet_fox_name,
      element: GameElement.astral,
      role: Role.damage,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 78, attack: 13, defense: 5, speed: 50),
      growthPerLevel:
          const Stats(hp: 6, attack: 1.0, defense: 0.35, speed: 0.42),
      ultimate: UltimateSkill(
          name: L.dk_comet_fox_ult,
          description: L.dk_comet_fox_ultDesc,
          damageMultiplier: 1.9,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_comet_fox_skill,
          description: L.dk_comet_fox_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_comet_fox_pass,
          description: L.dk_comet_fox_passDesc,
          statBonus: const Stats(hp: 0, attack: 1, defense: 0, speed: 1)),
      symbol: "hare.fill",
      flavorText: L.dk_comet_fox_flavor,
    ),
    DreamkeeperDefinition(
      id: "bramble_lynx",
      name: L.dk_bramble_lynx_name,
      artName: LEn.dk_bramble_lynx_name,
      element: GameElement.bloom,
      role: Role.control,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 90, attack: 13, defense: 7, speed: 56),
      growthPerLevel:
          const Stats(hp: 7, attack: 1.1, defense: 0.45, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_bramble_lynx_ult,
          description: L.dk_bramble_lynx_ultDesc,
          damageMultiplier: 2.0,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_bramble_lynx_skill,
          description: L.dk_bramble_lynx_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_bramble_lynx_pass,
          description: L.dk_bramble_lynx_passDesc,
          statBonus: const Stats(hp: 0, attack: 1, defense: 1, speed: 0)),
      symbol: "leaf.fill",
      flavorText: L.dk_bramble_lynx_flavor,
    ),
    DreamkeeperDefinition(
      id: "shade_panther",
      name: L.dk_shade_panther_name,
      artName: LEn.dk_shade_panther_name,
      element: GameElement.lunar,
      role: Role.damage,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 92, attack: 18, defense: 6, speed: 58),
      growthPerLevel:
          const Stats(hp: 7, attack: 1.5, defense: 0.4, speed: 0.55),
      ultimate: UltimateSkill(
          name: L.dk_shade_panther_ult,
          description: L.dk_shade_panther_ultDesc,
          damageMultiplier: 2.3,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_shade_panther_skill,
          description: L.dk_shade_panther_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_shade_panther_pass,
          description: L.dk_shade_panther_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 0, speed: 0)),
      symbol: "moon.stars.fill",
      flavorText: L.dk_shade_panther_flavor,
    ),
    DreamkeeperDefinition(
      id: "nova_falcon",
      name: L.dk_nova_falcon_name,
      artName: LEn.dk_nova_falcon_name,
      element: GameElement.astral,
      role: Role.control,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 88, attack: 13, defense: 7, speed: 62),
      growthPerLevel:
          const Stats(hp: 6.5, attack: 1.1, defense: 0.45, speed: 0.55),
      ultimate: UltimateSkill(
          name: L.dk_nova_falcon_ult,
          description: L.dk_nova_falcon_ultDesc,
          damageMultiplier: 1.9,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_nova_falcon_skill,
          description: L.dk_nova_falcon_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_nova_falcon_pass,
          description: L.dk_nova_falcon_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 0, speed: 3)),
      symbol: "bird.fill",
      flavorText: L.dk_nova_falcon_flavor,
    ),
    DreamkeeperDefinition(
      id: "magma_titan",
      name: L.dk_magma_titan_name,
      artName: LEn.dk_magma_titan_name,
      element: GameElement.ember,
      role: Role.tank,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 170, attack: 11, defense: 17, speed: 28),
      growthPerLevel:
          const Stats(hp: 13, attack: 0.8, defense: 1.3, speed: 0.22),
      ultimate: UltimateSkill(
          name: L.dk_magma_titan_ult,
          description: L.dk_magma_titan_ultDesc,
          damageMultiplier: 2.1,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_magma_titan_skill,
          description: L.dk_magma_titan_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_magma_titan_pass,
          description: L.dk_magma_titan_passDesc,
          statBonus: const Stats(hp: 12, attack: 0, defense: 2, speed: 0)),
      symbol: "flame.fill",
      flavorText: L.dk_magma_titan_flavor,
    ),
    DreamkeeperDefinition(
      id: "verdant_stag",
      name: L.dk_verdant_stag_name,
      artName: LEn.dk_verdant_stag_name,
      element: GameElement.bloom,
      role: Role.support,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 125, attack: 14, defense: 11, speed: 48),
      growthPerLevel: const Stats(hp: 9, attack: 1.1, defense: 0.8, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_verdant_stag_ult,
          description: L.dk_verdant_stag_ultDesc,
          damageMultiplier: 1.7,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_verdant_stag_skill,
          description: L.dk_verdant_stag_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_verdant_stag_pass,
          description: L.dk_verdant_stag_passDesc,
          statBonus: const Stats(hp: 8, attack: 0, defense: 1, speed: 0)),
      symbol: "leaf.fill",
      flavorText: L.dk_verdant_stag_flavor,
    ),
    DreamkeeperDefinition(
      id: "abyssal_kraken",
      name: L.dk_abyssal_kraken_name,
      artName: LEn.dk_abyssal_kraken_name,
      element: GameElement.tide,
      role: Role.damage,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 118, attack: 19, defense: 8, speed: 46),
      growthPerLevel: const Stats(hp: 9, attack: 1.6, defense: 0.5, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_abyssal_kraken_ult,
          description: L.dk_abyssal_kraken_ultDesc,
          damageMultiplier: 2.2,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_abyssal_kraken_skill,
          description: L.dk_abyssal_kraken_skillDesc,
          effectMultiplier: 1.35,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_abyssal_kraken_pass,
          description: L.dk_abyssal_kraken_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 0, speed: 0)),
      symbol: "tropicalstorm",
      flavorText: L.dk_abyssal_kraken_flavor,
    ),
    DreamkeeperDefinition(
      id: "leviathan_queen",
      name: L.dk_leviathan_queen_name,
      artName: LEn.dk_leviathan_queen_name,
      element: GameElement.tide,
      role: Role.tank,
      rarity: Rarity.legendary,
      baseStats: const Stats(hp: 200, attack: 13, defense: 20, speed: 36),
      growthPerLevel:
          const Stats(hp: 15, attack: 1.0, defense: 1.5, speed: 0.3),
      ultimate: UltimateSkill(
          name: L.dk_leviathan_queen_ult,
          description: L.dk_leviathan_queen_ultDesc,
          damageMultiplier: 2.6,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_leviathan_queen_skill,
          description: L.dk_leviathan_queen_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 8),
      passive: PassiveTrait(
          name: L.dk_leviathan_queen_pass,
          description: L.dk_leviathan_queen_passDesc,
          statBonus: const Stats(hp: 14, attack: 0, defense: 2, speed: 0)),
      symbol: "water.waves",
      flavorText: L.dk_leviathan_queen_flavor,
    ),
    DreamkeeperDefinition(
      id: "world_tree_warden",
      name: L.dk_world_tree_warden_name,
      artName: LEn.dk_world_tree_warden_name,
      element: GameElement.bloom,
      role: Role.healer,
      rarity: Rarity.legendary,
      baseStats: const Stats(hp: 150, attack: 13, defense: 12, speed: 44),
      growthPerLevel:
          const Stats(hp: 11, attack: 1.0, defense: 0.9, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_world_tree_warden_ult,
          description: L.dk_world_tree_warden_ultDesc,
          damageMultiplier: 3.0,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_world_tree_warden_skill,
          description: L.dk_world_tree_warden_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_world_tree_warden_pass,
          description: L.dk_world_tree_warden_passDesc,
          statBonus: const Stats(hp: 14, attack: 0, defense: 1, speed: 0)),
      symbol: "leaf.fill",
      flavorText: L.dk_world_tree_warden_flavor,
    ),
    DreamkeeperDefinition(
      id: "celestial_dragon",
      name: L.dk_celestial_dragon_name,
      artName: LEn.dk_celestial_dragon_name,
      element: GameElement.astral,
      role: Role.damage,
      rarity: Rarity.mythic,
      baseStats: const Stats(hp: 155, attack: 24, defense: 11, speed: 58),
      growthPerLevel:
          const Stats(hp: 12, attack: 1.9, defense: 0.7, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_celestial_dragon_ult,
          description: L.dk_celestial_dragon_ultDesc,
          damageMultiplier: 3.6,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_celestial_dragon_skill,
          description: L.dk_celestial_dragon_skillDesc,
          effectMultiplier: 1.4,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_celestial_dragon_pass,
          description: L.dk_celestial_dragon_passDesc,
          statBonus: const Stats(hp: 10, attack: 3, defense: 0, speed: 0)),
      symbol: "atom",
      flavorText: L.dk_celestial_dragon_flavor,
    ),
    DreamkeeperDefinition(
      id: "eclipse_empress",
      name: L.dk_eclipse_empress_name,
      artName: LEn.dk_eclipse_empress_name,
      element: GameElement.lunar,
      role: Role.control,
      rarity: Rarity.mythic,
      baseStats: const Stats(hp: 140, attack: 17, defense: 13, speed: 64),
      growthPerLevel:
          const Stats(hp: 11, attack: 1.3, defense: 1.0, speed: 0.55),
      ultimate: UltimateSkill(
          name: L.dk_eclipse_empress_ult,
          description: L.dk_eclipse_empress_ultDesc,
          damageMultiplier: 3.3,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_eclipse_empress_skill,
          description: L.dk_eclipse_empress_skillDesc,
          effectMultiplier: 1.4,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_eclipse_empress_pass,
          description: L.dk_eclipse_empress_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 1, speed: 2)),
      symbol: "crown.fill",
      flavorText: L.dk_eclipse_empress_flavor,
    ),

    // Second Wave (30 new Dreamkeepers) — mirrors
    // GameCore/Data/DreamkeeperCatalog.swift's "Second Wave" section exactly.
    DreamkeeperDefinition(
      id: "spark_kit",
      name: L.dk_spark_kit_name,
      artName: LEn.dk_spark_kit_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 64, attack: 11, defense: 4, speed: 47),
      growthPerLevel:
          const Stats(hp: 4.8, attack: 0.85, defense: 0.28, speed: 0.38),
      ultimate: UltimateSkill(
          name: L.dk_spark_kit_ult,
          description: L.dk_spark_kit_ultDesc,
          damageMultiplier: 1.4,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_spark_kit_skill,
          description: L.dk_spark_kit_skillDesc,
          effectMultiplier: 1.15,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_spark_kit_pass,
          description: L.dk_spark_kit_passDesc,
          statBonus: const Stats(hp: 0, attack: 1, defense: 0, speed: 1)),
      symbol: "pawprint.fill",
      flavorText: L.dk_spark_kit_flavor,
    ),
    DreamkeeperDefinition(
      id: "bubble_newt",
      name: L.dk_bubble_newt_name,
      artName: LEn.dk_bubble_newt_name,
      element: GameElement.tide,
      role: Role.support,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 72, attack: 8, defense: 6, speed: 37),
      growthPerLevel:
          const Stats(hp: 5.4, attack: 0.6, defense: 0.4, speed: 0.3),
      ultimate: UltimateSkill(
          name: L.dk_bubble_newt_ult,
          description: L.dk_bubble_newt_ultDesc,
          damageMultiplier: 1.35,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_bubble_newt_skill,
          description: L.dk_bubble_newt_skillDesc,
          effectMultiplier: 1.15,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_bubble_newt_pass,
          description: L.dk_bubble_newt_passDesc,
          statBonus: const Stats(hp: 3, attack: 0, defense: 0, speed: 0)),
      symbol: "drop.fill",
      flavorText: L.dk_bubble_newt_flavor,
    ),
    DreamkeeperDefinition(
      id: "petal_finch",
      name: L.dk_petal_finch_name,
      artName: LEn.dk_petal_finch_name,
      element: GameElement.bloom,
      role: Role.healer,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 74, attack: 7, defense: 5, speed: 41),
      growthPerLevel:
          const Stats(hp: 5.6, attack: 0.5, defense: 0.35, speed: 0.32),
      ultimate: UltimateSkill(
          name: L.dk_petal_finch_ult,
          description: L.dk_petal_finch_ultDesc,
          damageMultiplier: 1.4,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_petal_finch_skill,
          description: L.dk_petal_finch_skillDesc,
          effectMultiplier: 1.15,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_petal_finch_pass,
          description: L.dk_petal_finch_passDesc,
          statBonus: const Stats(hp: 4, attack: 0, defense: 0, speed: 0)),
      symbol: "bird.fill",
      flavorText: L.dk_petal_finch_flavor,
    ),
    DreamkeeperDefinition(
      id: "nightcap_moth",
      name: L.dk_nightcap_moth_name,
      artName: LEn.dk_nightcap_moth_name,
      element: GameElement.lunar,
      role: Role.control,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 67, attack: 9, defense: 5, speed: 49),
      growthPerLevel:
          const Stats(hp: 5, attack: 0.7, defense: 0.32, speed: 0.42),
      ultimate: UltimateSkill(
          name: L.dk_nightcap_moth_ult,
          description: L.dk_nightcap_moth_ultDesc,
          damageMultiplier: 1.4,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_nightcap_moth_skill,
          description: L.dk_nightcap_moth_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_nightcap_moth_pass,
          description: L.dk_nightcap_moth_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 0, speed: 2)),
      symbol: "moon.fill",
      flavorText: L.dk_nightcap_moth_flavor,
    ),
    DreamkeeperDefinition(
      id: "glimmer_vole",
      name: L.dk_glimmer_vole_name,
      artName: LEn.dk_glimmer_vole_name,
      element: GameElement.astral,
      role: Role.tank,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 98, attack: 6, defense: 10, speed: 25),
      growthPerLevel:
          const Stats(hp: 7.2, attack: 0.42, defense: 0.62, speed: 0.2),
      ultimate: UltimateSkill(
          name: L.dk_glimmer_vole_ult,
          description: L.dk_glimmer_vole_ultDesc,
          damageMultiplier: 1.3,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_glimmer_vole_skill,
          description: L.dk_glimmer_vole_skillDesc,
          effectMultiplier: 1.1,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_glimmer_vole_pass,
          description: L.dk_glimmer_vole_passDesc,
          statBonus: const Stats(hp: 5, attack: 0, defense: 1, speed: 0)),
      symbol: "sparkle",
      flavorText: L.dk_glimmer_vole_flavor,
    ),
    DreamkeeperDefinition(
      id: "cinderwing_broodmother",
      name: L.dk_cinderwing_broodmother_name,
      artName: LEn.dk_cinderwing_broodmother_name,
      element: GameElement.ember,
      role: Role.support,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 85, attack: 11, defense: 7, speed: 43),
      growthPerLevel:
          const Stats(hp: 6.5, attack: 0.85, defense: 0.42, speed: 0.34),
      ultimate: UltimateSkill(
          name: L.dk_cinderwing_broodmother_ult,
          description: L.dk_cinderwing_broodmother_ultDesc,
          damageMultiplier: 1.6,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_cinderwing_broodmother_skill,
          description: L.dk_cinderwing_broodmother_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_cinderwing_broodmother_pass,
          description: L.dk_cinderwing_broodmother_passDesc,
          statBonus: const Stats(hp: 5, attack: 1, defense: 0, speed: 0)),
      symbol: "flame.circle.fill",
      flavorText: L.dk_cinderwing_broodmother_flavor,
    ),
    DreamkeeperDefinition(
      id: "coral_duchess",
      name: L.dk_coral_duchess_name,
      artName: LEn.dk_coral_duchess_name,
      element: GameElement.tide,
      role: Role.support,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 90, attack: 11, defense: 8, speed: 42),
      growthPerLevel:
          const Stats(hp: 6.8, attack: 0.85, defense: 0.45, speed: 0.33),
      ultimate: UltimateSkill(
          name: L.dk_coral_duchess_ult,
          description: L.dk_coral_duchess_ultDesc,
          damageMultiplier: 1.55,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_coral_duchess_skill,
          description: L.dk_coral_duchess_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_coral_duchess_pass,
          description: L.dk_coral_duchess_passDesc,
          statBonus: const Stats(hp: 5, attack: 0, defense: 1, speed: 0)),
      symbol: "water.waves",
      flavorText: L.dk_coral_duchess_flavor,
    ),
    DreamkeeperDefinition(
      id: "moss_tortoise",
      name: L.dk_moss_tortoise_name,
      artName: LEn.dk_moss_tortoise_name,
      element: GameElement.bloom,
      role: Role.tank,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 115, attack: 8, defense: 12, speed: 27),
      growthPerLevel:
          const Stats(hp: 8.4, attack: 0.55, defense: 0.8, speed: 0.2),
      ultimate: UltimateSkill(
          name: L.dk_moss_tortoise_ult,
          description: L.dk_moss_tortoise_ultDesc,
          damageMultiplier: 1.7,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_moss_tortoise_skill,
          description: L.dk_moss_tortoise_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_moss_tortoise_pass,
          description: L.dk_moss_tortoise_passDesc,
          statBonus: const Stats(hp: 8, attack: 0, defense: 2, speed: 0)),
      symbol: "tortoise.fill",
      flavorText: L.dk_moss_tortoise_flavor,
    ),
    DreamkeeperDefinition(
      id: "moonweb_weaver",
      name: L.dk_moonweb_weaver_name,
      artName: LEn.dk_moonweb_weaver_name,
      element: GameElement.lunar,
      role: Role.control,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 80, attack: 12, defense: 6, speed: 52),
      growthPerLevel:
          const Stats(hp: 6, attack: 0.95, defense: 0.4, speed: 0.45),
      ultimate: UltimateSkill(
          name: L.dk_moonweb_weaver_ult,
          description: L.dk_moonweb_weaver_ultDesc,
          damageMultiplier: 1.6,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_moonweb_weaver_skill,
          description: L.dk_moonweb_weaver_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_moonweb_weaver_pass,
          description: L.dk_moonweb_weaver_passDesc,
          statBonus: const Stats(hp: 0, attack: 0, defense: 0, speed: 2)),
      symbol: "moon.stars.fill",
      flavorText: L.dk_moonweb_weaver_flavor,
    ),
    DreamkeeperDefinition(
      id: "comet_hatchling",
      name: L.dk_comet_hatchling_name,
      artName: LEn.dk_comet_hatchling_name,
      element: GameElement.astral,
      role: Role.damage,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 79, attack: 14, defense: 5, speed: 51),
      growthPerLevel:
          const Stats(hp: 6, attack: 1.05, defense: 0.35, speed: 0.44),
      ultimate: UltimateSkill(
          name: L.dk_comet_hatchling_ult,
          description: L.dk_comet_hatchling_ultDesc,
          damageMultiplier: 1.9,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_comet_hatchling_skill,
          description: L.dk_comet_hatchling_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_comet_hatchling_pass,
          description: L.dk_comet_hatchling_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 0, speed: 0)),
      symbol: "sparkles",
      flavorText: L.dk_comet_hatchling_flavor,
    ),
    DreamkeeperDefinition(
      id: "cinder_jackal",
      name: L.dk_cinder_jackal_name,
      artName: LEn.dk_cinder_jackal_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 82, attack: 14, defense: 5, speed: 52),
      growthPerLevel:
          const Stats(hp: 6.2, attack: 1.05, defense: 0.35, speed: 0.45),
      ultimate: UltimateSkill(
          name: L.dk_cinder_jackal_ult,
          description: L.dk_cinder_jackal_ultDesc,
          damageMultiplier: 1.85,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_cinder_jackal_skill,
          description: L.dk_cinder_jackal_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_cinder_jackal_pass,
          description: L.dk_cinder_jackal_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 0, speed: 0)),
      symbol: "flame.fill",
      flavorText: L.dk_cinder_jackal_flavor,
    ),
    DreamkeeperDefinition(
      id: "reef_diver_otter",
      name: L.dk_reef_diver_otter_name,
      artName: LEn.dk_reef_diver_otter_name,
      element: GameElement.tide,
      role: Role.healer,
      rarity: Rarity.uncommon,
      baseStats: const Stats(hp: 90, attack: 9, defense: 6, speed: 44),
      growthPerLevel:
          const Stats(hp: 6.8, attack: 0.7, defense: 0.45, speed: 0.36),
      ultimate: UltimateSkill(
          name: L.dk_reef_diver_otter_ult,
          description: L.dk_reef_diver_otter_ultDesc,
          damageMultiplier: 1.9,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_reef_diver_otter_skill,
          description: L.dk_reef_diver_otter_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_reef_diver_otter_pass,
          description: L.dk_reef_diver_otter_passDesc,
          statBonus: const Stats(hp: 6, attack: 0, defense: 0, speed: 0)),
      symbol: "fish.fill",
      flavorText: L.dk_reef_diver_otter_flavor,
    ),
    DreamkeeperDefinition(
      id: "thorn_queen_mantis",
      name: L.dk_thorn_queen_mantis_name,
      artName: LEn.dk_thorn_queen_mantis_name,
      element: GameElement.bloom,
      role: Role.control,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 92, attack: 14, defense: 7, speed: 57),
      growthPerLevel:
          const Stats(hp: 7, attack: 1.15, defense: 0.45, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_thorn_queen_mantis_ult,
          description: L.dk_thorn_queen_mantis_ultDesc,
          damageMultiplier: 2,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_thorn_queen_mantis_skill,
          description: L.dk_thorn_queen_mantis_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_thorn_queen_mantis_pass,
          description: L.dk_thorn_queen_mantis_passDesc,
          statBonus: const Stats(hp: 0, attack: 2, defense: 1, speed: 0)),
      symbol: "leaf.fill",
      flavorText: L.dk_thorn_queen_mantis_flavor,
    ),
    DreamkeeperDefinition(
      id: "silver_vixen",
      name: L.dk_silver_vixen_name,
      artName: LEn.dk_silver_vixen_name,
      element: GameElement.lunar,
      role: Role.damage,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 88, attack: 17, defense: 5, speed: 60),
      growthPerLevel:
          const Stats(hp: 6.6, attack: 1.45, defense: 0.35, speed: 0.55),
      ultimate: UltimateSkill(
          name: L.dk_silver_vixen_ult,
          description: L.dk_silver_vixen_ultDesc,
          damageMultiplier: 2.2,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_silver_vixen_skill,
          description: L.dk_silver_vixen_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_silver_vixen_pass,
          description: L.dk_silver_vixen_passDesc,
          statBonus: const Stats(hp: 0, attack: 3, defense: 0, speed: 1)),
      symbol: "moon.fill",
      flavorText: L.dk_silver_vixen_flavor,
    ),
    DreamkeeperDefinition(
      id: "comet_duelist_hawk",
      name: L.dk_comet_duelist_hawk_name,
      artName: LEn.dk_comet_duelist_hawk_name,
      element: GameElement.astral,
      role: Role.damage,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 86, attack: 18, defense: 5, speed: 63),
      growthPerLevel:
          const Stats(hp: 6.5, attack: 1.5, defense: 0.35, speed: 0.58),
      ultimate: UltimateSkill(
          name: L.dk_comet_duelist_hawk_ult,
          description: L.dk_comet_duelist_hawk_ultDesc,
          damageMultiplier: 2.4,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_comet_duelist_hawk_skill,
          description: L.dk_comet_duelist_hawk_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_comet_duelist_hawk_pass,
          description: L.dk_comet_duelist_hawk_passDesc,
          statBonus: const Stats(hp: 0, attack: 3, defense: 0, speed: 1)),
      symbol: "bird.fill",
      flavorText: L.dk_comet_duelist_hawk_flavor,
    ),
    DreamkeeperDefinition(
      id: "cinderhawk_matriarch",
      name: L.dk_cinderhawk_matriarch_name,
      artName: LEn.dk_cinderhawk_matriarch_name,
      element: GameElement.ember,
      role: Role.control,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 94, attack: 13, defense: 7, speed: 58),
      growthPerLevel:
          const Stats(hp: 7.2, attack: 1.1, defense: 0.45, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_cinderhawk_matriarch_ult,
          description: L.dk_cinderhawk_matriarch_ultDesc,
          damageMultiplier: 2,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_cinderhawk_matriarch_skill,
          description: L.dk_cinderhawk_matriarch_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_cinderhawk_matriarch_pass,
          description: L.dk_cinderhawk_matriarch_passDesc,
          statBonus: const Stats(hp: 3, attack: 1, defense: 1, speed: 0)),
      symbol: "flame.fill",
      flavorText: L.dk_cinderhawk_matriarch_flavor,
    ),
    DreamkeeperDefinition(
      id: "riptide_marauder",
      name: L.dk_riptide_marauder_name,
      artName: LEn.dk_riptide_marauder_name,
      element: GameElement.tide,
      role: Role.damage,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 90, attack: 17, defense: 6, speed: 56),
      growthPerLevel:
          const Stats(hp: 6.8, attack: 1.4, defense: 0.4, speed: 0.52),
      ultimate: UltimateSkill(
          name: L.dk_riptide_marauder_ult,
          description: L.dk_riptide_marauder_ultDesc,
          damageMultiplier: 2.3,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_riptide_marauder_skill,
          description: L.dk_riptide_marauder_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_riptide_marauder_pass,
          description: L.dk_riptide_marauder_passDesc,
          statBonus: const Stats(hp: 0, attack: 3, defense: 0, speed: 1)),
      symbol: "tropicalstorm",
      flavorText: L.dk_riptide_marauder_flavor,
    ),
    DreamkeeperDefinition(
      id: "hollow_marchioness_owl",
      name: L.dk_hollow_marchioness_owl_name,
      artName: LEn.dk_hollow_marchioness_owl_name,
      element: GameElement.lunar,
      role: Role.support,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 96, attack: 11, defense: 7, speed: 50),
      growthPerLevel:
          const Stats(hp: 7.3, attack: 0.9, defense: 0.45, speed: 0.42),
      ultimate: UltimateSkill(
          name: L.dk_hollow_marchioness_owl_ult,
          description: L.dk_hollow_marchioness_owl_ultDesc,
          damageMultiplier: 1.9,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_hollow_marchioness_owl_skill,
          description: L.dk_hollow_marchioness_owl_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_hollow_marchioness_owl_pass,
          description: L.dk_hollow_marchioness_owl_passDesc,
          statBonus: const Stats(hp: 5, attack: 0, defense: 1, speed: 0)),
      symbol: "eye.fill",
      flavorText: L.dk_hollow_marchioness_owl_flavor,
    ),
    DreamkeeperDefinition(
      id: "magma_matron",
      name: L.dk_magma_matron_name,
      artName: LEn.dk_magma_matron_name,
      element: GameElement.ember,
      role: Role.tank,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 175, attack: 11, defense: 18, speed: 27),
      growthPerLevel:
          const Stats(hp: 13.2, attack: 0.8, defense: 1.35, speed: 0.22),
      ultimate: UltimateSkill(
          name: L.dk_magma_matron_ult,
          description: L.dk_magma_matron_ultDesc,
          damageMultiplier: 2,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_magma_matron_skill,
          description: L.dk_magma_matron_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_magma_matron_pass,
          description: L.dk_magma_matron_passDesc,
          statBonus: const Stats(hp: 10, attack: 0, defense: 2, speed: 0)),
      symbol: "flame.circle.fill",
      flavorText: L.dk_magma_matron_flavor,
    ),
    DreamkeeperDefinition(
      id: "abyss_duchess_jelly",
      name: L.dk_abyss_duchess_jelly_name,
      artName: LEn.dk_abyss_duchess_jelly_name,
      element: GameElement.tide,
      role: Role.control,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 108, attack: 14, defense: 9, speed: 52),
      growthPerLevel:
          const Stats(hp: 8.2, attack: 1.1, defense: 0.55, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_abyss_duchess_jelly_ult,
          description: L.dk_abyss_duchess_jelly_ultDesc,
          damageMultiplier: 1.9,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_abyss_duchess_jelly_skill,
          description: L.dk_abyss_duchess_jelly_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_abyss_duchess_jelly_pass,
          description: L.dk_abyss_duchess_jelly_passDesc,
          statBonus: const Stats(hp: 4, attack: 0, defense: 1, speed: 1)),
      symbol: "water.waves",
      flavorText: L.dk_abyss_duchess_jelly_flavor,
    ),
    DreamkeeperDefinition(
      id: "thornvine_baroness",
      name: L.dk_thornvine_baroness_name,
      artName: LEn.dk_thornvine_baroness_name,
      element: GameElement.bloom,
      role: Role.support,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 128, attack: 13, defense: 11, speed: 46),
      growthPerLevel:
          const Stats(hp: 9.2, attack: 1.05, defense: 0.75, speed: 0.38),
      ultimate: UltimateSkill(
          name: L.dk_thornvine_baroness_ult,
          description: L.dk_thornvine_baroness_ultDesc,
          damageMultiplier: 1.7,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_thornvine_baroness_skill,
          description: L.dk_thornvine_baroness_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_thornvine_baroness_pass,
          description: L.dk_thornvine_baroness_passDesc,
          statBonus: const Stats(hp: 6, attack: 0, defense: 2, speed: 0)),
      symbol: "leaf.fill",
      flavorText: L.dk_thornvine_baroness_flavor,
    ),
    DreamkeeperDefinition(
      id: "umbral_countess_raven",
      name: L.dk_umbral_countess_raven_name,
      artName: LEn.dk_umbral_countess_raven_name,
      element: GameElement.lunar,
      role: Role.control,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 100, attack: 15, defense: 8, speed: 61),
      growthPerLevel:
          const Stats(hp: 7.6, attack: 1.2, defense: 0.5, speed: 0.55),
      ultimate: UltimateSkill(
          name: L.dk_umbral_countess_raven_ult,
          description: L.dk_umbral_countess_raven_ultDesc,
          damageMultiplier: 2,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_umbral_countess_raven_skill,
          description: L.dk_umbral_countess_raven_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_umbral_countess_raven_pass,
          description: L.dk_umbral_countess_raven_passDesc,
          statBonus: const Stats(hp: 3, attack: 1, defense: 1, speed: 1)),
      symbol: "moon.fill",
      flavorText: L.dk_umbral_countess_raven_flavor,
    ),
    DreamkeeperDefinition(
      id: "star_warden",
      name: L.dk_star_warden_name,
      artName: LEn.dk_star_warden_name,
      element: GameElement.astral,
      role: Role.tank,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 155, attack: 10, defense: 16, speed: 33),
      growthPerLevel:
          const Stats(hp: 11.4, attack: 0.72, defense: 1.15, speed: 0.24),
      ultimate: UltimateSkill(
          name: L.dk_star_warden_ult,
          description: L.dk_star_warden_ultDesc,
          damageMultiplier: 1.8,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_star_warden_skill,
          description: L.dk_star_warden_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_star_warden_pass,
          description: L.dk_star_warden_passDesc,
          statBonus: const Stats(hp: 8, attack: 0, defense: 2, speed: 0)),
      symbol: "sparkles",
      flavorText: L.dk_star_warden_flavor,
    ),
    DreamkeeperDefinition(
      id: "molten_behemoth",
      name: L.dk_molten_behemoth_name,
      artName: LEn.dk_molten_behemoth_name,
      element: GameElement.ember,
      role: Role.tank,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 172, attack: 11, defense: 17, speed: 28),
      growthPerLevel:
          const Stats(hp: 13, attack: 0.8, defense: 1.3, speed: 0.22),
      ultimate: UltimateSkill(
          name: L.dk_molten_behemoth_ult,
          description: L.dk_molten_behemoth_ultDesc,
          damageMultiplier: 2.1,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_molten_behemoth_skill,
          description: L.dk_molten_behemoth_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_molten_behemoth_pass,
          description: L.dk_molten_behemoth_passDesc,
          statBonus: const Stats(hp: 10, attack: 1, defense: 2, speed: 0)),
      symbol: "flame.fill",
      flavorText: L.dk_molten_behemoth_flavor,
    ),
    DreamkeeperDefinition(
      id: "tempest_siren_orca",
      name: L.dk_tempest_siren_orca_name,
      artName: LEn.dk_tempest_siren_orca_name,
      element: GameElement.tide,
      role: Role.damage,
      rarity: Rarity.epic,
      baseStats: const Stats(hp: 120, attack: 19, defense: 8, speed: 48),
      growthPerLevel:
          const Stats(hp: 9.1, attack: 1.55, defense: 0.5, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_tempest_siren_orca_ult,
          description: L.dk_tempest_siren_orca_ultDesc,
          damageMultiplier: 2.3,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_tempest_siren_orca_skill,
          description: L.dk_tempest_siren_orca_skillDesc,
          effectMultiplier: 1.35,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_tempest_siren_orca_pass,
          description: L.dk_tempest_siren_orca_passDesc,
          statBonus: const Stats(hp: 4, attack: 3, defense: 0, speed: 0)),
      symbol: "tropicalstorm",
      flavorText: L.dk_tempest_siren_orca_flavor,
    ),
    DreamkeeperDefinition(
      id: "sylvan_matriarch_elk",
      name: L.dk_sylvan_matriarch_elk_name,
      artName: LEn.dk_sylvan_matriarch_elk_name,
      element: GameElement.bloom,
      role: Role.healer,
      rarity: Rarity.legendary,
      baseStats: const Stats(hp: 148, attack: 13, defense: 12, speed: 44),
      growthPerLevel:
          const Stats(hp: 10.8, attack: 1, defense: 0.88, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_sylvan_matriarch_elk_ult,
          description: L.dk_sylvan_matriarch_elk_ultDesc,
          damageMultiplier: 2.8,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_sylvan_matriarch_elk_skill,
          description: L.dk_sylvan_matriarch_elk_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_sylvan_matriarch_elk_pass,
          description: L.dk_sylvan_matriarch_elk_passDesc,
          statBonus: const Stats(hp: 10, attack: 0, defense: 1, speed: 0)),
      symbol: "leaf.fill",
      flavorText: L.dk_sylvan_matriarch_elk_flavor,
    ),
    DreamkeeperDefinition(
      id: "leviathan_consort",
      name: L.dk_leviathan_consort_name,
      artName: LEn.dk_leviathan_consort_name,
      element: GameElement.tide,
      role: Role.tank,
      rarity: Rarity.legendary,
      baseStats: const Stats(hp: 198, attack: 13, defense: 19, speed: 35),
      growthPerLevel:
          const Stats(hp: 14.8, attack: 1, defense: 1.45, speed: 0.3),
      ultimate: UltimateSkill(
          name: L.dk_leviathan_consort_ult,
          description: L.dk_leviathan_consort_ultDesc,
          damageMultiplier: 2.5,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_leviathan_consort_skill,
          description: L.dk_leviathan_consort_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 8),
      passive: PassiveTrait(
          name: L.dk_leviathan_consort_pass,
          description: L.dk_leviathan_consort_passDesc,
          statBonus: const Stats(hp: 12, attack: 0, defense: 2, speed: 0)),
      symbol: "water.waves",
      flavorText: L.dk_leviathan_consort_flavor,
    ),
    DreamkeeperDefinition(
      id: "starcourt_sovereign_whale",
      name: L.dk_starcourt_sovereign_whale_name,
      artName: LEn.dk_starcourt_sovereign_whale_name,
      element: GameElement.astral,
      role: Role.support,
      rarity: Rarity.legendary,
      baseStats: const Stats(hp: 160, attack: 14, defense: 12, speed: 46),
      growthPerLevel:
          const Stats(hp: 11.6, attack: 1.05, defense: 0.85, speed: 0.38),
      ultimate: UltimateSkill(
          name: L.dk_starcourt_sovereign_whale_ult,
          description: L.dk_starcourt_sovereign_whale_ultDesc,
          damageMultiplier: 2.6,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_starcourt_sovereign_whale_skill,
          description: L.dk_starcourt_sovereign_whale_skillDesc,
          effectMultiplier: 1.25,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_starcourt_sovereign_whale_pass,
          description: L.dk_starcourt_sovereign_whale_passDesc,
          statBonus: const Stats(hp: 8, attack: 0, defense: 1, speed: 1)),
      symbol: "sparkles",
      flavorText: L.dk_starcourt_sovereign_whale_flavor,
    ),
    DreamkeeperDefinition(
      id: "midnight_sovereign",
      name: L.dk_midnight_sovereign_name,
      artName: LEn.dk_midnight_sovereign_name,
      element: GameElement.lunar,
      role: Role.control,
      rarity: Rarity.mythic,
      baseStats: const Stats(hp: 145, attack: 18, defense: 13, speed: 63),
      growthPerLevel:
          const Stats(hp: 11, attack: 1.35, defense: 1, speed: 0.55),
      ultimate: UltimateSkill(
          name: L.dk_midnight_sovereign_ult,
          description: L.dk_midnight_sovereign_ultDesc,
          damageMultiplier: 3.4,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_midnight_sovereign_skill,
          description: L.dk_midnight_sovereign_skillDesc,
          effectMultiplier: 1.4,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_midnight_sovereign_pass,
          description: L.dk_midnight_sovereign_passDesc,
          statBonus: const Stats(hp: 6, attack: 2, defense: 1, speed: 2)),
      symbol: "moon.stars.fill",
      flavorText: L.dk_midnight_sovereign_flavor,
    ),
    DreamkeeperDefinition(
      id: "emberfall_queen",
      name: L.dk_emberfall_queen_name,
      artName: LEn.dk_emberfall_queen_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.mythic,
      baseStats: const Stats(hp: 158, attack: 25, defense: 12, speed: 59),
      growthPerLevel: const Stats(hp: 12, attack: 2, defense: 0.72, speed: 0.5),
      ultimate: UltimateSkill(
          name: L.dk_emberfall_queen_ult,
          description: L.dk_emberfall_queen_ultDesc,
          damageMultiplier: 3.6,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_emberfall_queen_skill,
          description: L.dk_emberfall_queen_skillDesc,
          effectMultiplier: 1.4,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_emberfall_queen_pass,
          description: L.dk_emberfall_queen_passDesc,
          statBonus: const Stats(hp: 5, attack: 3, defense: 0, speed: 1)),
      symbol: "flame.circle.fill",
      flavorText: L.dk_emberfall_queen_flavor,
    ),
    DreamkeeperDefinition(
      id: "igo",
      name: L.dk_igo_name,
      artName: LEn.dk_igo_name,
      element: GameElement.tide,
      role: Role.guardian,
      rarity: Rarity.exclusive,
      baseStats: const Stats(hp: 200, attack: 20, defense: 24, speed: 56),
      growthPerLevel:
          const Stats(hp: 16, attack: 1.3, defense: 1.7, speed: 0.4),
      ultimate: UltimateSkill(
          name: L.dk_igo_ult,
          description: L.dk_igo_ultDesc,
          damageMultiplier: 1.0,
          attacksToCharge: 5),
      activeSkill: ActiveSkill(
          name: L.dk_igo_skill,
          description: L.dk_igo_skillDesc,
          effectMultiplier: 1.3,
          cooldownSeconds: 7),
      passive: PassiveTrait(
          name: L.dk_igo_pass,
          description: L.dk_igo_passDesc,
          statBonus: Stats.zero,
          reviveHPFraction: 0.3),
      symbol: "shield.lefthalf.filled",
      flavorText: L.dk_igo_flavor,
    ),
    DreamkeeperDefinition(
      id: "ames",
      name: L.dk_ames_name,
      artName: LEn.dk_ames_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.exclusive,
      baseStats: const Stats(hp: 165, attack: 30, defense: 15, speed: 66),
      growthPerLevel:
          const Stats(hp: 12, attack: 2.2, defense: 0.9, speed: 0.6),
      ultimate: UltimateSkill(
          name: L.dk_ames_ult,
          description: L.dk_ames_ultDesc,
          damageMultiplier: 3.8,
          attacksToCharge: 4),
      activeSkill: ActiveSkill(
          name: L.dk_ames_skill,
          description: L.dk_ames_skillDesc,
          effectMultiplier: 1.5,
          cooldownSeconds: 6),
      passive: PassiveTrait(
          name: L.dk_ames_pass,
          description: L.dk_ames_passDesc,
          statBonus: Stats.zero,
          lowHPAttackBonus: 0.6),
      symbol: "flame.fill",
      flavorText: L.dk_ames_flavor,
    ),

    // Olf \u2014 the joke starter every new save begins with. All six entries
    // here share family: 'olf' so any of them pulled later from Summoning
    // can be fused straight into whichever one the player is actually
    // raising, and all six are literally named "Olf" so DreamkeeperArt
    // resolves every one of them to the same single portrait.
    DreamkeeperDefinition(
      id: "olf_ember",
      name: L.dk_olf_name,
      artName: LEn.dk_olf_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 62, attack: 10, defense: 4, speed: 42),
      growthPerLevel:
          const Stats(hp: 4.6, attack: 0.75, defense: 0.28, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_olf_ember_ult,
          description: L.dk_olf_ember_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_olf_ember_skill,
          description: L.dk_olf_ember_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_olf_pass,
          description: L.dk_olf_passDesc,
          statBonus: Stats(hp: 0, attack: 1, defense: 0, speed: 0)),
      symbol: "theatermasks.fill",
      flavorText: L.dk_olf_ember_flavor,
      family: "olf",
    ),
    DreamkeeperDefinition(
      id: "olf_tide",
      name: L.dk_olf_name,
      artName: LEn.dk_olf_name,
      element: GameElement.tide,
      role: Role.damage,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 62, attack: 10, defense: 4, speed: 42),
      growthPerLevel:
          const Stats(hp: 4.6, attack: 0.75, defense: 0.28, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_olf_tide_ult,
          description: L.dk_olf_tide_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_olf_tide_skill,
          description: L.dk_olf_tide_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_olf_pass,
          description: L.dk_olf_passDesc,
          statBonus: Stats(hp: 0, attack: 1, defense: 0, speed: 0)),
      symbol: "theatermasks.fill",
      flavorText: L.dk_olf_tide_flavor,
      family: "olf",
    ),
    DreamkeeperDefinition(
      id: "olf_bloom",
      name: L.dk_olf_name,
      artName: LEn.dk_olf_name,
      element: GameElement.bloom,
      role: Role.damage,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 62, attack: 10, defense: 4, speed: 42),
      growthPerLevel:
          const Stats(hp: 4.6, attack: 0.75, defense: 0.28, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_olf_bloom_ult,
          description: L.dk_olf_bloom_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_olf_bloom_skill,
          description: L.dk_olf_bloom_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_olf_pass,
          description: L.dk_olf_passDesc,
          statBonus: Stats(hp: 0, attack: 1, defense: 0, speed: 0)),
      symbol: "theatermasks.fill",
      flavorText: L.dk_olf_bloom_flavor,
      family: "olf",
    ),
    DreamkeeperDefinition(
      id: "olf_lunar",
      name: L.dk_olf_name,
      artName: LEn.dk_olf_name,
      element: GameElement.lunar,
      role: Role.damage,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 62, attack: 10, defense: 4, speed: 42),
      growthPerLevel:
          const Stats(hp: 4.6, attack: 0.75, defense: 0.28, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_olf_lunar_ult,
          description: L.dk_olf_lunar_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_olf_lunar_skill,
          description: L.dk_olf_lunar_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_olf_pass,
          description: L.dk_olf_passDesc,
          statBonus: Stats(hp: 0, attack: 1, defense: 0, speed: 0)),
      symbol: "theatermasks.fill",
      flavorText: L.dk_olf_lunar_flavor,
      family: "olf",
    ),
    DreamkeeperDefinition(
      id: "olf_astral",
      name: L.dk_olf_name,
      artName: LEn.dk_olf_name,
      element: GameElement.astral,
      role: Role.damage,
      rarity: Rarity.common,
      baseStats: const Stats(hp: 62, attack: 10, defense: 4, speed: 42),
      growthPerLevel:
          const Stats(hp: 4.6, attack: 0.75, defense: 0.28, speed: 0.35),
      ultimate: UltimateSkill(
          name: L.dk_olf_astral_ult,
          description: L.dk_olf_astral_ultDesc,
          damageMultiplier: 1.5,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_olf_astral_skill,
          description: L.dk_olf_astral_skillDesc,
          effectMultiplier: 1.2,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_olf_pass,
          description: L.dk_olf_passDesc,
          statBonus: Stats(hp: 0, attack: 1, defense: 0, speed: 0)),
      symbol: "theatermasks.fill",
      flavorText: L.dk_olf_astral_flavor,
      family: "olf",
    ),
    // Never rolled by Summoning (isSummonable: false) \u2014 granted only by
    // holding the Ember option for 5 seconds on the post-onboarding
    // starter-element screen. Exactly +10% over the plain Olf's stats in
    // every field, per the secret's own promise.
    DreamkeeperDefinition(
      id: "olf_ultimate",
      name: L.dk_olf_name,
      artName: LEn.dk_olf_name,
      element: GameElement.ember,
      role: Role.damage,
      rarity: Rarity.rare,
      baseStats: const Stats(hp: 68.2, attack: 11, defense: 4.4, speed: 46.2),
      growthPerLevel:
          const Stats(hp: 5.06, attack: 0.825, defense: 0.308, speed: 0.385),
      ultimate: UltimateSkill(
          name: L.dk_olf_ultimate_ult,
          description: L.dk_olf_ultimate_ultDesc,
          damageMultiplier: 1.65,
          attacksToCharge: 3),
      activeSkill: ActiveSkill(
          name: L.dk_olf_ultimate_skill,
          description: L.dk_olf_ultimate_skillDesc,
          effectMultiplier: 1.32,
          cooldownSeconds: 5),
      passive: PassiveTrait(
          name: L.dk_olf_ultimate_pass,
          description: L.dk_olf_ultimate_passDesc,
          statBonus: Stats(hp: 4, attack: 1, defense: 1, speed: 1)),
      symbol: "theatermasks.fill",
      flavorText: L.dk_olf_ultimate_flavor,
      family: "olf",
      isSummonable: false,
    ),
  ]);

  /// Order new Dreamkeepers unlock in as the campaign progresses; the rest
  /// of the catalog is summon-only, reached via the Dream Shrine.
  static const List<String> unlockOrder = [
    'ember_fox',
    'moon_hare',
    'crystal_golem',
    'forest_spirit',
    'star_wolf'
  ];

  /// Every new save's starter, before the post-onboarding screen locks in
  /// an element (or, via the secret gesture, Ultimate Olf) \u2014 see
  /// GameState.needsStarterOlfChoice / chooseStarterOlf. Fire is the
  /// default because it's also the element the secret gesture hides
  /// behind, so a player who never touches the choice screen still ends up
  /// with a normal, fully playable Fire Olf.
  static const String starterOlfDefaultID = 'olf_ember';

  /// Granted only by the secret 5-second hold on Ember during the
  /// starter-element screen; never reachable via Summoning.
  static const String ultimateOlfID = 'olf_ultimate';

  static String olfDefinitionID(GameElement element) => 'olf_${element.name}';
}
