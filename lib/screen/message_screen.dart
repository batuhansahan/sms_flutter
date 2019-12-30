import 'package:flutter/material.dart';
import 'package:fluttersms/screen/test_screen.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: myController,
                    maxLines: 10,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your message here"),
                  ),
                ))
          ],
        ),
        floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title:'hey', message: myController.text)
                  ));
                
            // print(myController.text);
        },
        icon: Icon(Icons.contacts),
        label: Text('Select Contacts'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: sendSms,
        //   tooltip: 'Increment',
        //   child: Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
