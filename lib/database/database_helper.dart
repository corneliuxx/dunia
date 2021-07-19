import 'dart:io';

import 'package:path/path.dart';
import 'package:shambadunia/models/cartModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "Shambadunia.db";
  static final _databaseVersion = 1;

  static final table = 'shopping_cart_tb';

  static final columnId = '_id';
  static final columnProductId = 'pid';
  static final columnProductName = 'name';
  static final columnProductThumbnail = 'image';
  static final columnProductQuantity = 'quantity';
  static final columnProductAmount = 'amount';
  static final columnSubTotal = 'subtotal';
  static final columnProductUnit = 'unit';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnProductId INTEGER NOT NULL,
            $columnProductName TEXT NOT NULL,
            $columnProductThumbnail TEXT ,
            $columnProductQuantity INTEGER NOT NULL,
            $columnProductUnit TEXT NOT NULL,
            $columnProductAmount REAL NOT NULL,
            $columnSubTotal REAL NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    var idToCheck = row[columnId];
    var quanty = row[columnProductQuantity];

    /*Database db = await instance.database;

    var queryResult =
        await db.rawQuery('SELECT * FROM $table WHERE _id=$idToCheck');

    queryResult.isEmpty
        ? db.insert(table, row)
        : db.rawQuery('UPDATE $table SET quantity=quantity+$quanty, subtotal = (quantity+$quanty)*amount WHERE _id=$idToCheck');*/

    Database db = await instance.database;
    db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<CartModel>> queryOrders() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return CartModel(
        id: maps[i][columnId],
        productId: maps[i][columnProductId],
        productName: maps[i][columnProductName],
        thumbnail: maps[i][columnProductThumbnail],
        quantity: maps[i][columnProductQuantity],
        productUnit: maps[i][columnProductUnit],
        productAmount: maps[i][columnProductAmount],
        subTotal: maps[i][columnSubTotal],
      );
    });
  }

  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes ALL the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
