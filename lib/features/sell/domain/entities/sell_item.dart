import 'package:equatable/equatable.dart';

class SellItem extends Equatable {
  final int? id;
  final String name;
  final double price;
  final int quantity;
  final String syncStatus;

  const SellItem({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.syncStatus = 'pending',
  });

  SellItem copyWith({
    int? id,
    String? name,
    double? price,
    int? quantity,
    String? syncStatus,
  }) {
    return SellItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [id, name, price, quantity, syncStatus];
}
