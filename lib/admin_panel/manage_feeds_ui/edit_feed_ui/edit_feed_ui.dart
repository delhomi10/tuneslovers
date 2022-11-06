import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tunes_lovers/admin_panel/components/custom_text_field.dart';
import 'package:tunes_lovers/admin_panel/manage_events_ui/edit_event_ui/addresses_builder/addresses_bloc.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/address_selector_ui/address_selector_ui.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/cover_ui/cover_ui.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/edit_feed_ui_bloc.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/genres_selector_ui/genres_selector_ui.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/images_ui/images_ui.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/performers_selector_ui/performers_selector_ui.dart';
import 'package:tunes_lovers/app_drawer/app_drawer.dart';
import 'package:tunes_lovers/models/address.dart';
import 'package:tunes_lovers/models/feed.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uuid/uuid.dart';

class EditFeedUI extends StatefulWidget {
  final bool isEdit;
  final Person person;
  final Feed? feed;
  const EditFeedUI({
    Key? key,
    required this.isEdit,
    required this.person,
    this.feed,
  }) : super(key: key);

  @override
  State<EditFeedUI> createState() => _EditFeedUIState();
}

class _EditFeedUIState extends State<EditFeedUI> {
  String feedId = const Uuid().v4();

  TextEditingController titleController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Address? address;

  List<TextEditingController> contentControllers = [];

  List<String> images = [];
  List<String> selectedGenres = [];
  List<String> selectedPerformers = [];

  // Submit
  Future<void> onSubmit() async {
    Feed feed = Feed(
      address: address!,
      images: images,
      content: contentControllers.map((e) => e.text.toString()).toList(),
      coverImage: coverController.text.trim(),
      genres: selectedGenres,
      id: feedId,
      likes: {},
      performers: selectedPerformers,
      title: titleController.text.trim(),
      createdAt: Timestamp.now(),
    );
    if (widget.isEdit) {
      FirebaseFirestore.instance
          .collection("Feed")
          .doc(feedId)
          .update(feed.toMap)
          .then((value) => Navigator.pop(context));
    } else {
      FirebaseFirestore.instance
          .collection("Feed")
          .doc(feedId)
          .set(feed.toMap)
          .then((value) => Navigator.pop(context));
    }
  }

  EditFeedUIBloc editFeedUIBloc = EditFeedUIBloc();
  AddressesBloc addressesBloc = AddressesBloc();

  initializeData() {
    if (widget.feed!.content.isEmpty || !widget.isEdit) {
      contentControllers.add(TextEditingController());
    }
    titleController.text = widget.feed!.title;
    for (String c in widget.feed!.content) {
      contentControllers.add(TextEditingController(text: c));
    }
    feedId = widget.feed!.id;
    addressController.text = widget.feed!.address.formattedAddress;
    address = widget.feed!.address;
    coverController.text = widget.feed!.coverImage;
    images.addAll(widget.feed!.images);
    selectedGenres.addAll(widget.feed!.genres);
    selectedPerformers.addAll(widget.feed!.performers);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit) {
      setState(() {
        initializeData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        endDrawer: AppDrawer(person: widget.person),
        body: StreamBuilder<bool>(
            initialData: false,
            stream: editFeedUIBloc.stream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          key: widget.key,
                          pinned: true,
                          leading: BackButton(
                            key: widget.key,
                          ),
                          title: Text(widget.isEdit ? "Edit Feed" : "Add Feed"),
                          actions: widget.isEdit
                              ? [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        SizeService
                                                            .borderRadius),
                                              ),
                                              title:
                                                  const Text("Are You Sure?"),
                                              content: const Text(
                                                  "Do you want to delete this feed?"),
                                              actions: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            SizeService
                                                                .innerPadding),
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            SizeService
                                                                .borderRadius,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Cancel",
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            SizeService
                                                                .innerPadding),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("Feed")
                                                            .doc(
                                                                widget.feed!.id)
                                                            .delete()
                                                            .then((value) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Successfully Deleted Feed ${widget.feed!.title}");
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  SizeService
                                                                      .borderRadius,
                                                                ),
                                                              ),
                                                              primary: Colors
                                                                  .red[600]),
                                                      child: Text(
                                                        "Delete",
                                                        style: GoogleFonts.lato(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).then((value) {
                                        Navigator.pop(context);
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: ThemeService.isDark(context)
                                        ? DarkTheme.mainIconColor
                                        : LightTheme.mainIconColor,
                                  ),
                                ]
                              : [],
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(SizeService.innerPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Cover Image",
                                  style: GoogleFonts.lato(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                CoverUI(
                                    editFeedUIBloc: editFeedUIBloc,
                                    person: widget.person,
                                    coverController: coverController),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                CustomTextField(
                                  textEditingController: titleController,
                                  lableText: "Title",
                                ),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                Column(
                                  children: contentControllers
                                      .map(
                                        (e) => Dismissible(
                                          key: ValueKey(e),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (dir) {
                                            contentControllers.remove(e);
                                            setState(() {});
                                          },
                                          background: Container(
                                            height: 30,
                                            margin: const EdgeInsets.only(
                                                bottom: SizeService
                                                    .separatorHeight),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(
                                                    SizeService.borderRadius),
                                                bottomRight: Radius.circular(
                                                    SizeService.borderRadius),
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: SizeService
                                                    .separatorHeight),
                                            child: CustomTextField(
                                              textEditingController: e,
                                              maxLines: 4,
                                              lableText:
                                                  "Content ${contentControllers.indexOf(e) + 1}",
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                TextButton(
                                  onPressed: () {
                                    contentControllers
                                        .add(TextEditingController());
                                    setState(() {});
                                  },
                                  child: const Text("Add New Content Section"),
                                ),
                                AddressSelectorUI(
                                  onTap: (addr) {
                                    setState(() {
                                      address = addr;
                                    });
                                  },
                                  addressesBloc: addressesBloc,
                                  addressController: addressController,
                                  person: widget.person,
                                ),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                GenresSelectorUI(
                                    selectedGenres: selectedGenres),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                PerformersSelectorUI(
                                  selectedPerformers: selectedPerformers,
                                ),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                Text(
                                  "Preview Images",
                                  style: GoogleFonts.lato(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                const SizedBox(
                                    height: SizeService.separatorHeight),
                                ImagesUI(
                                  person: widget.person,
                                  images: images,
                                  editFeedUIBloc: editFeedUIBloc,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: SizeService.outerHorizontalPadding,
                        vertical: SizeService.innerVerticalPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(SizeService.innerPadding),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    SizeService.borderRadius,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.lato(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(SizeService.innerPadding),
                            child: ElevatedButton(
                              onPressed: snapshot.data! ? null : onSubmit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    SizeService.borderRadius,
                                  ),
                                ),
                              ),
                              child: Text(
                                widget.isEdit ? "Update" : "Create",
                                style: GoogleFonts.lato(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
