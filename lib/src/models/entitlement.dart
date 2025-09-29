import 'package:flutter/foundation.dart';

@immutable
class EntitlementState {
  final String key;          // напр. 'sub_premium_month'
  final bool isActive;
  final DateTime? expiryAt;  // для подписок
  const EntitlementState({
    required this.key,
    required this.isActive,
    this.expiryAt,
  });
}