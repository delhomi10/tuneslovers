import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/pages/dashboard/custom_tiles_builder/custom_tiles_builder.dart';
import 'package:tunes_lovers/pages/dashboard/ticket_builder/ticket_builder.dart';
import 'package:tunes_lovers/pages/dashboard/upcoming_events_builder/upcoming_events_builder.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  final Person person;
  final List<String> followedPerformers;
  const Dashboard(
      {Key? key, required this.person, required this.followedPerformers})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          key: widget.key,
          title: Row(
            children: [
              Image.asset(
                "assets/icon.png",
                height: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "Hi, ${widget.person.firstName}",
                style: GoogleFonts.lato(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: UpcomingEventsBuilder(
            followedPerformers: widget.followedPerformers,
            key: widget.key,
            person: widget.person,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: CustomTilesBuilder(
              person: widget.person,
              key: widget.key,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TicketBuilder(
            key: widget.key,
            person: widget.person,
          ),
        ),
      ],
    );
  }
}
