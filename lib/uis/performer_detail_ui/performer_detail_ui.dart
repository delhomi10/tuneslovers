import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/app_drawer/app_drawer.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class PerformerDetailUI extends StatelessWidget {
  final Person person;
  final String performerId;
  const PerformerDetailUI(
      {Key? key, required this.person, required this.performerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      key: key,
      child: Scaffold(
        endDrawer: AppDrawer(key: key, person: person),
        key: key,
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Performer")
                .doc(performerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              Performer performer = Performer.fromJson(snapshot.data!.data());
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    key: key,
                    leading: BackButton(key: key),
                    pinned: true,
                    title: Text(performer.name),
                  ),
                  SliverToBoxAdapter(
                    key: key,
                    child: Column(
                      key: key,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.all(SizeService.innerPadding),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                            boxShadow: [
                              ThemeService.boxShadow(context),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizeService.borderRadius),
                                  child: performer.avatarURL == ""
                                      ? Container(
                                          color: Theme.of(context).primaryColor,
                                          height:
                                              SizeService(context).height * 0.2,
                                          width: SizeService(context).height *
                                              0.15,
                                        )
                                      : Image.network(
                                          performer.avatarURL,
                                          height:
                                              SizeService(context).height * 0.2,
                                          width: SizeService(context).height *
                                              0.15,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(
                                  width: SizeService.innerHorizontalPadding),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        performer.name,
                                        style: GoogleFonts.lato(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        performer.country,
                                        style: GoogleFonts.lato(
                                          color: ThemeService.isDark(context)
                                              ? DarkTheme.secondaryTextColor
                                              : LightTheme.secondaryTextColor,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Wrap(
                                        spacing: 5.0,
                                        runSpacing: 5.0,
                                        children: performer.genre
                                            .map((e) => Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 3,
                                                      horizontal: 8.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color:
                                                          ThemeService.isDark(
                                                                  context)
                                                              ? Colors.black
                                                              : Colors.blue),
                                                  child: Text(
                                                    e,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                      const SizedBox(height: 5.0),
                                      TextButton(
                                        onPressed: () {
                                          //Launch Email App
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.email),
                                            const SizedBox(width: 5.0),
                                            Text(performer.email),
                                          ],
                                        ),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("Follower")
                                              .doc(performer.id)
                                              .collection("Follower")
                                              .snapshots(),
                                          builder: (context, pSnapshot) {
                                            if (!pSnapshot.hasData) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        key: key),
                                              );
                                            }

                                            List<String> followers = pSnapshot
                                                .data!.docs
                                                .map((e) => e.id)
                                                .toList();
                                            bool isFollowed = followers
                                                .contains(person.userId);
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${followers.length} ${followers.length > 1 ? " Followers" : " Follower"}",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () async {
                                                      if (!isFollowed) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Follower")
                                                            .doc(performer.id)
                                                            .collection(
                                                                "Follower")
                                                            .doc(person.userId)
                                                            .set({
                                                          "userId":
                                                              person.userId
                                                        });
                                                      } else {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Follower")
                                                            .doc(performer.id)
                                                            .collection(
                                                                "Follower")
                                                            .doc(person.userId)
                                                            .delete();
                                                      }
                                                    },
                                                    icon: Icon(
                                                      isFollowed
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: Colors.red,
                                                    ),
                                                    label: Text(
                                                      isFollowed
                                                          ? "Unfollow"
                                                          : "Follow",
                                                      style: GoogleFonts.lato(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .color,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                      const SizedBox(height: 5.0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(SizeService.innerPadding),
                      child: Column(
                        children: [
                          Text(
                            "About",
                            style: GoogleFonts.lato(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          Text(
                            performer.bio,
                            style: GoogleFonts.lato(
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          SizedBox(
                            height: SizeService.separatorHeight,
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SizeService.innerPadding),
                      child: Column(
                        children: [
                          Text(
                            "Images",
                            style: GoogleFonts.lato(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: performer.images!
                                  .map(
                                    (e) => Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            SizeService.borderRadius),
                                        child: Image.network(
                                          e,
                                          height:
                                              SizeService(context).height * 0.2,
                                          width:
                                              SizeService(context).width * 0.5,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          SizedBox(
                            height: SizeService.separatorHeight,
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(SizeService.innerPadding),
                          child: Text(
                            "Socials",
                            style: GoogleFonts.lato(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 20.0,
                          runSpacing: 20.0,
                          children: performer.socials
                              .map(
                                (e) => IconButton(
                                  onPressed: () {
                                    //Open Link
                                  },
                                  icon: Icon(
                                    e.iconData,
                                    color: e.username == ""
                                        ? Colors.grey
                                        : e.color,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: SizeService.separatorHeight),
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
