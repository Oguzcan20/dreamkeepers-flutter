import '../l10n/l10n.dart';

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
        return L.roleTank;
      case Role.damage:
        return L.roleDamage;
      case Role.support:
        return L.roleSupport;
      case Role.healer:
        return L.roleHealer;
      case Role.control:
        return L.roleControl;
      case Role.guardian:
        return L.roleGuardian;
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
