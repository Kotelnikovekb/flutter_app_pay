import 'dart:async';

import 'package:flutter/foundation.dart';
import '../flutter_app_pay.dart';
import 'registry/provider_registry.dart';
import 'package:flutter_app_pay_api/flutter_app_pay_api.dart' as api;

/// Main orchestrator. Consumes provider tokens, initializes providers,
/// exposes products and purchase events in app-friendly types.
class AppPayClient {
  AppPayClient({
    required Set<api.ProviderToken> providers,
    EntitlementStore? entitlements,
    AppPayVerifier? verifier,
  })  : _providerTokens = providers,
        _entitlements = entitlements ?? InMemoryEntitlementStore(),
        _verifier = verifier;

  final Set<api.ProviderToken> _providerTokens;
  final EntitlementStore _entitlements;
  final AppPayVerifier? _verifier;

  final List<_ProviderHandle> _handles = <_ProviderHandle>[];
  final _eventsCtrl = StreamController<PurchaseEvent>.broadcast();

  bool _initialized = false;

  /// Normalized purchase events for the app.
  Stream<PurchaseEvent> get purchases => _eventsCtrl.stream;

  /// Initialize all providers and subscribe to their event streams.
  Future<void> init() async {
    if (_initialized) return;

    final reg = AppPayRegistry.instance;

    for (final token in _providerTokens) {
      final entry = reg.resolve(token);
      final platform = entry.instance;

      await platform.init();

      try {
        await platform.refreshStatus();
      } catch (e, st) {
        debugPrint(
            'provider ${entry.descriptor.id} refreshStatus failed: $e\n$st');
      }

      final sub = platform.events.listen((apiEvt) async {
        // DTO -> публичная модель
        final ev = _mapPurchaseEvent(apiEvt);

        // (временно) без серверной верификации, т.к. у PurchaseEvent нет copyWithVerification
        // если нужна проверка — добавим поле/метод в модель и вернём этот блок.

        // применяем энтайтлменты
        _entitlements.apply(ev);

        _eventsCtrl.add(ev);
      });

      _handles.add(_ProviderHandle(
        id: entry.descriptor.id,
        platform: platform,
        sub: sub,
      ));
    }

    _initialized = true;
  }

  /// Query products by SKUs across all initialized providers.
  Future<List<Product>> queryProducts(Set<String> ids) async {
    _ensureInit();
    final List<Product> out = [];
    for (final h in _handles) {
      try {
        final list = await h.platform.queryProducts(ids);
        out.addAll(list.map(_mapProduct));
      } catch (e, st) {
        debugPrint('queryProducts failed for ${h.id}: $e\n$st');
      }
    }
    return out;
  }

  /// Buy a product via its owning provider.
  Future<void> buy(Product product, {String? offerId}) async {
    _ensureInit();
    final h = _handles.firstWhere(
          (p) => p.id == product.storeId,
      orElse: () => throw StateError('No provider registered for ${product.storeId}'),
    );
    await h.platform.buy(product.id, offerId: offerId);
  }

  /// Ask all providers to restore purchases.
  Future<void> restore() async {
    _ensureInit();
    for (final h in _handles) {
      try {
        await h.platform.restore();
      } catch (e, st) {
        debugPrint('restore failed for ${h.id}: $e\n$st');
      }
    }
  }

  /// Read entitlement snapshot for a logical key (your app mapping).
  Future<EntitlementState> entitlement(String key) => _entitlements.get(key);

  Future<void> dispose() async {
    for (final h in _handles) {
      await h.sub.cancel();
      await h.platform.dispose();
    }
    _handles.clear();
    await _eventsCtrl.close();
    _initialized = false;
  }

  // ─────────────────────────────── mapping helpers ───────────────────────────────

  Product _mapProduct(api.ProductDto d) => Product(
        id: d.id,
        title: d.title,
        description: d.description,
        price: d.priceLabel,
        currencyCode: d.currencyCode ?? '',
        type: d.type,
        storeId: d.providerId,
        raw: d.raw,
      );

  PurchaseEvent _mapPurchaseEvent(api.PurchaseEventDto d) => PurchaseEvent(
        storeId: d.providerId,
        productId: d.productId,
        transactionId: d.transactionId,
        status: api.PurchaseStatus.pending,
        raw: d.raw,
      );

  void _ensureInit() {
    if (!_initialized) {
      throw StateError('AppPayClient.init() must be called before use');
    }
  }
}

class _ProviderHandle {
  final String id; // providerId (e.g. 'pay.rustore')
  final api.AppPayPlatform platform;
  final StreamSubscription<api.PurchaseEventDto> sub;

  _ProviderHandle({
    required this.id,
    required this.platform,
    required this.sub,
  });
}
