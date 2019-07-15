import 'package:flutter/material.dart';
import 'package:sms_alarm_flutter/pages/main.dart';
import 'package:sms_alarm_flutter/pages/sms_commands.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

Future<bool> _checkIfExistValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String telephone = prefs.getString('telph');
  if (telephone == null) return false;
  if (telephone.isEmpty) return false;
  return true;
}

class MyApp extends StatefulWidget {
    @override
    MyAppstate createState() => MyAppstate();
}

class MyAppstate extends State<MyApp> {

  var _result;

  @override
  void initState() {
     // This is the proper place to make the async calls
     // This way they only get called once

     // During development, if you change this code,
     // you will need to do a full restart instead of just a hot reload
        
     // You can't use async/await here,
     // We can't mark this method as async because of the @override
     _checkIfExistValues().then((result) {
         // If we need to rebuild the widget with the resulting data,
         // make sure to use `setState`
         setState(() {
             _result = result;
        });
     });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Check if there's exist prevusly telephone and password saved
    Widget startWidget = MainPage();
    if (_result == true) {
        startWidget = SmsCommandPage();
    }
    
    return MaterialApp(
      title: 'SMS Alarm',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: startWidget,
    );
  }
}

