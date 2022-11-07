import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tunes_lovers/models/comment.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:uuid/uuid.dart';

class CommentUI extends StatefulWidget {
  final Person person;
  final String feedId;
  const CommentUI({super.key, required this.feedId, required this.person});

  @override
  State<CommentUI> createState() => _CommentUIState();
}

class _CommentUIState extends State<CommentUI> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  key: widget.key,
                  pinned: true,
                  title: const Text("Comments"),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Comment")
                        .doc(widget.feedId)
                        .collection("Comments")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      List<Comment> comments = snapshot.data!.docs
                          .map((e) => Comment.fromJson(e.data()))
                          .toList();
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            Comment comment = comments[i];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              padding: const EdgeInsets.all(
                                  SizeService.innerPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Theme.of(context).cardTheme.color,
                              ),
                              child: ListTile(
                                title: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("Customer")
                                        .doc(comment.userId)
                                        .snapshots(),
                                    builder: (context, personSnapshot) {
                                      if (!personSnapshot.hasData) {
                                        return const Center();
                                      }
                                      Person user = Person.fromJson(
                                          personSnapshot.data!.data());
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          user.avatarURL == ""
                                              ? CircleAvatar(
                                                  key: widget.key,
                                                  backgroundColor:
                                                      ThemeService.primaryColor,
                                                  child: Icon(
                                                    Icons.person,
                                                    key: widget.key,
                                                    color:
                                                        DarkTheme.mainIconColor,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    user.avatarURL!,
                                                  ),
                                                ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${user.firstName} ${user.lastName}",
                                                style: GoogleFonts.lato(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Text(
                                                Intl()
                                                    .date("MM.dd.yyyy HH:mm a")
                                                    .format(comment.updatedAt
                                                        .toDate()),
                                                style: GoogleFonts.lato(
                                                  fontSize: 12.0,
                                                  color: ThemeService.isDark(
                                                          context)
                                                      ? DarkTheme
                                                          .secondaryTextColor
                                                      : LightTheme
                                                          .secondaryTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.content,
                                        style: GoogleFonts.lato(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          if (comment.likes.containsKey(
                                              widget.person.userId)) {
                                            comment.likes
                                                .remove(widget.person.userId);
                                          } else {
                                            comment.likes.addAll({
                                              widget.person.userId:
                                                  widget.person.userId
                                            });
                                          }
                                          FirebaseFirestore.instance
                                              .collection("Comment")
                                              .doc(widget.feedId)
                                              .collection("Comments")
                                              .doc(comment.id)
                                              .update({"likes": comment.likes});
                                        },
                                        icon: Icon(
                                          comment.likes.containsKey(
                                                  widget.person.userId)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: comment.likes.containsKey(
                                                  widget.person.userId)
                                              ? ThemeService.secondaryColor
                                              : ThemeService.primaryColor,
                                        ),
                                        label: Text(
                                          comment.likes.length.toString(),
                                          style: GoogleFonts.lato(
                                            color: comment.likes.containsKey(
                                                    widget.person.userId)
                                                ? ThemeService.secondaryColor
                                                : ThemeService.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: comments.length,
                        ),
                      );
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Theme.of(context).cardTheme.color,
              ),
              child: TextField(
                controller: textEditingController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write Comments....",
                  suffixIcon: IconButton(
                    onPressed: () {
                      String commentId = const Uuid().v4();
                      FirebaseFirestore.instance
                          .collection("Comment")
                          .doc(widget.feedId)
                          .collection("Comments")
                          .doc(commentId)
                          .set(Comment(
                                  id: commentId,
                                  userId: widget.person.userId,
                                  content: textEditingController.text.trim(),
                                  isEdited: false,
                                  likes: {},
                                  createdAt: Timestamp.now(),
                                  updatedAt: Timestamp.now())
                              .toMap);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: ThemeService.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
