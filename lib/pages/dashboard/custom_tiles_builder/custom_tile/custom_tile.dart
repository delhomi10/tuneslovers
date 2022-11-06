import 'package:flutter/material.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTile extends StatelessWidget {
  final Function() onTap;
  final String top;
  final String title;
  const CustomTile(
      {Key? key, required this.onTap, required this.top, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeService.borderRadius),
              color: Theme.of(context).primaryColor,
              boxShadow: [
                ThemeService.boxShadow(context),
              ],
            ),
            alignment: Alignment.center,
            height: SizeService(context).height * 0.1,
            width: SizeService(context).height * 0.1,
            child: Text(
              top,
              style: GoogleFonts.lato(
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
