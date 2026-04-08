import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/call_entity.dart';
import '../../domain/repositories/call_repository.dart';
import '../datasources/call_remote_data_source.dart';

class CallRepositoryImpl implements CallRepository {
  final CallRemoteDataSource remoteDataSource;

  CallRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CallPaginatedInfo>> getCalls(int page) async {
    try {
      final result = await remoteDataSource.getCalls(page);
      return Right(CallPaginatedInfo(
        calls: result['calls'],
        hasMore: result['hasMore'],
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server connection error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
