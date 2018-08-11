library flutter_ravepay;

import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ravepay/src/config.dart';
import 'package:flutter_ravepay/src/result.dart';

export 'src/card.dart';
export 'src/config.dart';
export 'src/meta.dart';
export 'src/result.dart';

class Ravepay {
  BuildContext context;
  final String _channelName = 'ng.i.handikraft/flutter_ravepay';

  Ravepay(this.context);

  Future<RavepayResult> chargeCard(RavepayConfig config) async {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final MethodChannel _channel = new MethodChannel(_channelName);
    Map result;
    try {
      result = await _channel.invokeMethod('chargeCard', config.toMap());
      // print(result);
    } on PlatformException {
      result = <String, String>{"status": "CANCELLED"};
    }
    return new RavepayResult(
      result["status"],
      result["payload"] != null
          ? (isIos ? result["payload"] : json.decode(result["payload"]))
          : null,
    );
  }

  static Ravepay of(BuildContext context) {
    return new Ravepay(context);
  }
}
