import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/admin_panel/manage_events_ui/edit_event_ui/edit_event_ui.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/models/stripe_models/price.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class ManageEventsUI extends StatelessWidget {
  final Person person;
  const ManageEventsUI({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: key,
      child: Scaffold(
        key: key,
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Event").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  key: key,
                  child: CircularProgressIndicator(
                    key: key,
                  ),
                );
              }

              List<Event> list = snapshot.data!.docs
                  .map((e) => Event.fromJson(e.data()))
                  .toList();
              return CustomScrollView(
                key: key,
                slivers: [
                  SliverAppBar(
                    key: key,
                    pinned: true,
                    title: const Text("Events"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          NavigationService(context).push(
                            EditEventUI(
                              isEdit: false,
                              person: person,
                              event: null,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        Event event = list[i];
                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.all(
                              SizeService.innerHorizontalPadding),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(
                                  SizeService.borderRadius),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                event.title,
                                key: key,
                              ),
                              const SizedBox(
                                  height: SizeService.separatorHeight),
                              Text(
                                event.address!.formattedAddress,
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
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
                                  fontSize: 12.0,
                                  letterSpacing: 0.2,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(
                                  height: SizeService.separatorHeight),
                              Text(
                                "Capcity (${event.capacity})",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  letterSpacing: 0.2,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(
                                  height: SizeService.separatorHeight),
                              Text(
                                "Space: (${event.space})",
                                style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  letterSpacing: 0.2,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(
                                  height: SizeService.separatorHeight),
                              event.performers.isEmpty
                                  ? const Center()
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Performers",
                                          style: GoogleFonts.lato(
                                            fontSize: 12.0,
                                            letterSpacing: 0.2,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                            width: SizeService.separatorHeight),
                                        SizedBox(
                                          height: 25,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  event.performers.length,
                                              itemBuilder: (context, i) {
                                                return StreamBuilder<
                                                        DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("Performer")
                                                        .doc(
                                                            event.performers[i])
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          key: key,
                                                        );
                                                      }
                                                      Performer performer =
                                                          Performer.fromJson(
                                                              snapshot.data!
                                                                  .data());
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        decoration: BoxDecoration(
                                                            color: ThemeService
                                                                    .isDark(
                                                                        context)
                                                                ? DarkTheme
                                                                    .chipBackgroundColor
                                                                : LightTheme
                                                                    .chipBackgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            boxShadow: [
                                                              ThemeService
                                                                  .boxShadow(
                                                                      context),
                                                            ]),
                                                        child: Text(
                                                          performer.name,
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.2,
                                                            color: ThemeService
                                                                    .isDark(
                                                                        context)
                                                                ? DarkTheme
                                                                    .mainTextColor
                                                                : LightTheme
                                                                    .mainTextColor,
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }),
                                        ),
                                      ],
                                    ),
                              const SizedBox(
                                  height: SizeService.separatorHeight),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("Event")
                                      .doc(event.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: Text("Loading"),
                                      );
                                    } else {
                                      Price price = Price.fromJSON(
                                          snapshot.data!["price"]);
                                      return Text(
                                        "Ticket Price: \$ ${(price.amount / 100).toStringAsFixed(2)}",
                                        style: GoogleFonts.lato(
                                            color: ThemeService.primaryColor,
                                            fontWeight: FontWeight.w700),
                                      );
                                    }
                                  }),
                              const SizedBox(
                                  height: SizeService.separatorHeight),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeService.borderRadius),
                                  ),
                                  primary: ThemeService.primaryColor,
                                ),
                                onPressed: () {
                                  NavigationService(context).push(
                                    EditEventUI(
                                      isEdit: true,
                                      person: person,
                                      event: event,
                                    ),
                                  );
                                },
                                child: const Text("Edit"),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: list.length,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
