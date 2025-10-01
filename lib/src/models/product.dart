import 'package:flutter_app_pay_api/flutter_app_pay_api.dart' as api;

class Product {
  final String id;
  final String title;
  final String description;
  final String price;
  final String currencyCode;
  final api.ProductType type;   // <<< ВАЖНО: тип из api
  final String storeId;
  final Map<String, Object?> raw;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.type,
    required this.storeId,
    this.raw = const {},
  });

  factory Product.fromDto(api.ProductDto d) => Product(
    id: d.id,
    title: d.title,
    description: d.description,
    price: d.priceLabel,
    currencyCode: d.currencyCode ?? '',
    type: d.type,
    storeId: d.providerId,
    raw: d.raw,
  );
}