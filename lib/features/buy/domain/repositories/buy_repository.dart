import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/buy_item.dart';

abstract class BuyRepository {
  Future<Either<Failure, List<BuyItem>>> getItems();
  Future<Either<Failure, void>> toggleWishlist(BuyItem item);
}
