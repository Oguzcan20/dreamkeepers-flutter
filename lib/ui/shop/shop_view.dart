import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/shop_catalog.dart';
import '../../l10n/l10n.dart';
import '../../models/rarity.dart';
import '../../models/shop_item.dart';
import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// The Shop — Dream Gem packs, the Gold exchange, real-money-only Arena
/// Ticket packs, the one-time Starter Pack / VIP Pass offers, and the two
/// one-time Exclusive-character purchases (Igo/Ames — see `TwinBond`).
/// Every catalog section, price, and one-time-claim rule comes straight from
/// `ShopCatalog`/`GameState.canPurchase`/`.purchase`, already fully ported —
/// this screen is purely the display/interaction layer around them.
///
/// Swift lays every section out in one tall two-column `ScrollView`. That
/// reads fine on paper but in practice piles Special Offers, both Exclusive
/// characters, Arena Tickets and the Gold Exchange into a single column that
/// runs far taller than the Gem Packs column beside it, so the page scrolls
/// much further than any one purchase actually needs. This splits the same
/// catalog into three segmented tabs (Offers / Gems / Tickets & Gold)
/// instead — each tab's content fits with little or no scrolling of its
/// own, and the tab bar itself groups the catalog the way a player already
/// thinks about it (one-time deals vs. currency vs. consumables).
class ShopView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const ShopView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<ShopView> createState() => _ShopViewState();
}

enum _ShopTab { offers, gems, extras }

class _ShopViewState extends State<ShopView> {
  bool _appeared = false;
  String? _justPurchasedID;
  Timer? _justPurchasedTimer;
  late _ShopTab _tab;

  GameState get _gameState => widget.gameState;

  bool get _hasSpecialOffers =>
      !_gameState.isPurchased(ShopCatalog.starterPack) ||
      !_gameState.isVIP ||
      ShopCatalog.exclusiveCharacters.any(_gameState.canPurchase);

  @override
  void initState() {
    super.initState();
    // Opens on whichever tab actually has something new for a returning
    // player to look at — a player with every one-time offer already
    // claimed has nothing left in Offers, so Gems is the more useful start.
    _tab = _hasSpecialOffers ? _ShopTab.offers : _ShopTab.gems;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appeared = true);
    });
  }

  @override
  void dispose() {
    _justPurchasedTimer?.cancel();
    super.dispose();
  }

  Future<void> _buy(ShopItem item) async {
    final ok = await _gameState.purchaseWithRealMoney(item);
    if (!ok || !mounted) return;
    _gameState.playHaptic(HapticStyle.levelUp);
    _justPurchasedTimer?.cancel();
    setState(() => _justPurchasedID = item.id);
    _justPurchasedTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted && _justPurchasedID == item.id) setState(() => _justPurchasedID = null);
    });
  }

  /// Ribbon shown on a gem pack card, if any — hand-picked (not derived) so
  /// the two callouts stay deliberately distinct. Mirrors `ShopView.badge`.
  (String, Color)? _badge(ShopItem item, AppLocalizations l) {
    switch (item.id) {
      case 'gems_medium':
        return (l.shopBadgePopular, dk_theme.Theme.violet);
      case 'gems_large':
        return (l.shopBadgeBestValue, dk_theme.Theme.gold);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Stack(
      children: [
        const dk_theme.AmbientBackground(topTint: dk_theme.Theme.gold, bottomTint: dk_theme.Theme.violet),
        SafeArea(
          child: AnimatedBuilder(
            animation: _gameState,
            builder: (context, _) => AnimatedOpacity(
              opacity: _appeared ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: Column(
                children: [
                  _header(l),
                  const SizedBox(height: 10),
                  _tabBar(l),
                  const SizedBox(height: 6),
                  Expanded(child: _tabBody(l)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Three-way segmented control, same visual pattern as `InventoryView`'s
  /// Dreamkeepers/Items picker — a small tinted dot marks Offers while it
  /// still has an unclaimed deal, so switching away from it doesn't hide
  /// that something's waiting there.
  Widget _tabBar(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(child: _tabButton(_ShopTab.offers, l.shopTabOffers, showDot: _hasSpecialOffers)),
            Expanded(child: _tabButton(_ShopTab.gems, l.shopTabGems)),
            Expanded(child: _tabButton(_ShopTab.extras, l.shopTabTicketsGold)),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(_ShopTab tab, String label, {bool showDot = false}) {
    final selected = _tab == tab;
    return GestureDetector(
      onTap: () => setState(() => _tab = tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: selected ? Colors.white.withValues(alpha: 0.16) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: Colors.white.withValues(alpha: selected ? 1 : 0.6), fontSize: 13, fontWeight: FontWeight.w600)),
            if (showDot) ...[
              const SizedBox(width: 5),
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: dk_theme.Theme.gold, shape: BoxShape.circle)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tabBody(AppLocalizations l) {
    switch (_tab) {
      case _ShopTab.offers:
        return _offersTab(l);
      case _ShopTab.gems:
        return _gemsTab(l);
      case _ShopTab.extras:
        return _extrasTab(l);
    }
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
          Text(l.navShop, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              dk_theme.ResourcePill(
                icon: sfSymbol('circle.hexagongrid.fill'),
                value: '${_gameState.save.gold}',
                tint: dk_theme.Theme.gold,
                semanticLabel: l.resGold,
              ),
              const SizedBox(height: 6),
              dk_theme.ResourcePill(
                icon: sfSymbol('sparkles'),
                value: '${_gameState.save.dreamGems}',
                tint: dk_theme.Theme.violet,
                semanticLabel: l.resDreamGems,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Starter Pack / VIP Pass / Igo & Ames — every one-time deal, laid out as
  /// a centered wrap of fixed-width cards so two (or three) sit side by side
  /// on the wide landscape screen instead of stacking one per row.
  Widget _offersTab(AppLocalizations l) {
    final cards = <Widget>[
      if (!_gameState.isPurchased(ShopCatalog.starterPack))
        _highlighted(dk_theme.Theme.gold, _offerCard(item: ShopCatalog.starterPack, tint: dk_theme.Theme.gold, l: l)),
      if (!_gameState.isVIP)
        _highlighted(dk_theme.Theme.violet, _offerCard(item: ShopCatalog.vipPass, tint: dk_theme.Theme.violet, l: l)),
      for (final item in ShopCatalog.exclusiveCharacters)
        if (_gameState.canPurchase(item)) _highlighted(Rarity.exclusive.primaryColor, _exclusiveCharacterCard(item, l)),
    ];
    if (cards.isEmpty) return _emptyState(l.shopNoOffers);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 14,
        children: [for (final card in cards) SizedBox(width: 260, child: card)],
      ),
    );
  }

  /// Dream Gem packs, centered and free to use the full width now that
  /// there's no fixed-width sidebar squeezing it into `Expanded`.
  Widget _gemsTab(AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 14,
        children: [
          for (final item in ShopCatalog.gemPacks)
            SizedBox(
              width: 160,
              child: _GemPackCard(
                item: item,
                badge: _badge(item, l),
                justPurchased: _justPurchasedID == item.id,
                onBuy: () => _buy(item),
              ),
            ),
        ],
      ),
    );
  }

  /// Arena Tickets and the Gold Exchange side by side — two short,
  /// independent lists that used to be stacked into one long column; as
  /// columns of a wide two-up row they each fit without scrolling.
  Widget _extrasTab(AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _arenaTicketSection(l)),
          const SizedBox(width: 16),
          _verticalDivider(),
          const SizedBox(width: 16),
          Expanded(child: _goldExchangeSection(l)),
        ],
      ),
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
        ),
      ),
    );
  }

  /// A hairline rule that fades at both ends, used between the ticket and
  /// gold-exchange columns instead of a bare gap.
  Widget _verticalDivider() {
    return Container(
      width: 1,
      constraints: const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }

  /// A small tinted accent bar ahead of the title breaks the section list
  /// into readable rhythm instead of one long run of same-weight white
  /// headings, and ties each section back to the tint its own cards/buttons
  /// already use.
  Widget _sectionHeader(String title, {Color? tint}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tint != null) ...[
            Container(
              width: 4,
              height: 15,
              decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 8),
          ],
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _highlighted(Color tint, Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
        border: Border.all(color: tint.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [BoxShadow(color: tint.withValues(alpha: 0.3), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  /// The Starter Pack / VIP Pass card body — both are a one-time offer with
  /// an icon, name, description, and claim button; Starter Pack additionally
  /// shows its gold/gems grant. Mirrors `starterPackCard`/`vipPassCard`.
  Widget _offerCard({required ShopItem item, required Color tint, required AppLocalizations l}) {
    return dk_theme.GlassCard(
      child: Column(
        children: [
          _IconBadge(icon: sfSymbol(item.icon), tint: tint),
          const SizedBox(height: 12),
          Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
          ),
          if (item.kind == ShopItemKind.starterPack) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(sfSymbol('circle.hexagongrid.fill'), size: 14, color: dk_theme.Theme.gold),
                const SizedBox(width: 4),
                Text('${item.goldGranted}', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                Icon(sfSymbol('sparkles'), size: 14, color: dk_theme.Theme.violet),
                const SizedBox(width: 4),
                Text('${item.gemsGranted}', style: TextStyle(color: dk_theme.Theme.violet, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _purchaseButton(item, tint, l),
        ],
      ),
    );
  }

  /// Locale-invariant art name for the character this item grants — never
  /// derived from `item.name`, which is localized; mirrors the `artName`
  /// convention every `DreamkeeperDefinition` art lookup elsewhere uses.
  static const _exclusiveArtNames = {'igo': 'Igo', 'ames': 'Ames'};

  Widget _exclusiveCharacterCard(ShopItem item, AppLocalizations l) {
    final artName = _exclusiveArtNames[item.grantsDefinitionID];
    return dk_theme.GlassCard(
      child: Column(
        children: [
          artName != null
              ? _PortraitBadge(artName: artName, fallbackIcon: sfSymbol(item.icon))
              : _IconBadge(icon: sfSymbol(item.icon), tint: dk_theme.Theme.gold, diameter: 64, iconSize: 30),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(gradient: Rarity.exclusive.gradient, borderRadius: BorderRadius.circular(999)),
            child: Text(
              Rarity.exclusive.displayName,
              style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
          ),
          const SizedBox(height: 12),
          _purchaseButton(item, dk_theme.Theme.gold, l),
        ],
      ),
    );
  }

  /// Mirrors `ShopView.purchaseButton(for:tint:)` exactly: "Claimed" once
  /// owned (disabled), a transient "Purchased!" right after buying, else the
  /// item's price label.
  Widget _purchaseButton(ShopItem item, Color tint, AppLocalizations l) {
    final purchased = _gameState.isPurchased(item);
    final label = purchased ? l.commonClaimed : (_justPurchasedID == item.id ? l.shopPurchased : item.priceLabel);
    return dk_theme.PrimaryButton(
      tint: tint,
      onPressed: (purchased || !_gameState.canPurchase(item)) ? null : () => _buy(item),
      child: Text(label),
    );
  }

  /// Arena Tower tickets, real-money only by design — see
  /// `ShopItemKind.arenaTicketPack`. Mirrors `arenaTicketSection`.
  Widget _arenaTicketSection(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(l.shopTrialTickets, tint: dk_theme.Theme.softBlue),
        const SizedBox(height: 10),
        for (final item in ShopCatalog.arenaTicketPacks) ...[
          _TicketPackRow(item: item, justPurchased: _justPurchasedID == item.id, onBuy: () => _buy(item)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _goldExchangeSection(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(l.shopGoldExchange, tint: dk_theme.Theme.gold),
        const SizedBox(height: 10),
        for (final item in ShopCatalog.goldExchanges) ...[
          _ExchangeRow(item: item, canAfford: _gameState.canPurchase(item), onBuy: () => _gameState.purchase(item)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

/// Icon inside a tinted, glowing circle — the badge treatment already
/// established by `ProfileView._levelCard` and `RootView._AchievementToast`,
/// reused here so every Shop card reads as one consistent visual language
/// instead of bare floating icons.
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final double diameter;
  final double iconSize;

  const _IconBadge({required this.icon, required this.tint, this.diameter = 56, this.iconSize = 26});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tint.withValues(alpha: 0.2),
        boxShadow: [BoxShadow(color: tint.withValues(alpha: 0.35), blurRadius: 12, spreadRadius: 1)],
      ),
      child: Icon(icon, size: iconSize, color: tint),
    );
  }
}

/// Circular character portrait for Igo/Ames' exclusive shop cards, falling
/// back to an `_IconBadge` when the art asset isn't available — mirrors the
/// `hasArt` gating every other art lookup in the app already uses.
class _PortraitBadge extends StatelessWidget {
  static const _diameter = 64.0;

  final String artName;
  final IconData fallbackIcon;

  const _PortraitBadge({required this.artName, required this.fallbackIcon});

  @override
  Widget build(BuildContext context) {
    if (!dk_theme.DreamkeeperArt.hasArt(artName)) {
      return _IconBadge(icon: fallbackIcon, tint: dk_theme.Theme.gold, diameter: _diameter, iconSize: _diameter * 0.46);
    }
    return Container(
      width: _diameter,
      height: _diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: dk_theme.Theme.gold.withValues(alpha: 0.7), width: 2),
        boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.35), blurRadius: 14, spreadRadius: 1)],
      ),
      child: ClipOval(child: Image.asset(dk_theme.DreamkeeperArt.assetName(artName), fit: BoxFit.cover)),
    );
  }
}

class _GemPackCard extends StatelessWidget {
  final ShopItem item;
  final (String, Color)? badge;
  final bool justPurchased;
  final VoidCallback onBuy;

  const _GemPackCard({required this.item, required this.badge, required this.justPurchased, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final badgeTint = badge?.$2;
    return Padding(
      padding: EdgeInsets.only(top: badge != null ? 12 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dk_theme.Theme.cornerRadius),
              border: Border.all(color: badgeTint?.withValues(alpha: 0.5) ?? Colors.transparent, width: 1.5),
            ),
            child: dk_theme.GlassCard(
              child: Column(
                children: [
                  _IconBadge(icon: sfSymbol(item.icon), tint: dk_theme.Theme.violet, diameter: 44, iconSize: 20),
                  const SizedBox(height: 6),
                  Text('${item.gemsGranted}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  dk_theme.PrimaryButton(tint: dk_theme.Theme.violet, onPressed: onBuy, child: Text(justPurchased ? l.shopAdded : item.priceLabel)),
                ],
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: badgeTint, borderRadius: BorderRadius.circular(999)),
                  child: Text(badge!.$1, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TicketPackRow extends StatelessWidget {
  final ShopItem item;
  final bool justPurchased;
  final VoidCallback onBuy;

  const _TicketPackRow({required this.item, required this.justPurchased, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return dk_theme.GlassCard(
      child: Row(
        children: [
          _IconBadge(icon: sfSymbol(item.icon), tint: dk_theme.Theme.softBlue, diameter: 40, iconSize: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(l.shopTicketsGranted(item.ticketsGranted), style: TextStyle(color: dk_theme.Theme.softBlue, fontSize: 11)),
              ],
            ),
          ),
          _PillButton(
            label: justPurchased ? l.shopAdded : item.priceLabel,
            tint: dk_theme.Theme.softBlue,
            onTap: onBuy,
          ),
        ],
      ),
    );
  }
}

class _ExchangeRow extends StatelessWidget {
  final ShopItem item;
  final bool canAfford;
  final VoidCallback onBuy;

  const _ExchangeRow({required this.item, required this.canAfford, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return dk_theme.GlassCard(
      child: Row(
        children: [
          _IconBadge(icon: sfSymbol(item.icon), tint: dk_theme.Theme.gold, diameter: 40, iconSize: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(l.havenPlusGold(item.goldGranted), style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11)),
              ],
            ),
          ),
          Opacity(
            opacity: canAfford ? 1 : 0.5,
            child: _PillButton(
              label: item.priceLabel,
              tint: dk_theme.Theme.violet,
              icon: sfSymbol('sparkles'),
              onTap: canAfford ? onBuy : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small capsule button used by the ticket/exchange rows — Swift styles
/// these as a plain tinted-capsule `Button`, distinct from `PrimaryButton`'s
/// heavier full-width gradient treatment which wouldn't fit a row.
class _PillButton extends StatelessWidget {
  final String label;
  final Color tint;
  final IconData? icon;
  final VoidCallback? onTap;

  const _PillButton({required this.label, required this.tint, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: tint.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 12, color: Colors.white), const SizedBox(width: 4)],
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
