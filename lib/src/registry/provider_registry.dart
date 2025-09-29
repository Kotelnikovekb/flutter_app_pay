import '../platform/app_pay_platform.dart';
import 'provider_descriptor.dart';

typedef ProviderFactory = AppPayPlatform Function();

class AppPayRegistry {
  AppPayRegistry._();
  static final AppPayRegistry instance = AppPayRegistry._();

  final Map<String, (ProviderDescriptor, ProviderFactory)> _map = {};

  ProviderToken register(ProviderDescriptor desc, ProviderFactory factory) {
    _map[desc.id] = (desc, factory);
    return ProviderToken(desc);
  }

  Iterable<ProviderDescriptor> descriptors() =>
      _map.values.map((e) => e.$1);

  AppPayPlatform createById(String id) {
    final pair = _map[id];
    if (pair == null) throw StateError('Provider "$id" not registered');
    return pair.$2();
  }
}