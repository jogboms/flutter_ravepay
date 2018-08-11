import UIKit
import Flutter
import Rave
import Alamofire

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, RavePaymentManagerDelegate {
    var _result: FlutterResult!
    var RAVEPAY_CHANNEL = "ng.i.handikraft/flutter_ravepay"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller = self.window.rootViewController
        let channel = FlutterMethodChannel(name: RAVEPAY_CHANNEL, binaryMessenger: controller as! FlutterBinaryMessenger);
        
        channel.setMethodCallHandler(handle)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("iOS => call \(call.method)")
        _result = result
        switch (call.method) {
        case "chargeCard":
            chargeCard(call)
        default:
            _result(FlutterMethodNotImplemented)
        }
    }
    
    public func chargeCard(_ call: FlutterMethodCall) {
        let config = RavePayConfig.sharedConfig()
        
        let options = call.arguments as! [String: Any]
        let amount = options["amount"] as! String
        let country = options["country"] as! String
        let currency = options["currency"] as! String
        let email = options["email"] as! String
        let isStaging = options["isStaging"]
        let meta = options["metadata"] as! [[String: String]]
        let narration = options["narration"] as! String
//        let useAccounts = options["useAccounts"] as! Bool
//        let useCards = options["useCards"] as! Bool
        let useSave = options["useSave"] as! Bool
        let txRef = options["txRef"] as! String
//        let style = options["style"] as! String
        let publicKey = options["publicKey"] as! String
        let secretKey = options["secretKey"] as! String
        
        config.publicKey = publicKey
        config.secretKey = secretKey
        config.isStaging = isStaging != nil ? isStaging as! Bool : true
        config.themeColor = UIColor.init(hex: "B456BF")
        config.buttonThemeColor = UIColor.init(hex: "FEC545")
        
        let raveMgr = RavePayManager()
        raveMgr.email = email
        raveMgr.amount = amount
        raveMgr.transcationRef = txRef
        raveMgr.country = country
        raveMgr.currencyCode = currency
        raveMgr.savedCardsAllow = useSave
        raveMgr.delegate = self
        raveMgr.narration = narration
        raveMgr.meta = meta
        raveMgr.supportedPaymentMethods = [.card]
        // raveMgr.supportedPaymentMethods = [.card,.account] // Choose supported payment channel allowed
        
        raveMgr.show(withController:self.window.rootViewController!)
    }
    
    func ravePaymentManagerDidCancel(_ ravePaymentManager: RavePayManager) {
        _result(["status": "CANCELLED", "payload": nil]);
    }
    
    func ravePaymentManager(_ ravePaymentManager: RavePayManager, didSucceedPaymentWithResult result: [String : AnyObject]) {
        let payload = result["payload"]!;
        let data = payload["data"] as! [String: AnyObject];
        let secret = RavePayConfig.sharedConfig().secretKey;
        let flwRef = data["flw_ref"]!;
        let isStaging = RavePayConfig.sharedConfig().isStaging;
        let url = isStaging ? "https://ravesandboxapi.flutterwave.com" : "https://api.ravepay.co";
        let  params = ["SECKEY": secret as Any, "flw_ref": flwRef] as! [String: String];
        
        Alamofire.request(url + "/flwv3-pug/getpaidx/api/verify", method: .post, parameters: params).responseJSON {
            (res) -> Void in
            
            if(res.result.isSuccess){
                let result = res.result.value as? Dictionary<String,AnyObject>;
                if let  status = result?["status"] as? String{
                    if (status == "success"){
                        self._result(["status": "SUCCESS", "payload": result!]);
                    }
                }
            } else{
//                KVNProgress.dismiss()
//                showMessageDialog("Error", message: "Something went wrong please try again.", image: nil, axis: .horizontal, viewController: self, handler: {
//                })
//                errorCallback( res.result.error!.localizedDescription)
            }
        }
    }
    
    func ravePaymentManager(_ ravePaymentManager: RavePayManager, didFailPaymentWithResult result: [String : AnyObject]) {
        _result(["status": "ERROR", "payload": result["payload"]!]);
    }
}

