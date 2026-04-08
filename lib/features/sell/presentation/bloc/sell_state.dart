import 'package:equatable/equatable.dart';
import '../../domain/entities/sell_item.dart';

class SellState extends Equatable {
  final List<SellItem> items;
  final Set<int> selectedIds;
  final bool isLoading;
  final String? errorMessage;
  final List<SellItem>? lastDeletedItems;

  const SellState({
    this.items = const [],
    this.selectedIds = const {},
    this.isLoading = false,
    this.errorMessage,
    this.lastDeletedItems,
  });

  SellState copyWith({
    List<SellItem>? items,
    Set<int>? selectedIds,
    bool? isLoading,
    String? Function()? errorMessage,
    List<SellItem>? Function()? lastDeletedItems,
  }) {
    return SellState(
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      lastDeletedItems: lastDeletedItems != null ? lastDeletedItems() : this.lastDeletedItems,
    );
  }

  @override
  List<Object?> get props => [items, selectedIds, isLoading, errorMessage, lastDeletedItems];
}
