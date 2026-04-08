import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sell_usecases.dart';
import 'sell_event.dart';
import 'sell_state.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  final GetSellItemsUseCase getSellItemsUseCase;
  final AddSellItemUseCase addSellItemUseCase;
  final UpdateSellItemUseCase updateSellItemUseCase;
  final DeleteSellItemUseCase deleteSellItemUseCase;
  final BulkDeleteSellItemUseCase bulkDeleteSellItemUseCase;

  SellBloc({
    required this.getSellItemsUseCase,
    required this.addSellItemUseCase,
    required this.updateSellItemUseCase,
    required this.deleteSellItemUseCase,
    required this.bulkDeleteSellItemUseCase,
  }) : super(const SellState()) {
    on<LoadSellItemsEvent>(_onLoadItems);
    on<AddSellItemEvent>(_onAddItem);
    on<UpdateSellItemEvent>(_onUpdateItem);
    on<DeleteSellItemEvent>(_onDeleteItem);
    on<UndoDeleteSellItemEvent>(_onUndoDelete);
    on<ToggleSelectionEvent>(_onToggleSelection);
    on<BulkDeleteSelectedEvent>(_onBulkDelete);
    on<ClearSelectionEvent>(_onClearSelection);
  }

  Future<void> _onLoadItems(LoadSellItemsEvent event, Emitter<SellState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getSellItemsUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: () => failure.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  Future<void> _onAddItem(AddSellItemEvent event, Emitter<SellState> emit) async {
    final result = await addSellItemUseCase.call(event.item);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
      (_) => add(LoadSellItemsEvent()), // Reload to get fresh ID
    );
  }

  Future<void> _onUpdateItem(UpdateSellItemEvent event, Emitter<SellState> emit) async {
    final result = await updateSellItemUseCase.call(event.item);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
      (_) => add(LoadSellItemsEvent()),
    );
  }

  Future<void> _onDeleteItem(DeleteSellItemEvent event, Emitter<SellState> emit) async {
    if (event.item.id == null) return;
    
    final result = await deleteSellItemUseCase.call(event.item.id!);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
      (_) {
        emit(state.copyWith(lastDeletedItems: () => [event.item]));
        add(LoadSellItemsEvent());
      },
    );
  }

  Future<void> _onUndoDelete(UndoDeleteSellItemEvent event, Emitter<SellState> emit) async {
    // Add items back mapping them appropriately
    for(var item in event.items) {
      await addSellItemUseCase.call(item.copyWith(id: null)); // Ignore previous id
    }
    emit(state.copyWith(lastDeletedItems: () => null));
    add(LoadSellItemsEvent());
  }

  void _onToggleSelection(ToggleSelectionEvent event, Emitter<SellState> emit) {
    final updatedSet = Set<int>.from(state.selectedIds);
    if (updatedSet.contains(event.id)) {
      updatedSet.remove(event.id);
    } else {
      updatedSet.add(event.id);
    }
    emit(state.copyWith(selectedIds: updatedSet));
  }

  void _onClearSelection(ClearSelectionEvent event, Emitter<SellState> emit) {
    emit(state.copyWith(selectedIds: {}));
  }

  Future<void> _onBulkDelete(BulkDeleteSelectedEvent event, Emitter<SellState> emit) async {
    if (state.selectedIds.isEmpty) return;
    
    final itemsToDelete = state.items.where((i) => i.id != null && state.selectedIds.contains(i.id)).toList();
    final idsList = state.selectedIds.toList();

    final result = await bulkDeleteSellItemUseCase.call(idsList);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: () => failure.message)),
      (_) {
         emit(state.copyWith(
           selectedIds: {},
           lastDeletedItems: () => itemsToDelete
         ));
         add(LoadSellItemsEvent());
      }
    );
  }
}
