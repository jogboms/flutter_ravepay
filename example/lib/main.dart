import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ravepay/flutter_ravepay.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _result;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, dynamic> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await FlutterRavepay.chargeCard({"test": "card"});
    } on PlatformException {
      result = {"message": 'Failed to get platform version.'};
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

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
          child: new Text('Working?: ${_result['message']}\n'),
        ),
      ),
    );
  }
}
