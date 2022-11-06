import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunes_lovers/models/stripe_models/billing_address.dart';

class Charge {
  final String? chargeId;
  final String? customerId;
  final int? amount;
  final BillingAddress? billingAddress;
  final String? chargeStatus;
  final String? currency;
  final String? paymentIntentId;
  final String? paymentmethodId;
  final String? receiptUrl;
  final String? transactionId;
  final bool? refunded;
  final Timestamp? createdAt;

  Charge({
    this.chargeId,
    this.customerId,
    this.amount,
    this.billingAddress,
    this.chargeStatus,
    this.currency,
    this.paymentIntentId,
    this.paymentmethodId,
    this.receiptUrl,
    this.transactionId,
    this.refunded,
    this.createdAt,
  });

  Map<String, dynamic> get toJSON => {
        "chargeId": chargeId ?? "",
        "customerId": customerId ?? "",
        "amount": amount ?? 0,
        "billingAddress": billingAddress?.toJSON,
        "chargeStatus": chargeStatus ?? "",
        "currency": currency ?? "",
        "paymentIntentId": paymentIntentId ?? "",
        "paymentmethodId": paymentmethodId ?? "",
        "receiptUrl": receiptUrl ?? "",
        "transactionId": transactionId ?? "",
        "refunded": refunded ?? false,
        "createdAt": createdAt ?? Timestamp.now(),
      };

  factory Charge.fromJSON(dynamic jsonData) {
    return Charge(
      amount: jsonData["amount"] ?? 0,
      billingAddress: BillingAddress.fromJSON(jsonData["billingAddress"]),
      chargeId: jsonData["chargeId"] ?? "",
      chargeStatus: jsonData["chargeStatus"] ?? "",
      currency: jsonData["currency"] ?? "",
      customerId: jsonData["customerId"] ?? "",
      paymentIntentId: jsonData["paymentIntentId"] ?? "",
      paymentmethodId: jsonData["paymentmethodId"] ?? "",
      receiptUrl: jsonData["receiptUrl"] ?? "",
      refunded: jsonData["refunded"] ?? false,
      transactionId: jsonData["transactionId"] ?? "",
      createdAt:
          Timestamp.fromMillisecondsSinceEpoch(jsonData["createdAt"] * 1000),
    );
  }
}
