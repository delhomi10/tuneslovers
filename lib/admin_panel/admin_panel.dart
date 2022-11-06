import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tunes_lovers/admin_panel/components/tile_button.dart';
import 'package:tunes_lovers/admin_panel/manage_events_ui/manage_events_ui.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/manage_feeds_ui.dart';
import 'package:tunes_lovers/admin_panel/manage_performers_ui/manage_performers_ui.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:theme_provider/theme_provider.dart';

class AdminPanel extends StatelessWidget {
  final Person person;
  const AdminPanel({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: key,
      child: Scaffold(
        key: key,
        body: CustomScrollView(
          key: key,
          slivers: [
            SliverAppBar(
              key: key,
              pinned: true,
              title: const Text("Admin Panel"),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: SizeService.innerHorizontalPadding),
                child: Column(
                  children: [
                    TileButton(
                      person: person,
                      onTap: () {
                        NavigationService(context)
                            .push(ManageEventsUI(person: person));
                      },
                      title: "Manage Events",
                      subtitle: "Add, Edit, Delete Events",
                      leading: const Icon(
                        Icons.event,
                        color: Colors.white,
                      ),
                    ),
                    TileButton(
                      person: person,
                      onTap: () {
                        NavigationService(context)
                            .push(ManagePerformersUI(person: person));
                      },
                      title: "Manage Performers",
                      subtitle: "Add, Edit, Delete Performers",
                      leading: const Icon(
                        FontAwesomeIcons.artstation,
                        color: Colors.white,
                      ),
                    ),
                    TileButton(
                      person: person,
                      onTap: () {
                        NavigationService(context)
                            .push(ManageFeedsUI(person: person));
                      },
                      title: "Manage Feeds",
                      subtitle: "Add, Edit, Delete Feeds",
                      leading: const Icon(
                        Icons.feed,
                        color: Colors.white,
                      ),
                    ),
                    TileButton(
                      person: person,
                      onTap: () {},
                      title: "Manage Tickets",
                      subtitle: "Add, Edit, Delete Tickets",
                      leading: const Icon(
                        Icons.subscriptions,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
