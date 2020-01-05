import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttersms/model/custom_contact.dart';
import 'package:fluttersms/screens/message_screen.dart';

import 'package:contacts_service/contacts_service.dart';
import 'package:fluttersms/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactSelection extends StatefulWidget {
  static const routeName = '/Home';
  ContactSelection({Key key, this.title}) : super(key: key);

  final String title;
  final String floatingButtonTitle = 'Write a Message';

  @override
  _ContactSelectionState createState() => new _ContactSelectionState(
        floatingButtonLabel: this.floatingButtonTitle,
      );
}

class _ContactSelectionState extends State<ContactSelection> {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  List<CustomContact> _uiReceiverCustomContacts = List<CustomContact>();
  List<CustomContact> _allContacts = List<CustomContact>();
  bool _isLoading = false;
  String floatingButtonLabel;

  _ContactSelectionState({
    this.floatingButtonLabel
  });

  @override
  void initState() {
    super.initState();
    refreshContacts();
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
                itemCount: _uiCustomContacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact = _uiCustomContacts[index];
                  var _phonesList = _contact.contact.phones.toList();

                  return _buildListTile(_contact, _phonesList);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: contactButtonColor,
        onPressed: _onSubmit,
        icon: contactButtonIcon,
        label: Text(floatingButtonLabel,style: floatingButtonLabelTextStyle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _onSubmit() {
    setState(() {
        if (_allContacts.where((contact) => contact.isChecked == true).length ==
            0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Oops"),
                content: new Text("Select more than one contact please."),
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
        } else {
          _uiReceiverCustomContacts = _allContacts
              .where((contact) => contact.isChecked == true)
              .toList();
          // print(_uiCustomContacts);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MessageScreen(
                      title: 'Write a Message',
                      contacts: _uiReceiverCustomContacts)));
        }

    });
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      onTap: () {
        setState(() {
          c.isChecked = !c.isChecked;
        });
      },
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: checkboxActiveColor,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
          }),
    );
  }


  refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      setState(() {
        _isLoading = true;
      });
      var contacts = await ContactsService.getContacts();
      _populateContacts(contacts);
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }
}
