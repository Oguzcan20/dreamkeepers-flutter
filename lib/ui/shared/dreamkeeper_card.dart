import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../models/dreamkeeper.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import 'star_row.dart';

/// A 96-wide roster card: portrait (real art or a rarity-gradient + symbol
/// fallback) with an element badge, name, level, star row, deployed-state
/// border treatment, and two optional overlays — a sell-selection checkmark
/// and a Twin Bond pill. Mirrors `DreamkeeperCard` (UI/Shared/DreamkeeperCard.swift)
/// exactly, except name/status shrinking: Flutter has no `.minimumScaleFactor`
/// equivalent, so the name falls back to `maxLines`/ellipsis instead of
/// truly shrinking font size (same tradeoff already made for
/// `DreamHavenView`'s building cards).
class DreamkeeperCard extends StatelessWidget {
  final DreamkeeperDefinition definition;
  final DreamkeeperInstance instance;
  final bool isDeployed;

  /// Non-null while the roster grid is in sell-selection mode — true means
  /// this card is one of the ones currently picked to sell. Null (the
  /// default) hides the selection checkmark entirely for every other use of
  /// this card.
  final bool? isSelectedForSale;

  /// Igo/Ames only — null hides the badge entirely for the other 30
  /// characters. See `TwinBond`.
  final bool? twinBondActive;

  final VoidCallback? onTap;

  const DreamkeeperCard({
    super.key,
    required this.definition,
    required this.instance,
    this.isDeployed = false,
    this.isSelectedForSale,
    this.twinBondActive,
    this.onTap,
  });

  bool get _hasArt => dk_theme.DreamkeeperArt.hasArt(definition.name);

  @override
  Widget build(BuildContext context) {
    final selected = isSelectedForSale == true;
    return Semantics(
      label: '${definition.name}, Lv ${instance.level}',
      selected: isDeployed || selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 96,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDeployed ? dk_theme.Theme.violet.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDeployed ? dk_theme.Theme.gold : dk_theme.Theme.cardStroke,
              width: isDeployed ? 2 : 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _portrait(),
                  const SizedBox(height: 8),
                  Text(
                    definition.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text('Lv ${instance.level}', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 10)),
                  const SizedBox(height: 4),
                  StarRow(stars: instance.stars),
                  if (twinBondActive != null) ...[
                    const SizedBox(height: 4),
                    _twinBondPill(twinBondActive!, AppLocalizations.of(context)),
                  ],
                ],
              ),
              if (isSelectedForSale != null)
                Positioned(
                  left: 4,
                  top: 4,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(color: dk_theme.Theme.deepNavy.withValues(alpha: 0.6), shape: BoxShape.circle),
                      child: Icon(
                        selected ? Icons.check_circle : Icons.circle_outlined,
                        size: 18,
                        color: selected ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _portrait() {
    final glow = definition.rarity.glows
        ? [BoxShadow(color: definition.element.color.withValues(alpha: 0.7), blurRadius: 10)]
        : const <BoxShadow>[];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _hasArt ? null : definition.rarity.gradient,
            boxShadow: glow,
          ),
          alignment: Alignment.center,
          child: _hasArt
              ? ClipOval(child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.name), width: 64, height: 64, fit: BoxFit.cover))
              : Icon(sfSymbol(definition.symbol), size: 26, color: Colors.white),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: definition.element.color, shape: BoxShape.circle),
            child: Icon(sfSymbol(definition.element.symbol), size: 10, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _twinBondPill(bool active, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: active ? dk_theme.Theme.gold.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.15)),
      ),
      child: Text(
        l.cardTwinBond,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: active ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
