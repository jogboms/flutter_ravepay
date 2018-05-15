package ng.i.handikraft.flutterravepay;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

// import org.json.JSONArray;
// import org.json.JSONException;
// import org.json.JSONObject;
// import android.util.Patterns;

import java.util.HashMap;
import java.util.Map;

// import android.app.Activity;
// import android.content.Intent;
// import android.util.Log;
// import android.net.Uri;

/**
 * FlutterRavepayPlugin
 */
public class FlutterRavepayPlugin implements MethodCallHandler {
  public static final String TAG = "FlutterRavePayPlugin";

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
