import 'dart:convert';

class BillingAddress {
  final String? city, country, line1, line2, postalCode, state;

  BillingAddress(
      {this.city,
      this.country,
      this.line1,
      this.line2,
      this.postalCode,
      this.state});

  Map<String, dynamic> get toJSON => {
        "city": city ?? '',
        "country": country ?? '',
        "line1": line1 ?? '',
        "line2": line2 ?? '',
        "postalCode": postalCode ?? '',
        "state": state ?? '',
      };
  factory BillingAddress.fromJSON(dynamic jsonData) {
    return BillingAddress(
      city: jsonData["city"] ?? "",
      country: jsonData["country"] ?? "",
      line1: jsonData["line1"] ?? "",
      line2: jsonData["line2"] ?? "",
      postalCode: jsonData["postalCode"] ?? "",
      state: jsonData["state"] ?? "",
    );
  }
}
