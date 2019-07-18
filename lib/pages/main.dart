import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:sms_alarm_flutter/pages/sms_commands.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:sms_alarm_flutter/common/utils.dart';

class MainPage extends StatefulWidget{
  @override 
  MainPageState createState() => MainPageState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class MainPageState extends State<MainPage> {
  final _phoneController = TextEditingController();
  final _passwdController = TextEditingController();
  
  Future<void> savingData(String passwd, String telph) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('telph', telph);
    prefs.setString('passwd', passwd);
    await new Future.delayed(const Duration(seconds: 1));
  }

  Future<ConfirmAction> confirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Is data correct?'),
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
  
  Future<ConfirmAction> warningDialog(BuildContext context, String msg) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              msg),
          actions: <Widget>[
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _phoneController.dispose();
    _passwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size / 2;
    
    final saveButton = ProgressButton(
        color: Color(0xff01A0C7),
        borderRadius: 32.0,
        defaultWidget: Text(
                "Save",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)
                ),
        progressWidget: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
        ),
        onPressed: () async {
          if (_passwdController.text.isEmpty || _phoneController.text.isEmpty) {
                final String msg = _phoneController.text.isEmpty?"Telephone field is empty":"Password field is empty";
                await warningDialog(context, msg);
          } else {
                final ConfirmAction action = await confirmDialog(context);
                if (action == ConfirmAction.ACCEPT) {
                  final String cleanPhone = _phoneController.text.replaceAll("-", "");
                  await savingData(_passwdController.text, cleanPhone);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SmsCommandPage()));
                }
          }
          return () {
          // Optional returns is returning a function that can be called
          // after the animation is stopped at the beginning.
          // A best practice would be to do time-consuming task in [onPressed],
          // and do page navigation in the returned function.
          // So that user won't missed out the reverse animation.
          };
        },
    );

    return new WillPopScope(
        onWillPop: () => exitAppPopup(context),
        child: new Scaffold(
            appBar: AppBar(
              title: Text('Initializate data'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children : <Widget> [ 
                  SizedBox (
                    child: MaskedTextField (
                        maskedTextFieldController: _phoneController,
                        mask: "xxx-xxx-xx-xx",
                        maxLength: 13,
                        keyboardType: TextInputType.number,
                        inputDecoration: InputDecoration(
                            hintText: "Write you Telephone Number", 
                            labelText: "Telephone",
                            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder (
                              borderRadius: BorderRadius.circular(32.0)
                            )
                        ),
                    ),
                  ),
                  SizedBox (
                    child: TextFormField(
                      controller : _passwdController,
                      obscureText: true, // Use secure text for passwords.
                      decoration: new InputDecoration(
                        hintText: 'Password',
                        labelText: 'Enter your password',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)
                        )
                      )
                    )
                  ),
                  Container(
                      width: screenSize.width,
                      height: 70,
                      child: saveButton
                  ),
                ]
              ),
            ),
        ),
    );
  }
}

