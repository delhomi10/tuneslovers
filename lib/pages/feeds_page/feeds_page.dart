import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FeedsPage extends StatelessWidget {
  final Person person;
  final List<String> followedPerformers;

  const FeedsPage(
      {Key? key, required this.person, required this.followedPerformers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          key: key,
          pinned: true,
          title: const Text("Feeds"),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Feed").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              List<Feed> list = snapshot.data!.docs
                  .map((e) => Feed.fromJson(e.data()))
                  .toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    Feed feed = list[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: SizeService.innerVerticalPadding,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: SizeService.innerVerticalPadding,
                        horizontal: SizeService.innerHorizontalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        isThreeLine: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              Intl()
                                  .date("MM.dd.yyyy HH:mm a")
                                  .format(feed.createdAt.toDate()),
                              style: GoogleFonts.lato(
                                fontSize: 12.0,
                                color: ThemeService.isDark(context)
                                    ? DarkTheme.secondaryTextColor
                                    : LightTheme.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: SizeService.separatorHeight),
                            Text(feed.title),
                            const SizedBox(height: SizeService.separatorHeight),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  SizeService.borderRadius),
                              child: CachedNetworkImage(
                                imageUrl: feed.coverImage,
                                height: SizeService(context).height * 0.25,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feed.content[0],
                                style: GoogleFonts.lato(
                                  color: ThemeService.isDark(context)
                                      ? DarkTheme.secondaryTextColor
                                      : LightTheme.secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: list.length,
                ),
              );
            }),
      ],
    );
  }
}
