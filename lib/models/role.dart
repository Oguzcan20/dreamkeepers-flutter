/// Mirrors GameCore/Models/Role.swift exactly — keep both in sync.
enum Role {
  tank,
  damage,
  support,
  healer,
  control,

  /// Tank/Support hybrid: Ultimate shields the whole team, Active Skill
  /// strikes and slows the enemy. See BattleEngine.shieldAllies /
  /// quickStrikeAndSlow. Introduced for Igo rather than special-casing his
  /// identity in combat code.
  guardian;

  String get displayName {
    switch (this) {
      case Role.tank:
        return 'Tank';
      case Role.damage:
        return 'Damage';
      case Role.support:
        return 'Support';
      case Role.healer:
        return 'Healer';
      case Role.control:
        return 'Control';
      case Role.guardian:
        return 'Guardian';
    }
  }

  String get symbol {
    switch (this) {
      case Role.tank:
        return 'shield.fill';
      case Role.damage:
        return 'bolt.fill';
      case Role.support:
        return 'wand.and.stars';
      case Role.healer:
        return 'cross.case.fill';
      case Role.control:
        return 'snowflake';
      case Role.guardian:
        return 'shield.righthalf.filled';
    }
  }
}
