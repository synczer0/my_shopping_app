import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shopping_list/model/db_provider.dart';
import 'package:provider/provider.dart';
import '../model/shopping_model.dart';
import '../db/shopping_db.dart';
import '../utils/utils.dart';

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController item_name = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController qty = TextEditingController();
  DatabaseAccess database = DatabaseAccess();
  Utility utils = Utility();

  Future initDatabase(Map<String, dynamic> maps) async {
    await database.initDB();
    await database.insertItem(maps);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: item_name,
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
                        if (_formKey.currentState!.validate()) {
                          myModel.setId(utils
                              .returnRandomNumber()); // set some random generated number
                          myModel.setPriority(2);
                          myModel.setItemName(item_name.text);
                          myModel.setDescription(desc.text);
                          myModel.setPrice(double.parse(price.text));
                          myModel.setQty(int.parse(qty.text));

                          initDatabase(myModel.toMap());
                          Provider.of<ItemProvider>(context, listen: false)
                              .fetchAndSet();
                          // Set the input boxes to empty
                          item_name.text = '';
                          desc.text = '';
                          price.text = '';
                          qty.text = '';

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item Successfully added..'),
                            ),
                          );
                        }
                      },
                      child: Text('Add Item'),
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
