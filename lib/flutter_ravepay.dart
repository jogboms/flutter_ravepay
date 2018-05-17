import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  const MethodChannel _androidChannel = const MethodChannel('ng.i.handikraft/flutter_ravepay');
  const MethodChannel _iosChannel = const MethodChannel('ng.i.handikraft/flutter_ravepay_local');
  BuildContext context;

  FlutterRavepay(this.context);

  Future<FlutterRavepayResult> chargeCard(Map<String, dynamic> chargeOptions) async {
    MethodChannel _channel = Theme.of(context).platform == TargetPlatform.iOS ? _iosChannel : _androidChannel;
    Map result = await _channel.invokeMethod('chargeCard', chargeOptions);
    return new FlutterRavepayResult(result);
  }

  static of(BuildContext context) {
    return new FlutterRavepay(context);
  }
}
