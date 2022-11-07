import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/pages/feeds_page/feeds_tags_ui.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tunes_lovers/uis/feed_detail_ui/comment_ui.dart';
import 'package:tunes_lovers/uis/feed_detail_ui/feed_detail_ui.dart';

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
                                TextButton.icon(
                                  onPressed: () {
                                    if (feed.likes.containsKey(person.userId)) {
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
                                    color: feed.likes.containsKey(person.userId)
                                        ? ThemeService.secondaryColor
                                        : ThemeService.primaryColor,
                                  ),
                                  label: Text(
                                    feed.likes.length.toString(),
                                    style: GoogleFonts.lato(
                                      color:
                                          feed.likes.containsKey(person.userId)
                                              ? ThemeService.secondaryColor
                                              : ThemeService.primaryColor,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        enableDrag: true,
                                        context: context,
                                        builder: (context) {
                                          return CommentUI(
                                              feedId: feed.id, person: person);
                                        });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical:
                                            SizeService(context).height * 0.01),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: ThemeService.isDark(context)
                                          ? DarkTheme.mainBackgroundColor
                                          : LightTheme.mainBackgroundColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Comments...",
                                          style: GoogleFonts.lato(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.message,
                                          color: ThemeService.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
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
            }),
      ],
    );
  }
}
