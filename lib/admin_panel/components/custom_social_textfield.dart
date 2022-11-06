import 'package:flutter/material.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSocialTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String lableText;
  final int? maxLines;
  final Widget prefix;
  final Widget suffix;

  const CustomSocialTextField({
    Key? key,
    required this.textEditingController,
    required this.lableText,
    required this.prefix,
    required this.suffix,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: SizeService.separatorHeight),
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
          hintText: "@username",
          labelText: lableText,
          labelStyle: GoogleFonts.lato(
            fontSize: 14.0,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          prefixIcon: prefix,
          suffixIcon: suffix,
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
