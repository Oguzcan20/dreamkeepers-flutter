import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/shop_item.dart';

/// Result of attempting to charge real money for a `ShopItem` — kept small
/// and billing-SDK-agnostic so `GameState`/UI don't need to reason about
/// any particular platform's transaction types directly. Mirrors
/// Platform/PurchaseService.swift's `PurchaseOutcome` exactly.
enum PurchaseOutcome { success, userCancelled, pending, failed }

/// One seam for real-money purchases, same shape as `AdRewardService`.
/// `GameState.purchase(_)` remains the *grant* step (unchanged, still
/// directly unit-testable with no billing SDK involved); a
/// `PurchaseService` implementation is the *charge* step that must succeed
/// first for any item with a non-null `ShopItem.productID`. Items with a
/// null `productID` (currently only `.goldExchange`, a virtual-currency-only
/// trade) never go through this at all and keep calling
/// `GameState.purchase(_)` directly. Mirrors Platform/PurchaseService.swift
/// exactly.
abstract class PurchaseService {
  Future<PurchaseOutcome> purchase(ShopItem item);

  /// Fires for a verified transaction the app didn't itself initiate this
  /// launch — a restore, or an out-of-band approval that completes after
  /// the original `purchase` call already returned. A real implementation
  /// wires this to grant the matching `ShopItem` via `GameState`, keyed by
  /// product ID. `GameState.create` assigns this exactly once, so a plain
  /// settable field (rather than a constructor param) keeps every
  /// `PurchaseService` implementation, mock included, uniform.
  void Function(String productID)? onExternalPurchase;
}

/// Always succeeds instantly — used by tests and anywhere else a real
/// billing round-trip would just add noise.
class MockPurchaseService implements PurchaseService {
  @override
  void Function(String productID)? onExternalPurchase;

  @override
  Future<PurchaseOutcome> purchase(ShopItem item) async => PurchaseOutcome.success;
}

/// Real Google Play Billing purchases via the `in_app_purchase` plugin,
/// same shape as the iOS side's `StoreKitPurchaseService`
/// (Platform/PurchaseService.swift): query the product, launch the
/// platform purchase sheet, and resolve once Google's `purchaseStream`
/// reports a terminal status for it. Every `ShopItem.productID` already
/// matches the App Store Connect identifiers 1:1
/// (`com.dreamhaven.dreamkeepers.<id>`, see `ShopCatalog`) — create
/// matching in-app products with the *same* IDs in the Play Console
/// (consumable for `.gemPack`/`.arenaTicketPack`, non-consumable/managed
/// for `.starterPack`/`.vip`/`.exclusiveCharacter`) before this can charge
/// anything for real; until then `queryProductDetails` reports every ID as
/// not-found and `purchase()` fails cleanly, same as StoreKit's
/// `Product.products(for:)` returning no match before the App Store
/// Connect products exist.
class GooglePlayPurchaseService implements PurchaseService {
  GooglePlayPurchaseService() {
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate, onError: (_) {});
  }

  static const _consumableKinds = {ShopItemKind.gemPack, ShopItemKind.arenaTicketPack};

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Resolves the in-flight `purchase()` call waiting on this product ID.
  /// A `purchaseStream` update with no matching entry here (a restore, or
  /// an out-of-band approval arriving after `purchase()` already
  /// returned) routes through `onExternalPurchase` instead — mirrors
  /// StoreKit's separate `Transaction.updates` listener on the iOS side.
  final Map<String, Completer<PurchaseOutcome>> _pending = {};

  @override
  void Function(String productID)? onExternalPurchase;

  @override
  Future<PurchaseOutcome> purchase(ShopItem item) async {
    final productID = item.productID;
    if (productID == null) return PurchaseOutcome.failed;

    final available = await _iap.isAvailable();
    if (!available) return PurchaseOutcome.failed;

    final response = await _iap.queryProductDetails({productID});
    if (response.productDetails.isEmpty) {
      // Not yet created in the Play Console (or the store is unreachable) —
      // same "failed" outcome the mock's caller already handles.
      return PurchaseOutcome.failed;
    }

    final completer = Completer<PurchaseOutcome>();
    _pending[productID] = completer;

    final purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
    final started = _consumableKinds.contains(item.kind)
        ? await _iap.buyConsumable(purchaseParam: purchaseParam)
        : await _iap.buyNonConsumable(purchaseParam: purchaseParam);

    if (!started) {
      _pending.remove(productID);
      return PurchaseOutcome.failed;
    }

    return completer.future;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      final completer = _pending.remove(purchase.productID);
      switch (purchase.status) {
        case PurchaseStatus.pending:
          completer?.complete(PurchaseOutcome.pending);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchase.pendingCompletePurchase) _iap.completePurchase(purchase);
          if (completer != null) {
            completer.complete(PurchaseOutcome.success);
          } else {
            onExternalPurchase?.call(purchase.productID);
          }
        case PurchaseStatus.canceled:
          completer?.complete(PurchaseOutcome.userCancelled);
        case PurchaseStatus.error:
          if (purchase.pendingCompletePurchase) _iap.completePurchase(purchase);
          completer?.complete(PurchaseOutcome.failed);
      }
    }
  }

  /// Call from a `State.dispose()` if this service is ever recreated
  /// mid-session; `GameState.create()` currently builds one for the whole
  /// app lifetime, so this is here for completeness rather than a call
  /// site that exists today.
  void dispose() {
    _subscription?.cancel();
  }
}
