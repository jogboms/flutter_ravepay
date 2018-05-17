import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

class FlutterRavepayResult {
  final Map result;
  FlutterRavepayResult(this.result);

  get status => result['status'];
  get data => result['data'];

  get isSuccess => status == "SUCCESS";
  get isError => status == "ERROR";
  get isCancel => status == "CANCELLED";

  toMap() {
    return result;
  }
}

class FlutterRavepay {
  BuildContext context;
  const String _androidChannel = 'ng.i.handikraft/flutter_ravepay';
  const String _iosChannel = 'ng.i.handikraft/flutter_ravepay_local';

  FlutterRavepay(this.context);

  Future<FlutterRavepayResult> chargeCard(Map<String, dynamic> chargeOptions) async {
    String _channelName = Theme.of(context).platform == TargetPlatform.iOS ? _iosChannel : _androidChannel;
    MethodChannel _channel = const MethodChannel(_channelName);
    Map result = await _channel.invokeMethod('chargeCard', chargeOptions);
    // print(result);
    return new FlutterRavepayResult(result);
  }

  static of(BuildContext context) {
    return new FlutterRavepay(context);
  }
}
