import 'dart:async';

import 'package:flutter/services.dart';

class FlutterRavepay {
  static const MethodChannel _channel = const MethodChannel('flutter_ravepay');

  static Future<Map<String, String>> chargeCard(Map<String, dynamic> chargeOptions) {
    return _channel.invokeMethod('chargeCard', chargeOptions);
  }
}
