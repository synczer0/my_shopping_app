import 'package:flutter/material.dart';

class ShoppingModel extends ChangeNotifier {
  int? id;
  String? itemName;
  String? description;
  double? price;
  int? qty;
  int? priority;

  List<Map>? listM;

  ShoppingModel(
      {this.id,
      this.itemName,
      this.description,
      this.price,
      this.qty,
      this.priority});

  setListMap(List<Map> m) {
    this.listM = m;
    notifyListeners();
  }

  setId(int id) {
    this.id = id;
    notifyListeners();
  }

  setItemName(String itemName) {
    this.itemName = itemName;
    notifyListeners();
  }

  setDescription(String desc) {
    this.description = desc;
    notifyListeners();
  }

  setPrice(double price) {
    this.price = price;
    notifyListeners();
  }

  setQty(int qty) {
    this.qty = qty;
    notifyListeners();
  }

  setPriority(int prio) {
    this.priority = prio;
    notifyListeners();
  }

  // SET DATA TO DB
  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'item_name': itemName,
      'desc': description,
      'price': price,
      'qty': qty,
      'priority': priority
    };
  }

  // factory ShoppingModel.fromMap(Map<String, dynamic> json) => new ShoppingModel(
  //     id: json['id'],
  //     itemName: json['item_name'],
  //     description: json['desc'],
  //     price: json['price'],
  //     qty: json['qty'],
  //     priority: json['priority']);
}
