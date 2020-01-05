import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttersms/model/custom_contact.dart';
import 'package:fluttersms/screens/feedback_screen.dart';
import 'package:fluttersms/constants.dart';
import 'package:sms/sms.dart';

import 'package:flutter_sms/flutter_sms.dart';

// import 'package:url_launcher/url_launcher.dart';

class MessageScreen extends StatefulWidget {
  final List<CustomContact> contacts;

  MessageScreen({Key key, this.title, @required this.contacts})
      : super(key: key);

  final String title;

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<CustomContact> contacts = List<CustomContact>();

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    // B PLAN
    List<String> recipients = new List();
    if (myController.text.length > 0) {
      for (var i = 0; i < widget.contacts.length; i++) {
        if (Platform.isAndroid) {
          SmsSender sender = new SmsSender();
          String address = widget.contacts[i].contact.phones.first.value;
          sender.sendSms(new SmsMessage(address, myController.text));
          print("Message sent to:" + address);
        }
        // B PLAN
        recipients.add(widget.contacts[i].contact.phones.first.value);

        //   String _result = await FlutterSms
        //         .sendSMS(message: myController.text, recipients: widget.contacts[i].contact.phones.first.value.toString())
        //         .catchError((onError) {
        //       print(onError);
        //     });
        // print(_result);

        //   if(Platform.isAndroid){
        //       //FOR Android
        //       const url ='sms:+6000000000?body=deneme';
        //       await launch(url);

        // String _result = await FlutterSms.sendSMS(
        //         message: myController.text, recipients: recipients)
        //     .catchError((onError) {
        //   print(onError);
        // });
        // print(_result);

        //   }
        //   else if(Platform.isIOS){
        //       //FOR IOS
        //       const url ='sms:+6000000000&body=message';
        //       await launch(url);
        //   }

      }

      // B PLAN
      if (Platform.isIOS) {
        //       //FOR IOS
        //       const url ='sms:+6000000000&body=message';
        //       await launch(url);

        String _result = await FlutterSms.sendSMS(
                message: myController.text, recipients: recipients)
            .catchError((onError) {
          print(onError);
        });
        print(_result);
      }

      myController.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FeedBackScreen(
                  title: 'Messages Sent Successfully',
                  contacts: widget.contacts)));
      // }

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ContactSelection(title: 'test')),
      //     ModalRoute.withName("/Home"));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Oops"),
            content: new Text("Type something please."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
              color: messageTextareaColor,
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
        backgroundColor: messageButtonColor,
        onPressed: sendMessage,
        icon: messageButtonIcon,
        label: Text(
          'Send Message',
          style: floatingButtonLabelTextStyle,
        ),
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
