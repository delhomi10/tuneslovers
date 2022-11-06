import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class TileButton extends StatelessWidget {
  final Person person;
  final Function() onTap;
  final String title;
  final String subtitle;
  final Widget leading;
  const TileButton(
      {Key? key,
      required this.person,
      required this.onTap,
      required this.title,
      required this.subtitle,
      required this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeService.borderRadius),
      ),
      onTap: onTap,
      leading: Card(
          shape: const CircleBorder(),
          color: ThemeService.isDark(context) ? Colors.black : Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: leading,
          )),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.lato(
          fontSize: 12.0,
          color: ThemeService.isDark(context)
              ? DarkTheme.secondaryTextColor
              : LightTheme.secondaryTextColor,
        ),
      ),
    );
  }
}
