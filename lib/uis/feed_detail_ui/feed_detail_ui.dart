import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';

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
      body: CustomScrollView(
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
                              "\t\t $e",
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
