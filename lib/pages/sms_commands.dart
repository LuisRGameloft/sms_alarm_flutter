import 'package:flutter/material.dart';

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

enum ConfirmAction { CANCEL, ACCEPT }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Data is correct?'),
        content: const Text(
            'You can change this setting on options section.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

class SmsCommandState extends State<SmsCommandPage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size / 2;
    final saveButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              print("Presseed buttoonn");
              final ConfirmAction action = await _asyncConfirmDialog(context);
            },
            child: Text("Save",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Initializate data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children : <Widget> [ 
            SizedBox (
              width: screenSize.width,
              child: TextFormField(
                obscureText: true, // Use secure text for passwords.
                decoration: new InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter your password',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)
                  )
                )
              )
            ),
            Container(
                width: screenSize.width,
                child: saveButton
            )
          ]
        ),
      ),
    );
  }
}

class SmsCommandPage extends StatefulWidget{
  @override 
  SmsCommandState createState() => SmsCommandState();
}