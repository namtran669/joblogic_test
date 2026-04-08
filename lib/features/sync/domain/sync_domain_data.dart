import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/failures.dart';

abstract class SyncRepository {
  Future<Either<Failure, int>> getPendingCount();
  Future<Either<Failure, void>> syncData();
}

class GetPendingCountUseCase {
  final SyncRepository repository;
  GetPendingCountUseCase(this.repository);
  Future<Either<Failure, int>> call() => repository.getPendingCount();
}

class TriggerSyncUseCase {
  final SyncRepository repository;
  TriggerSyncUseCase(this.repository);
  Future<Either<Failure, void>> call() => repository.syncData();
}

class SyncRepositoryImpl implements SyncRepository {
  final DatabaseHelper dbHelper;
  final Dio dio;

  SyncRepositoryImpl({required this.dbHelper, required this.dio});

  @override
  Future<Either<Failure, int>> getPendingCount() async {
    try {
      final db = await dbHelper.database;
      final result = await db.rawQuery("SELECT COUNT(*) FROM ItemToSell WHERE sync_status = 'pending'");
      int count = Sqflite.firstIntValue(result) ?? 0;
      return Right(count);
    } catch(e) {
       return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncData() async {
    try {
       final db = await dbHelper.database;
       final maps = await db.query('ItemToSell', where: "sync_status = 'pending'");
       
       for (var map in maps) {
          // Mock Network call
          await dio.post('/api/sell', data: map);
          // If successful, update DB status
          await db.update('ItemToSell', {'sync_status': 'synced'}, where: 'id = ?', whereArgs: [map['id']]);
       }
       return const Right(null);
    } on DioException catch(e) {
       return Left(ServerFailure("Network sync failed: ${e.message}"));
    } catch(e) {
       return Left(ServerFailure(e.toString()));
    }
  }
}
