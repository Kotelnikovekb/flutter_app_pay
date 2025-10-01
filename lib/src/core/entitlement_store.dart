import 'package:flutter_app_pay_api/flutter_app_pay_api.dart';

import '../models/entitlement.dart';
import '../models/purchase.dart';

abstract class EntitlementStore {
  Future<EntitlementState> get(String key);
  void apply(PurchaseEvent event);
}

class InMemoryEntitlementStore implements EntitlementStore {
  final _map = <String, EntitlementState>{};

  @override
  Future<EntitlementState> get(String key) async =>
      _map[key] ?? EntitlementState(key: key, isActive: false);

  @override
  void apply(PurchaseEvent e) {
    switch (e.status) {
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        _map[e.productId] = EntitlementState(key: e.productId, isActive: true);
        break;
      case PurchaseStatus.canceled:
      case PurchaseStatus.expired:
        _map[e.productId] = EntitlementState(key: e.productId, isActive: false);
        break;
      default:
      // pending/error — не меняем
        break;
    }
  }
}