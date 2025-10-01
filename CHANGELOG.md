## 0.0.3
- Refactored core package to use `flutter_app_pay_api` for provider interfaces and DTOs.
- Removed platform/provider interfaces from public exports (`AppPayPlatform`, `ProviderDescriptor`, etc).
- Updated `AppPayClient` to work with typed `ProductDto` / `PurchaseEventDto`.
- Simplified public API: applications now work with `Product`, `PurchaseEvent`, `EntitlementStore` and `ProviderToken`.
- Cleaned up `pubspec.yaml` (removed plugin section, dropped unused dependencies).
- General bug fixes and stability improvements.

## 0.0.2
- bug fix.

## 0.0.1

- first release.
