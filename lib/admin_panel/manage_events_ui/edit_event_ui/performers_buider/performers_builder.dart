import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformersBuilder extends StatelessWidget {
  final Person person;
  final Function(Performer) onTap;
  PerformersBuilder({Key? key, required this.onTap, required this.person})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Performer").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Center(
                key: key,
                child: CircularProgressIndicator(
                  key: key,
                ),
              ),
            );
          }

          List<Performer> list = snapshot.data!.docs
              .map((e) => Performer.fromJson(e.data()))
              .toList();

          List<DropdownMenuItem<Performer>> dropdownItems = list
              .map((e) => DropdownMenuItem<Performer>(
                    onTap: () => onTap(e),
                    alignment: Alignment.center,
                    value: e,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: SizeService.innerVerticalPadding),
                      padding: const EdgeInsets.all(
                          SizeService.innerVerticalPadding),
                      child: Row(
                        children: [
                          e.avatarURL == ""
                              ? CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                )
                              : CircleAvatar(
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

          return SliverToBoxAdapter(
            child: Container(
              key: key,
              margin: const EdgeInsets.symmetric(
                  horizontal: SizeService.innerHorizontalPadding),
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
            ),
          );
        });
  }
}
