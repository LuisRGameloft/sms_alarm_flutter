import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:progress_dialog/progress_dialog.dart';

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

class DataValues {
  String pw;
  String tl;

  DataValues({this.pw, this.tl});
}

class SmsCommandState extends State<SmsCommandPage> {
  ProgressDialog _pr;
  DataValues _values;
  
  Future<DataValues> _gettingValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String telephone = prefs.getString('telph');
    String passwd = prefs.getString('passwd');
    DataValues vals = DataValues(pw : passwd, tl: telephone);
    return vals;
  }

  @override
  void initState() {
     // This is the proper place to make the async calls
     // This way they only get called once

     // During development, if you change this code,
     // you will need to do a full restart instead of just a hot reload
        
     // You can't use async/await here,
     // We can't mark this method as async because of the @override
     _gettingValues().then((result) {
         // If we need to rebuild the widget with the resulting data,
         // make sure to use `setState`
         setState(() {
            _values = result;
        });
     });
  }

  void _sendSMS(String message, List<String> recipents) async {
    try {  
      final result = await FlutterSms.canSendSMS();
      if(result) {
        await FlutterSms
          .sendSMS(message: message, recipients: recipents)
          .catchError((onError) {
              print(onError);
          });
      }
    } on PlatformException { } 
    catch (e) { }
    //await new Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    _pr = ProgressDialog(context, ProgressDialogType.Normal);
    _pr.setMessage('Sending message wait...');

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
                      _pr.show();
                      await _sendSMS(_values.pw, [_values.tl]);
                      _pr.hide();
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
                      _pr.show();
                      await _sendSMS("Here is a test Message", [""]);
                      _pr.hide();
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