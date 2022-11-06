import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunes_lovers/services/global_services/global_services.dart';
import 'package:http/http.dart';

class Price {
  final String priceId;
  final bool active;
  final String currency;
  final Timestamp createdAt;
  final int amount;
  final String productId;
  final String type;

  Price({
    required this.createdAt,
    required this.amount,
    required this.priceId,
    required this.active,
    required this.currency,
    required this.productId,
    required this.type,
  });

  factory Price.fromJSON(dynamic jsonData) {
    return Price(
      createdAt:
          Timestamp.fromMillisecondsSinceEpoch(jsonData["createdAt"] * 1000),
      amount: jsonData["amount"],
      priceId: jsonData["priceId"],
      active: jsonData["active"],
      currency: jsonData["currency"],
      productId: jsonData["productId"],
      type: jsonData["type"],
    );
  }

  static Future<Price?> createPrice(
      {required int amount, required String eventId}) async {
    try {
      Response response = await Client()
          .post((Uri.parse("${GlobalServices.baseUrl}/price/create")), body: {
        "amount": amount.toString(),
        "eventId": eventId,
      });
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["data"] == null) return null;
      return Price.fromJSON(jsonResponse["data"]);
    } catch (e) {
      log("error: $e");
    }
    return null;
  }

  static Future<Price?> fetchPrice(String priceId) async {
    try {
      Response response = await Client().post(
          (Uri.parse(
              "https://us-central1-go-events-7.cloudfunctions.net/fetchPrice")),
          body: {"priceId": priceId});
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse["price"] == null) return null;
      return Price.fromJSON(jsonResponse["price"]);
    } catch (e) {
      log("error: $e");
    }
    return null;
  }

  static Future<String?> createPaymentSession(
      {required String priceId,
      required String customerId,
      required String eventId,
      required String firebaseUserId}) async {
    try {
      Response response = await Client()
          .post((Uri.parse("${GlobalServices.baseUrl}/session/create")), body: {
        "priceId": priceId,
        "customerId": customerId,
        "eventId": eventId,
        "firebaseUserId": firebaseUserId
      });

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse["data"] == null) return null;
      return jsonResponse["data"]["url"];
    } catch (e) {
      log("error: $e");
    }
    return null;
  }

  static Future<void> refund({
    required String priceId,
    required String customerId,
    required String eventId,
    required String firebaseUserId,
    required String paymentIntentId,
  }) async {
    try {
      Response response = await Client()
          .post((Uri.parse("${GlobalServices.baseUrl}/charge/refund")), body: {
        "priceId": priceId,
        "customerId": customerId,
        "eventId": eventId,
        "firebaseUserId": firebaseUserId,
        "paymentIntentId": paymentIntentId,
      });

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
    } catch (e) {
      log("error: $e");
    }
  }
}
