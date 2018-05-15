import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ravepay/flutter_ravepay.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterRavepayResult _result;

  chargeCard() async {
    FlutterRavepayResult result;

    try {
      result = await FlutterRavepay.chargeCard({"test": "card"});
    } on PlatformException {
      result = new FlutterRavepayResult({"message": 'Failed to get platform version.'});
    }

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Ravepay'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                color: Colors.green,
                onPressed: () => chargeCard(),
                child: new Text("TEST"),
              ),
              SizedBox(height: 16.0,),
              new Text('Working?: ${_result?.toMap()}\n'),
            ],
          ),
        ),
      ),
    );
  }
}
