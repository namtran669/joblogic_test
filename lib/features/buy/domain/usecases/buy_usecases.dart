import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/buy_item.dart';
import '../repositories/buy_repository.dart';

class GetBuyItemsUseCase {
  final BuyRepository repository;
  GetBuyItemsUseCase(this.repository);

  Future<Either<Failure, List<BuyItem>>> call() {
    return repository.getItems();
  }
}

class ToggleWishlistUseCase {
  final BuyRepository repository;
  ToggleWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(BuyItem item) {
    return repository.toggleWishlist(item);
  }
}
