/// Igo and Ames were the only two humans who ever stayed in Dream Haven —
/// their bond only manifests when they fight side by side. Mirrors
/// GameCore/Combat/TwinBond.swift exactly.
class TwinBond {
  static const igoID = 'igo';
  static const amesID = 'ames';

  /// +75% ATK/DEF for both, only while both are in the active battle formation.
  static const statBonusMultiplier = 0.75;

  static bool isActive(Iterable<String> memberDefinitionIDs) {
    final set = memberDefinitionIDs.toSet();
    return set.contains(igoID) && set.contains(amesID);
  }

  static bool isBondCharacter(String definitionID) {
    return definitionID == igoID || definitionID == amesID;
  }

  static String? partnerID(String definitionID) {
    if (definitionID == igoID) return amesID;
    if (definitionID == amesID) return igoID;
    return null;
  }
}
