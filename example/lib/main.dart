import 'package:flutter/material.dart';
import 'package:flutter_ravepay/flutter_ravepay.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Ravepay ravePay;
  RavepayResult _result;

  void chargeCard() async {
    final RavepayResult result = await ravePay.chargeCard(
      const RavepayConfig(
        amount: 4500.0,
        country: "NG",
        currency: "NGN",
        email: "jeremiahogbomo@gmail.com",
        firstname: "Jeremiah",
        lastname: "Ogbomo",
        narration: "Test Payment",
        publicKey: "FLWPUBK-cd3500135be97b13a29c70e3ee233cbf-X",
        secretKey: "FLWSECK-6257675603889ba57c880eda2a936b46-X",
        txRef: "ravePay-1234345",
        useAccounts: false,
        useCards: true,
        isStaging: true,
        useSave: true,
        metadata: [
          const RavepayMeta("email", "jeremiahogbomo@gmail.com"),
          const RavepayMeta("id", "1994"),
        ],
      ),
    );

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    ravePay = Ravepay.of(context);

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Ravepay'),
        ),
        body: new Center(
          child: SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  color: Colors.green,
                  onPressed: () => chargeCard(),
                  child: new Text("TEST"),
                ),
                SizedBox(
                  height: 16.0,
                ),
                new Text('Working?: ${_result?.toMap()}\n'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
