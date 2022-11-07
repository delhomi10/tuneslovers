import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String content;
  final bool isEdited;
  final Map<String, dynamic> likes;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.isEdited,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> get toMap => {
        "id": id,
        "userId": userId,
        "content": content,
        "isEdited": isEdited,
        "likes": likes,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  factory Comment.fromJson(dynamic jsonData) {
    return Comment(
      id: jsonData["id"],
      userId: jsonData["userId"],
      content: jsonData["content"],
      isEdited: jsonData["isEdited"],
      likes: jsonData["likes"],
      createdAt: jsonData["createdAt"],
      updatedAt: jsonData["updatedAt"],
    );
  }
}
