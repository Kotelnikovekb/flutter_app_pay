import 'package:flutter/foundation.dart';
import 'package:flutter_app_pay_api/flutter_app_pay_api.dart' as api;

/// Internal registry that stores provider descriptors & factories,
/// exposes a resolve() API for AppPayClient, and installs the global
/// registration hook so provider plugins can self-register without
/// depending on this core package.
class AppPayRegistry {
  AppPayRegistry._internal() {
    // Install global registration hook. Provider packages call this.
    api.AppPayRegisterHook.register = (descriptor, factory) {
      return _register(descriptor, factory);
    };
  }

  static final AppPayRegistry instance = AppPayRegistry._internal();

  final Map<String, _Entry> _entries = <String, _Entry>{};
  int _seq = 0;

  /// Registers a provider and returns an opaque token for the app.
  api.ProviderToken _register(api.ProviderDescriptor d, api.ProviderFactory f) {
    if (!d.supports(api.kAppPayApiVersion)) {
      throw StateError(
        'Provider ${d.id} supports API [${d.apiVersionMin}..${d.apiVersionMax}], '
            'but core is ${api.kAppPayApiVersion}. Update core or provider.',
      );
    }
    final key = '${d.id}#${_seq++}';
    _entries[key] = _Entry(descriptor: d, factory: f);
    if (kDebugMode) {
      // ignore: avoid_print
      print('[AppPayRegistry] registered ${d.id} as $key');
    }
    return api.ProviderToken(key);
  }

  /// Resolve a token into a concrete provider entry.
  _Entry resolve(api.ProviderToken token) {
    final e = _entries[token.registryKey];
    if (e == null) {
      throw StateError('Unknown ProviderToken: ${token.registryKey}');
    }
    return e;
  }

  /// For diagnostics/tests.
  Iterable<_Entry> get entries => _entries.values;
}

class _Entry {
  final api.ProviderDescriptor descriptor;
  final api.ProviderFactory factory;

  api.AppPayPlatform? _instance;

  _Entry({required this.descriptor, required this.factory});

  api.AppPayPlatform get instance => _instance ??= factory();
}