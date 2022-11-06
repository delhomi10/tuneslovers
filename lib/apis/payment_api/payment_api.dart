import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class PaymentApi {
  static String testPublishableKey =
      "pk_test_51LVmtIEdS45Wayf4ilqroTLyowvZfLq5k6SLQMaXqNOXzcbkLB1Vc7PiOkjCvXyv1rwuzqPKyfA3zV0SjWmlmyIW00lTeDD7Gx";
  static String testSecretKey =
      "sk_test_51LVmtIEdS45Wayf41KlK6CvUJkt1NdEbiSM7SAomiBxdkTSlTAAfQvgEvJlkrHGmvq7CiLJyLovGvjjlxHglOIFr00O3c7eHlR";

  Future<void> initPaymentSheet(
    BuildContext context, {
    required String email,
    required int amount,
    required String name,
    required String description,
    required String? city,
    required String? country,
    required String? line1,
    required String? line2,
    required String? postalCode,
    required String? state,
  }) async {
    try {
      Response response = await Client().post(
          Uri.parse(
              "https://us-central1-go-events-7.cloudfunctions.net/stripePaymentIntentRequest"),
          body: {
            "email": email.toLowerCase().trim(),
            "amount": amount.toString(),
            "description": description.trim(),
            "name": name.trim(),
            "city": city?.trim(),
            "country": city?.trim(),
            "line1": city?.trim(),
            "line2": city?.trim(),
            "postalCode": city?.trim(),
            "state": state?.trim(),
          });
      var jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse["paymentIntent"],
          merchantDisplayName: "Tunes Lovers",
          customerId: jsonResponse["customer"],
          customerEphemeralKeySecret: jsonResponse["ephemeralKey"],
          style: ThemeMode.system,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      Fluttertoast.showToast(msg: "Payment Completed");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> getCustomerDetail(String email) async {
    try {
      Response response = await Client().post(
          Uri.parse(
              "https://us-central1-go-events-7.cloudfunctions.net/retrieveCustomerDetail"),
          body: {
            "email": email.toLowerCase(),
          });
      var jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
