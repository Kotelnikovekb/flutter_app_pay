abstract interface class AppPayPlatform {
  Stream<Map<String, dynamic>> get purchaseStream;

  Future<void> init();
  Future<List<Map<String, dynamic>>> queryProducts(Set<String> ids);
  Future<void> buy(String productId, {String? offerId});
  Future<void> restore();
  Future<void> dispose();
}