import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String? sessionId;
  final int? amount;
  final String? customerId;
  final String? currency;
  final String? customerEmail;
  final String? customerName;
  final Timestamp? expiresAt;
  final String? mode;
  final String? paymentStatus;
  final String? sessionStatus;
  final String? sessionUrl;
  final String? firebaseUserId;
  final String? eventId;
  final String? priceId;
  final String? paymentIntentId;

  Session({
    this.sessionId,
    this.amount,
    this.customerId,
    this.currency,
    this.customerEmail,
    this.customerName,
    this.expiresAt,
    this.mode,
    this.paymentStatus,
    this.sessionStatus,
    this.sessionUrl,
    this.firebaseUserId,
    this.eventId,
    this.priceId,
    this.paymentIntentId,
  });

  factory Session.fronJSON(dynamic jsonData) {
    return Session(
      amount: jsonData["amount"],
      currency: jsonData["currency"],
      customerEmail: jsonData["customerEmail"],
      customerId: jsonData["customerId"],
      customerName: jsonData["customerName"],
      eventId: jsonData["eventId"],
      expiresAt:
          Timestamp.fromMillisecondsSinceEpoch(jsonData["expiresAt"] * 1000),
      firebaseUserId: jsonData["firebaseUserId"],
      mode: jsonData["mode"],
      paymentIntentId: jsonData["paymentIntentId"],
      paymentStatus: jsonData["paymentStatus"],
      priceId: jsonData["priceId"],
      sessionId: jsonData["sessionId"],
      sessionStatus: jsonData["sessionStatus"],
      sessionUrl: jsonData["url"],
    );
  }
}
