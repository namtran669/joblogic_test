import 'package:equatable/equatable.dart';
import '../../domain/entities/buy_item.dart';

class BuyState extends Equatable {
  final List<BuyItem> items;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String sortOption;

  const BuyState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.sortOption = 'none',
  });

  List<BuyItem> get displayItems {
    var filtered = items;
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((e) => e.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    
    if (sortOption == 'name_asc') {
      filtered = List.from(filtered)..sort((a, b) => a.name.compareTo(b.name));
    } else if (sortOption == 'price_asc') {
      filtered = List.from(filtered)..sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == 'price_desc') {
      filtered = List.from(filtered)..sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

  BuyState copyWith({
    List<BuyItem>? items,
    bool? isLoading,
    String? Function()? errorMessage,
    String? searchQuery,
    String? sortOption,
  }) {
    return BuyState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage, searchQuery, sortOption];
}
