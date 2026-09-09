import 'package:flutter/material.dart';

import '../../combat/twin_bond.dart';
import '../../data/dreamkeeper_catalog.dart';
import '../../models/dreamkeeper.dart';
import '../../models/element.dart';
import '../../models/role.dart';
import '../../models/stats.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../shared/star_row.dart';

/// Full reference page for one Dreamkeeper — art, stats, every ability with
/// what it actually does in battle, its element matchups, and its lore.
/// Presented as an in-place `Stack` overlay by `DreamkeeperCodexView`, same
/// as the rest of this app's full-screen overlays. Mirrors
/// DreamkeeperCodexDetailView.swift exactly.
class DreamkeeperCodexDetailView extends StatelessWidget {
  final DreamkeeperDefinition definition;
  final bool isOwned;
  final int ownedCount;
  final int maxStars;

  /// Only needed to read the currently-deployed team, for the Zwillingsbund
  /// active/inactive indicator on Igo/Ames — see `TwinBond`.
  final GameState gameState;
  final VoidCallback onClose;

  const DreamkeeperCodexDetailView({
    super.key,
    required this.definition,
    required this.isOwned,
    required this.ownedCount,
    required this.maxStars,
    required this.gameState,
    required this.onClose,
  });

  bool get _hasArt => dk_theme.DreamkeeperArt.hasArt(definition.name);

  /// Reference ranges pulled from the whole catalog so every stat bar reads
  /// relative to the strongest Dreamkeeper in the game, not some arbitrary
  /// fixed scale.
  static final List<DreamkeeperDefinition> _allDefinitions = DreamkeeperCatalog.starter.definitions;
  static final double _maxHP = _allDefinitions.map((d) => d.baseStats.hp).reduce((a, b) => a > b ? a : b);
  static final double _maxAttack = _allDefinitions.map((d) => d.baseStats.attack).reduce((a, b) => a > b ? a : b);
  static final double _maxDefense = _allDefinitions.map((d) => d.baseStats.defense).reduce((a, b) => a > b ? a : b);
  static final double _maxSpeed = _allDefinitions.map((d) => d.baseStats.speed).reduce((a, b) => a > b ? a : b);

  /// What each role's Ultimate/Active Skill actually resolves to in
  /// `BattleEngine` — the numbers on a skill card don't explain themselves
  /// without this.
  static const Map<Role, String> _roleMechanics = {
    Role.tank: 'High HP and Defense — built to endure. Both the Ultimate and Active Skill strike the enemy directly.',
    Role.damage: 'High Attack. Both the Ultimate and Active Skill strike the enemy for extra damage.',
    Role.healer: 'The Ultimate heals the whole team at once; the Active Skill heals whichever ally is lowest on HP.',
    Role.support: "The Ultimate boosts the whole team's Attack for the rest of the battle; the Active Skill boosts its own Attack.",
    Role.control: 'The Ultimate strikes the enemy and briefly stuns it; the Active Skill is a quick strike.',
    Role.guardian: 'The Ultimate shields the whole team; the Active Skill strikes the enemy and slows it.',
  };

  List<GameElement> get _strongAgainst =>
      GameElement.values.where((e) => definition.element.multiplier(e) > 1.0).toList();

  List<GameElement> get _weakAgainst =>
      GameElement.values.where((e) => e.multiplier(definition.element) > 1.0).toList();

  /// `AbilityRow`'s detail lines and `_statBonusSummary` build plain
  /// `String`s from interpolated numbers, so they never go through any
  /// localization table no matter how they're wrapped — picking the
  /// finished sentence directly, in whichever language is active, is the
  /// only way these read correctly in German. Mirrors Swift's `isGerman`/
  /// `localized(en:de:)` on this view.
  bool get _isGerman => gameState.preferredLanguage == 'de';

  String _localized({required String en, required String de}) => _isGerman ? de : en;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: dk_theme.Theme.background)),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [definition.element.color.withValues(alpha: 0.3), Colors.transparent],
                    radius: 0.9,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _closeHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 250, child: _heroColumn()),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              _roleCard(),
                              const SizedBox(height: 14),
                              _statsCard(),
                              const SizedBox(height: 14),
                              _abilitiesCard(),
                              const SizedBox(height: 14),
                              _matchupCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Semantics(
            label: 'Close',
            button: true,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: Icon(sfSymbol('xmark'), color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Hero column

  Widget _heroColumn() {
    return Column(
      children: [
        SizedBox(
          width: 132,
          height: 132,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.55,
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: definition.rarity.gradient),
                ),
              ),
              _hasArt
                  ? ClipOval(
                      child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.name), width: 132, height: 132, fit: BoxFit.cover),
                    )
                  : Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: definition.rarity.gradient),
                      child: Icon(sfSymbol(definition.symbol), size: 52, color: Colors.white),
                    ),
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: definition.rarity.primaryColor, width: 3)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          definition.name,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: [
            _PillBadge(icon: definition.element.symbol, text: definition.element.displayName, tint: definition.element.color),
            _PillBadge(icon: definition.role.symbol, text: definition.role.displayName, tint: Colors.white.withValues(alpha: 0.7)),
          ],
        ),
        const SizedBox(height: 6),
        _PillBadge(icon: 'sparkles', text: definition.rarity.displayName, tint: definition.rarity.primaryColor, filled: true),
        const SizedBox(height: 12),
        _ownershipCard(),
        const SizedBox(height: 12),
        _storyCard(),
      ],
    );
  }

  Widget _ownershipCard() {
    return SizedBox(
      width: double.infinity,
      child: dk_theme.GlassCard(
        child: isOwned
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(sfSymbol('checkmark.seal.fill'), size: 14, color: dk_theme.Theme.gold),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'In Your Collection',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Owned ×$ownedCount', style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 10)),
                  const SizedBox(height: 4),
                  StarRow(stars: maxStars),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(sfSymbol('questionmark.circle.fill'), size: 14, color: Colors.white.withValues(alpha: 0.5)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Not Owned Yet',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find this Dreamkeeper at the Summoning Shrine.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 10),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _storyCard() {
    return SizedBox(
      width: double.infinity,
      child: dk_theme.GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol('quote.opening'), size: 12, color: definition.element.color.withValues(alpha: 0.7)),
            const SizedBox(height: 6),
            Text(
              definition.flavorText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - Right column

  Widget _roleCard() {
    return dk_theme.GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 20, child: Icon(sfSymbol(definition.role.symbol), size: 18, color: dk_theme.Theme.softBlue)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How It Fights', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(_roleMechanics[definition.role] ?? '', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsCard() {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Base Stats', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _StatBar(label: 'HP', value: definition.baseStats.hp, maxValue: _maxHP, tint: Colors.red.withValues(alpha: 0.75)),
          const SizedBox(height: 8),
          _StatBar(label: 'ATK', value: definition.baseStats.attack, maxValue: _maxAttack, tint: dk_theme.Theme.gold),
          const SizedBox(height: 8),
          _StatBar(label: 'DEF', value: definition.baseStats.defense, maxValue: _maxDefense, tint: dk_theme.Theme.softBlue),
          const SizedBox(height: 8),
          _StatBar(label: 'SPD', value: definition.baseStats.speed, maxValue: _maxSpeed, tint: dk_theme.Theme.violet),
        ],
      ),
    );
  }

  Widget _abilitiesCard() {
    return Column(
      children: [
        _AbilityRow(
          icon: 'sparkles',
          tint: dk_theme.Theme.gold,
          category: 'Ultimate',
          name: definition.ultimate.name,
          description: definition.ultimate.description,
          detail: _localized(
            en: 'Charges after ${definition.ultimate.attacksToCharge} attacks · ×${definition.ultimate.damageMultiplier.toStringAsFixed(1)} power',
            de: 'Lädt nach ${definition.ultimate.attacksToCharge} Angriffen · ×${definition.ultimate.damageMultiplier.toStringAsFixed(1)} Stärke',
          ),
        ),
        const SizedBox(height: 10),
        _AbilityRow(
          icon: 'bolt.fill',
          tint: dk_theme.Theme.softBlue,
          category: 'Active Skill',
          name: definition.activeSkill.name,
          description: definition.activeSkill.description,
          detail: _localized(
            en: '${definition.activeSkill.cooldownSeconds.toInt()}s cooldown · ×${definition.activeSkill.effectMultiplier.toStringAsFixed(1)} power',
            de: '${definition.activeSkill.cooldownSeconds.toInt()} s Abklingzeit · ×${definition.activeSkill.effectMultiplier.toStringAsFixed(1)} Stärke',
          ),
        ),
        const SizedBox(height: 10),
        _AbilityRow(
          icon: 'shield.lefthalf.filled',
          tint: Colors.white.withValues(alpha: 0.7),
          category: 'Passive',
          name: definition.passive.name,
          description: definition.passive.description,
          detail: _statBonusSummary(definition.passive.statBonus),
        ),
        if (TwinBond.isBondCharacter(definition.id)) ...[
          const SizedBox(height: 10),
          _twinBondRow(),
        ],
      ],
    );
  }

  /// Igo/Ames only — the visible hint for `TwinBond`: gold and "Aktiv" while
  /// both are in the deployed formation, gray and "Inaktiv" otherwise.
  Widget _twinBondRow() {
    final active = TwinBond.isActive(gameState.deployedTeam.map((i) => i.definitionID));
    final isIgo = definition.id == TwinBond.igoID;
    return _AbilityRow(
      icon: 'link',
      tint: active ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.4),
      category: _localized(en: 'Twin Bond', de: 'Zwillingsbund'),
      name: '+75% ATK/DEF',
      description: _localized(
        en: isIgo
            ? 'Twin Bond: +75% ATK/DEF — only active while Ames is also in the battle formation.'
            : 'Twin Bond: +75% ATK/DEF — only active while Igo is also in the battle formation.',
        de: isIgo
            ? 'Zwillingsbund: +75% ATK/DEF — nur aktiv, wenn Ames ebenfalls in der Kampfformation steht.'
            : 'Zwillingsbund: +75% ATK/DEF — nur aktiv, wenn Igo ebenfalls in der Kampfformation steht.',
      ),
      detail: _localized(en: active ? 'Active' : 'Inactive', de: active ? 'Aktiv' : 'Inaktiv'),
    );
  }

  String _statBonusSummary(Stats bonus) {
    final parts = <String>[];
    if (bonus.hp > 0) parts.add('+${bonus.hp.toInt()} HP');
    if (bonus.attack > 0) parts.add('+${bonus.attack.toInt()} ATK');
    if (bonus.defense > 0) parts.add('+${bonus.defense.toInt()} DEF');
    if (bonus.speed > 0) parts.add('+${bonus.speed.toInt()} SPD');
    return parts.isEmpty ? _localized(en: 'Always active', de: 'Immer aktiv') : parts.join(' · ');
  }

  Widget _matchupCard() {
    final strong = _strongAgainst;
    final weak = _weakAgainst;
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Element Matchups', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (strong.isEmpty && weak.isEmpty)
            Text(
              'Balanced against every element — no bonus or penalty either way.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
            )
          else ...[
            if (strong.isNotEmpty) _MatchupRow(icon: 'arrow.up.circle.fill', tint: Colors.green, label: 'Strong Against', elements: strong),
            if (strong.isNotEmpty && weak.isNotEmpty) const SizedBox(height: 6),
            if (weak.isNotEmpty)
              _MatchupRow(icon: 'arrow.down.circle.fill', tint: Colors.red.withValues(alpha: 0.85), label: 'Weak Against', elements: weak),
          ],
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String icon;
  final String text;
  final Color tint;
  final bool filled;

  const _PillBadge({required this.icon, required this.text, required this.tint, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? tint : tint.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: filled ? Colors.transparent : tint.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(sfSymbol(icon), size: 10, color: filled ? Colors.black : Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: filled ? Colors.black : Colors.white.withValues(alpha: 0.9), fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final Color tint;

  const _StatBar({required this.label, required this.value, required this.maxValue, required this.tint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 10, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text('${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 3),
        LayoutBuilder(
          builder: (context, constraints) {
            final fraction = maxValue == 0 ? 0.0 : (value / maxValue).clamp(0.0, 1.0);
            return SizedBox(
              height: 7,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: (constraints.maxWidth * fraction).clamp(4, constraints.maxWidth),
                      color: tint,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AbilityRow extends StatelessWidget {
  final String icon;
  final Color tint;
  final String category;
  final String name;
  final String description;
  final String detail;

  const _AbilityRow({
    required this.icon,
    required this.tint,
    required this.category,
    required this.name,
    required this.description,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: dk_theme.GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 20, child: Icon(sfSymbol(icon), size: 18, color: tint)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(category, style: TextStyle(color: tint, fontSize: 10, fontWeight: FontWeight.w800)),
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(description, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(detail, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchupRow extends StatelessWidget {
  final String icon;
  final Color tint;
  final String label;
  final List<GameElement> elements;

  const _MatchupRow({required this.icon, required this.tint, required this.label, required this.elements});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol(icon), size: 14, color: tint),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
        for (final element in elements)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(color: element.color.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(sfSymbol(element.symbol), size: 10, color: Colors.white),
                const SizedBox(width: 3),
                Text(element.displayName, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }
}
