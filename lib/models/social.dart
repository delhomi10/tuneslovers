import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Social {
  static const String facebook = "facebook";
  static const String instagram = "instagram";
  static const String twitter = "twitter";
  static const String snapchat = "snapchat";
  static const String spotify = "spotify";

  final String title;
  final String username;
  final IconData? iconData;

  Color get color => title == "facebook"
      ? Colors.blue
      : title == "instagram"
          ? Colors.pink
          : title == "twitter"
              ? Colors.blue.shade300
              : title == "snapchat"
                  ? Colors.yellow
                  : Colors.green;

  String get link {
    if (title == facebook) {
      return "https://facebook.com/$username";
    } else if (title == instagram) {
      return "https://instagram.com/$username";
    } else if (title == twitter) {
      return "https://twitter.com/$username";
    } else if (title == snapchat) {
      return "https://snapchat.com/$username";
    } else {
      return "https://spotify.com/$username";
    }
  }

  Social({
    required this.title,
    required this.username,
    this.iconData,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "username": username,
        "iconData": title,
      };

  factory Social.fromJson(dynamic jsonData) {
    return Social(
      title: jsonData["title"],
      username: jsonData["username"],
      iconData: jsonData["iconData"] == facebook
          ? FontAwesomeIcons.facebook
          : jsonData["iconData"] == instagram
              ? FontAwesomeIcons.instagram
              : jsonData["iconData"] == twitter
                  ? FontAwesomeIcons.twitter
                  : jsonData["iconData"] == snapchat
                      ? FontAwesomeIcons.snapchat
                      : FontAwesomeIcons.spotify,
    );
  }
}
