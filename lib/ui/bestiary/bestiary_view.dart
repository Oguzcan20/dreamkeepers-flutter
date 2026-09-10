import 'package:flutter/material.dart';

import '../../data/monster_catalog.dart';
import '../../data/world_catalog.dart';
import '../../l10n/l10n.dart';
import '../../models/world.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// Dream Observatory (spec: "Schaltet neue Inhalte frei" — unlocks new
/// content). Every monster and boss fought gets logged here; undiscovered
/// entries stay silhouetted until the player meets them in battle. Mirrors
/// UI/Bestiary/BestiaryView.swift exactly.
class BestiaryView extends StatelessWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;
  const BestiaryView({super.key, required this.gameState, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Stack(
      children: [
        const dk_theme.AmbientBackground(topTint: dk_theme.Theme.softBlue, bottomTint: dk_theme.Theme.gold),
        SafeArea(
          child: Column(
            children: [
              _header(l),
              Expanded(
                child: AnimatedBuilder(
                  animation: gameState,
                  builder: (context, _) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Column(
                      children: [
                        for (final world in WorldCatalog.worlds) ...[
                          _WorldCodexSection(world: world, gameState: gameState),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Semantics(
            label: l.commonBack,
            button: true,
            child: GestureDetector(
              onTap: () => onNavigate(const DreamHavenRoute()),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: const Icon(Icons.chevron_left, color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Text(l.navObservatory, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                l.havenDiscovered(gameState.bestiaryDiscoveredCount, gameState.bestiaryTotalCount),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 40, height: 1),
        ],
      ),
    );
  }
}

class _WorldCodexSection extends StatelessWidget {
  final World world;
  final GameState gameState;
  const _WorldCodexSection({required this.world, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(world.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(world.description, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 148,
            ),
            itemCount: MonsterCatalog.allEntries(world.id).length,
            itemBuilder: (context, index) {
              final entry = MonsterCatalog.allEntries(world.id)[index];
              return _CodexEntryCard(
                name: entry.name,
                symbol: entry.symbol,
                lore: entry.lore,
                isBoss: entry.isBoss,
                accent: world.accentColor,
                isDiscovered: gameState.isDiscovered(entry.name),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CodexEntryCard extends StatelessWidget {
  final String name;
  final String symbol;
  final String lore;
  final bool isBoss;
  final Color accent;
  final bool isDiscovered;

  const _CodexEntryCard({
    required this.name,
    required this.symbol,
    required this.lore,
    required this.isBoss,
    required this.accent,
    required this.isDiscovered,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBoss && isDiscovered ? Colors.red.withValues(alpha: 0.4) : dk_theme.Theme.cardStroke,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MonsterBadge(name: name, symbol: symbol, isBoss: isBoss, accent: accent, isDiscovered: isDiscovered),
          const SizedBox(height: 8),
          Text(
            isDiscovered ? name : '???',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            isDiscovered ? lore : l.bestiaryNotEncountered,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white.withValues(alpha: isDiscovered ? 0.6 : 0.35), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

/// A layered fantasy-badge treatment (glow + gradient medallion + bevel ring)
/// standing in for real per-monster art where none exists yet — still just
/// a Material icon underneath, but staged like an inventory icon rather than
/// a flat tinted circle. Once art is supplied (see `MonsterArt`), that's
/// used instead, same glow/bevel frame around it. Mirrors Swift's
/// `MonsterBadge` exactly.
class MonsterBadge extends StatelessWidget {
  final String name;
  final String symbol;
  final bool isBoss;
  final Color accent;
  final bool isDiscovered;
  final double size;

  const MonsterBadge({
    super.key,
    required this.name,
    required this.symbol,
    required this.isBoss,
    required this.accent,
    required this.isDiscovered,
    this.size = 44,
  });

  Color get _tint => isBoss ? Colors.red : accent;
  bool get _hasArt => isDiscovered && dk_theme.MonsterArt.hasArt(name);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_hasArt)
            ClipOval(
              child: Image.asset(dk_theme.MonsterArt.assetName(name), width: size, height: size, fit: BoxFit.cover),
            )
          else ...[
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDiscovered
                      ? [_tint.withValues(alpha: 0.85), _tint.withValues(alpha: 0.35)]
                      : [Colors.white.withValues(alpha: 0.08), Colors.white.withValues(alpha: 0.03)],
                ),
              ),
            ),
            Icon(
              isDiscovered ? sfSymbol(symbol) : Icons.question_mark,
              size: size * 0.4,
              color: isDiscovered ? Colors.white : Colors.white.withValues(alpha: 0.3),
            ),
          ],
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDiscovered ? (isBoss ? dk_theme.Theme.gold : Colors.white).withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.18),
                width: isBoss && isDiscovered ? 1.6 : 1,
              ),
            ),
          ),
          if (isBoss && isDiscovered)
            Positioned(
              right: size * 0.02,
              top: size * 0.02,
              child: Icon(Icons.auto_awesome, size: size * 0.22, color: dk_theme.Theme.gold),
            ),
        ],
      ),
    );
  }
}
