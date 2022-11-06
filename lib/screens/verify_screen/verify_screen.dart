import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/apis/auth_api.dart';
import 'package:tunes_lovers/custom_widgets/error_dialog/error_dialog.dart';
import 'package:tunes_lovers/custom_widgets/success_dialog/success_dialog.dart';
import 'package:tunes_lovers/screens/home_landing_screen/home_landing_screen.dart';
import 'package:tunes_lovers/screens/landing_screen/landing_screen.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:theme_provider/theme_provider.dart';

class VerifyScreen extends StatefulWidget {
  final User firebaseUser;
  const VerifyScreen({Key? key, required this.firebaseUser}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.firebaseUser.emailVerified) {
      return HomeLandingScreen(
        firebaseUser: widget.firebaseUser,
        key: widget.key,
      );
    } else {
      return ThemeConsumer(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                await AuthApi().reloadUserData().then((value) {
                  NavigationService(context).pushAndReplace(
                    LandingScreen(key: widget.key),
                  );
                });
              },
              icon: const Icon(Icons.replay_outlined),
            ),
            title: const Text("Go Events"),
            actions: [
              IconButton(
                onPressed: () {
                  AuthApi().logout();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          key: widget.key,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please Verify you Email ${widget.firebaseUser.email}",
                textAlign: TextAlign.center,
                key: widget.key,
              ),
              TextButton(
                onPressed: () {
                  AuthApi().sendVerification(widget.firebaseUser).then((value) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return SuccessDialog(
                              message:
                                  "Check you email to verify the email address: ${widget.firebaseUser.email}");
                        });
                  }).catchError((error) {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return ErrorDialog(message: error);
                        });
                  });
                },
                child: Text(
                  "Resend Verification",
                  key: widget.key,
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
