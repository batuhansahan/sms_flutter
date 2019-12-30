import 'package:flutter/material.dart';
import 'package:fluttersms/screens/contact_selection_screen.dart';
import 'package:fluttersms/utils/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: appbarColor),
      home: ContactSelection(title: 'Select Contacts'),
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => new ContactSelection(),
      },
    );
  }
}
