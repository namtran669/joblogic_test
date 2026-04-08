import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/buy_usecases.dart';
import 'buy_event.dart';
import 'buy_state.dart';

class BuyBloc extends Bloc<BuyEvent, BuyState> {
  final GetBuyItemsUseCase getBuyItemsUseCase;
  final ToggleWishlistUseCase toggleWishlistUseCase;

  BuyBloc({
    required this.getBuyItemsUseCase,
    required this.toggleWishlistUseCase,
  }) : super(const BuyState()) {
    on<FetchBuyItemsEvent>(_onFetch);
    on<ToggleWishlistEvent>(_onToggleWishlist);
    on<FilterBuyItemsEvent>(_onFilter);
    on<SortBuyItemsEvent>(_onSort);
  }

  Future<void> _onFetch(FetchBuyItemsEvent event, Emitter<BuyState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    final result = await getBuyItemsUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: () => failure.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  Future<void> _onToggleWishlist(ToggleWishlistEvent event, Emitter<BuyState> emit) async {
    final result = await toggleWishlistUseCase.call(event.item);
    result.fold(
      (failure) {
         emit(state.copyWith(errorMessage: () => failure.message));
      },
      (_) {
        final newItems = state.items.map((i) {
          if (i.id == event.item.id) {
            return i.copyWith(isWishlisted: !i.isWishlisted);
          }
          return i;
        }).toList();
        
        emit(state.copyWith(items: newItems));
      }
    );
  }

  void _onFilter(FilterBuyItemsEvent event, Emitter<BuyState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSort(SortBuyItemsEvent event, Emitter<BuyState> emit) {
    emit(state.copyWith(sortOption: event.sortOption));
  }
}
