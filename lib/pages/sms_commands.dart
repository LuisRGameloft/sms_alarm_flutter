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
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Activate Alarm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children : <Widget> [ 
            Container(
                child: Material(
                  shape: CircleBorder(side: BorderSide(
                    color: Colors.black, width: 1.0,style: BorderStyle.solid)
                  ),
                  elevation: 5.0,
                  color: Color(0xff4B8B3B),
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
                    onPressed: () async {
                      final ConfirmAction action = await _asyncConfirmDialog(context);
                    },
                    child: Text("On",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
            ),
            Container(
                child: Material(
                  shape: CircleBorder(side: BorderSide(
                    color: Colors.black, width: 1.0,style: BorderStyle.solid)
                  ),
                  elevation: 5.0,
                  color: Color(0xffAB4B52),
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
                    onPressed: () async {
                      final ConfirmAction action = await _asyncConfirmDialog(context);
                    },
                    child: Text("Off",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
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