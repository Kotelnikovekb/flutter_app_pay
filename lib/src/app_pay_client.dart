import 'dart:async';
import 'core/entitlement_store.dart';
import 'core/mapper.dart';
import 'core/verifier.dart';
import 'models/entitlement.dart';
import 'models/product.dart';
import 'models/purchase.dart';
import 'platform/app_pay_platform.dart';
import 'registry/provider_registry.dart';
import 'registry/provider_descriptor.dart';

class AppPayClient {
  AppPayClient({
    Set<ProviderToken>? providers,
    this.verifier,
    EntitlementStore? entitlements,
  })  : _tokens = providers,
        _ents = entitlements ?? InMemoryEntitlementStore();

  final Set<ProviderToken>? _tokens;
  final AppPayVerifier? verifier;
  final EntitlementStore _ents;

  final _platforms = <String, AppPayPlatform>{};
  final _purchaseCtrl = StreamController<PurchaseEvent>.broadcast();
  Stream<PurchaseEvent> get purchases => _purchaseCtrl.stream;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final selected = _tokens?.map((t) => t.descriptor)
        ?? AppPayRegistry.instance.descriptors();

    for (final d in selected) {
      final p = AppPayRegistry.instance.createById(d.id);
      await p.init();
      _platforms[d.id] = p;

      p.purchaseStream.listen((raw) async {
        final ev = mapPurchase(raw);
        final v  = await verifier?.verify(ev) ?? VerificationResult.passed();
        _ents.apply(ev);
        _purchaseCtrl.add(ev.copyWith(verification: v));
      });
    }
    _initialized = true;
  }

  Future<List<Product>> queryProducts(Set<String> ids) async {
    final out = <Product>[];
    for (final entry in _platforms.entries) {
      final rawList = await entry.value.queryProducts(ids);
      out.addAll(rawList.map(mapProduct));
    }
    return out;
  }

  Future<void> buy(Product product, {String? offerId}) async {
    final p = _platforms[product.storeId];
    if (p == null) {
      throw StateError('Provider "${product.storeId}" not initialized');
    }
    await p.buy(product.id, offerId: offerId);
  }

  Future<void> restore({String? providerId}) async {
    final list = providerId == null
        ? _platforms.values
        : [_platforms[providerId]!];
    for (final p in list) {
      await p.restore();
    }
  }

  Future<EntitlementState> entitlement(String key) => _ents.get(key);

  Future<void> dispose() async {
    for (final p in _platforms.values) { await p.dispose(); }
    await _purchaseCtrl.close();
  }
}