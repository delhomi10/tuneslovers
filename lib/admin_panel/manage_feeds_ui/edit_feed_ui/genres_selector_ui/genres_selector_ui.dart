import 'package:flutter/material.dart';
import 'package:tunes_lovers/services/global_services/global_services.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class GenresSelectorUI extends StatefulWidget {
  final List<String> selectedGenres;
  const GenresSelectorUI({Key? key, required this.selectedGenres})
      : super(key: key);

  @override
  State<GenresSelectorUI> createState() => _GenresSelectorUIState();
}

class _GenresSelectorUIState extends State<GenresSelectorUI> {
  List<DropdownMenuItem<String>> get dropdownItems => GlobalServices.genres
      .map((e) => DropdownMenuItem<String>(
            onTap: () {
              if (!widget.selectedGenres.contains(e)) {
                setState(() {
                  widget.selectedGenres.add(e);
                });
              }
            },
            value: e,
            child: Text(e),
          ))
      .toList();
  String? val;
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.selectedGenres.isNotEmpty)
          Text(
            "Genres",
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        Wrap(
          spacing: 8.0,
          runSpacing: 0,
          children: widget.selectedGenres
              .map(
                (e) => InputChip(
                  padding: const EdgeInsets.all(2.0),
                  avatar: CircleAvatar(
                    backgroundColor: DarkTheme.mainBackgroundColor,
                    child: Text(e[0]),
                  ),
                  label: Text(
                    e,
                    style: TextStyle(
                        color: _isSelected ? Colors.white : Colors.black),
                  ),
                  selected: _isSelected,
                  selectedColor: Colors.blue.shade600,
                  onSelected: (bool selected) {
                    setState(() {
                      _isSelected = selected;
                    });
                  },
                  onDeleted: () {
                    setState(() {
                      widget.selectedGenres.remove(e);
                    });
                  },
                ),
              )
              .toList(),
        ),
        Container(
          key: widget.key,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(SizeService.borderRadius),
            boxShadow: [
              ThemeService.boxShadow(context),
            ],
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(SizeService.borderRadius),
            underline: const Center(),
            value: val,
            hint: Text(
              "Select Genres",
              style: GoogleFonts.lato(
                fontSize: 14.0,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
            items: dropdownItems,
            onChanged: (val) {
              // setState(() {
              //   val = val!;
              // });
            },
          ),
        ),
      ],
    );
  }
}
