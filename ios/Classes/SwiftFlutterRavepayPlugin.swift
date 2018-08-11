import Flutter
import UIKit

public class SwiftFlutterRavepayPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ng.i.handikraft/null", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterRavepayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(["message": "I Love flutter"]);
  }
}
