import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final LatLng? latLng;
  final String placeId;

  final String? county; //administrative_area_level_2
  final String formattedAddress;

  final String streetNumber;
  final String streetName; //route
  final String? line2; //route
  final String city; //locality

  final String state; //administrative_area_level_1
  final String country; //country
  final String postalCode; //postal_code

  Address(
      {this.latLng,
      this.county,
      required this.formattedAddress,
      required this.placeId,
      required this.streetNumber,
      required this.streetName,
      this.line2,
      required this.city,
      required this.state,
      required this.country,
      required this.postalCode});

  Map<String, dynamic> toJson() {
    return {
      "latlng": latLng!.toJson(),
      "county": county,
      "placeId": placeId,
      "formattedAddress": formattedAddress,
      "streetNumber": streetNumber,
      "streetName": streetName,
      "line2": line2 ?? "",
      "city": city,
      "state": state,
      "country": country,
      "postalCode": postalCode,
    };
  }

  String get text =>
      "$streetNumber $streetName, $city, $state $postalCode, $country";

  factory Address.fromJson(dynamic jsonData) {
    return Address(
      formattedAddress: jsonData["formattedAddress"] ?? "",
      latLng: LatLng.fromJson(jsonData["latlng"]),
      county: jsonData["county"],
      line2: jsonData["line2"] ?? "",
      placeId: jsonData["placeId"],
      streetNumber: jsonData["streetNumber"],
      streetName: jsonData["streetName"],
      city: jsonData["city"],
      country: jsonData["country"],
      postalCode: jsonData["postalCode"],
      state: jsonData["state"],
    );
  }

  factory Address.fromGoogleMapApi(dynamic jsonData) {
    print(List.from(jsonData["address_components"]).firstWhere((element) =>
        List.from(element["types"]).contains("administrative_area_level_2")));

    return Address(
      placeId: jsonData["place_id"],
      formattedAddress: jsonData["formatted_address"],
      latLng: LatLng(jsonData["geometry"]["location"]["lat"],
          jsonData["geometry"]["location"]["lng"]),
      county: List.from(jsonData["address_components"]).firstWhere((element) =>
                  List.from(element["types"])
                      .contains("administrative_area_level_2")) ==
              null
          ? ""
          : List.from(jsonData["address_components"]).firstWhere((element) =>
              List.from(element["types"])
                  .contains("administrative_area_level_2"))["long_name"],
      streetNumber: List.from(jsonData["address_components"]).firstWhere(
                  (element) =>
                      List.from(element["types"]).contains("street_number")) ==
              null
          ? ""
          : List.from(jsonData["address_components"]).firstWhere((element) =>
              List.from(element["types"])
                  .contains("street_number"))["long_name"],
      streetName: List.from(jsonData["address_components"]).firstWhere(
                  (element) => List.from(element["types"]).contains("route")) ==
              null
          ? ""
          : List.from(jsonData["address_components"]).firstWhere((element) =>
              List.from(element["types"]).contains("route"))["long_name"],
      city: List.from(jsonData["address_components"]).firstWhere((element) =>
                  List.from(element["types"]).contains("locality")) ==
              null
          ? ""
          : List.from(jsonData["address_components"]).firstWhere((element) =>
              List.from(element["types"]).contains("locality"))["long_name"],
      state: List.from(jsonData["address_components"]).firstWhere((element) =>
                  List.from(element["types"])
                      .contains("administrative_area_level_1")) ==
              null
          ? ""
          : List.from(jsonData["address_components"]).firstWhere((element) =>
              List.from(element["types"])
                  .contains("administrative_area_level_1"))["long_name"],
      country: List.from(jsonData["address_components"]).firstWhere((element) =>
                  List.from(element["types"]).contains("country")) ==
              null
          ? ""
          : List.from(jsonData["address_components"]).firstWhere((element) =>
              List.from(element["types"]).contains("country"))["long_name"],
      postalCode: List.from(jsonData["address_components"]).firstWhere(
                  (element) =>
                      List.from(element["types"]).contains("postal_code")) ==
              null
          ? ""
          : List.from(jsonData["address_components"]).firstWhere((element) =>
              List.from(element["types"]).contains("postal_code"))["long_name"],

              line2: ""
    );
  }
}
