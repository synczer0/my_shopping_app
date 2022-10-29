import 'package:flutter/cupertino.dart';
import 'package:my_shopping_list/db/shopping_db.dart';
import 'package:my_shopping_list/model/shopping_model.dart';
import 'package:sqflite/sqflite.dart';

class ItemProvider extends ChangeNotifier {
  List<ShoppingModel> aList = [];
  DatabaseAccess DBHelper = DatabaseAccess();
  Database? db;

  // Set and acquire from DB to initialize the ShoppingModel Class data
  Future<void> fetchAndSet() async {
    await DBHelper.initDB();

    final dataList = await DBHelper.getItems();
    aList = dataList
        .map((item) => ShoppingModel(
              id: item["id"],
              itemName: item["item_name"],
              description: item["desc"],
              price: item["price"],
              qty: item["qty"],
              priority: item["priority"],
            ))
        .toList();
    notifyListeners();
  }
}
