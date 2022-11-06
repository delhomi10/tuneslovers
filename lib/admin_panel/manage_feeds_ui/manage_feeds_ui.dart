import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/admin_panel/manage_events_ui/edit_event_ui/edit_event_ui.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/edit_feed_ui.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class ManageFeedsUI extends StatelessWidget {
  final Person person;
  const ManageFeedsUI({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: key,
      child: Scaffold(
        key: key,
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Feed").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  key: key,
                  child: CircularProgressIndicator(
                    key: key,
                  ),
                );
              }

              List<Feed> list = snapshot.data!.docs
                  .map((e) => Feed.fromJson(e.data()))
                  .toList();

              return CustomScrollView(
                key: key,
                slivers: [
                  SliverAppBar(
                    key: key,
                    pinned: true,
                    title: const Text("Feed"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          NavigationService(context).push(
                            EditFeedUI(
                              isEdit: false,
                              person: person,
                              feed: null,
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
                        Feed feed = list[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: SizeService.innerVerticalPadding,
                              horizontal: SizeService.innerHorizontalPadding),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            leading: feed.coverImage == ""
                                ? CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        feed.title[0],
                                        style: GoogleFonts.lato(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage:
                                        NetworkImage(feed.coverImage),
                                  ),
                            key: key,
                            title: Text(
                              feed.title,
                              key: key,
                            ),
                            subtitle: Text(
                              feed.content.isEmpty ? "" : feed.content[0],
                              maxLines: 3,
                              style: GoogleFonts.lato(
                                  fontSize: 12.0,
                                  color:
                                      Theme.of(context).primaryIconTheme.color),
                            ),
                            trailing: IconButton(
                              key: key,
                              iconSize: 20.0,
                              onPressed: () {
                                NavigationService(context).push(
                                  EditFeedUI(
                                    isEdit: true,
                                    person: person,
                                    feed: feed,
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                key: key,
                              ),
                            ),
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
