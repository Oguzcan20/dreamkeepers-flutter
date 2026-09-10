import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../progression/star_fusion_system.dart';
import '../../theme/theme.dart' as dk_theme;

/// Compact star-rating row shared by Dreamkeeper cards, item rows, and the
/// fusion sheets — filled stars up to [stars], outlined slots for the
/// remainder up to `StarFusionSystem.maxStars`. Mirrors `StarRow`
/// (UI/Shared/StarRow.swift) exactly.
class StarRow extends StatelessWidget {
  final int stars;
  final double size;

  const StarRow({super.key, required this.stars, this.size = 10});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).starRowSemantic(stars, StarFusionSystem.maxStars),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < StarFusionSystem.maxStars; index++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.5),
                child: Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  size: size,
                  color: index < stars ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.25),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
