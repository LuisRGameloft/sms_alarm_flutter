import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

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

  _sendSMS(String message, List<String> recipents) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activate Alarm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children : <Widget> [ 
            Container (
              height: 120,
              width: 120,
              child : ProgressButton(
                animate:false,
                color: Color(0xff4B8B3B),
                borderRadius: 100,
                defaultWidget: Text("On",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
                progressWidget: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                ),
                onPressed: () async {
                  await _sendSMS(_values.pw, [_values.tl]);
                },
              )
            ),
            Container (
              height: 120,
              width: 120,
              child : ProgressButton(
                animate:false,
                color: Color(0xffAB4B52),
                borderRadius: 100,
                defaultWidget: Text("Off",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
                progressWidget: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                ),
                onPressed: () async {
                  await _sendSMS(_values.pw, [_values.tl]);
                },
              )
            ),
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