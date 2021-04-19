import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseAccess with ChangeNotifier {
  final int version = 1; // SQL Versioning
  final oneSecond = Duration(seconds: 1);
  Database _db;

  // Factory Constructor
  static final DatabaseAccess _dbAcess = DatabaseAccess._internal();

  DatabaseAccess._internal();
  factory DatabaseAccess() {
    return _dbAcess;
  }

  Future<Database> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (_db == null) {
      _db = await openDatabase(join(await getDatabasesPath(), 'shopping_db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE shop_table (id INTEGER PRIMARY KEY, item_name TEXT, ' +
                'desc TEXT , price REAL, qty INT, priority INT)');
      }, version: version);
    } else {
      print('Database is already initialized..');
    }
    return _db;
  }

  Future<Database> dropDBTable() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (_db == null) {
      print('no table');
    } else {
      print('table initialized');
    }
    _db = await openDatabase(join(await getDatabasesPath(), 'shopping_db'),
        onCreate: (database, version) {
      database.execute('DROP TABLE shop_table');
    }, version: version);

    return _db;
  }

  Future<void> insertItem(Map<String, dynamic> maps) async {
    await _db.insert('shop_table', maps,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    List<Map<String, dynamic>> getData =
        await _db.rawQuery('SELECT * FROM shop_table');

    return getData;
  }

  int getLe() {
    int i;
    getItems().then((value) => i = value.length);
    print(i);
    return i;
  }
}
