import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunes_lovers/models/address.dart';

class Feed {
  final String id;
  final String title;
  final List<String> content;
  final String coverImage;
  final List<String> images;
  final Map<String, dynamic> likes;
  final List<String> genres;
  final List<String> performers;
  final Address address;
  final Timestamp createdAt;

  Feed({
    required this.id,
    required this.coverImage,
    required this.images,
    required this.title,
    required this.content,
    required this.likes,
    required this.genres,
    required this.performers,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> get toMap => {
        "id": id,
        "coverImage": coverImage,
        "images": images,
        "content": content,
        "title": title,
        "likes": likes,
        "genres": genres,
        "performers": performers,
        "address": address.toJson(),
        "createdAt": createdAt,
      };

  factory Feed.fromJson(dynamic jsonData) {
    return Feed(
      createdAt: jsonData["createdAt"],
      address: Address.fromJson(jsonData["address"]),
      id: jsonData["id"],
      coverImage: jsonData["coverImage"],
      images: List.from(jsonData["images"]).map((e) => e.toString()).toList(),
      title: jsonData["title"],
      content: List.from(jsonData["content"]).map((e) => e.toString()).toList(),
      likes: jsonData["likes"],
      genres: List.from(jsonData["genres"]).map((e) => e.toString()).toList(),
      performers:
          List.from(jsonData["performers"]).map((e) => e.toString()).toList(),
    );
  }
}
