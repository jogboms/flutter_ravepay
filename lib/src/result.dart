import 'package:flutter_ravepay/src/card.dart';

class RavepayResult {
  int id;
  int merchantId;
  int customerId;
  int isLive;
  double amount;
  double appfee;
  double merchantfee;
  double chargedAmount;
  double merchantbearsfee;
  String txRef;
  String flwRef;
  String orderRef;
  String raveRef;
  String transactionCurrency;
  String paymentEntity;
  String paymentId;
  String chargeType;
  String fraudStatus;
  String narration;
  DateTime createdAt;
  DateTime updatedAt;
  RavepayCard card;

  String ___status;
  String __status;
  String __message;

  final Map __payload;

  RavepayResult(this.___status, this.__payload) {
    if (!isCancel && __payload != null) {
      __status = __payload['status'];
      __message = __payload['message'];
      final Map data = __payload['data'];

      if (data != null) {
        id = int.tryParse(data["id"].toString());
        amount = double.tryParse(data["amount"].toString());
        orderRef = data["order_ref"];
        raveRef = data["rave_ref"];
        isLive = int.tryParse(data["id"].toString());
        appfee = double.tryParse(data["appfee"].toString());
        merchantfee = double.tryParse(data["merchantfee"].toString());
        chargedAmount = double.tryParse(data["charged_amount"].toString());
        merchantbearsfee = double.tryParse(data["merchant_id"].toString());
        merchantId = int.tryParse(data["merchantbearsfee"].toString());
        customerId = int.tryParse(data["customer.id"].toString());
        transactionCurrency = data["transaction_currency"];
        paymentEntity = data["payment_entity"];
        paymentId = data["payment_id"];
        chargeType = data["charge_type"];
        fraudStatus = data["fraud_status"];
        narration = data["narration"];
        createdAt = DateTime.tryParse(data["createdAt"]);
        updatedAt = DateTime.tryParse(data["updatedAt"]);
        txRef = data["tx_ref"];
        flwRef = data["flw_ref"];
        card = data["card"] != null ? RavepayCard.fromMap(data["card"]) : null;
      }
    }
  }

  bool get isSuccess => ___status == "SUCCESS";
  bool get isError => ___status == "ERROR";
  bool get isCancel => ___status == "CANCELLED";

  String getStatus() => __status;

  String getMessage() => __message;

  Map<String, dynamic> toMap() {
    if (isCancel) {
      return null;
    }
    return <String, dynamic>{
      "id": id.toString(),
      "amount": amount.toString(),
      "orderRef": orderRef,
      "raveRef": raveRef,
      "isLive": id.toString(),
      "appfee": appfee.toString(),
      "merchantfee": merchantfee.toString(),
      "chargedAmount": chargedAmount.toString(),
      "merchantbearsfee": merchantId.toString(),
      "merchantId": merchantbearsfee.toString(),
      "customerId": customerId.toString(),
      "transactionCurrency": transactionCurrency,
      "paymentEntity": paymentEntity,
      "paymentId": paymentId,
      "chargeType": chargeType,
      "fraudStatus": fraudStatus,
      "narration": narration,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
      "txRef": txRef,
      "flwRef": flwRef,
      "card": card.toMap(),
    };
  }

  /// Response as it is from Ravepay
  Map<String, dynamic> raw() {
    return !isCancel ? __payload['data'] : null;
  }
}
