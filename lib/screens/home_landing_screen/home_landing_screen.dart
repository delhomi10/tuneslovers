import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/screens/home_landing_screen/create_account_screen/create_account_screen.dart';
import 'package:tunes_lovers/screens/home_landing_screen/home_screen/home_screen.dart';

class HomeLandingScreen extends StatelessWidget {
  final User firebaseUser;
  const HomeLandingScreen({Key? key, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot?>(
        stream: FirebaseFirestore.instance
            .collection("Customer")
            .doc(firebaseUser.uid)
            .snapshots(),
        builder: (conterxt, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              key: key,
              child: CircularProgressIndicator(
                key: key,
              ),
            );
          } else if (!snapshot.data!.exists) {
            return CreateAccountScreen(
              firebaseUser: firebaseUser,
              key: key,
            );
          } else {
            return HomeScreen(
              key: key,
              person: Person.fromJson(snapshot.data!.data()),
            );
          }
        });
  }
}
