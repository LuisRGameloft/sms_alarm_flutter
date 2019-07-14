import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size / 2;
    final myController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Input data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children : <Widget> [ 
            MaskedTextField
            (
                maskedTextFieldController: myController,
                mask: "+(xxx) xxx-xxx-xx-xx",
                maxLength: 21,
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
            TextFormField(
                obscureText: true, // Use secure text for passwords.
                decoration: new InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter your password',
                  border: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(1.5)
                  )
                )
            ),
            Container(
                width: screenSize.width,
                child: new RaisedButton(
                  child: new Text(
                    'Login',
                    style: new TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () => null,
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