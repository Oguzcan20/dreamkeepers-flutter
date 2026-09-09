enum ShopItemKind {
  /// Real-money purchase, gated behind a real Google Play Billing
  /// transaction via `GameState.purchaseWithRealMoney` (see
  /// `ShopItem.productID` / `PurchaseService`) — `GameState.purchase`
  /// itself only grants, never charges, which is why it stays directly
  /// unit-testable.
  gemPack,

  /// In-game soft-currency exchange: spend gems, receive gold. No real
  /// money involved, always available.
  goldExchange,

  /// One-time bonus offer, real-money priced like a gem pack but claimable
  /// only once per account.
  starterPack,

  /// One-time real-money purchase, same placeholder pattern as `gemPack`.
  /// Sets `GameSave.isVIP` instead of granting currency — permanently
  /// removes the rewarded-ad prompt.
  vip,

  /// Real-money purchase, same placeholder pattern as `gemPack`. Grants
  /// `ticketsGranted` Arena Tower tickets to `GameSave.arenaBonusTickets`.
  /// Deliberately the ONLY way to buy Arena tickets.
  arenaTicketPack,

  /// One-time real-money purchase, same placeholder pattern as `gemPack`.
  /// Grants the roster a max-level, max-star copy of `grantsDefinitionID`
  /// — the shop half of Igo/Ames' dual acquisition path, see TwinBond.
  exclusiveCharacter,
}

/// Mirrors GameCore/Models/ShopItem.swift exactly.
class ShopItem {
  final String id;
  final ShopItemKind kind;
  final String name;
  final String description;
  final String priceLabel;
  final String icon;
  final int gemCost;
  final int goldGranted;
  final int gemsGranted;
  final int ticketsGranted;

  /// `.exclusiveCharacter` only — the `DreamkeeperDefinition.id` this
  /// purchase grants.
  final String? grantsDefinitionID;

  /// Google Play Billing product identifier for real-money items (every
  /// kind except `.goldExchange`, a virtual-currency-only trade). `null`
  /// means "never routes through PurchaseService".
  final String? productID;

  const ShopItem({
    required this.id,
    required this.kind,
    required this.name,
    required this.description,
    required this.priceLabel,
    required this.icon,
    required this.gemCost,
    required this.goldGranted,
    required this.gemsGranted,
    this.ticketsGranted = 0,
    this.grantsDefinitionID,
    this.productID,
  });
}
