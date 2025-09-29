import '../models/entitlement.dart';
import '../models/purchase.dart';
import '../models/enums.dart';

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
      case PurchaseStatusU.purchased:
      case PurchaseStatusU.restored:
        _map[e.productId] = EntitlementState(key: e.productId, isActive: true);
        break;
      case PurchaseStatusU.canceled:
      case PurchaseStatusU.expired:
        _map[e.productId] = EntitlementState(key: e.productId, isActive: false);
        break;
      default:
      // pending/error — не меняем
        break;
    }
  }
}