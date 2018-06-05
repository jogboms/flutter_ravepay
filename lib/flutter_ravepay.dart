import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

class RavepayConfig {
  final double amount;
  final String country;
  final String currency;
  final String email;
  final String firstname;
  final String lastname;
  final String narration;
  final String publicKey;
  final String secretKey;
  final String txRef;
  final bool useAccounts;
  final bool useCards;
  final bool isStaging;
  final bool useSave;
  final bool style = null;

  RavepayConfig({
    @required this.amount,
    @required this.country,
    @required this.currency,
    @required this.email,
    @required this.firstname,
    this.lastname = "",
    this.narration = "",
    @required this.publicKey,
    @required this.secretKey,
    @required this.txRef,
    this.useAccounts = true,
    this.useCards = true,
    this.isStaging = true,
    this.useSave = true,
  });

  toMap() {
    return {
      "amount": amount.toString(),
      "currency": currency,
      "country": country,
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "narration": narration,
      "publicKey": publicKey,
      "secretKey": secretKey,
      "txRef": txRef,
      "useAccounts": useAccounts,
      "useCards": useCards,
      "isStaging": isStaging,
      "useSave": useSave,
      "style": style,
    };
  }
}

class RavepayResult {
  int id;
  double amount;
  double charged_amount;
  String authurl;
  String chargeResponseMessage;
  int merchantbearsfee;
  int customerId;
  int merchantfee;
  String modalauditid;
  String currency;
  String narration;
  DateTime updatedAt;
  String paymentPlan;
  String paymentId;
  bool customercandosubsequentnoauth;
  String charge_type;
  String paymentType;
  String orderRef;
  String txRef;
  String flwRef;
  String raveRef;
  String user_token;
  String embed_token;

  String __status;
  String __message;

  final Map __result;

  RavepayResult(this.__result) {
    if (!isCancel && __result['payload'] != null) {
      __status = __result['payload']['status'];
      __message = __result['payload']['message'];
      final Map data = __result['payload']['data'];

      if (data != null) {
        id = int.tryParse(data["id"].toString());
        paymentPlan = data["paymentPlan"];
        updatedAt = DateTime.tryParse(data["updatedAt"]);
        narration = data["narration"];
        currency = data["currency"];
        modalauditid = data["modalauditid"];
        amount = double.tryParse(data["amount"].toString());
        charged_amount = double.tryParse(data["charged_amount"].toString());
        merchantfee = int.tryParse(data["merchantfee"].toString());
        customerId = int.tryParse(data["customerId"].toString());
        merchantbearsfee = int.tryParse(data["merchantbearsfee"].toString());
        chargeResponseMessage = data["chargeResponseMessage"];
        authurl = data["authurl"];
        paymentId = data["paymentId"];
        customercandosubsequentnoauth = data["customercandosubsequentnoauth"].toString() == "true";
        charge_type = data["charge_type"];
        paymentType = data["paymentType"];
        orderRef = data["orderRef"];
        txRef = data["txRef"];
        flwRef = data["flwRef"];
        raveRef = data["raveRef"];
        user_token = data["chargeToken"]["user_token"];
        embed_token = data["chargeToken"]["embed_token"];
      }
    }
  }

  get isSuccess => __result['status'] == "SUCCESS";
  get isError => __result['status'] == "ERROR";
  get isCancel => __result['status'] == "CANCELLED";

  getStatus() => __status;

  getMessage() => __message;

  toMap() => !isCancel ? __result['payload']['data'] : null;
}

class Ravepay {
  BuildContext context;
  const String _androidChannel = 'ng.i.handikraft/flutter_ravepay';
  const String _iosChannel = 'ng.i.handikraft/flutter_ravepay_local';

  Ravepay(this.context);

  Future<RavepayResult> chargeCard(RavepayConfig config) async {
    String _channelName = Theme.of(context).platform == TargetPlatform.iOS ? _iosChannel : _androidChannel;
    MethodChannel _channel = new MethodChannel(_channelName);
    Map result;
    try {
      result = await _channel.invokeMethod('chargeCard', config.toMap());
      // print(result);
    } on PlatformException {
      result = {"status": "CANCELLED"};
    }
    return new RavepayResult(result);
  }

  static of(BuildContext context) {
    return new Ravepay(context);
  }
}
