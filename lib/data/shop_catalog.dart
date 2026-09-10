import '../l10n/l10n.dart';
import '../models/shop_item.dart';

/// Mirrors GameCore/Data/ShopCatalog.swift exactly.
class ShopCatalog {
  static const starterPackID = 'starter_pack';

  /// App Store / Play Store product identifiers all share this prefix,
  /// matching the app's own bundle/application ID convention.
  static const _productIDPrefix = 'com.dreamhaven.dreamkeepers';

  static final List<ShopItem> gemPacks = [
    ShopItem(
      id: 'gems_small',
      kind: ShopItemKind.gemPack,
      name: L.shopGemsSmallName,
      description: L.shopGemsSmallDesc,
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
      name: L.shopGemsMediumName,
      description: L.shopGemsMediumDesc,
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
      name: L.shopGemsLargeName,
      description: L.shopGemsLargeDesc,
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
      name: L.shopGemsMegaName,
      description: L.shopGemsMegaDesc,
      priceLabel: r'$19.99',
      icon: 'sparkles',
      gemCost: 0,
      goldGranted: 0,
      gemsGranted: 1600,
      productID: '$_productIDPrefix.gems_mega',
    ),
  ];

  static final List<ShopItem> goldExchanges = [
    ShopItem(
      id: 'gold_small',
      kind: ShopItemKind.goldExchange,
      name: L.shopGoldSmallName,
      description: L.shopGoldSmallDesc,
      priceLabel: L.commonAmountGems(20),
      icon: 'circle.hexagongrid.fill',
      gemCost: 20,
      goldGranted: 200,
      gemsGranted: 0,
    ),
    ShopItem(
      id: 'gold_large',
      kind: ShopItemKind.goldExchange,
      name: L.shopGoldLargeName,
      description: L.shopGoldLargeDesc,
      priceLabel: L.commonAmountGems(80),
      icon: 'circle.hexagongrid.fill',
      gemCost: 80,
      goldGranted: 1000,
      gemsGranted: 0,
    ),
  ];

  static final ShopItem starterPack = ShopItem(
    id: starterPackID,
    kind: ShopItemKind.starterPack,
    name: L.shopStarterPackName,
    description:
        L.shopStarterPackDesc,
    priceLabel: r'$2.99',
    icon: 'gift.fill',
    gemCost: 0,
    goldGranted: 500,
    gemsGranted: 150,
    productID: '$_productIDPrefix.$starterPackID',
  );

  static const vipPassID = 'vip_pass';

  static final ShopItem vipPass = ShopItem(
    id: vipPassID,
    kind: ShopItemKind.vip,
    name: L.shopVipPassName,
    description:
        L.shopVipPassDesc,
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
  static final List<ShopItem> arenaTicketPacks = [
    ShopItem(
      id: 'arena_tickets_small',
      kind: ShopItemKind.arenaTicketPack,
      name: L.shopTicketSmallName,
      description: L.shopTicketSmallDesc,
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
      name: L.shopTicketLargeName,
      description: L.shopTicketLargeDesc,
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
  static final List<ShopItem> exclusiveCharacters = [
    ShopItem(
      id: 'exclusive_igo',
      kind: ShopItemKind.exclusiveCharacter,
      name: L.dk_igo_name,
      description:
          L.shopExclusiveIgoDesc,
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
      name: L.dk_ames_name,
      description:
          L.shopExclusiveAmesDesc,
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
