import 'package:equatable/equatable.dart';
import '../../domain/entities/call_entity.dart';

class CallState extends Equatable {
  final List<CallEntity> calls;
  final String searchQuery;
  final bool hasReachedMax;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final DateTime? lastSynced;

  const CallState({
    this.calls = const [],
    this.searchQuery = '',
    this.hasReachedMax = false,
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.lastSynced,
  });

  List<CallEntity> get filteredCalls {
    if (searchQuery.isEmpty) return calls;
    return calls.where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()) || c.phone.contains(searchQuery)).toList();
  }

  CallState copyWith({
    List<CallEntity>? calls,
    String? searchQuery,
    bool? hasReachedMax,
    bool? isLoading,
    String? Function()? errorMessage,
    int? currentPage,
    DateTime? lastSynced,
  }) {
    return CallState(
      calls: calls ?? this.calls,
      searchQuery: searchQuery ?? this.searchQuery,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  @override
  List<Object?> get props => [calls, searchQuery, hasReachedMax, isLoading, errorMessage, currentPage, lastSynced];
}
