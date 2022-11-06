import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformersSelectorUI extends StatefulWidget {
  final List<String> selectedPerformers;
  const PerformersSelectorUI({Key? key, required this.selectedPerformers})
      : super(key: key);

  @override
  State<PerformersSelectorUI> createState() => _PerformersSelectorUIState();
}

class _PerformersSelectorUIState extends State<PerformersSelectorUI> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.selectedPerformers.isNotEmpty)
          Text(
            "Performers",
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
          children: widget.selectedPerformers
              .map(
                (e) => StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Performer")
                        .doc(e)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          key: widget.key,
                        );
                      }
                      Performer performer =
                          Performer.fromJson(snapshot.data!.data());
                      return InputChip(
                        padding: const EdgeInsets.all(2.0),
                        avatar: CircleAvatar(
                          backgroundColor: DarkTheme.mainBackgroundColor,
                          backgroundImage: NetworkImage(performer.avatarURL),
                        ),
                        label: Text(
                          performer.name,
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
                            widget.selectedPerformers.remove(e);
                          });
                        },
                      );
                    }),
              )
              .toList(),
        ),
        StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("Performer").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  key: widget.key,
                  child: CircularProgressIndicator(
                    key: widget.key,
                  ),
                );
              }

              List<Performer> list = snapshot.data!.docs
                  .map((e) => Performer.fromJson(e.data()))
                  .toList();

              List<DropdownMenuItem<Performer>> dropdownItems = list
                  .map((e) => DropdownMenuItem<Performer>(
                        onTap: () {
                          setState(() {
                            widget.selectedPerformers.add(e.id);
                          });
                        },
                        alignment: Alignment.center,
                        value: e,
                        child: Container(
                          padding: const EdgeInsets.all(
                              SizeService.innerVerticalPadding),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(e.avatarURL),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                e.name,
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList();

              return Container(
                key: widget.key,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(SizeService.borderRadius),
                  boxShadow: [
                    ThemeService.boxShadow(context),
                  ],
                ),
                child: DropdownButton<Performer>(
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(SizeService.borderRadius),
                  underline: const Center(),
                  value: null,
                  hint: Text(
                    "Select Performer",
                    style: GoogleFonts.lato(
                      fontSize: 14.0,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
                  elevation: 0,
                  items: dropdownItems,
                  onChanged: (val) {},
                ),
              );
            }),
      ],
    );
  }
}
