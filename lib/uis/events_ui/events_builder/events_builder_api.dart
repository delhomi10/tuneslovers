import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tunes_lovers/uis/events_ui/events_builder/events_builder.dart';

class EventsBuilderApi {
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshots(
      {required EventType eventType}) {
    if (eventType == EventType.trending) {
      // return FirebaseFirestore.instance
      //     .collection("Event")
      //     .where("isTrending", isEqualTo: true)
      //     .where("event.followers", )
      //     .orderBy("startDate", descending: true)
      //     .limit(15)
      //     .snapshots();

      return FirebaseFirestore.instance
          .collection("Event")
          .where("startDate", isGreaterThan: Timestamp.now())
          .orderBy("startDate", descending: true)
          .limit(15)
          .snapshots();
    } else if (eventType == EventType.recent) {
      return FirebaseFirestore.instance
          .collection("Event")
          .where("startDate", isLessThan: Timestamp.now())
          .where(
            "startDate",
            isGreaterThan: Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 25))),
          )
          .orderBy("startDate", descending: true)
          .limit(15)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection("Event")
          .where("startDate", isGreaterThan: Timestamp.now())
          .orderBy("startDate", descending: true)
          .limit(15)
          .snapshots();
    }
  }
}
