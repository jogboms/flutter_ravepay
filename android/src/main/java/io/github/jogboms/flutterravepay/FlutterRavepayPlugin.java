package io.github.jogboms.flutterravepay;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import android.content.Intent;
import android.util.Log;

import com.flutterwave.raveandroid.RavePayManager;
import com.flutterwave.raveandroid.RavePayActivity;
import com.flutterwave.raveandroid.RaveConstants;
import com.flutterwave.raveandroid.Meta;

/**
 * FlutterRavepayPlugin
 */
public class FlutterRavepayPlugin implements PluginRegistry.ActivityResultListener, MethodCallHandler {
  public static final String TAG = "FlutterRavepayPlugin";
  private static final String CHANNEL_NAME = "ng.i.handikraft/flutter_ravepay";
  private static final String METHOD_CHARGE_CARD = "chargeCard";

  private final Registrar registrar;
  private Result pendingResult;

  private RavePayManager ravepayManager;
  private Map<String, Object> chargeParams;

  private FlutterRavepayPlugin(Registrar registrar) {
    this.registrar = registrar;
    initialize();
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
      chargeParams = (Map<String, Object>) call.arguments;
      setPendingResult(call.method, result);
      chargeCard();
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

  private void finishWithResult(HashMap<String, Object> result) {
    if (pendingResult != null) {
      pendingResult.success(result);
      pendingResult = null;
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    Log.d(TAG, "Result " + data);
    final HashMap<String, Object> res = new HashMap<String, Object>();
    if (requestCode == RaveConstants.RAVE_REQUEST_CODE && data != null) {
      String message = data.getStringExtra("response");
      if (resultCode == RavePayActivity.RESULT_SUCCESS) {
        Log.d(TAG, "SUCCESS " + message);
        res.put("status", "SUCCESS");
      } else if (resultCode == RavePayActivity.RESULT_ERROR) {
        Log.d(TAG, "ERROR " + message);
        res.put("status", "ERROR");
      } else if (resultCode == RavePayActivity.RESULT_CANCELLED) {
        Log.d(TAG, "CANCELLED " + message);
        res.put("status", "CANCELLED");
      }
      res.put("payload", message);
      finishWithResult(res);
      return true;
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
    ravepayManager.setAmount(Double.parseDouble((String) chargeParams.get("amount")));
    ravepayManager.setCountry((String) chargeParams.get("country"));
    ravepayManager.setCurrency((String) chargeParams.get("currency"));
    ravepayManager.setEmail((String) chargeParams.get("email"));

    ravepayManager.setfName((String) chargeParams.get("firstname"));
    ravepayManager.setlName((String) chargeParams.get("lastname"));
    ravepayManager.setNarration((String) chargeParams.get("narration"));

    ravepayManager.setPublicKey((String) chargeParams.get("publicKey"));

    ravepayManager.setSecretKey((String) chargeParams.get("secretKey"));
    ravepayManager.setTxRef((String) chargeParams.get("txRef"));

    List<Meta> metaList = new ArrayList<Meta>();
    for(Map meta: (List<Map>) chargeParams.get("metadata")){
      metaList.add(new Meta((String) meta.get("metaname"), (String) meta.get("metavalue")));
    }

    ravepayManager.setMeta(metaList);
    // ravepayManager.setMeta((List<Meta>) (List) chargeParams.get("metadata"));
    ravepayManager.acceptAccountPayments((boolean) chargeParams.get("useAccounts"));
    ravepayManager.acceptCardPayments((boolean) chargeParams.get("useCards"));
    ravepayManager.onStagingEnv((boolean) chargeParams.get("isStaging"));
    ravepayManager.allowSaveCardFeature((boolean) chargeParams.get("useSave"));

    boolean hasTheme = hasStringKey("style");
    if (hasTheme) {
      ravepayManager.withTheme((int) chargeParams.get("style"));
    }

    ravepayManager.initialize();
  }

  private boolean isEmpty(String s) {
    return s == null || s.length() < 1;
  }

  private boolean hasStringKey(String key) {
    return chargeParams.containsKey(key) && !isEmpty((String) chargeParams.get(key));
  }
}
