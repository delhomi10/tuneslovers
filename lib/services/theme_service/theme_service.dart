import 'package:flutter/material.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeService {
  static const String lightThemeId = "light_theme";
  static const String darkThemeId = "dark_theme";
  static const primaryColor = Color(0xFF1266F1);
  static const secondaryColor = Color(0xFFB23CFD);
  static const successColor = Color(0xFF00B74A);
  static const dangerColor = Color(0xFFF93154);
  static const warningColor = Color(0xFFFFA900);
  static const infoColor = Color(0xFF39C0ED);
  static const lightColor = Color(0xFFFBFBFB);

  static List<AppTheme> themes = [
    AppTheme(
      id: lightThemeId,
      data: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: LightTheme.cardBackgroundColor,
          foregroundColor: LightTheme.mainTextColor,
          iconTheme: IconThemeData(
            color: LightTheme.mainIconColor,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.black,
          ),
          shadowColor: LightTheme.mainBackgroundColor,
          elevation: 1.0,
        ),
        cardColor: LightTheme.cardBackgroundColor,
        primaryColor: LightTheme.primaryColor,
        backgroundColor: LightTheme.mainBackgroundColor,
        cardTheme: const CardTheme(
          color: LightTheme.cardBackgroundColor,
          elevation: 1.0,
          shadowColor: LightTheme.mainBackgroundColor,
        ),
        scaffoldBackgroundColor: LightTheme.mainBackgroundColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: LightTheme.cardBackgroundColor,
          selectedItemColor: LightTheme.primaryColor,
          unselectedItemColor: LightTheme.secondaryTextColor,
          elevation: 1.0,
        ),
        textTheme: TextTheme(
          bodyText1: GoogleFonts.lato(
            fontSize: 14.0,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          // General Body Text and Subtitle in ListTile
          bodyText2: GoogleFonts.lato(
            fontSize: 14.0,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          button: GoogleFonts.lato(
            fontSize: 14.0,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          caption: GoogleFonts.lato(
            fontSize: 14.0,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          headline1: GoogleFonts.lato(
            fontSize: 30,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          headline2: GoogleFonts.lato(
            fontSize: 30,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          headline3: GoogleFonts.lato(
            fontSize: 30,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          headline4: GoogleFonts.lato(
            fontSize: 40,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          headline5: GoogleFonts.lato(
            fontSize: 30,
            color: LightTheme.mainTextColor,
            fontWeight: FontWeight.w500,
          ),
          //AppBar Title
          headline6: GoogleFonts.lato(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: LightTheme.mainTextColor,
          ),
          // ListTile title size
          subtitle1: GoogleFonts.lato(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: LightTheme.mainTextColor,
          ),
          subtitle2: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            color: LightTheme.mainTextColor,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: LightTheme.secondaryIconColor,
          textColor: LightTheme.mainTextColor,
        ),
        iconTheme: const IconThemeData(
          color: LightTheme.secondaryIconColor,
        ),
        primaryIconTheme: const IconThemeData(
          color: LightTheme.secondaryIconColor,
        ),
        useMaterial3: false,
      ),
      description: "This is Light Theme",
    ),
    AppTheme(
      id: darkThemeId,
      data: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: DarkTheme.cardBackgroundColor,
          foregroundColor: DarkTheme.mainTextColor,
          iconTheme: IconThemeData(
            color: DarkTheme.mainIconColor,
          ),
          actionsIconTheme: IconThemeData(
            color: DarkTheme.mainIconColor,
          ),
          elevation: 3.0,
          shadowColor: DarkTheme.mainBackgroundColor,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: DarkTheme.cardBackgroundColor,
          elevation: 3.0,
          shadowColor: DarkTheme.mainBackgroundColor,
        ),
        scaffoldBackgroundColor: DarkTheme.mainBackgroundColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: DarkTheme.cardBackgroundColor,
          selectedItemColor: DarkTheme.primaryColor,
          unselectedItemColor: DarkTheme.secondaryTextColor,
          elevation: 0,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: DarkTheme.secondaryIconColor,
          textColor: DarkTheme.mainTextColor,
        ),
        textTheme: TextTheme(
          bodyText1: GoogleFonts.lato(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          // General Body Text and Subtitle in ListTile
          bodyText2: GoogleFonts.lato(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          button: GoogleFonts.lato(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          caption: GoogleFonts.lato(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          headline1: GoogleFonts.lato(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          headline2: GoogleFonts.lato(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          headline3: GoogleFonts.lato(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          headline4: GoogleFonts.lato(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          headline5: GoogleFonts.lato(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          //AppBar Title
          headline6: GoogleFonts.lato(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          // ListTile title size
          subtitle1: GoogleFonts.lato(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
          subtitle2: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            color: DarkTheme.mainTextColor,
          ),
        ),
        iconTheme: const IconThemeData(
          color: DarkTheme.secondaryIconColor,
        ),
        primaryIconTheme: const IconThemeData(
          color: DarkTheme.secondaryIconColor,
        ),
        useMaterial3: false,
      ),
      description: "This is Dark Theme",
    ),
  ];

  static Color borderColor(BuildContext context) =>
      isDark(context) ? DarkTheme.lightTextColor : LightTheme.lightTextColor;

  static BoxShadow boxShadow(BuildContext context) => isDark(context)
      ? const BoxShadow(
          color: Color.fromRGBO(18, 25, 37, 0.814),
          offset: Offset(0, 1),
          blurRadius: 4)
      : const BoxShadow(
          color: Color.fromRGBO(98, 109, 120, 0.14),
          offset: Offset(0, 1),
          blurRadius: 4);

  static bool isDark(BuildContext context) =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      ThemeService.darkThemeId;

  static ThemeData theme(BuildContext context) =>
      ThemeProvider.themeOf(context).data;

  static void switchTheme(BuildContext context) {
    ThemeProvider.controllerOf(context).nextTheme();
  }

  static ThemeData pickerTheme(BuildContext context) => ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Theme.of(context).textTheme.bodyText1!.color!,
          onPrimary: Theme.of(context).scaffoldBackgroundColor,
          surface: Theme.of(context).cardTheme.color!,
          onSurface: Theme.of(context).textTheme.bodyText1!.color!,
          onTertiary: Theme.of(context).textTheme.bodyText1!.color!,
          onSecondary: Theme.of(context).textTheme.bodyText1!.color!,
          onPrimaryContainer: Theme.of(context).textTheme.bodyText1!.color!,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: GoogleFonts.lato(
              color: Theme.of(context).textTheme.bodyText1!.color!,
            ),
          ),
        ),
        dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );
}
