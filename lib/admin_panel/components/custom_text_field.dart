import 'package:flutter/material.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String lableText;
  final int? maxLines;

  const CustomTextField({
    Key? key,
    required this.textEditingController,
    required this.lableText,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(SizeService.borderRadius),
        boxShadow: [
          ThemeService.boxShadow(context),
        ],
      ),
      child: TextFormField(
        key: key,
        controller: textEditingController,
        style: GoogleFonts.lato(
          fontSize: 14.0,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8.0),
          border: InputBorder.none,
          hintText: lableText,
          labelText: lableText,
          labelStyle: GoogleFonts.lato(
            fontSize: 14.0,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          hintStyle: GoogleFonts.lato(
            fontSize: 14.0,
            color: Theme.of(context).primaryIconTheme.color,
          ),
        ),
        maxLines: maxLines ?? 1,
      ),
    );
  }
}
