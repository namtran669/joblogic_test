import 'package:equatable/equatable.dart';
import '../../domain/entities/sell_item.dart';

abstract class SellEvent extends Equatable {
  const SellEvent();
  @override
  List<Object?> get props => [];
}

class LoadSellItemsEvent extends SellEvent {}

class AddSellItemEvent extends SellEvent {
  final SellItem item;
  const AddSellItemEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateSellItemEvent extends SellEvent {
  final SellItem item;
  const UpdateSellItemEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class DeleteSellItemEvent extends SellEvent {
  final SellItem item;
  const DeleteSellItemEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class UndoDeleteSellItemEvent extends SellEvent {
  final List<SellItem> items; // Support undoing multiple
  const UndoDeleteSellItemEvent(this.items);
  @override
  List<Object?> get props => [items];
}

class ToggleSelectionEvent extends SellEvent {
  final int id;
  const ToggleSelectionEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class BulkDeleteSelectedEvent extends SellEvent {}

class ClearSelectionEvent extends SellEvent {}
