import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/pages/dashboard/custom_tiles_builder/custom_tile/custom_tile.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/uis/event_calendar_ui/event_calendar_ui.dart';

class CustomTilesBuilder extends StatelessWidget {
  final Person person;
  const CustomTilesBuilder({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomTile(onTap: () {}, top: "M", title: "Merch"),
        CustomTile(onTap: () {}, top: "T", title: "Talent"),
        CustomTile(
          onTap: () {
            NavigationService(context).push(
              EventCalendarUI(person: person),
            );
          },
          top: "C",
          title: "Calendar",
        ),
      ],
    );
  }
}
