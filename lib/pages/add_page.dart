import 'package:flutter/material.dart';
import '../widgets/add_page_form.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Shopping List'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(15),
          alignment: Alignment.topCenter,
          child: AddForm(),
        ),
      ),
    );
  }
}
