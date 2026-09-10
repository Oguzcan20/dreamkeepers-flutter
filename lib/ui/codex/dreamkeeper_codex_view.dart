import 'package:flutter/material.dart';

import '../../data/dreamkeeper_catalog.dart';
import '../../l10n/l10n.dart';
import '../../models/dreamkeeper.dart';
import '../../models/element.dart';
import '../../models/rarity.dart';
import '../../models/role.dart';
import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';
import '../shared/star_row.dart';
import 'dreamkeeper_codex_detail_view.dart';

/// Dreamkeeper Codex — a full reference for every Dreamkeeper in the game,
/// owned or not. Unlike the Dream Observatory's enemy bestiary (which stays
/// silhouetted until discovered in battle), every entry here shows its full
/// art, stats and lore up front: the Summoning Shrine already shows exact
/// odds with "no hidden mechanics", so hiding a Dreamkeeper's own details
/// behind ownership would be inconsistent with that. Ownership is a badge,
/// not a lock. Mirrors DreamkeeperCodexView.swift exactly. On the
/// `showsGlobalHomeButton` exclusion list (own header back button), reached
/// today from Team/Inventory's "Dreamkeeper Codex" header button.
class DreamkeeperCodexView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;
  const DreamkeeperCodexView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<DreamkeeperCodexView> createState() => _DreamkeeperCodexViewState();
}

class _DreamkeeperCodexViewState extends State<DreamkeeperCodexView> {
  GameElement? _elementFilter;
  Role? _roleFilter;
  DreamkeeperDefinition? _selectedDefinition;

  DreamkeeperCatalog get _catalog => widget.gameState.catalog;

  List<DreamkeeperDefinition> get _filteredDefinitions {
    final list = _catalog.definitions
        .where((def) => _elementFilter == null || def.element == _elementFilter)
        .where((def) => _roleFilter == null || def.role == _roleFilter)
        .toList();
    list.sort((lhs, rhs) {
      if (lhs.rarity != rhs.rarity) return rhs.rarity.compareTo(lhs.rarity);
      return lhs.name.compareTo(rhs.name);
    });
    return list;
  }

  bool _isOwned(DreamkeeperDefinition definition) =>
      widget.gameState.roster.any((i) => i.definitionID == definition.id);

  int _ownedCount(DreamkeeperDefinition definition) =>
      widget.gameState.roster.where((i) => i.definitionID == definition.id).length;

  int _maxStars(DreamkeeperDefinition definition) {
    final owned = widget.gameState.roster.where((i) => i.definitionID == definition.id);
    if (owned.isEmpty) return 0;
    return owned.map((i) => i.stars).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.gameState,
      builder: (context, _) => Stack(
        children: [
          const dk_theme.AmbientBackground(topTint: dk_theme.Theme.gold, bottomTint: dk_theme.Theme.violet),
          SafeArea(
            child: Column(
              children: [
                _header(AppLocalizations.of(context)),
                _filterBar(AppLocalizations.of(context)),
                Expanded(child: _grid()),
              ],
            ),
          ),
          if (_selectedDefinition != null)
            DreamkeeperCodexDetailView(
              definition: _selectedDefinition!,
              isOwned: _isOwned(_selectedDefinition!),
              ownedCount: _ownedCount(_selectedDefinition!),
              maxStars: _maxStars(_selectedDefinition!),
              gameState: widget.gameState,
              onClose: () => setState(() => _selectedDefinition = null),
            ),
        ],
      ),
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
              onTap: () => widget.onNavigate(const DreamHavenRoute()),
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
              Text(l.navCodex, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                l.codexCollected(widget.gameState.ownedSpeciesCount, _catalog.definitions.length),
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

  Widget _filterBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ElementChip(
                    title: l.commonAll,
                    color: Colors.white,
                    isSelected: _elementFilter == null,
                    onTap: () => setState(() => _elementFilter = null),
                  ),
                  for (final element in GameElement.values) ...[
                    const SizedBox(width: 8),
                    _ElementChip(
                      title: element.displayName,
                      symbol: element.symbol,
                      color: element.color,
                      isSelected: _elementFilter == element,
                      onTap: () => setState(() => _elementFilter = element),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          _roleFilterButton(l),
        ],
      ),
    );
  }

  Widget _roleFilterButton(AppLocalizations l) {
    return Semantics(
      label: l.codexFilterByRole,
      button: true,
      // `PopupMenuButton` wraps its `child` in its own `Tooltip`/`InkWell`
      // (its own semantics-emitting subtree), so this outer label needs
      // `container: true` to get its own isolated `SemanticsNode` instead
      // of merging into (and losing to) that inner one.
      container: true,
      child: PopupMenuButton<Role?>(
        onSelected: (role) => setState(() => _roleFilter = role),
        color: dk_theme.Theme.midnightPurple,
        itemBuilder: (context) => [
          PopupMenuItem<Role?>(value: null, child: Text(l.codexAllRoles, style: const TextStyle(color: Colors.white))),
          for (final role in Role.values)
            PopupMenuItem<Role?>(
              value: role,
              child: Row(
                children: [
                  Icon(sfSymbol(role.symbol), size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(role.displayName, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(999)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(sfSymbol(_roleFilter?.symbol ?? 'line.3.horizontal.decrease.circle'), size: 14, color: Colors.white.withValues(alpha: 0.85)),
              const SizedBox(width: 6),
              Text(
                _roleFilter?.displayName ?? l.codexAllRoles,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _grid() {
    final definitions = _filteredDefinitions;
    return GridView.builder(
      key: const Key('codex-grid'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 108,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // Tall enough for the 68px avatar + up to 2 lines of name + the
        // owned/not-owned row without the card's Column overflowing —
        // 160 clipped a 2-line name by ~4px.
        mainAxisExtent: 172,
      ),
      itemCount: definitions.length,
      itemBuilder: (context, index) {
        final definition = definitions[index];
        return GestureDetector(
          // Several Olf variants share the display name "Olf" (see
          // `DreamkeeperCatalog`'s `family: 'olf'` entries), so a plain
          // text finder can't disambiguate them in tests — key each card by
          // its unique definition id instead.
          key: ValueKey('codex-card-${definition.id}'),
          onTap: () {
            widget.gameState.playHaptic(HapticStyle.light);
            setState(() => _selectedDefinition = definition);
          },
          child: _CodexCard(
            definition: definition,
            isOwned: _isOwned(definition),
            maxStars: _maxStars(definition),
          ),
        );
      },
    );
  }
}

class _ElementChip extends StatelessWidget {
  final String title;
  final String? symbol;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ElementChip({required this.title, this.symbol, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: isSelected ? Colors.transparent : color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (symbol != null) ...[
              Icon(sfSymbol(symbol!), size: 12, color: isSelected ? Colors.black : Colors.white.withValues(alpha: 0.8)),
              const SizedBox(width: 5),
            ],
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodexCard extends StatelessWidget {
  final DreamkeeperDefinition definition;
  final bool isOwned;
  final int maxStars;

  const _CodexCard({required this.definition, required this.isOwned, required this.maxStars});

  bool get _hasArt => dk_theme.DreamkeeperArt.hasArt(definition.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dk_theme.Theme.cardStroke),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: isOwned ? 1 : 0.7,
                  child: _hasArt
                      ? ClipOval(
                          child: Image.asset(dk_theme.DreamkeeperArt.assetName(definition.name), width: 68, height: 68, fit: BoxFit.cover),
                        )
                      : Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: definition.rarity.gradient),
                          child: Icon(sfSymbol(definition.symbol), size: 28, color: Colors.white),
                        ),
                ),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: definition.rarity.primaryColor, width: definition.rarity.glows ? 2 : 1.2),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: definition.element.color, shape: BoxShape.circle),
                    child: Icon(sfSymbol(definition.element.symbol), size: 9, color: Colors.white),
                  ),
                ),
                if (!isOwned)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), shape: BoxShape.circle),
                      child: const Icon(Icons.lock, size: 8, color: Colors.white),
                    ),
                  ),
                if (definition.rarity == Rarity.exclusive)
                  Positioned(
                    left: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(gradient: definition.rarity.gradient, shape: BoxShape.circle),
                      child: const Icon(Icons.emoji_events, size: 8, color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            definition.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          if (isOwned)
            StarRow(stars: maxStars)
          else
            Text(AppLocalizations.of(context).codexNotOwned, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
        ],
      ),
    );
  }
}
