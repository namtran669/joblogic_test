import 'package:dio/dio.dart';
import '../models/buy_item_model.dart';
import '../../../../core/database/database_helper.dart';

abstract class BuyRemoteDataSource {
  Future<List<BuyItemModel>> getItems();
}

class BuyRemoteDataSourceImpl implements BuyRemoteDataSource {
  final Dio dio;
  BuyRemoteDataSourceImpl(this.dio);

  @override
  Future<List<BuyItemModel>> getItems() async {
    final response = await dio.get('/api/buy');
    final List data = response.data;
    return data.map((e) => BuyItemModel.fromJson(e)).toList();
  }
}

abstract class BuyLocalDataSource {
  Future<List<String>> getWishlistIds();
  Future<void> addToWishlist(BuyItemModel item);
  Future<void> removeFromWishlist(String externalId);
}

class BuyLocalDataSourceImpl implements BuyLocalDataSource {
  final DatabaseHelper dbHelper;
  BuyLocalDataSourceImpl(this.dbHelper);

  @override
  Future<List<String>> getWishlistIds() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Wishlist', columns: ['external_id']);
    return maps.map((e) => e['external_id'] as String).toList();
  }

  @override
  Future<void> addToWishlist(BuyItemModel item) async {
    final db = await dbHelper.database;
    await db.insert('Wishlist', item.toDbMap());
  }

  @override
  Future<void> removeFromWishlist(String externalId) async {
    final db = await dbHelper.database;
    await db.delete('Wishlist', where: 'external_id = ?', whereArgs: [externalId]);
  }
}
