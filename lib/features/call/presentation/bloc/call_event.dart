import 'package:equatable/equatable.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();
  @override
  List<Object?> get props => [];
}

class FetchCallsEvent extends CallEvent {
  final bool isRefresh;
  const FetchCallsEvent({this.isRefresh = false});
  @override
  List<Object?> get props => [isRefresh];
}

class FilterCallsEvent extends CallEvent {
  final String query;
  const FilterCallsEvent(this.query);
  @override
  List<Object?> get props => [query];
}
