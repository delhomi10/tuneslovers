import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:tunes_lovers/apis/payment_api/payment_api.dart';
import 'package:tunes_lovers/firebase_options.dart';
import 'package:tunes_lovers/screens/landing_screen/landing_screen.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(debug: true);

  await Permission.storage.request();
  Stripe.publishableKey = PaymentApi.testPublishableKey;
  runApp(
    const TunesLovers(),
  );
}

class TunesLovers extends StatelessWidget {
  const TunesLovers({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: ThemeService.themes,
      child: ThemeConsumer(
        child: Builder(builder: (BuildContext themeContext) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeService.theme(themeContext),
            home: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: LandingScreen(
                key: key,
              ),
            ),
          );
        }),
      ),
    );
  }
}
