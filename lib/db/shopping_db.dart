import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess extends ChangeNotifier {
  final int version = 1; // SQL Versioning

  Database? _db;
  var logger = Logger();

  // Factory Constructor
  static final DatabaseAccess _dbAcess = DatabaseAccess._internal();

  DatabaseAccess._internal();
  factory DatabaseAccess() {
    return _dbAcess;
  }

  Future<Database?>? initDB() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (_db == null) {
      _db = await openDatabase(join(await getDatabasesPath(), 'shopping_db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE shop_table (id INTEGER PRIMARY KEY, item_name TEXT, ' +
                'desc TEXT , price REAL, qty INT, priority INT)');
      }, version: version);
    }
    // else {

    //   logger.d('Database is already initialized..');
    // }
    return _db;
  }

  Future<Database?> dropDBTable() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (_db == null) {
      print('No table initialized yet.');
      // logger.d('No table initialized yet.');
    } else {
      print('Database table is already initialized');
      // logger.d('Database table is already initialized');
    }
    _db = await openDatabase(join(await getDatabasesPath(), 'shopping_db'),
        onCreate: (database, version) {
      database.execute('DROP TABLE shop_table');
    }, version: version);

    return _db;
  }

  Future<void> insertItem(Map<String, dynamic> maps) async {
    await _db!.insert('shop_table', maps,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    await initDB();
    List<Map<String, dynamic>> getData =
        await _db!.rawQuery('SELECT * FROM shop_table');

    return getData;
  }

  Future<void> removeItem(int? id) async {
    await initDB();
    await _db!.delete('shop_table', where: "id = ?", whereArgs: [id]);
  }

  Future<void> updateItem(
      int id, String name, String desc, double price, int qty) async {
    Map<String, dynamic> toUpdate = {
      'id': id,
      'item_name': name,
      'desc': desc,
      'price': price,
      'qty': qty
    };

    await initDB();
    await _db!.update('shop_table', toUpdate, where: 'id = ?', whereArgs: [id]);
  }
}
