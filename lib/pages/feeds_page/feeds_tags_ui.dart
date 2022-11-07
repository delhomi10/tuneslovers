import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/feed_detail_ui/feed_detail_ui.dart';

class FeedsTagsUI extends StatelessWidget {
  final Person person;
  final String tag;
  const FeedsTagsUI({
    super.key,
    required this.person,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("#$tag"),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Feed")
                .where("genres", arrayContains: tag)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                List<Feed> list = snapshot.data!.docs
                    .map((e) => Feed.fromJson(e.data()))
                    .toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      Feed feed = list[i];
                      return GestureDetector(
                        onTap: () {
                          NavigationService(context).push(
                            FeedDetailUI(person: person, feed: feed),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: SizeService.innerVerticalPadding,
                            horizontal: SizeService.innerHorizontalPadding,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: SizeService.innerVerticalPadding,
                            horizontal: SizeService.innerHorizontalPadding,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).cardTheme.color,
                            boxShadow: [
                              ThemeService.boxShadow(context),
                            ],
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
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                Text(feed.title),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
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
                                  const SizedBox(
                                    height: SizeService.separatorHeight * 2,
                                  ),
                                  Wrap(
                                    runSpacing: 10.0,
                                    spacing: 10.0,
                                    children: feed.genres
                                        .map(
                                          (e) => GestureDetector(
                                            onTap: () {
                                              NavigationService(context).push(
                                                FeedsTagsUI(
                                                    person: person, tag: e),
                                              );
                                            },
                                            child: Chip(
                                              backgroundColor: Theme.of(context)
                                                  .cardTheme
                                                  .color,
                                              elevation: 1.0,
                                              label: Text(
                                                "#$e",
                                                style: GoogleFonts.lato(
                                                  color:
                                                      ThemeService.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(
                                    height: SizeService.separatorHeight * 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          if (feed.likes
                                              .containsKey(person.userId)) {
                                            feed.likes.remove(person.userId);
                                          } else {
                                            feed.likes.addAll(
                                                {person.userId: person.userId});
                                          }
                                          FirebaseFirestore.instance
                                              .collection("Feed")
                                              .doc(feed.id)
                                              .update({"likes": feed.likes});
                                        },
                                        icon: Icon(
                                          feed.likes.containsKey(person.userId)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: feed.likes
                                                  .containsKey(person.userId)
                                              ? ThemeService.secondaryColor
                                              : ThemeService.primaryColor,
                                        ),
                                        label: Text(
                                          "Like",
                                          style: GoogleFonts.lato(
                                            color: feed.likes
                                                    .containsKey(person.userId)
                                                ? ThemeService.secondaryColor
                                                : ThemeService.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: list.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
