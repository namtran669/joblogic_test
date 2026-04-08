import 'package:equatable/equatable.dart';
import '../../domain/entities/buy_item.dart';

abstract class BuyEvent extends Equatable {
  const BuyEvent();
  @override
  List<Object?> get props => [];
}

class FetchBuyItemsEvent extends BuyEvent {}

class ToggleWishlistEvent extends BuyEvent {
  final BuyItem item;
  const ToggleWishlistEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class FilterBuyItemsEvent extends BuyEvent {
  final String query;
  const FilterBuyItemsEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SortBuyItemsEvent extends BuyEvent {
  final String sortOption; 
  const SortBuyItemsEvent(this.sortOption);
  @override
  List<Object?> get props => [sortOption];
}
