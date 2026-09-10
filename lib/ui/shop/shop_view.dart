import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/shop_catalog.dart';
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
/// Mirrors `ShopView` (UI/Shop/ShopView.swift) exactly: every catalog
/// section, price, and one-time-claim rule comes straight from
/// `ShopCatalog`/`GameState.canPurchase`/`.purchase`, already fully ported —
/// this screen is purely the display/interaction layer around them.
///
/// Swift lays the left-hand cards and the gem-pack grid out side by side in
/// an `HStack` (the app is landscape-locked, so there's always room); this
/// keeps that same two-column shape rather than stacking everything in one
/// long column, since it reads far more like the original on the wide
/// screens this app actually runs on.
class ShopView extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const ShopView({super.key, required this.gameState, required this.onNavigate});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  bool _appeared = false;
  String? _justPurchasedID;
  Timer? _justPurchasedTimer;

  GameState get _gameState => widget.gameState;

  @override
  void initState() {
    super.initState();
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
  (String, Color)? _badge(ShopItem item) {
    switch (item.id) {
      case 'gems_medium':
        return ('Popular', dk_theme.Theme.violet);
      case 'gems_large':
        return ('Best Value', dk_theme.Theme.gold);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _header(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 340),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 300, child: _leftColumn()),
                            const SizedBox(width: 16),
                            Expanded(child: _gemPacksSection()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Semantics(
            label: 'Back',
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
          const Text('Shop', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              dk_theme.ResourcePill(
                icon: sfSymbol('circle.hexagongrid.fill'),
                value: '${_gameState.save.gold}',
                tint: dk_theme.Theme.gold,
                semanticLabel: 'Gold',
              ),
              const SizedBox(height: 6),
              dk_theme.ResourcePill(
                icon: sfSymbol('sparkles'),
                value: '${_gameState.save.dreamGems}',
                tint: dk_theme.Theme.violet,
                semanticLabel: 'Dream Gems',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _leftColumn() {
    return Column(
      children: [
        if (!_gameState.isPurchased(ShopCatalog.starterPack)) ...[
          _highlighted(dk_theme.Theme.gold, _offerCard(item: ShopCatalog.starterPack, tint: dk_theme.Theme.gold)),
          const SizedBox(height: 14),
        ],
        if (!_gameState.isVIP) ...[
          _highlighted(dk_theme.Theme.violet, _offerCard(item: ShopCatalog.vipPass, tint: dk_theme.Theme.violet)),
          const SizedBox(height: 14),
        ],
        ..._exclusiveCharacterCards(),
        _arenaTicketSection(),
        const SizedBox(height: 14),
        _goldExchangeSection(),
      ],
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
  Widget _offerCard({required ShopItem item, required Color tint}) {
    return dk_theme.GlassCard(
      child: Column(
        children: [
          Icon(sfSymbol(item.icon), size: 40, color: tint),
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
          _purchaseButton(item, tint),
        ],
      ),
    );
  }

  /// Igo and Ames' shop cards — one per un-owned exclusive character (a card
  /// disappears once bought here or pulled from the Summoning Shrine, per
  /// `GameState.canPurchase`). Mirrors `exclusiveCharactersSection`.
  List<Widget> _exclusiveCharacterCards() {
    final widgets = <Widget>[];
    for (final item in ShopCatalog.exclusiveCharacters) {
      if (!_gameState.canPurchase(item)) continue;
      widgets.add(_highlighted(Rarity.exclusive.primaryColor, _exclusiveCharacterCard(item)));
      widgets.add(const SizedBox(height: 14));
    }
    return widgets;
  }

  Widget _exclusiveCharacterCard(ShopItem item) {
    return dk_theme.GlassCard(
      child: Column(
        children: [
          Icon(sfSymbol(item.icon), size: 40, color: dk_theme.Theme.gold),
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
          _purchaseButton(item, dk_theme.Theme.gold),
        ],
      ),
    );
  }

  /// Mirrors `ShopView.purchaseButton(for:tint:)` exactly: "Claimed" once
  /// owned (disabled), a transient "Purchased!" right after buying, else the
  /// item's price label.
  Widget _purchaseButton(ShopItem item, Color tint) {
    final purchased = _gameState.isPurchased(item);
    final label = purchased ? 'Claimed' : (_justPurchasedID == item.id ? 'Purchased!' : item.priceLabel);
    return dk_theme.PrimaryButton(
      tint: tint,
      onPressed: (purchased || !_gameState.canPurchase(item)) ? null : () => _buy(item),
      child: Text(label),
    );
  }

  Widget _gemPacksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dream Gems', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in ShopCatalog.gemPacks)
              SizedBox(
                width: 150,
                child: _GemPackCard(
                  item: item,
                  badge: _badge(item),
                  justPurchased: _justPurchasedID == item.id,
                  onBuy: () => _buy(item),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Arena Tower tickets, real-money only by design — see
  /// `ShopItemKind.arenaTicketPack`. Mirrors `arenaTicketSection`.
  Widget _arenaTicketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trial Tickets', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        for (final item in ShopCatalog.arenaTicketPacks) ...[
          _TicketPackRow(item: item, justPurchased: _justPurchasedID == item.id, onBuy: () => _buy(item)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _goldExchangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gold Exchange', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        for (final item in ShopCatalog.goldExchanges) ...[
          _ExchangeRow(item: item, canAfford: _gameState.canPurchase(item), onBuy: () => _gameState.purchase(item)),
          const SizedBox(height: 10),
        ],
      ],
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
    final badgeTint = badge?.$2;
    return Stack(
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
                Icon(sfSymbol(item.icon), size: 22, color: dk_theme.Theme.violet),
                const SizedBox(height: 6),
                Text('${item.gemsGranted}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                ),
                const SizedBox(height: 8),
                dk_theme.PrimaryButton(tint: dk_theme.Theme.violet, onPressed: onBuy, child: Text(justPurchased ? 'Added!' : item.priceLabel)),
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
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Icon(sfSymbol(item.icon), size: 20, color: dk_theme.Theme.softBlue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('+${item.ticketsGranted} Tickets', style: TextStyle(color: dk_theme.Theme.softBlue, fontSize: 11)),
              ],
            ),
          ),
          _PillButton(
            label: justPurchased ? 'Added!' : item.priceLabel,
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
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Icon(sfSymbol(item.icon), size: 20, color: dk_theme.Theme.gold),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('+${item.goldGranted} Gold', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 11)),
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
