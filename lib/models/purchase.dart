import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  final String purcahseId;
  final Timestamp createdAt;
  final String userId;
  final String eventId;

  Purchase({
    required this.purcahseId,
    required this.createdAt,
    required this.userId,
    required this.eventId,
  });

  Map<String, dynamic> get toMap => {
        "purchaseId": purcahseId,
        "createdAt": createdAt,
        "userId": userId,
        "eventId": eventId,
      };

  factory Purchase.fromJSON(dynamic jsonData) => Purchase(
        purcahseId: jsonData["purchaseId"],
        createdAt: jsonData["createdAt"],
        userId: jsonData["userId"],
        eventId: jsonData["eventId"],
      );
}
