import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

class RavepayMeta {
  final String metaname;
  final String metavalue;

  RavepayMeta(this.metaname, this.metavalue);

  toMap() {
    return {
      "metaname": metaname,
      "metavalue": metavalue,
    };
  }
}

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
  final List<RavepayMeta> metadata;

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
    this.metadata,
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
      "metadata": metadata != null ? metadata.map((meta) => meta.toMap()).toList() : [],
      "useCards": useCards,
      "isStaging": isStaging,
      "useSave": useSave,
      "style": style,
    };
  }
}

List<Map<dynamic, dynamic>> _parseTokenList(List<dynamic> tokens) {
  if (tokens == null) return [];

  return new List.from(tokens.map((token) => Map.from(token)));
}

class RavepayCard {
  String expirymonth;
  String expiryyear;
  String cardBIN;
  String last4digits;
  String brand;
  List<Map<dynamic, dynamic>> card_tokens;
  String life_time_token;

  RavepayCard({
    this.expirymonth,
    this.expiryyear,
    this.cardBIN,
    this.last4digits,
    this.brand,
    this.card_tokens,
    this.life_time_token,
  });

  factory RavepayCard.fromMap(Map map) {
    return new RavepayCard(
      expirymonth: map["expirymonth"],
      expiryyear: map["expiryyear"],
      cardBIN: map["cardBIN"],
      last4digits: map["last4digits"],
      brand: map["brand"],
      card_tokens: _parseTokenList(map["card_tokens"]),
      life_time_token: map["life_time_token"],
    );
  }
}

class RavepayResult {
  int id;
  int merchant_id;
  int customer_id;
  int is_live;
  double amount;
  double appfee;
  double merchantfee;
  double charged_amount;
  double merchantbearsfee;
  String tx_ref;
  String flw_ref;
  String order_ref;
  String rave_ref;
  String transaction_currency;
  String payment_entity;
  String payment_id;
  String charge_type;
  String fraud_status;
  String narration;
  DateTime createdAt;
  DateTime updatedAt;
  RavepayCard card;

  String __status__;
  String __status;
  String __message;

  final Map __payload;

  RavepayResult(this.__status__, this.__payload) {
    if (!isCancel && __payload != null) {
      __status = __payload['status'];
      __message = __payload['message'];
      final Map data = __payload['data'];

      if (data != null) {
        id = int.tryParse(data["id"].toString());
        amount = double.tryParse(data["amount"].toString());
        order_ref = data["order_ref"];
        rave_ref = data["rave_ref"];
        is_live = int.tryParse(data["id"].toString());
        appfee = double.tryParse(data["appfee"].toString());
        merchantfee = double.tryParse(data["merchantfee"].toString());
        charged_amount = double.tryParse(data["charged_amount"].toString());
        merchantbearsfee = double.tryParse(data["merchant_id"].toString());
        merchant_id = int.tryParse(data["merchantbearsfee"].toString());
        customer_id = int.tryParse(data["customer.id"].toString());
        transaction_currency = data["transaction_currency"];
        payment_entity = data["payment_entity"];
        payment_id = data["payment_id"];
        charge_type = data["charge_type"];
        fraud_status = data["fraud_status"];
        narration = data["narration"];
        createdAt = DateTime.tryParse(data["createdAt"]);
        updatedAt = DateTime.tryParse(data["updatedAt"]);
        tx_ref = data["tx_ref"];
        flw_ref = data["flw_ref"];
        card = data["card"] != null ? RavepayCard.fromMap(data["card"]) : null;
      }
    }
  }

  get isSuccess => __status__ == "SUCCESS";
  get isError => __status__ == "ERROR";
  get isCancel => __status__ == "CANCELLED";

  getStatus() => __status;

  getMessage() => __message;

  toMap() => !isCancel ? __payload['payload']['data'] : null;
}

class Ravepay {
  BuildContext context;
  const String _androidChannel = 'ng.i.handikraft/flutter_ravepay';
  const String _iosChannel = 'ng.i.handikraft/flutter_ravepay_local';

  Ravepay(this.context);

  Future<RavepayResult> chargeCard(RavepayConfig config) async {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    String _channelName = isIos ? _iosChannel : _androidChannel;
    MethodChannel _channel = new MethodChannel(_channelName);
    Map result;
    try {
      result = await _channel.invokeMethod('chargeCard', config.toMap());
      // print(result);
    } on PlatformException {
      result = {"status": "CANCELLED"};
    }
    return new RavepayResult(
      result["status"],
      result["payload"] != null ? (isIos ? result["payload"] : json.decode(result["payload"])) : null,
    );
  }

  static of(BuildContext context) {
    return new Ravepay(context);
  }
}
