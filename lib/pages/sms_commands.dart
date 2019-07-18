import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:sms_alarm_flutter/pages/main.dart';
import 'package:sms_alarm_flutter/common/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsCommandPage extends StatefulWidget{
  @override 
  SmsCommandState createState() => SmsCommandState();
}

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
class DataValues {
  String pw;
  String tl;
  DataValues({this.pw, this.tl});
}

class SmsCommandState extends State<SmsCommandPage> {
  static const platform = const MethodChannel('com.platforms/utils');
  DataValues _values;
  
  Future<void> sendSMS({String message, String phonenumber}) async {
    try {
      await platform.invokeMethod('p_SendSMS', {"message":message, "phone":phonenumber});
      // sleep 1 second for feedback
      await Future.delayed(const Duration(seconds: 1), () => "1");
    } on PlatformException catch (e) { e.toString(); }
  }

  Future<DataValues> gettingValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String telephone = prefs.getString('telph');
    String passwd = prefs.getString('passwd');
    DataValues vals = DataValues(pw : passwd, tl: telephone);
    return vals;
  }

  @override
  void initState() {
    super.initState();
     // This is the proper place to make the async calls
     // This way they only get called once

     // During development, if you change this code,
     // you will need to do a full restart instead of just a hot reload
        
     // You can't use async/await here,
     // We can't mark this method as async because of the @override
     gettingValues().then((result) {
         // If we need to rebuild the widget with the resulting data,
         // make sure to use `setState`
         setState(() {
            _values = result;
        });
     });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => exitAppPopup(context),
      child: Scaffold(
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
                        color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                    progressWidget: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                    ),
                    onPressed: () async {
                      // Check permission  
                      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.sms);
                      if (permission != PermissionStatus.granted) {
                        // Try to access its permission
                        Map<PermissionGroup, PermissionStatus> getPermissions = await PermissionHandler().requestPermissions([PermissionGroup.sms]);
                        if (getPermissions[PermissionGroup.sms] != PermissionStatus.granted) {
                            return;
                        }
                      } 
                      String msg = _values.pw + "1#";
                      await sendSMS(message: msg, phonenumber: _values.tl);
                      await Future.delayed(const Duration(seconds: 1), () => "1");
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
                        color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                    progressWidget: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                    ),
                    onPressed: () async {
                      // Check permission  
                      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.sms);
                      if (permission != PermissionStatus.granted) {
                        // Try to access its permission
                        Map<PermissionGroup, PermissionStatus> getPermissions = await PermissionHandler().requestPermissions([PermissionGroup.sms]);
                        if (getPermissions[PermissionGroup.sms] != PermissionStatus.granted) {
                            return;
                        }
                      } 
                      String msg = _values.pw + "0#";
                      await sendSMS(message: msg, phonenumber: _values.tl);
                      await Future.delayed(const Duration(seconds: 1), () => "1");
                    },
                  )
                ),
              ]
            ),
          ),
          floatingActionButton: new FloatingActionButton(
              onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage())
                  );
              },
              backgroundColor: Colors.red,
              //if you set mini to true then it will make your floating button small
              mini: false,
              child: new Icon(Icons.build),
          ),
      ),
    );
  }
}

