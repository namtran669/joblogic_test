import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/buy_item.dart';
import '../../domain/repositories/buy_repository.dart';
import '../datasources/buy_data_sources.dart';
import '../models/buy_item_model.dart';

class BuyRepositoryImpl implements BuyRepository {
  final BuyRemoteDataSource remoteDataSource;
  final BuyLocalDataSource localDataSource;

  BuyRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<BuyItem>>> getItems() async {
    try {
      final remoteItems = await remoteDataSource.getItems();
      final wishlistIds = await localDataSource.getWishlistIds();

      final mergedItems = remoteItems.map((item) {
        return item.copyWith(isWishlisted: wishlistIds.contains(item.id));
      }).toList();

      return Right(mergedItems);
    } on DioException catch(e) {
      return Left(ServerFailure(e.message ?? 'Server Connection Error'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleWishlist(BuyItem item) async {
    try {
      final model = BuyItemModel(id: item.id, name: item.name, price: item.price, isWishlisted: item.isWishlisted);
      if (item.isWishlisted) {
        // It was wishlisted, we need to remove it
        await localDataSource.removeFromWishlist(item.id);
      } else {
        // It was not wishlisted, we need to add it
        await localDataSource.addToWishlist(model);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
