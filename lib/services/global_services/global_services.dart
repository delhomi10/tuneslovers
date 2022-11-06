import 'dart:io';

class GlobalServices {
  static String get baseUrl =>
      Platform.isIOS ? "http://localhost:8080" : "http://10.0.2.2:8080";
}
