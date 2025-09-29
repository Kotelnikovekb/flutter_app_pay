enum VerificationStatus { notChecked, passed, failed, transientError }

class VerificationResult {
  final VerificationStatus status;
  final String? reason;
  const VerificationResult({required this.status, this.reason});
  const VerificationResult.notChecked()
      : status = VerificationStatus.notChecked, reason = null;

  factory VerificationResult.passed() =>
      const VerificationResult(status: VerificationStatus.passed);
  factory VerificationResult.failed(String reason) =>
      VerificationResult(status: VerificationStatus.failed, reason: reason);
}

abstract class AppPayVerifier {
  Future<VerificationResult> verify(Object event); // обычно PurchaseEvent
}