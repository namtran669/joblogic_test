import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/sell_item.dart';

abstract class SellRepository {
  Future<Either<Failure, List<SellItem>>> getItems();
  Future<Either<Failure, void>> addItem(SellItem item);
  Future<Either<Failure, void>> updateItem(SellItem item);
  Future<Either<Failure, void>> deleteItem(int id);
  Future<Either<Failure, void>> bulkDelete(List<int> ids);
}

class GetSellItemsUseCase {
  final SellRepository repository;
  GetSellItemsUseCase(this.repository);
  Future<Either<Failure, List<SellItem>>> call() => repository.getItems();
}
class AddSellItemUseCase {
  final SellRepository repository;
  AddSellItemUseCase(this.repository);
  Future<Either<Failure, void>> call(SellItem item) => repository.addItem(item);
}
class UpdateSellItemUseCase {
  final SellRepository repository;
  UpdateSellItemUseCase(this.repository);
  Future<Either<Failure, void>> call(SellItem item) => repository.updateItem(item);
}
class DeleteSellItemUseCase {
  final SellRepository repository;
  DeleteSellItemUseCase(this.repository);
  Future<Either<Failure, void>> call(int id) => repository.deleteItem(id);
}
class BulkDeleteSellItemUseCase {
  final SellRepository repository;
  BulkDeleteSellItemUseCase(this.repository);
  Future<Either<Failure, void>> call(List<int> ids) => repository.bulkDelete(ids);
}
