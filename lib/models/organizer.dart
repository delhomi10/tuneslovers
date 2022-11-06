import 'package:tunes_lovers/models/address.dart';
import 'package:tunes_lovers/models/social.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Organizer {
  final String id;
  final String name;
  final String bio;
  final String email;
  final String phone;
  final Address? address;
  final List<Social>? socials;

  Organizer({
    required this.id,
    required this.name,
    required this.bio,
    required this.email,
    required this.phone,
    required this.address,
    required this.socials,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "bio": bio,
      "email": email,
      "phone": phone,
      "address": address!.toJson(),
      "socials": socials == null ? [] : socials!.map((e) => e.toJson()).toList()
    };
  }

  factory Organizer.fromJson(dynamic jsonData) {
    return Organizer(
      id: jsonData["id"],
      name: jsonData["name"],
      bio: jsonData["bio"],
      email: jsonData["email"],
      phone: jsonData["phone"],
      address: Address.fromJson(jsonData["address"]),
      socials: jsonData["socials"] == null
          ? []
          : List.from(jsonData["socials"])
              .map((e) => Social.fromJson(e))
              .toList(),
    );
  }

  static Organizer organizer = Organizer(
    id: "1",
    name: "Organizer",
    bio: "This is a organizer",
    email: "organizer.gmail.com",
    phone: "+1 (333) 444 5555",
    address: Address(
        formattedAddress: "formattedAddress",
        placeId: "placeId",
        streetNumber: "streetNumber",
        streetName: "streetName",
        city: "city",
        state: "state",
        country: "country",
        postalCode: "postalCode",
        county: "",
        latLng: const LatLng(0.00, 0.00)),
    socials: [],
  );
}
