## 0.0.4
- Fixed type conflicts between `flutter_app_pay` and `flutter_app_pay_api` (duplicate `ProviderToken`, `ProductType`).
- Updated `AppPayClient` to use only API types (`ProductDto`, `PurchaseEventDto`).
- Removed redundant local enums and models from the core package.
- Improved compatibility with provider plugins (Google Play, App Store, RuStore).
- Minor code cleanup and documentation improvements.

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
