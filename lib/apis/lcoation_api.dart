import 'package:geolocator/geolocator.dart';
import 'package:tunes_lovers/apis/map_apis/place_api.dart';
import 'package:tunes_lovers/models/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationApi {
  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    return LatLng(position.latitude, position.longitude);
  }

  Future<List<Address>> getAddresesFromLatLng(LatLng latLng) async {
    List<Map<String, dynamic>> results =
        await PlaceApi().getAddressesFromLatLng(latLng);
    return results.map((e) => Address.fromGoogleMapApi(e)).toList();
  }

  Future<Address> getAddressFromLatLng(LatLng latLng) async {
    Map<String, dynamic> result = await PlaceApi().getAddressFromLatLng(latLng);
    return Address.fromGoogleMapApi(result);
  }

  Future<List<Address>> getAddresesFromText(String text) async {
    LatLng latLng = await PlaceApi().getALatLngFromText(text);
    print(latLng.toJson());
    List<Map<String, dynamic>> results =
        await PlaceApi().getAddressesFromLatLng(latLng);

    // results.forEach((element) {
    //   print(element["place_id"]);
    // });
    return results.map((e) => Address.fromGoogleMapApi(e)).toList();
  }

  Future<Map<String, dynamic>> getFormattedAddress(String text) async {
    Map<String, dynamic> result = await PlaceApi().findPlaceFromText(text);
    return result;
  }
}
