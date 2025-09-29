/// Базовый интерфейс для провайдера магазина (реализуется внешним модулем).
abstract class AppPayPlatform {
  /// Stream сырых событий покупки (map), ядро замапит в PurchaseEvent.
  Stream<Map<String, dynamic>> get purchaseStream;

  Future<void> init();
  Future<List<Map<String, dynamic>>> queryProducts(Set<String> ids);
  Future<void> buy(String productId, {String? offerId});
  Future<void> restore();
  Future<void> dispose();
}