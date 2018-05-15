package ng.i.handikraft.flutterravepay;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

// import org.json.JSONArray;
// import org.json.JSONException;
// import org.json.JSONObject;
// import android.util.Patterns;

import java.util.HashMap;
import java.util.Map;

// import android.app.Activity;
import android.content.Intent;
import android.util.Log;
// import android.net.Uri;

import com.flutterwave.raveandroid.RavePayManager;
import com.flutterwave.raveandroid.RavePayActivity;
import com.flutterwave.raveandroid.RaveConstants;

/**
 * FlutterRavepayPlugin
 */
// public class FlutterRavepayPlugin implements
// PluginRegistry.ActivityResultListener, MethodCallHandler {
public class FlutterRavepayPlugin implements MethodCallHandler {
  public static final String TAG = "FlutterRavepayPlugin";
  private static final String CHANNEL_NAME = "ng.i.handikraft/flutter_ravepay";
  private static final String METHOD_CHARGE_CARD = "chargeCard";

  private final Registrar registrar;
  private Result pendingResult;

  private RavePayManager ravepayManager;

  private FlutterRavepayPlugin(Registrar registrar) {
    this.registrar = registrar;
    initialize();
    // chargeCard();
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final FlutterRavepayPlugin plugin = new FlutterRavepayPlugin(registrar);
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Log.d(TAG, call.method);
    if (call.method.equals("chargeCard")) {
      if (!(call.arguments instanceof Map)) {
        throw new IllegalArgumentException("Plugin not passing a map as parameter: " + call.arguments);
      }
      Map chargeParams = (Map<String, Object>) call.arguments;
      setPendingResult(call.method, result);
      chargeCard();
      // final HashMap<String, Object> res = new HashMap<String, Object>();
      // res.put("message", "SUCCESS ");
      // finishWithResult(res);
    } else {
      result.notImplemented();
    }
  }

  private void setPendingResult(String methodName, MethodChannel.Result result) {
    if (pendingResult != null) {
      result.error("ERROR", methodName + " called while another FlutterRavepay operation was in progress.", null);
    }

    pendingResult = result;
  }

  private void finishWithResult(Object result) {
    if (pendingResult != null) {
      pendingResult.success(result);
      pendingResult = null;
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    Log.d(TAG, "Result " + requestCode);
    final HashMap<String, Object> res = new HashMap<String, Object>();
    if (requestCode == RaveConstants.RAVE_REQUEST_CODE && data != null) {
      String message = data.getStringExtra("response");
      if (resultCode == RavePayActivity.RESULT_SUCCESS) {
        Log.d(TAG, "SUCCESS " + message);
        res.put("message", "SUCCESS " + message);
      } else if (resultCode == RavePayActivity.RESULT_ERROR) {
        Log.d(TAG, "ERROR " + message);
        res.put("message", "ERROR " + message);
      } else if (resultCode == RavePayActivity.RESULT_CANCELLED) {
        Log.d(TAG, "CANCELLED " + message);
        res.put("message", "CANCELLED " + message);
      }
      finishWithResult(res);
    }
    return false;
  }

  private RavePayManager initialize() {
    if (ravepayManager == null) {
      registrar.addActivityResultListener(this);
      ravepayManager = new RavePayManager(registrar.activity());
    }

    return ravepayManager;
  }

  public void chargeCard() {
    initialize();
    Log.d(TAG, "ravepayManager");

    ravepayManager.setAmount(3000.0).setCountry("NG").setCurrency("NGN").setEmail("o.jeremiah@rom-flex.com")
        // ravepayManager.setAmount(3000.0).setCountry("NG").setCurrency("NGN").setEmail("jeremiahogbomo@gmail.com")
        .setfName("Jeremiah").setlName("Ogbomo").setNarration("Test Narration")
        .setPublicKey("FLWPUBK-cd3500135be97b13a29c70e3ee233cbf-X")
        .setSecretKey("FLWSECK-6257675603889ba57c880eda2a936b46-X").setTxRef("vwexy-123456789")
        .acceptAccountPayments(false).acceptCardPayments(true).onStagingEnv(true).allowSaveCardFeature(true)
        // .withTheme(styleId)
        .initialize();
  }
}
