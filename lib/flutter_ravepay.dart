import 'dart:async';

import 'package:flutter/services.dart';

class FlutterRavepayResult {
  final Map result;
  FlutterRavepayResult(this.result);

  get status => result['status'];
  get message => result['message'];

  toMap() {
    return result;
  }
}

class FlutterRavepay {
  static const MethodChannel _androidChannel = const MethodChannel('ng.i.handikraft/flutter_ravepay');
  static const MethodChannel _iosChannel = const MethodChannel('ng.i.handikraft/flutter_ravepay_local');

  static Future<FlutterRavepayResult> chargeCard(Map<String, dynamic> chargeOptions) async {
    MethodChannel _channel = TargetPlatform.iOS ? _iosChannel : _androidChannel;
    Map result = await _channel.invokeMethod('chargeCard', chargeOptions);
    return new FlutterRavepayResult(result);
  }
}
