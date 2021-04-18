import 'package:flutter/cupertino.dart';

class MyItemsList with ChangeNotifier {
  List myItems;

  get getMyitems => this.myItems;

  passItems(List x) {
    this.myItems = x;
    notifyListeners();
  }
}
