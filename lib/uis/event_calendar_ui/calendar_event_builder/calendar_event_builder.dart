import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/event_detail_ui/event_detail_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CalendarEventBuilder extends StatelessWidget {
  final DateTime selectedDate;
  final Person person;
  const CalendarEventBuilder({
    Key? key,
    required this.selectedDate,
    required this.person,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Event")
            .where(
              "startDate",
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(DateUtils.dateOnly(selectedDate)),
              isLessThanOrEqualTo: Timestamp.fromDate(
                DateUtils.dateOnly(
                  DateTime(selectedDate.year, selectedDate.month,
                      selectedDate.day + 1),
                ),
              ),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: CupertinoActivityIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          List<Event> eventList =
              snapshot.data!.docs.map((e) => Event.fromJson(e.data())).toList();
          return MultiSliver(children: [
            SliverToBoxAdapter(
              child: Divider(
                color: ThemeService.isDark(context)
                    ? DarkTheme.secondaryIconColor
                    : LightTheme.secondaryIconColor,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Events",
                  style: GoogleFonts.lato(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            eventList.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Text(
                        "Caught Up. No events found!!!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        Event event = eventList[i];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          margin: const EdgeInsets.all(
                              SizeService.innerHorizontalPadding),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                            boxShadow: [
                              ThemeService.boxShadow(context),
                            ],
                          ),
                          child: ListTile(
                            key: key,
                            isThreeLine: true,
                            onTap: () {
                              NavigationService(context).push(
                                EventDetailUI(
                                    person: person, eventId: event.id),
                              );
                            },
                            minLeadingWidth: 0.0,
                            enableFeedback: true,
                            title: Text(
                              event.title,
                              key: key,
                            ),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                Text(
                                  event.address!.formattedAddress,
                                  style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    letterSpacing: 0.2,
                                    color: ThemeService.isDark(context)
                                        ? DarkTheme.secondaryTextColor
                                        : LightTheme.secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                Text(
                                  Intl()
                                      .date("MM/dd/yyyy HH:mm a (EEEE)")
                                      .format(event.startDate.toDate()),
                                  style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    letterSpacing: 0.2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                              ],
                            ),
                            trailing: FittedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.upLong,
                                    size: 16.0,
                                  ),
                                  Text(
                                    event.space.toString(),
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: eventList.length,
                    ),
                  ),
          ]);
        });
  }
}
