import 'package:flutter/material.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeService.borderRadius),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        "Error",
        style: GoogleFonts.lato(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.lato(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Close"),
        )
      ],
    );
  }
}
