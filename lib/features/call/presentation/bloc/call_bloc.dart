import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/get_calls_usecase.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final GetCallsUseCase getCallsUseCase;

  CallBloc({required this.getCallsUseCase}) : super(const CallState()) {
    on<FetchCallsEvent>(_onFetchCalls);
    on<FilterCallsEvent>(_onFilterCalls);
    _loadLastSynced();
  }

  Future<void> _loadLastSynced() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString('last_synced_calls');
    if (timeStr != null) {
      emit(state.copyWith(lastSynced: DateTime.tryParse(timeStr)));
    }
  }

  Future<void> _saveLastSynced(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_synced_calls', time.toIso8601String());
  }

  void _onFilterCalls(FilterCallsEvent event, Emitter<CallState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onFetchCalls(FetchCallsEvent event, Emitter<CallState> emit) async {
    if (state.hasReachedMax && !event.isRefresh) return;
    if (state.isLoading) return;

    emit(state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      currentPage: event.isRefresh ? 1 : state.currentPage,
    ));

    final pageToFetch = event.isRefresh ? 1 : state.currentPage;

    final result = await getCallsUseCase.call(pageToFetch);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        ));
      },
      (paginatedInfo) {
        final now = DateTime.now();
        _saveLastSynced(now);

        final updatedCalls = event.isRefresh
            ? paginatedInfo.calls
            : List.of(state.calls)..addAll(paginatedInfo.calls);

        emit(state.copyWith(
          isLoading: false,
          calls: updatedCalls,
          hasReachedMax: !paginatedInfo.hasMore,
          currentPage: pageToFetch + 1,
          lastSynced: now,
        ));
      },
    );
  }
}
