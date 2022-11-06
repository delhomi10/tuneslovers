import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/apis/auth_api.dart';
import 'package:tunes_lovers/screens/auth_screen/auth_screen.dart';
import 'package:tunes_lovers/screens/verify_screen/verify_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  static final AuthApi authApi = AuthApi();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authApi.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AuthScreen(key: key);
        } else {
          if (snapshot.data == null) {
            return AuthScreen(key: key);
          } else {
            return VerifyScreen(
              firebaseUser: snapshot.data!,
              key: key,
            );
          }
        }
      },
    );
  }
}
