import 'package:flutter/material.dart';
import 'package:my_shopping_list/model/db_provider.dart';
import 'pages/add_page.dart';
import 'pages/edit_page.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'model/test_model.dart';
import 'model/list_model.dart';
import 'model/shopping_model.dart';
import 'db/shopping_db.dart';

void main() {
  runApp(MyShoppingList());
}

class MyShoppingList extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ShoppingModel>(
              create: (context) => ShoppingModel()),
          ChangeNotifierProvider<ItemProvider>(
              create: (context) => ItemProvider()),
        ],
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/add-page': (context) => AddPage(),
            '/edit-page': (context) => EditItems(),
          },
        ));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyItemsList lists;
  DatabaseAccess database = DatabaseAccess();
  List<Map<String, dynamic>> getData;
  ShoppingModel shopdata;
  ItemProvider pr = ItemProvider();

  Future removeItems(int id) async {
    await database.removeItem(id);
  }

  // Initialize the provider
  Future initData() async {
    Provider.of<ItemProvider>(context, listen: false).fetchAndSet();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  Widget displayMessage() {
    return Center(
      child: Text('No current listed items...'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shopping List'),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: 15,
              ),
              child: GestureDetector(
                onTap: () {
                  // initData();
                },
                child: Icon(Icons.more_vert),
              ),
            )
          ],
        ),
        body: Consumer<ItemProvider>(
          builder: (context, value, child) {
            return value.aList.length == 0
                ? displayMessage()
                : ListView.builder(
                    itemCount: value.aList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        dismissThresholds: {
                          DismissDirection.endToStart: 0.3,
                          DismissDirection.startToEnd: 0.3,
                        },
                        // secondaryBackground: Container(
                        //   color: Colors.green,
                        // ),
                        background: Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          // print(value.aList[index].id);

                          removeItems(value.aList[index].id);
                          initData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value.aList[index].itemName +
                                  ' Item Removed.'),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          padding: EdgeInsets.only(
                            left: 3,
                            right: 3,
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            width: 0.3,
                          ))),
                          child: ListTile(
                            trailing: IconButton(
                                splashRadius: 20,
                                icon: Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  // Pass the arguments to the Edit Page Screen
                                  Navigator.pushNamed(context, '/edit-page',
                                      arguments: {
                                        'id': value.aList[index].id,
                                        'item_name':
                                            value.aList[index].itemName,
                                        'desc': value.aList[index].description,
                                        'price': value.aList[index].price,
                                        'qty': value.aList[index].qty,
                                      });
                                }),
                            subtitle: Text(
                                'PHP ' + value.aList[index].price.toString()),
                            title: Text(value.aList[index].itemName),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/add-page');
          },
        ));
  }
}
