import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/event_detail_ui/event_detail_ui.dart';
import 'package:tunes_lovers/uis/events_ui/events_builder/events_builder_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum EventType { trending, recent, upcoming }

class EventsBuilder extends StatelessWidget {
  final EventType eventType;
  final Person person;

  const EventsBuilder({
    Key? key,
    required this.person,
    required this.eventType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: EventsBuilderApi().snapshots(eventType: eventType),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            key: key,
            child: Center(
              key: key,
              child: CircularProgressIndicator(
                key: key,
              ),
            ),
          );
        } else {
          List<Event> list =
              snapshot.data!.docs.map((e) => Event.fromJson(e.data())).toList();
          if (eventType == EventType.trending) {
            list.sort((a, b) =>
                (b.capacity - b.space).compareTo(a.capacity - a.space));
          }
          if (list.isEmpty) {
            return SliverToBoxAdapter(
              key: key,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "No Events",
                    key: key,
                    style: GoogleFonts.lato(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              Event event = list[i];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                margin:
                    const EdgeInsets.all(SizeService.innerHorizontalPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(SizeService.borderRadius),
                  boxShadow: [
                    ThemeService.boxShadow(context),
                  ],
                ),
                child: ListTile(
                  key: key,
                  dense: true,
                  isThreeLine: true,
                  onTap: () {
                    NavigationService(context).push(
                      EventDetailUI(person: person, eventId: event.id),
                    );
                  },
                  minLeadingWidth: 0.0,
                  enableFeedback: true,
                  title: Text(
                    event.title,
                    key: key,
                    style: GoogleFonts.lato(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: SizeService.separatorHeight),
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
                      const SizedBox(height: SizeService.separatorHeight),
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
                      const SizedBox(height: SizeService.separatorHeight),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.artstation,
                            size: 14.0,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Performers",
                            style: GoogleFonts.lato(
                              fontSize: 14.0,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SizeService.separatorHeight),
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: event.performers
                            .map(
                              (e) => StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("Performer")
                                      .doc(e)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        key: key,
                                      );
                                    }
                                    Performer performer = Performer.fromJson(
                                        snapshot.data!.data());
                                    return Container(
                                      padding: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.chipBackgroundColor
                                              : LightTheme.chipBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            ThemeService.boxShadow(context),
                                          ]),
                                      child: Text(
                                        performer.name,
                                        style: GoogleFonts.lato(
                                          fontSize: 14.0,
                                          letterSpacing: 0.2,
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.mainTextColor
                                              : LightTheme.mainTextColor,
                                        ),
                                      ),
                                    );
                                  }),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  trailing: FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FontAwesomeIcons.arrowTrendUp,
                          size: 16.0,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          (event.capacity - event.space).toString(),
                          style: GoogleFonts.lato(
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: list.length),
          );
        }
      },
    );
  }
}
