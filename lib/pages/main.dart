import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:sms_alarm_flutter/effects/scale_transition.dart';
import 'package:sms_alarm_flutter/pages/sms_commands.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

_savingData(String passwd, String telph) async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.setString('telph', telph);
  //prefs.setString('passwd', passwd);
  
  await new Future.delayed(const Duration(seconds: 1));
}

class MainPageState extends State<MainPage> {
  ProgressDialog _pr;
  
  @override
  Widget build(BuildContext context) {
    _pr = ProgressDialog(context, ProgressDialogType.Download);
    _pr.setMessage('Saving plase wait...');

    final Size screenSize = MediaQuery.of(context).size / 2;
    final _phoneController = TextEditingController();
    final _passwdController = TextEditingController();

    final saveButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              final ConfirmAction action = await _asyncConfirmDialog(context);
              if (action == ConfirmAction.ACCEPT) {
                  _pr.show();
                  await _savingData(_passwdController.text, _phoneController.text);    
                  _pr.hide();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SmsCommandPage()));
              }
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
              child: MaskedTextField (
                  maskedTextFieldController: _phoneController,
                  mask: "(xxx) xxx-xxx-xx-xx",
                  maxLength: 19,
                  keyboardType: TextInputType.number,
                  inputDecoration: InputDecoration(
                      hintText: "Write you Telephone Number", 
                      labelText: "Telephone",
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder (
                        borderRadius: BorderRadius.circular(32.0)
                      )
                  ),
              ),
            ),
            SizedBox (
              width: screenSize.width,
              child: TextFormField(
                controller : _passwdController,
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

class MainPage extends StatefulWidget{
  @override 
  MainPageState createState() => MainPageState();
}