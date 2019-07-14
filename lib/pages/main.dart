import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

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

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size / 2;
    final myController = TextEditingController();

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
              child: MaskedTextField (
                  maskedTextFieldController: myController,
                  mask: "(xxx) xxx-xxx-xx-xx",
                  maxLength: 19,
                  keyboardType: TextInputType.number,
                  inputDecoration: InputDecoration(
                      hintText: "Write you Telephone Number", 
                      labelText: "Telephone",
                      border: OutlineInputBorder(
                        gapPadding: 0.0,
                        borderRadius: BorderRadius.circular(1.5)
                      )
                    ),
              ),
            ),
            SizedBox (
              width: screenSize.width,
              child: TextFormField(
                obscureText: true, // Use secure text for passwords.
                decoration: new InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter your password',
                  border: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(1.5)
                  )
                )
              )
            ),
            Container(
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Save',
                    style: new TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () async {
                      print("Presseed buttoonn");
                      final ConfirmAction action = await _asyncConfirmDialog(context);
                  },
                  color: Colors.blue,
                ),
                margin: new EdgeInsets.only(
                  top: 20.0
                ),
               )
          ]
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget{
  @override 
  MainPageState createState() => MainPageState();
}