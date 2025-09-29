import 'enums.dart';
import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String title;
  final String description;
  final String price;        // локализованная строка
  final String currencyCode; // 'EUR'
  final double priceValue;   // 2.99
  final ProductType type;
  final String storeId;      // id провайдера из ProviderDescriptor.id
  final Map<String, Object?> raw;
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.priceValue,
    required this.type,
    required this.storeId,
    this.raw = const {},
  });
}