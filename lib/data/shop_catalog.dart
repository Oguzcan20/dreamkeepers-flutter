import '../models/shop_item.dart';

/// Mirrors GameCore/Data/ShopCatalog.swift exactly.
class ShopCatalog {
  static const starterPackID = 'starter_pack';

  /// App Store / Play Store product identifiers all share this prefix,
  /// matching the app's own bundle/application ID convention.
  static const _productIDPrefix = 'com.dreamhaven.dreamkeepers';

  static const List<ShopItem> gemPacks = [
    ShopItem(
      id: 'gems_small',
      kind: ShopItemKind.gemPack,
      name: 'Handful of Gems',
      description: 'A small top-up.',
      priceLabel: r'$0.99',
      icon: 'sparkles',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 60,
      productID: '$_productIDPrefix.gems_small',
    ),
    ShopItem(
      id: 'gems_medium',
      kind: ShopItemKind.gemPack,
      name: 'Pouch of Gems',
      description: 'Good value for regular summoning.',
      priceLabel: r'$4.99',
      icon: 'sparkles',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 340,
      productID: '$_productIDPrefix.gems_medium',
    ),
    ShopItem(
      id: 'gems_large',
      kind: ShopItemKind.gemPack,
      name: 'Chest of Gems',
      description: 'Best value per gem.',
      priceLabel: r'$9.99',
      icon: 'sparkles',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 720,
      productID: '$_productIDPrefix.gems_large',
    ),
    ShopItem(
      id: 'gems_mega',
      kind: ShopItemKind.gemPack,
      name: 'Vault of Gems',
      description: 'For serious Dream Haven builders.',
      priceLabel: r'$19.99',
      icon: 'sparkles',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 1600,
      productID: '$_productIDPrefix.gems_mega',
    ),
  ];

  static const List<ShopItem> goldExchanges = [
    ShopItem(
      id: 'gold_small',
      kind: ShopItemKind.goldExchange,
      name: 'Gold Pouch',
      description: 'Exchange gems for gold.',
      priceLabel: '20 Gems',
      icon: 'circle.hexagongrid.fill',
      gemCost: 20,
      goldGranted: 200,
      gemsGranted: 0,
    ),
    ShopItem(
      id: 'gold_large',
      kind: ShopItemKind.goldExchange,
      name: 'Gold Chest',
      description: 'Better exchange rate.',
      priceLabel: '80 Gems',
      icon: 'circle.hexagongrid.fill',
      gemCost: 80,
      goldGranted: 1000,
      gemsGranted: 0,
    ),
  ];

  static const ShopItem starterPack = ShopItem(
    id: starterPackID,
    kind: ShopItemKind.starterPack,
    name: 'Dreamkeeper Starter Pack',
    description:
        'One-time bonus for new Dream Haven builders: gold and gems to get your roster going.',
    priceLabel: r'$2.99',
    icon: 'gift.fill',
    gemCost: 0,
    goldGranted: 500,
    gemsGranted: 150,
    productID: '$_productIDPrefix.$starterPackID',
  );

  static const vipPassID = 'vip_pass';

  static const ShopItem vipPass = ShopItem(
    id: vipPassID,
    kind: ShopItemKind.vip,
    name: 'VIP Pass',
    description:
        'Removes rewarded-ad prompts for good — a permanent, one-time thank-you for supporting Dream Haven.',
    priceLabel: r'$4.99',
    icon: 'crown.fill',
    gemCost: 0,
    goldGranted: 0,
    gemsGranted: 0,
    productID: '$_productIDPrefix.$vipPassID',
  );

  /// Real-money-only Arena Tower ticket top-ups — never purchasable with
  /// gold or gems, by design. Granted tickets stack on top of the free
  /// daily allotment via `GameSave.arenaBonusTickets` and never expire.
  static const List<ShopItem> arenaTicketPacks = [
    ShopItem(
      id: 'arena_tickets_small',
      kind: ShopItemKind.arenaTicketPack,
      name: 'Arena Ticket Pack',
      description: '5 extra Arena Tower attempts, on top of your free daily tickets.',
      priceLabel: r'$1.99',
      icon: 'ticket.fill',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 0,
      ticketsGranted: 5,
      productID: '$_productIDPrefix.arena_tickets_small',
    ),
    ShopItem(
      id: 'arena_tickets_large',
      kind: ShopItemKind.arenaTicketPack,
      name: 'Arena Ticket Bundle',
      description: '15 extra Arena Tower attempts — better value for a serious climb.',
      priceLabel: r'$4.99',
      icon: 'ticket.fill',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 0,
      ticketsGranted: 15,
      productID: '$_productIDPrefix.arena_tickets_large',
    ),
  ];

  /// Igo and Ames — the only two humans who ever stayed in Dream Haven.
  /// Each is its own one-time purchase (not bundled) that grants a
  /// max-level, max-star copy directly, the shop half of their dual
  /// acquisition path alongside the Summoning Shrine (see `TwinBond`).
  static const List<ShopItem> exclusiveCharacters = [
    ShopItem(
      id: 'exclusive_igo',
      kind: ShopItemKind.exclusiveCharacter,
      name: 'Igo',
      description:
          "The tide's own guardian — permanently joins your roster at max level and max stars.",
      priceLabel: r'$99.99',
      icon: 'shield.righthalf.filled',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 0,
      grantsDefinitionID: 'igo',
      productID: '$_productIDPrefix.exclusive_igo',
    ),
    ShopItem(
      id: 'exclusive_ames',
      kind: ShopItemKind.exclusiveCharacter,
      name: 'Ames',
      description:
          'Ember given human form — permanently joins your roster at max level and max stars.',
      priceLabel: r'$99.99',
      icon: 'flame.fill',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 0,
      grantsDefinitionID: 'ames',
      productID: '$_productIDPrefix.exclusive_ames',
    ),
  ];

  /// Every item that carries a real-money `productID`, across all
  /// sections — used to resolve a restored or externally-approved
  /// transaction back to the `ShopItem` it should grant. `.goldExchange`
  /// items are deliberately excluded — they never have a `productID` and
  /// are never charged for.
  static List<ShopItem> get allRealMoneyItems =>
      [...gemPacks, ...arenaTicketPacks, ...exclusiveCharacters, starterPack, vipPass];
}
