import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class FavoriteManagerDb {
  static final FavoriteManagerDb favoriteDb = FavoriteManagerDb._internal();

  static Database? _dataBase;

  FavoriteManagerDb._internal();

  Future<Database> get database async {
    if (_dataBase != null) {
      return _dataBase!;
    }

    _dataBase = await _initDatabase();
    return _dataBase!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/nike.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE IF NOT EXISTS ${FieldNamesDb.tableNameProduct}(${FieldNamesDb.columnId} INTEGER PRIMARY KEY ,
        ${FieldNamesDb.columnTitle} TEXT,
        ${FieldNamesDb.columnImageUrl} TEXT,
        ${FieldNamesDb.columnPrice} INTEGER,
        ${FieldNamesDb.columnDiscount} INTEGER,
        ${FieldNamesDb.columnPreviousPrice} INTEGER
      )''');
  }

  Future<int> insertFavorite(ProductEntity productEntity) async {
    final db = await favoriteDb._initDatabase();
    final id =
        await db.insert(FieldNamesDb.tableNameProduct, productEntity.toMap());
    return id;
  }

  Future<bool> isFavorite(int id) async {
    final db = await favoriteDb.database;
    final maps = await db.query(
      FieldNamesDb.tableNameProduct,
      columns: [FieldNamesDb.columnId],
      where: '${FieldNamesDb.columnId} = ?',
      whereArgs: [id],
    );

    return maps.isEmpty;
  }

  Future<List<ProductEntity>> readAll() async {
    final db = await favoriteDb.database;
    final result = await db.query(FieldNamesDb.tableNameProduct);
    return result.map((json) => ProductEntity.fromMap(json)).toList();
  }

  Future<int> update(ProductEntity productEntity) async {
    final db = await favoriteDb.database;
    return db.update(
      FieldNamesDb.tableNameProduct,
      productEntity.toMap(),
      where: '${FieldNamesDb.columnId} = ?',
      whereArgs: [productEntity.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await favoriteDb.database;
    return await db.delete(
      FieldNamesDb.tableNameProduct,
      where: '${FieldNamesDb.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await favoriteDb.database;
    db.close();
  }
}

class FieldNamesDb {
  static const String tableNameProduct = 'product_favorite';
  static const String columnId = '_id';
  static const String columnTitle = 'title';
  static const String columnImageUrl = 'image_url';
  static const String columnPrice = 'price';
  static const String columnDiscount = 'discount';
  static const String columnPreviousPrice = 'previous_price';
}
