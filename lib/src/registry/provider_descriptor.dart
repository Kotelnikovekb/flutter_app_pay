import '../models/enums.dart';

enum ProviderPlatform { android, ios, any }

class ProviderDescriptor {
  final String id;                 // уникальный ключ, напр. 'pay.google'
  final String name;               // 'Google Play Billing'
  final ProviderPlatform platform; // android | ios | any
  final Set<ProductType> capabilities;
  const ProviderDescriptor({
    required this.id,
    required this.name,
    required this.platform,
    this.capabilities = const {},
  });
}

class ProviderToken {
  final ProviderDescriptor descriptor;
  const ProviderToken(this.descriptor);
}