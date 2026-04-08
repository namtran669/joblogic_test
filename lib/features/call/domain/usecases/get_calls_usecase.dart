import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/call_entity.dart';
import '../repositories/call_repository.dart';

class GetCallsUseCase {
  final CallRepository repository;

  GetCallsUseCase(this.repository);

  Future<Either<Failure, CallPaginatedInfo>> call(int page) async {
    return await repository.getCalls(page);
  }
}
