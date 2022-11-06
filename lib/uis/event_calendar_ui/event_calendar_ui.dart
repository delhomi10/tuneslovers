import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/event_calendar_ui/calendar_event_builder/calendar_event_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarUI extends StatefulWidget {
  final Person person;

  const EventCalendarUI({Key? key, required this.person}) : super(key: key);

  @override
  State<EventCalendarUI> createState() => _EventCalendarUIState();
}

class _EventCalendarUIState extends State<EventCalendarUI> {
  DateTime selectedDate = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        key: widget.key,
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              "Event Calendar",
              style: GoogleFonts.lato(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Event").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Text("Loading"),
                  );
                }

                List<Event> events = snapshot.data!.docs
                    .map((e) => Event.fromJson(e.data()))
                    .toList();
                return SliverToBoxAdapter(
                  child: TableCalendar<Event>(
                    firstDay: DateTime(2022),
                    lastDay: DateTime(DateTime.now().year + 20),
                    focusedDay: selectedDate,
                    calendarFormat: calendarFormat,
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 4,
                      defaultTextStyle: GoogleFonts.lato(
                        color: ThemeService.isDark(context)
                            ? DarkTheme.mainTextColor
                            : LightTheme.mainTextColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                      weekendTextStyle: GoogleFonts.lato(
                        color: ThemeService.isDark(context)
                            ? DarkTheme.secondaryTextColor
                            : LightTheme.secondaryTextColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                      holidayTextStyle: GoogleFonts.lato(
                        color: ThemeService.isDark(context)
                            ? DarkTheme.dangerColor
                            : LightTheme.dangerColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                      canMarkersOverflow: false,
                      isTodayHighlighted: true,
                      todayDecoration: const BoxDecoration(
                        color: DarkTheme.successColor,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: ThemeService.isDark(context)
                            ? DarkTheme.secondaryIconColor
                            : LightTheme.secondaryIconColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                    onDaySelected: (sD, fD) {
                      setState(() {
                        selectedDate = sD;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        calendarFormat = format;
                      });
                    },
                    eventLoader: (date) {
                      LinkedHashMap<DateTime, List<Event>> kEvent =
                          LinkedHashMap<DateTime, List<Event>>(
                              equals: isSameDay);
                      kEvent.addAll({
                        date: events
                            .where((e) => isSameDay(date, e.startDate.toDate()))
                            .toList(),
                      });

                      return kEvent[date] ?? [];
                    },
                  ),
                );
              }),
          CalendarEventBuilder(
            selectedDate: selectedDate,
            person: widget.person,
          ),
        ],
      ),
    );
  }
}
