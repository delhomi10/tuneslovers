import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/event_detail_ui/event_detail_ui.dart';
import 'package:tunes_lovers/uis/events_ui/events_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UpcomingEventsBuilder extends StatefulWidget {
  final Person person;
  final List<String> followedPerformers;

  const UpcomingEventsBuilder({
    Key? key,
    required this.person,
    required this.followedPerformers,
  }) : super(key: key);

  @override
  State<UpcomingEventsBuilder> createState() => _UpcomingEventsBuilderState();
}

class _UpcomingEventsBuilderState extends State<UpcomingEventsBuilder> {
  int current = 0;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeService.outerHorizontalPadding,
      ),
      child: Column(
        key: widget.key,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            title: Text(
              "Upcoming events",
              key: widget.key,
              style: GoogleFonts.lato(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                NavigationService(context).push(
                  EventsUI(person: widget.person),
                );
              },
              child: Text(
                "View All",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: ThemeService.isDark(context)
                      ? DarkTheme.secondaryTextColor
                      : Colors.black54,
                ),
                key: widget.key,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: widget.followedPerformers.isEmpty
                  ? FirebaseFirestore.instance.collection("Event").snapshots()
                  : FirebaseFirestore.instance
                      .collection("Event")
                      .where("performers",
                          arrayContainsAny: widget.followedPerformers)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      key: widget.key,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else {
                  Set<Event> events = snapshot.data!.docs
                      .map((e) => Event.fromJson(e.data()))
                      .toSet();
                  return Column(
                    children: [
                      CarouselSlider(
                        items: events.map((Event event) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  NavigationService(context).push(
                                    EventDetailUI(
                                      person: widget.person,
                                      eventId: event.id,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        event.coverImage,
                                      ),
                                      opacity: .9,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.black87,
                                        BlendMode.colorDodge,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        SizeService.borderRadius),
                                    boxShadow: [
                                      ThemeService.boxShadow(context),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        event.title,
                                        style: GoogleFonts.lato(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: SizeService.separatorHeight),
                                      Text(
                                        "Available Tickets: ${event.space}",
                                        style: GoogleFonts.lato(
                                          letterSpacing: 0.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: SizeService.separatorHeight),
                                      Text(
                                        "Date: ${Intl().date("MM/dd/yyyy").format(event.startDate.toDate())}",
                                        style: GoogleFonts.lato(
                                          letterSpacing: 0.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              current = index;
                            });
                          },
                          height: SizeService(context).height * 0.2,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 10),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events.map((entry) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: CircleAvatar(
                              radius: 4.0,
                              backgroundColor:
                                  current == events.toList().indexOf(entry)
                                      ? Colors.black
                                      : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }
}
