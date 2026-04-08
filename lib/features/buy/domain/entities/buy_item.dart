import 'package:equatable/equatable.dart';

class BuyItem extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isWishlisted;

  const BuyItem({
    required this.id,
    required this.name,
    required this.price,
    this.isWishlisted = false,
  });

  BuyItem copyWith({bool? isWishlisted}) {
    return BuyItem(
      id: id,
      name: name,
      price: price,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  @override
  List<Object?> get props => [id, name, price, isWishlisted];
}
