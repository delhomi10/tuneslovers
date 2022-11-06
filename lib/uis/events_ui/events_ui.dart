import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/events_ui/events_builder/events_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class EventsUI extends StatefulWidget {
  final Person person;
  const EventsUI({Key? key, required this.person}) : super(key: key);

  @override
  State<EventsUI> createState() => _EventsUIState();
}

class _EventsUIState extends State<EventsUI>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  static int currentIndex = 0;

  EventType get eventType => currentIndex == 0
      ? EventType.trending
      : currentIndex == 1
          ? EventType.recent
          : EventType.upcoming;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(
                "Events",
                style: GoogleFonts.lato(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              bottom: TabBar(
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                unselectedLabelColor: ThemeService.isDark(context)
                    ? DarkTheme.secondaryTextColor
                    : LightTheme.secondaryTextColor,
                labelColor: Theme.of(context).primaryColor,
                enableFeedback: true,
                physics: const BouncingScrollPhysics(),
                isScrollable: true,
                controller: tabController,
                tabs: [
                  Tab(
                    key: widget.key,
                    text: "Trending Events",
                  ),
                  Tab(
                    key: widget.key,
                    text: "Recent Events",
                  ),
                  Tab(
                    key: widget.key,
                    text: "Upcoming Events",
                  ),
                ],
              ),
            ),
            EventsBuilder(person: widget.person, eventType: eventType),
          ],
        ),
      ),
    );
  }
}
