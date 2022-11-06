import 'dart:convert';

import 'package:tunes_lovers/secrets/api_secret.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PlaceApi {
  Future<Map<String, dynamic>> findPlaceFromText(String text) async {
    Uri url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$text&inputtype=textquery&&fields=formatted_address,name,geometry,place_id&key=${ApiSecret.googleMapApi}");
    http.Response response = await http.get(url);
    return {
      "formatted_address": List.from(json.decode(response.body)["candidates"])
          .first["formatted_address"],
      "place_id":
          List.from(json.decode(response.body)["candidates"]).first["place_id"],
      "latlng": List.from(json.decode(response.body)["candidates"])
          .first["geometry"]["location"],
    };
  }

  Future<LatLng> getALatLngFromText(String text) async {
    Uri url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$text&inputtype=textquery&&fields=formatted_address,name,geometry,place_id&key=${ApiSecret.googleMapApi}");
    http.Response response = await http.get(url);
    return LatLng(
        List.from(json.decode(response.body)["candidates"]).first["geometry"]
            ["location"]["lat"],
        List.from(json.decode(response.body)["candidates"]).first["geometry"]
            ["location"]["lng"]);
  }

  Future<Map<String, dynamic>> getAddressFromLatLng(LatLng latLng) async {
    Uri url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${ApiSecret.googleMapApi}");
    http.Response response = await http.get(url);
    return List.from(json.decode(response.body)["results"]).first;
  }

  Future<List<Map<String, dynamic>>> getAddressesFromLatLng(
      LatLng latLng) async {
    Uri url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&&fields=address_components,formatted_address,place_id,geometry&key=${ApiSecret.googleMapApi}");
    http.Response response = await http.get(url);
    return List.from(List.from(json.decode(response.body)["results"]).where(
        (element) =>
            List.from(element["types"]).contains("street_address") ||
            List.from(element["types"]).contains("premise")));
  }
}
