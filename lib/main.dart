import 'package:flutter/material.dart';
import 'package:fluttersms/screen/message_screen.dart';
// import 'package:fluttersms/screen/contacts_screen.dart';
// import 'package:fluttersms/screen/test_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MessageScreen(title: 'Multi SMS'),
    );
  }
}
