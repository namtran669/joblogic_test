import 'package:equatable/equatable.dart';

class CallEntity extends Equatable {
  final int id;
  final String name;
  final String phone;

  const CallEntity({required this.id, required this.name, required this.phone});

  @override
  List<Object?> get props => [id, name, phone];
}

class CallPaginatedInfo extends Equatable {
  final List<CallEntity> calls;
  final bool hasMore;

  const CallPaginatedInfo({required this.calls, required this.hasMore});

  @override
  List<Object?> get props => [calls, hasMore];
}
