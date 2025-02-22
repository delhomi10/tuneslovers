import 'dart:io';

class GlobalServices {
  static String get baseUrl =>
      Platform.isIOS ? "http://localhost:8080" : "http://10.0.2.2:8080";

  static List<String> genres = [
    "Techno",
    "House",
    "Electro",
    "Dubstep ",
    "Electro-Pop",
    "Trance",
    "Jungle And Drum & Bass",
    "Breakbeat",
    "Downtempo",
    "Ambient",
    "Synthwave",
    "IDM",
    "Garage",
    "Industrial and Post-Industrial",
    "Hardcore",
  ];
}
