import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunes_lovers/models/address.dart';
import 'package:tunes_lovers/models/organizer.dart';
import 'package:tunes_lovers/models/stripe_models/price.dart';

class Event {
  final String id;
  final String title;
  final String detail;
  final List<String> performers;
  final Address? address;
  final int capacity;
  final int space;
  final Price? price;
  final String coverImage;
  final Organizer organizer;
  final Timestamp startDate;
  final Timestamp endDate;

  Event({
    required this.id,
    required this.title,
    required this.detail,
    required this.performers,
    required this.space,
    required this.address,
    required this.coverImage,
    this.price,
    required this.capacity,
    required this.startDate,
    required this.endDate,
    required this.organizer,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "detail": detail,
      "capacity": capacity,
      "coverImage": coverImage,
      "space": space,
      "address": address!.toJson(),
      "startDate": startDate,
      "endDate": endDate,
      "organizer": organizer.toJson(),
      "performers": performers,
    };
  }

  factory Event.fromJson(dynamic jsonData) {
    return Event(
      coverImage: jsonData["coverImage"] ?? "",
      id: jsonData["id"],
      price: Price.fromJSON(jsonData["price"]),
      title: jsonData["title"],
      detail: jsonData["detail"],
      capacity: jsonData["capacity"],
      space: jsonData["space"],
      organizer:
          Organizer.fromJson(Map<String, dynamic>.from(jsonData["organizer"])),
      address: Address.fromJson(jsonData["address"]),
      startDate: jsonData["startDate"],
      endDate: jsonData["endDate"],
      performers: List<String>.from(jsonData["performers"]),
    );
  }
}
