import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunes_lovers/models/address.dart';
import 'package:tunes_lovers/models/social.dart';

class Person {
  final String? customerId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String userId;
  final String email;
  final bool isVerified;
  final String phone;
  final String? avatarURL;
  final Timestamp? dateOfBirth;
  final List<Social>? socials;
  final Address? address;
  final int accessLevel;

  Person(
      {this.customerId,
      required this.firstName,
      this.middleName,
      required this.lastName,
      required this.isVerified,
      required this.userId,
      required this.email,
      required this.phone,
      this.avatarURL,
      required this.accessLevel,
      this.address,
      this.dateOfBirth,
      this.socials});

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId ?? "",
      "userId": userId,
      "email": email,
      "phone": phone,
      "isVerified": isVerified,
      "firstName": firstName,
      "middleName": middleName ?? "",
      "lastName": lastName,
      "avatarURL": avatarURL ?? "",
      "dateOfBirth": dateOfBirth,
      "accessLevel": accessLevel,
      "address": address!.toJson(),
      "socials": socials!.map((e) => e.toJson()).toList(),
    };
  }

  factory Person.fromJson(dynamic jsonData) {
    return Person(
      customerId: jsonData["customerId"],
      firstName: jsonData["firstName"],
      middleName: jsonData["middleName"],
      lastName: jsonData["lastName"],
      userId: jsonData["userId"],
      email: jsonData["email"],
      isVerified: jsonData["isVerified"],
      phone: jsonData["phone"],
      avatarURL: jsonData["avatarURL"],
      accessLevel: jsonData["accessLevel"],
      dateOfBirth: jsonData["dateOfBirth"],
      address: Address.fromJson(jsonData["address"]),
      socials: jsonData["socials"] == null
          ? []
          : List.from(jsonData["socials"])
              .map((e) => Social.fromJson(e))
              .toList(),
    );
  }
}
