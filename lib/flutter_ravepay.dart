import 'dart:async';

import 'package:flutter/services.dart';

class FlutterRavepayResult {
  final Map result;
  FlutterRavepayResult(this.result);

  get message => result['message'];

  toMap() {
    return result;
  }
}

class FlutterRavepay {
  static const MethodChannel _channel = const MethodChannel('ng.i.handikraft/flutter_ravepay');

  static Future<FlutterRavepayResult> chargeCard(Map<String, dynamic> chargeOptions) async {
    Map result = await _channel.invokeMethod('chargeCard', chargeOptions);
    return new FlutterRavepayResult(result);
  }
}
