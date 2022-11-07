import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:tunes_lovers/uis/feed_detail_ui/comment_ui.dart';

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
                        Text(
                          feed.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                            color: ThemeService.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: SizeService.separatorHeight * 2,
                        ),
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
                        const SizedBox(
                          height: SizeService.separatorHeight * 2,
                        ),
                        Text(
                          "Images",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                            color: ThemeService.primaryColor,
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
