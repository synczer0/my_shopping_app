import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shopping_list/db/shopping_db.dart';
import 'package:my_shopping_list/model/db_provider.dart';
import 'package:my_shopping_list/model/shopping_model.dart';
import 'package:my_shopping_list/utils/utils.dart';
import 'package:provider/provider.dart';

class EditItems extends StatefulWidget {
  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  DatabaseAccess database = DatabaseAccess();
  final _formKey = GlobalKey<FormState>();
  Utility utils = Utility();

  Future updateDatabase(
      int id, String name, String desc, double price, int qty) async {
    await database.initDB();
    await database.updateItem(id, name, desc, price, qty);
  }

  @override
  Widget build(BuildContext context) {
    // get the arguments from navigation
    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var _getValues = routes.values.toList();

    // set the initial value on the text form field
    TextEditingController itemName = TextEditingController(text: _getValues[1]);
    TextEditingController desc = TextEditingController(text: _getValues[2]);
    TextEditingController price =
        TextEditingController(text: _getValues[3].toString());
    TextEditingController qty =
        TextEditingController(text: _getValues[4].toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: itemName,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    labelText: 'Item Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: desc,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: price,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r"[a-z,A-Z]"))
                  ],
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    labelText: 'Price',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: qty,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r"[a-z,A-Z]"))
                  ],
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    labelText: 'Quantity',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Consumer<ShoppingModel>(
                          builder: (context, myModel, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              updateDatabase(
                                  _getValues[0],
                                  itemName.text,
                                  desc.text,
                                  double.parse(price.text),
                                  int.parse(qty.text));
                              Provider.of<ItemProvider>(context, listen: false)
                                  .fetchAndSet();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Item Successfully Edited...'),
                                ),
                              );
                            }
                          },
                          child: Text('Edit Item'),
                        );
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
