import '../../domain/entities/sell_item.dart';
import '../../../../core/database/database_helper.dart';

class SellItemModel extends SellItem {
  const SellItemModel({
    super.id,
    required super.name,
    required super.price,
    required super.quantity,
    super.syncStatus,
  });

  factory SellItemModel.fromEntity(SellItem entity) {
    return SellItemModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      quantity: entity.quantity,
      syncStatus: entity.syncStatus,
    );
  }

  factory SellItemModel.fromJson(Map<String, dynamic> json) {
    return SellItemModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      syncStatus: json['sync_status'],
    );
  }

  Map<String, dynamic> toDbMap() {
    final map = <String, dynamic>{
      'name': name,
      'price': price,
      'quantity': quantity,
      'sync_status': syncStatus,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}

abstract class SellLocalDataSource {
  Future<List<SellItemModel>> getItems();
  Future<void> addItem(SellItemModel item);
  Future<void> updateItem(SellItemModel item);
  Future<void> deleteItem(int id);
  Future<void> bulkDelete(List<int> ids);
}

class SellLocalDataSourceImpl implements SellLocalDataSource {
  final DatabaseHelper dbHelper;
  SellLocalDataSourceImpl(this.dbHelper);

  @override
  Future<List<SellItemModel>> getItems() async {
    final db = await dbHelper.database;
    final maps = await db.query('ItemToSell');
    return maps.map((e) => SellItemModel.fromJson(e)).toList();
  }

  @override
  Future<void> addItem(SellItemModel item) async {
    final db = await dbHelper.database;
    await db.insert('ItemToSell', item.toDbMap());
  }

  @override
  Future<void> updateItem(SellItemModel item) async {
    if (item.id == null) return;
    final db = await dbHelper.database;
    await db.update('ItemToSell', item.toDbMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  @override
  Future<void> deleteItem(int id) async {
    final db = await dbHelper.database;
    await db.delete('ItemToSell', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> bulkDelete(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await dbHelper.database;
    await db.delete('ItemToSell', where: 'id IN (${ids.join(',')})');
  }
}
