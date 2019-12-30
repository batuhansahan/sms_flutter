import 'package:flutter/material.dart';

import 'package:fluttersms/model/custom_contact.dart';
import 'package:fluttersms/screens/contact_selection_screen.dart';

import 'package:contacts_service/contacts_service.dart';

import 'package:fluttersms/utils/constants.dart';

class FeedBackScreen extends StatefulWidget {
  final List<CustomContact> contacts;
  FeedBackScreen({Key key, this.title, @required this.contacts})
      : super(key: key);

  final String title;
  final String floatingButtonTitle = 'Back To Home';

  @override
  _FeedBackState createState() => new _FeedBackState(
        floatingButtonLabel: this.floatingButtonTitle
      );
}

class _FeedBackState extends State<FeedBackScreen> {
  bool _isLoading = false;
  String floatingButtonLabel;
  _FeedBackState({
    this.floatingButtonLabel,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: !_isLoading
          ? Container(
              child: ListView.builder(
                itemCount: widget.contacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact = widget.contacts[index];
                  var _phonesList = _contact.contact.phones.toList();

                  return _buildListTile(_contact, _phonesList);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: feedbackButtonColor,
        onPressed: _onSubmit,
        icon: feedbackButtonIcon,
        label: Text(floatingButtonLabel,style: floatingButtonLabelTextStyle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _onSubmit() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ContactSelection(title: 'Select Contacts')),
        ModalRoute.withName("/Home"));
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: checkboxActiveColor,
          value: c.isChecked,
          onChanged: (bool value) {}),
    );
  }
}
