import '../registry/provider_registry.dart';

/// Ensures the core is initialized and the global registration hook is set.
/// Call this **before** calling any `registerFlutterAppPay*()` from providers.
class AppPayCore {
  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) return;
    AppPayRegistry.instance;
    _initialized = true;
  }
}