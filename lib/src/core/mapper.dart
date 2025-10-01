import 'package:flutter_app_pay_api/flutter_app_pay_api.dart';

import '../models/product.dart';
import '../models/purchase.dart';

Product mapProduct(Map<String, dynamic> raw) {
  return Product(
    id: raw['id'] as String,
    title: (raw['title'] as String?) ?? raw['id'] as String,
    description: (raw['description'] as String?) ?? '',
    price: (raw['priceLabel'] as String?) ?? (raw['price'] as String?) ?? '',
    currencyCode: (raw['currency'] as String?) ?? '',
    type: _typeFrom(raw['type'] as String?),
    storeId: raw['storeId'] as String,
    raw: raw,
  );
}

PurchaseEvent mapPurchase(Map<String, dynamic> raw) {
  return PurchaseEvent(
    storeId: raw['storeId'] as String,
    productId: (raw['productId'] as String?) ?? '',
    transactionId: (raw['transactionId'] as String?) ?? '',
    status: _statusFrom(raw['status'] as String?),
    errorMessage: raw['error'] as String?,
    raw: raw,
  );
}

ProductType _typeFrom(String? t) => switch (t) {
      'consumable' => ProductType.consumable,
      'subscription' => ProductType.subscription,
      _ => ProductType.nonConsumable,
    };

PurchaseStatus _statusFrom(String? s) => switch (s) {
      'pending' => PurchaseStatus.pending,
      'purchased' => PurchaseStatus.purchased,
      'restored' => PurchaseStatus.restored,
      'canceled' => PurchaseStatus.canceled,
      'expired' => PurchaseStatus.expired,
      'error' => PurchaseStatus.error,
      _ => PurchaseStatus.error,
    };
