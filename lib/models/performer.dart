import 'package:tunes_lovers/models/social.dart';

class Performer {
  final String id;
  final String name;
  final String email;
  final String bio;
  final List<String> genre;
  final String country;
  final String avatarURL;
  final List<String>? images;
  final List<Social> socials;

  Performer({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.genre,
    required this.country,
    required this.avatarURL,
    required this.socials,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "bio": bio,
      "genre": genre.map((e) => e.toLowerCase().trim()).toList(),
      "country": country,
      "avatarURL": avatarURL,
      "images": images ?? [],
      "socials": socials.map((e) => e.toJson()).toList(),
    };
  }

  factory Performer.fromJson(dynamic jsonData) {
    return Performer(
      id: jsonData["id"] ?? "",
      email: jsonData["email"] ?? "",
      name: jsonData["name"] ?? "",
      bio: jsonData["bio"] ?? "",
      genre: List.from(jsonData["genre"])
          .map((e) =>
              e[0].toString().toUpperCase() + e.toString().replaceAll(e[0], ""))
          .toList(),
      country: jsonData["country"] ?? "",
      avatarURL: jsonData["avatarURL"] ?? "",
      socials: List.from(jsonData["socials"])
          .map((e) => Social.fromJson(e))
          .toList(),
      images:
          List.from(jsonData["images"] ?? []).map((e) => e.toString()).toList(),
    );
  }
}
