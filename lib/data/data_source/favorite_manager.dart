import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final favoriteManagerDb = FavoriteManagerDb._internal();

class FavoriteManagerDb {
  static Database? _dataBase;

  ValueNotifier<List<ProductEntity>> valuNotifireFavorite = ValueNotifier([]);
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

  Future<bool> insertFavorite(ProductEntity productEntity) async {
    final db = await favoriteManagerDb._initDatabase();
    int id = -1;
    id = await db.insert(FieldNamesDb.tableNameProduct, productEntity.toMap());
    valuNotifireFavorite.value = await readAll();
    return id > -1;
  }

  Future<bool> isFavorite(int id) async {
    final db = await favoriteManagerDb.database;
    final maps = await db.query(
      FieldNamesDb.tableNameProduct,
      columns: [FieldNamesDb.columnId],
      where: '${FieldNamesDb.columnId} = ?',
      whereArgs: [id],
    );
    valuNotifireFavorite.value = await readAll();
    return maps.isNotEmpty;
  }

  Future<List<ProductEntity>> readAll() async {
    final db = await favoriteManagerDb.database;
    final result = await db.query(FieldNamesDb.tableNameProduct);
    final favorites =
        result.map((json) => ProductEntity.fromMap(json)).toList();
    valuNotifireFavorite.value = favorites;
    return favorites;
  }

  Future<int> update(ProductEntity productEntity) async {
    final db = await favoriteManagerDb.database;
    valuNotifireFavorite.value = await readAll();
    return db.update(
      FieldNamesDb.tableNameProduct,
      productEntity.toMap(),
      where: '${FieldNamesDb.columnId} = ?',
      whereArgs: [productEntity.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await favoriteManagerDb.database;
    int rowsEfected = await db.delete(
      FieldNamesDb.tableNameProduct,
      where: '${FieldNamesDb.columnId} = ?',
      whereArgs: [id],
    );
    valuNotifireFavorite.value = await readAll();
    return rowsEfected;
  }

  Future close() async {
    final db = await favoriteManagerDb.database;
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
