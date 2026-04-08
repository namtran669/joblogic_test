import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/call_entity.dart';

abstract class CallRepository {
  Future<Either<Failure, CallPaginatedInfo>> getCalls(int page);
}
