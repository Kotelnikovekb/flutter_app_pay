import 'enums.dart';
import '../core/verifier.dart';
import 'package:flutter/foundation.dart';

@immutable
class PurchaseEvent {
  final String storeId;         // 'pay.google' | 'pay.apple' | 'pay.rustore'
  final String productId;
  final String transactionId;
  final PurchaseStatusU status;
  final String? errorMessage;
  final Map<String, Object?> raw;
  final VerificationResult verification;

  const PurchaseEvent({
    required this.storeId,
    required this.productId,
    required this.transactionId,
    required this.status,
    this.errorMessage,
    this.raw = const {},
    this.verification =
    const VerificationResult(status: VerificationStatus.notChecked),
  });

  PurchaseEvent copyWith({VerificationResult? verification}) => PurchaseEvent(
    storeId: storeId,
    productId: productId,
    transactionId: transactionId,
    status: status,
    errorMessage: errorMessage,
    raw: raw,
    verification: verification ?? this.verification,
  );
}