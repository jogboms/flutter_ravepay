package ng.i.handikraft.flutterravepay;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterRavepayPlugin
 */
public class FlutterRavepayPlugin implements MethodCallHandler {
  public static final String TAG = "FlutterRavePayPlugin";
  private Map chargeOptions;

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_ravepay");
    channel.setMethodCallHandler(new FlutterRavepayPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("chargeCard")) {
      if (!(call.arguments instanceof Map)) {
        throw new IllegalArgumentException("Plugin not passing a map as parameter: " + call.arguments);
      }
      Map chargeParams = (Map<String, Object>) call.arguments;
      Map res = new HashMap<String, Object>();
      res.put("message", "Android Works");
      result.success(res);
    } else {
      result.notImplemented();
    }
  }
}
