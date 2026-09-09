import 'package:flutter/material.dart';

import '../../combat/twin_bond.dart';
import '../../models/dreamkeeper.dart';
import '../../models/equipment.dart';
import '../../models/rarity.dart';
import '../../models/team.dart';
import '../../platform/platform_service.dart';
import '../../progression/equipment_upgrade.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../equipment/equipment_detail_sheet.dart';
import '../equipment/equipment_sheet.dart';
import '../root/app_route.dart';
import '../shared/dreamkeeper_card.dart';
import '../shared/star_row.dart';

enum _Tab { dreamkeepers, items }

enum _RosterSort {
  level,
  rarity,
  stars,
  attack;

  String get label => switch (this) {
        _RosterSort.level => 'Level',
        _RosterSort.rarity => 'Rarity',
        _RosterSort.stars => 'Stars',
        _RosterSort.attack => 'Attack',
      };

  String get symbol => switch (this) {
        _RosterSort.level => 'arrow.up.forward',
        _RosterSort.rarity => 'sparkles',
        _RosterSort.stars => 'star.fill',
        _RosterSort.attack => 'bolt.fill',
      };
}

/// The single hub for "everything the player owns" — Dreamkeepers (with team
/// deploy/bench) and Items in one place. Mirrors `InventoryView`
/// (UI/Team/InventoryView.swift) exactly, with these deliberate gaps:
/// - `DK_AUTO_GEAR`/`DK_AUTO_ITEM`/`DK_INVENTORY_TAB` QA env-var hooks — an
///   Xcode-scheme-only dev convenience, matching every other screen ported
///   so far (see `RootView`'s doc comment).
/// - Equipment/item detail is reached via `Navigator.push` (full-screen
///   route) instead of SwiftUI's `.sheet(item:)`, so there's no
///   `equipmentTarget`/`itemTarget` state to hold — the pushed route reads
///   the tapped instance's id directly.
class InventoryView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const InventoryView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  _Tab _tab = _Tab.dreamkeepers;
  _RosterSort _rosterSort = _RosterSort.level;
  bool _sellMode = false;
  final Set<String> _selectedForSale = {};

  GameState get _gameState => widget.gameState;

  List<DreamkeeperInstance> get _sortedRoster {
    final roster = List<DreamkeeperInstance>.from(_gameState.roster);
    roster.sort((a, b) {
      final defA = _gameState.definition(a);
      final defB = _gameState.definition(b);
      switch (_rosterSort) {
        case _RosterSort.level:
          if (a.level != b.level) return b.level.compareTo(a.level);
        case _RosterSort.rarity:
          final rarityA = defA?.rarity ?? Rarity.common;
          final rarityB = defB?.rarity ?? Rarity.common;
          if (rarityA != rarityB) return rarityB.compareTo(rarityA);
        case _RosterSort.stars:
          if (a.stars != b.stars) return b.stars.compareTo(a.stars);
        case _RosterSort.attack:
          final attackA = _gameState.currentStats(a).attack;
          final attackB = _gameState.currentStats(b).attack;
          if (attackA != attackB) return attackB.compareTo(attackA);
      }
      return (defA?.name ?? '').compareTo(defB?.name ?? '');
    });
    return roster;
  }

  ({int gold, int gems}) get _sellTotal {
    var gold = 0;
    var gems = 0;
    for (final id in _selectedForSale) {
      final matches = _gameState.roster.where((r) => r.id == id);
      if (matches.isEmpty) continue;
      final value = _gameState.sellValue(matches.first);
      gold += value.gold;
      gems += value.gems;
    }
    return (gold: gold, gems: gems);
  }

  void _toggleSaleSelection(DreamkeeperInstance instance) {
    if (!_gameState.canSellDreamkeeper(instance)) return;
    setState(() {
      if (_selectedForSale.contains(instance.id)) {
        _selectedForSale.remove(instance.id);
      } else {
        _selectedForSale.add(instance.id);
      }
    });
    _gameState.playHaptic(HapticStyle.light);
  }

  void _openEquipmentSheet(DreamkeeperInstance instance) {
    Navigator.of(context).push(
      MaterialPageRoute(fullscreenDialog: true, builder: (context) => EquipmentSheet(instanceID: instance.id, gameState: _gameState)),
    );
  }

  void _openItemDetail(EquipmentItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(fullscreenDialog: true, builder: (context) => EquipmentDetailSheet(itemID: item.id, gameState: _gameState)),
    );
  }

  Future<void> _confirmSell() async {
    final value = _sellTotal;
    final label = value.gems > 0 ? 'Sell for ${value.gold} Gold + ${value.gems} Gems' : 'Sell for ${value.gold} Gold';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          backgroundColor: dk_theme.Theme.midnightPurple,
          title: Text(_selectedForSale.length == 1 ? 'Sell 1 Dreamkeeper?' : 'Sell ${_selectedForSale.length} Dreamkeepers?'),
          content: const Text("This can't be undone. Equipped gear is unequipped, not sold."),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(label, style: const TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    _gameState.sellDreamkeepers(_selectedForSale);
    _gameState.playHaptic(HapticStyle.success);
    setState(() {
      _sellMode = false;
      _selectedForSale.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        dk_theme.AmbientBackground(topTint: dk_theme.Theme.softBlue, bottomTint: dk_theme.Theme.violet),
        AnimatedBuilder(
          animation: _gameState,
          builder: (context, _) => SafeArea(
            child: Column(
              children: [
                _header(),
                const SizedBox(height: 12),
                _picker(),
                const SizedBox(height: 12),
                Expanded(child: _tab == _Tab.dreamkeepers ? _dreamkeepersTab() : _itemsTab()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _iconButton(icon: 'chevron.left', label: 'Back', onTap: () => widget.onNavigate(const DreamHavenRoute())),
          const Spacer(),
          const Text('Inventory', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          _iconButton(icon: 'book.closed.fill', label: 'Dreamkeeper Codex', onTap: () => widget.onNavigate(const CodexRoute())),
        ],
      ),
    );
  }

  Widget _iconButton({required String icon, required String label, required VoidCallback onTap}) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: Icon(sfSymbol(icon), color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _picker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(child: _tabButton(_Tab.dreamkeepers, 'Dreamkeepers')),
            Expanded(child: _tabButton(_Tab.items, 'Items')),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(_Tab tab, String label) {
    final selected = _tab == tab;
    return GestureDetector(
      onTap: () => setState(() => _tab = tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: selected ? Colors.white.withValues(alpha: 0.16) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: selected ? 1 : 0.6), fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // MARK: - Dreamkeepers tab

  Widget _dreamkeepersTab() {
    return Column(
      children: [
        _teamPicker(),
        Padding(
          // Trimmed from the original 14px top gap — on a landscape phone
          // (this app is landscape-locked) the vertical budget above the
          // grid is tight enough that `_teamPicker`'s fixed 56px plus this
          // padding could overflow the Column by a few pixels on shorter
          // landscape heights (caught on the Android emulator; the extra
          // couple of points of headroom this saves costs nothing visually).
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: _sellMode ? _sellBar() : _controlsRow(),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            // A fixed `mainAxisExtent` (rather than `childAspectRatio`) keeps
            // every card's height constant regardless of how evenly 96px
            // columns divide the available width — with an aspect ratio,
            // a narrower-than-max leftover column width shrinks the row
            // height too, and `DreamkeeperCard`'s content (fixed-size
            // portrait, two-line name, level, star row, optional Twin Bond
            // pill) no longer fits, overflowing the card.
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 96, mainAxisSpacing: 14, crossAxisSpacing: 14, mainAxisExtent: 158),
            itemCount: _sortedRoster.length,
            itemBuilder: (context, index) {
              final instance = _sortedRoster[index];
              final definition = _gameState.definition(instance);
              if (definition == null) return const SizedBox.shrink();
              final twinBondActive = TwinBond.isBondCharacter(instance.definitionID)
                  ? TwinBond.isActive(_gameState.deployedTeam.map((d) => d.definitionID))
                  : null;
              return DreamkeeperCard(
                definition: definition,
                instance: instance,
                isDeployed: _gameState.isDeployed(instance),
                isSelectedForSale: _sellMode ? _selectedForSale.contains(instance.id) : null,
                twinBondActive: twinBondActive,
                onTap: () => _sellMode ? _toggleSaleSelection(instance) : _openEquipmentSheet(instance),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _controlsRow() {
    return Row(
      children: [
        Expanded(
          child: Text('Tap a Dreamkeeper to view stats and fusion.', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
        ),
        _pillButton(icon: 'tag.fill', label: 'Sell', onTap: () => setState(() => _sellMode = true)),
        const SizedBox(width: 8),
        _sortMenu(),
        const SizedBox(width: 8),
        Text('${_gameState.deployedTeam.length}/${Team.maxSize} deployed', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _pillButton({required String icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol(icon), size: 12, color: Colors.white.withValues(alpha: 0.75)),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _sortMenu() {
    return PopupMenuButton<_RosterSort>(
      color: dk_theme.Theme.midnightPurple,
      tooltip: 'Sort Dreamkeepers',
      onSelected: (value) => setState(() => _rosterSort = value),
      itemBuilder: (context) => [
        for (final option in _RosterSort.values)
          PopupMenuItem(
            value: option,
            child: Row(
              children: [
                Icon(sfSymbol(option.symbol), size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(option.label, style: const TextStyle(color: Colors.white))),
                if (_rosterSort == option) const Icon(Icons.check, size: 16, color: Colors.white),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sfSymbol('arrow.up.arrow.down'), size: 12, color: Colors.white.withValues(alpha: 0.75)),
            const SizedBox(width: 4),
            Text(_rosterSort.label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  /// Replaces the normal "tap to view stats" row while `_sellMode` is
  /// active — shows the running payout for whatever's currently checked and
  /// lets the player back out without selling anything.
  Widget _sellBar() {
    final value = _sellTotal;
    return Row(
      children: [
        TextButton(
          onPressed: () => setState(() {
            _sellMode = false;
            _selectedForSale.clear();
          }),
          child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.75))),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${_selectedForSale.length} selected', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10)),
            if (_selectedForSale.isNotEmpty)
              Text(
                value.gems > 0 ? '+${value.gold} Gold · +${value.gems} Gems' : '+${value.gold} Gold',
                style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11, fontWeight: FontWeight.w600),
              ),
          ],
        ),
        const SizedBox(width: 10),
        // See `PrimaryButton`'s doc comment (theme.dart) — it always forces
        // `width: double.infinity`, so a Row placement needs a fixed-width
        // wrapper.
        SizedBox(
          width: 90,
          child: dk_theme.PrimaryButton(
            tint: dk_theme.Theme.gold,
            onPressed: _selectedForSale.isEmpty ? null : _confirmSell,
            child: const Text('Sell'),
          ),
        ),
      ],
    );
  }

  Widget _teamPicker() {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (final team in _gameState.teams) ...[
            _TeamChip(
              team: team,
              isActive: team.id == _gameState.activeTeamID,
              onTap: () {
                _gameState.setActiveTeam(team.id);
                _gameState.playHaptic(HapticStyle.light);
              },
            ),
            const SizedBox(width: 10),
          ],
          if (_gameState.teams.length < GameState.maxTeams)
            Semantics(
              label: 'Create Team',
              button: true,
              child: GestureDetector(
                onTap: () {
                  _gameState.createTeam();
                  _gameState.playHaptic(HapticStyle.light);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                  child: Icon(sfSymbol('plus'), color: Colors.white, size: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // MARK: - Items tab

  List<(EquipmentSlot slot, List<EquipmentItem> items)> get _itemsBySlot {
    return [
      for (final slot in EquipmentSlot.values)
        (
          slot,
          _gameState.inventory.where((i) => i.slot == slot).toList()
            ..sort((a, b) => a.rarity == b.rarity ? b.level.compareTo(a.level) : b.rarity.compareTo(a.rarity)),
        ),
    ];
  }

  Widget _itemsTab() {
    if (_gameState.inventory.isEmpty) {
      return SingleChildScrollView(padding: const EdgeInsets.all(20), child: _emptyItemsCallout());
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (final group in _itemsBySlot)
          if (group.$2.isNotEmpty) ...[
            _itemSlotSection(slot: group.$1, items: group.$2),
            const SizedBox(height: 20),
          ],
      ],
    );
  }

  /// Landscape leaves a lot of open canvas below a lone small card, which
  /// used to just trail off into empty background — a real CTA gives the
  /// empty state somewhere to send the player instead of a dead end.
  Widget _emptyItemsCallout() {
    return dk_theme.GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(color: dk_theme.Theme.softBlue.withValues(alpha: 0.16), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(sfSymbol('shippingbox.fill'), size: 26, color: dk_theme.Theme.softBlue),
            ),
            const SizedBox(height: 14),
            const Text('No Items Yet', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              'Clear a campaign stage to find equipment for your Dreamkeepers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
            ),
            const SizedBox(height: 14),
            SizedBox(
              // Wide enough for "Go to Campaign" at the button's default
              // 16pt text plus its icon — `_autoEquipButton`
              // (equipment_sheet.dart) hits the same "Row content wider
              // than its fixed-width SizedBox" shape and also falls back to
              // `Flexible`/ellipsis rather than trying to compute an exact
              // width, for the same reason: Dynamic Type/larger text scales
              // would overflow a razor-thin fit regardless of the number.
              width: 260,
              child: dk_theme.PrimaryButton(
                tint: dk_theme.Theme.softBlue,
                onPressed: () => widget.onNavigate(const CampaignRoute()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(sfSymbol('map.fill'), size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    const Flexible(child: Text('Go to Campaign', overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemSlotSection({required EquipmentSlot slot, required List<EquipmentItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(sfSymbol(slot.symbol), color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(slot.displayName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 10),
        for (final item in items) ...[
          _InventoryItemRow(
            item: item,
            wearerName: (() {
              final wearer = _gameState.wearer(item);
              return wearer == null ? null : _gameState.definition(wearer)?.name;
            })(),
            onTap: () => _openItemDetail(item),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _TeamChip extends StatelessWidget {
  final Team team;
  final bool isActive;
  final VoidCallback onTap;

  const _TeamChip({required this.team, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isActive,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? dk_theme.Theme.violet.withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: isActive ? dk_theme.Theme.gold : dk_theme.Theme.cardStroke, width: isActive ? 2 : 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(team.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              Text('${team.memberIDs.length}/${Team.maxSize}', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryItemRow extends StatelessWidget {
  final EquipmentItem item;
  final String? wearerName;
  final VoidCallback onTap;

  const _InventoryItemRow({required this.item, required this.wearerName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasArt = dk_theme.ItemArt.hasArt(item.name);
    return Semantics(
      button: true,
      label: '${item.name}, ${item.rarity.displayName}, Lv ${item.level}${wearerName != null ? ', worn by $wearerName' : ', in storage'}',
      child: GestureDetector(
        onTap: onTap,
        child: dk_theme.GlassCard(
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: hasArt ? null : item.rarity.gradient,
                  border: hasArt ? Border.fromBorderSide(BorderSide(color: item.rarity.primaryColor, width: 2.5)) : null,
                ),
                alignment: Alignment.center,
                child: hasArt
                    ? ClipOval(child: Image.asset(dk_theme.ItemArt.assetName(item.name), width: 48, height: 48, fit: BoxFit.cover))
                    : Icon(sfSymbol(item.slot.symbol), size: 20, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(
                      '${item.rarity.displayName} · Lv ${item.level}/${EquipmentUpgrade.maxLevel}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    StarRow(stars: item.stars, size: 9),
                    Text(
                      wearerName != null ? 'Worn by $wearerName' : 'In storage',
                      style: TextStyle(color: wearerName != null ? dk_theme.Theme.softBlue : Colors.white.withValues(alpha: 0.4), fontSize: 10),
                    ),
                  ],
                ),
              ),
              Icon(sfSymbol('chevron.right'), size: 14, color: Colors.white.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}
