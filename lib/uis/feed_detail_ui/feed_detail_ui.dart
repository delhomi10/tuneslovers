import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/pages/feeds_page/feeds_tags_ui.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/feed_detail_ui/comment_ui.dart';
import 'package:tunes_lovers/uis/performer_detail_ui/performer_detail_ui.dart';

class FeedDetailUI extends StatelessWidget {
  final Person person;
  final Feed feed;

  const FeedDetailUI({
    super.key,
    required this.person,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: Text(feed.title),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(
                            width: double.infinity,
                            height: SizeService(context).height * 0.4,
                            fit: BoxFit.cover,
                            image: NetworkImage(feed.coverImage),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Intl()
                                .date("MM.dd.yyyy HH:mm a")
                                .format(feed.createdAt.toDate()),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            feed.address.formattedAddress,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
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
                                      FeedsTagsUI(person: person, tag: e),
                                    );
                                  },
                                  child: Chip(
                                    backgroundColor:
                                        Theme.of(context).cardTheme.color,
                                    label: Text(
                                      "#$e",
                                      style: GoogleFonts.lato(
                                        color: ThemeService.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const Divider(),
                        Text(
                          "Performers",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: ThemeService.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: SizeService.separatorHeight,
                        ),
                        SizedBox(
                          height: SizeService(context).height * 0.28,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: feed.performers
                                .map((String performerId) => StreamBuilder<
                                        DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("Performer")
                                        .doc(performerId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          key: key,
                                        );
                                      }

                                      Performer performer = Performer.fromJson(
                                          snapshot.data!.data());
                                      return GestureDetector(
                                        onTap: () {
                                          NavigationService(context).push(
                                            PerformerDetailUI(
                                                person: person,
                                                performerId: performer.id),
                                          );
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 14 / 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: SizeService
                                                  .innerVerticalPadding,
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 8.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .cardTheme
                                                  .color,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeService.borderRadius),
                                              boxShadow: [
                                                ThemeService.boxShadow(context),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: performer.avatarURL ==
                                                          ""
                                                      ? CircleAvatar(
                                                          radius: 50.0,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    SizeService
                                                                        .borderRadius),
                                                            child:
                                                                Image.network(
                                                              performer
                                                                  .avatarURL,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          performer.name,
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          performer.bio
                                                              .substring(0, 20),
                                                          style: GoogleFonts.lato(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          performer.country,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          performer.email,
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Text(
                                                          "Genres",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        const SizedBox(
                                                            height: SizeService
                                                                .separatorHeight),
                                                        Wrap(
                                                          spacing: 6.0,
                                                          runSpacing: 6.0,
                                                          children:
                                                              performer.genre
                                                                  .map(
                                                                    (e) => Container(
                                                                        padding: const EdgeInsets.all(6.0),
                                                                        decoration: BoxDecoration(
                                                                          color: ThemeService.isDark(context)
                                                                              ? DarkTheme.chipBackgroundColor
                                                                              : LightTheme.chipBackgroundColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                          boxShadow: [
                                                                            ThemeService.boxShadow(context),
                                                                          ],
                                                                        ),
                                                                        child: Text(e)),
                                                                  )
                                                                  .toList(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }))
                                .toList(),
                          ),
                        ),
                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: feed.content
                              .map((e) => Text(
                                    e,
                                    style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const Divider(),
                        Text(
                          "Images",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: ThemeService.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: SizeService.separatorHeight,
                        ),
                        feed.images.length == 1
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl: feed.images.first,
                                  fit: BoxFit.cover,
                                  height: SizeService(context).height * 0.25,
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: feed.images
                                      .map(
                                        (e) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: CachedNetworkImage(
                                            imageUrl: e,
                                            fit: BoxFit.cover,
                                            height:
                                                SizeService(context).height *
                                                    0.25,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    enableDrag: true,
                    context: context,
                    builder: (context) {
                      return CommentUI(feedId: feed.id, person: person);
                    });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: SizeService(context).height * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Theme.of(context).cardTheme.color,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ),
        ],
      ),
    );
  }
}
