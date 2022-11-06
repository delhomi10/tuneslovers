import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunes_lovers/models/stripe_models/price.dart';
import 'package:http/http.dart';

class Subscription {
  final String subscriptionId;
  final String customerId;
  final String invoiceId;
  final String paymentMethodId;
  final String priceId;
  final String productId;
  final String currency;
  final Timestamp startAt;
  final Timestamp endAt;
  final String status;
  final int amount;
  final String interval;
  final Timestamp createdAt;

  Subscription({
    required this.subscriptionId,
    required this.customerId,
    required this.invoiceId,
    required this.paymentMethodId,
    required this.priceId,
    required this.productId,
    required this.currency,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.amount,
    required this.interval,
    required this.createdAt,
  });

  Map<String, dynamic> get toMap => {
        "subscriptionId": subscriptionId,
        "customerId": customerId,
        "invoiceId": invoiceId,
        "paymentMethodId": paymentMethodId,
        "priceId": priceId,
        "productId": productId,
        "currency": currency,
        "status": status,
        "amount": amount,
        "interval": interval,
        "startAt": startAt,
        "endAt": endAt,
        "createdAt": createdAt,
      };

  factory Subscription.fromJSON(dynamic jsonData) {
    return Subscription(
      subscriptionId: jsonData["subscriptionId"],
      customerId: jsonData["customerId"],
      invoiceId: jsonData["invoiceId"],
      paymentMethodId: jsonData["paymentMethodId"],
      priceId: jsonData["priceId"],
      productId: jsonData["productId"],
      currency: jsonData["currency"],
      status: jsonData["status"],
      amount: jsonData["amount"],
      interval: jsonData["interval"],
      startAt: Timestamp.fromMillisecondsSinceEpoch(jsonData["startAt"] * 1000),
      endAt: Timestamp.fromMillisecondsSinceEpoch(jsonData["endAt"] * 1000),
      createdAt:
          Timestamp.fromMillisecondsSinceEpoch(jsonData["createdAt"] * 1000),
    );
  }

  static Future<Subscription?> fetchSubscription(
      {required String customerId}) async {
    try {
      Response response = await Client()
          .post(Uri.parse("http://10.0.2.2:8080/subscription/retrieve"), body: {
        "customerId": customerId,
      });

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse["data"] == null) return null;

      return Subscription.fromJSON(jsonResponse["data"]);
    } catch (e) {
      log("error: $e");
    }
    return null;
  }

  static Future<String?> createMonthlySubscriptionSession(
      {required String customerId, required String firebaseUserId}) async {
    try {
      Response response = await Client().post(
          (Uri.parse("http://10.0.2.2:8080/session/subscription/month")),
          body: {"customerId": customerId, firebaseUserId: "firebaseUserId"});

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse["data"]["url"];
    } catch (e) {
      log("error: $e");
    }
    return null;
  }

  static Future<String?> createYearlySubscriptionSession(
      {required String customerId, required String firebaseUserId}) async {
    try {
      Response response = await Client().post(
          (Uri.parse("http://10.0.2.2:8080/session/subscription/year")),
          body: {"customerId": customerId, firebaseUserId: "firebaseUserId"});

      var jsonResponse = jsonDecode(response.body);

      return jsonResponse["data"]["url"];
    } catch (e) {
      log("error: $e");
    }
    return null;
  }
}
