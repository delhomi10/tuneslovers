// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDtKWXvKD9tNGghiBwzGmKPT61Vhu7BOCw',
    appId: '1:805908232824:web:860531e460754f11804b8d',
    messagingSenderId: '805908232824',
    projectId: 'go-events-7',
    authDomain: 'go-events-7.firebaseapp.com',
    storageBucket: 'go-events-7.appspot.com',
    measurementId: 'G-V4JVS9H8NQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7MD0EKgXSI5TxFuBADHmSqXfwmajgu0U',
    appId: '1:805908232824:android:91ba91110b478a81804b8d',
    messagingSenderId: '805908232824',
    projectId: 'go-events-7',
    storageBucket: 'go-events-7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCe6JzFG9au4tYOHgJVugpgkwcWgIIIt_M',
    appId: '1:805908232824:ios:676334cfd2fbadb0804b8d',
    messagingSenderId: '805908232824',
    projectId: 'go-events-7',
    storageBucket: 'go-events-7.appspot.com',
    iosClientId: '805908232824-jmbohhklg126q30renfjlofh2a5rmla5.apps.googleusercontent.com',
    iosBundleId: 'com.tuneslove',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCe6JzFG9au4tYOHgJVugpgkwcWgIIIt_M',
    appId: '1:805908232824:ios:9d39968f74379b95804b8d',
    messagingSenderId: '805908232824',
    projectId: 'go-events-7',
    storageBucket: 'go-events-7.appspot.com',
    iosClientId: '805908232824-uohppipme7in25orh9nv06n5foc14uma.apps.googleusercontent.com',
    iosBundleId: 'com.example.tunesLovers',
  );
}
