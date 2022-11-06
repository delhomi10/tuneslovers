import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/admin_panel/manage_performers_ui/edit_performer_ui/edit_performer_ui.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/navigation_service/navigation_service.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

class ManagePerformersUI extends StatelessWidget {
  final Person person;
  const ManagePerformersUI({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("Performer").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  key: key,
                  child: CircularProgressIndicator(
                    key: key,
                  ),
                );
              }

              List<Performer> list = snapshot.data!.docs
                  .map((e) => Performer.fromJson(e.data()))
                  .toList();
              return CustomScrollView(
                key: key,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: const Text("Manage Performers"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          NavigationService(context).push(
                            EditPerformerUI(
                                person: person, isEdit: false, performer: null),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        Performer performer = list[i];
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
                            leading: performer.avatarURL == ""
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
                                        performer.name[0],
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
                                        NetworkImage(performer.avatarURL),
                                  ),
                            key: key,
                            title: Text(
                              performer.name,
                              key: key,
                            ),
                            subtitle: Text(
                              performer.bio,
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
                                  EditPerformerUI(
                                    isEdit: true,
                                    person: person,
                                    performer: performer,
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
