import '../../domain/entities/buy_item.dart';

class BuyItemModel extends BuyItem {
  const BuyItemModel({
    required super.id,
    required super.name,
    required super.price,
    super.isWishlisted,
  });

  factory BuyItemModel.fromJson(Map<String, dynamic> json) {
    return BuyItemModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'external_id': id,
      'name': name,
      'price': price,
    };
  }
}
