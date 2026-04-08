import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/sell_item.dart';
import '../../domain/usecases/sell_usecases.dart'; // Contains SellRepository definition here
import 'package:test_joblogic/features/sell/data/datasources/sell_local_data_source.dart';

class SellRepositoryImpl implements SellRepository {
  final SellLocalDataSource localDataSource;
  SellRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<SellItem>>> getItems() async {
    try {
      final items = await localDataSource.getItems();
      return Right(items);
    } catch(e) {
      return Left(CacheFailure("Failed to load sell items: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> addItem(SellItem item) async {
    try {
      await localDataSource.addItem(SellItemModel.fromEntity(item));
      return const Right(null);
    } catch(e) {
      return Left(CacheFailure("Failed to add sell item: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> updateItem(SellItem item) async {
    try {
      await localDataSource.updateItem(SellItemModel.fromEntity(item));
      return const Right(null);
    } catch(e) {
      return Left(CacheFailure("Failed to update sell item: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(int id) async {
    try {
      await localDataSource.deleteItem(id);
      return const Right(null);
    } catch(e) {
      return Left(CacheFailure("Failed to delete item: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> bulkDelete(List<int> ids) async {
    try {
      if (ids.isEmpty) return const Right(null);
      await localDataSource.bulkDelete(ids);
      return const Right(null);
    } catch(e) {
      return Left(CacheFailure("Failed to bulk delete items: $e"));
    }
  }
}
