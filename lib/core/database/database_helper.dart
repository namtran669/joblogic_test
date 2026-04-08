import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('joblogic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const syncStatusType = 'TEXT NOT NULL'; // 'synced' or 'pending'

    await db.execute('''
CREATE TABLE ItemToSell (
  id $idType,
  name $textType,
  price $realType,
  quantity $integerType,
  sync_status $syncStatusType
)
''');

    await db.execute('''
CREATE TABLE Wishlist (
  id $idType,
  external_id $textType,
  name $textType,
  price $realType
)
''');
  }
}
