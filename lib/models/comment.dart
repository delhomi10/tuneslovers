import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Comment {
  final String authorId;
  final String content;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Comment({
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> get toMap => {
        "authorId": authorId,
        "content": content,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  factory Comment.fromJson(dynamic jsonData) {
    return Comment(
      authorId: jsonData["authorId"],
      content: jsonData["content"],
      createdAt: jsonData["createdAt"],
      updatedAt: jsonData["updatedAt"],
    );
  }
}
