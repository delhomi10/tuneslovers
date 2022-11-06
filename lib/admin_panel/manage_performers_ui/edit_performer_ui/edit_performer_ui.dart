import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tunes_lovers/admin_panel/components/custom_social_textfield.dart';
import 'package:tunes_lovers/admin_panel/components/custom_text_field.dart';
import 'package:tunes_lovers/admin_panel/manage_performers_ui/edit_performer_ui/components/avatar_ui.dart';
import 'package:tunes_lovers/custom_widgets/error_dialog/error_dialog.dart';
import 'package:tunes_lovers/models/performer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/models/social.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class EditPerformerUI extends StatefulWidget {
  final Person person;
  final bool isEdit;
  final Performer? performer;
  const EditPerformerUI({
    Key? key,
    required this.person,
    required this.isEdit,
    this.performer,
  }) : super(key: key);

  @override
  State<EditPerformerUI> createState() => _EditPerformerUIState();
}

class _EditPerformerUIState extends State<EditPerformerUI> {
  String performerId = const Uuid().v4();

  initializeData() {
    if (widget.isEdit && widget.performer != null) {
      performerId = widget.performer!.id;
      nameController.text = widget.performer!.name;
      emailController.text = widget.performer!.email;
      bioController.text = widget.performer!.bio;
      countryController.text = widget.performer!.country;
      avatarURLController.text = widget.performer!.avatarURL;
      tags.addAll(widget.performer!.genre);
      images.addAll(widget.performer!.images!);

      for (var social in widget.performer!.socials) {
        if (social.title == Social.facebook) {
          isFacebook = true;
          facebookController.text = widget.performer!.socials
              .firstWhere((element) => element.title == Social.facebook)
              .username;
        } else if (social.title == Social.instagram) {
          isInstagram = true;
          instagramController.text = widget.performer!.socials
              .firstWhere((element) => element.title == Social.instagram)
              .username;
        } else if (social.title == Social.twitter) {
          isTwitter = true;
          twitterController.text = widget.performer!.socials
              .firstWhere((element) => element.title == Social.twitter)
              .username;
        } else if (social.title == Social.snapchat) {
          isSnapchat = true;
          snapchatController.text = widget.performer!.socials
              .firstWhere((element) => element.title == Social.snapchat)
              .username;
        } else if (social.title == Social.spotify) {
          isSpotify = true;
          spotifyController.text = widget.performer!.socials
              .firstWhere((element) => element.title == Social.spotify)
              .username;
        }
      }
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController avatarURLController = TextEditingController();

  List<String> tags = [];

  List<DropdownMenuItem<String>> get dropdownItems => Performer.genres
      .map((e) => DropdownMenuItem<String>(
            onTap: () {
              if (!tags.contains(e)) {
                setState(() {
                  tags.add(e);
                });
              }
            },
            value: e,
            child: Text(e),
          ))
      .toList();

  bool _isSelected = false;

//Social
  bool isFacebook = false;
  bool isInstagram = false;
  bool isTwitter = false;
  bool isSnapchat = false;
  bool isSpotify = false;
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController snapchatController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController spotifyController = TextEditingController();

  toggleFacebook() {
    setState(() {
      facebookController.clear();
      isFacebook = !isFacebook;
    });
  }

  toggleInstagram() {
    setState(() {
      instagramController.clear();
      isInstagram = !isInstagram;
    });
  }

  toggleTwitter() {
    setState(() {
      twitterController.clear();
      isTwitter = !isTwitter;
    });
  }

  toggleSnapchat() {
    snapchatController.clear();
    setState(() {
      isSnapchat = !isSnapchat;
    });
  }

  toggleSpotify() {
    setState(() {
      spotifyController.clear();
      isSpotify = !isSpotify;
    });
  }

  List<Social> get socials => [
        if (isFacebook)
          Social(
              title: Social.facebook, username: facebookController.text.trim()),
        if (isInstagram)
          Social(
              title: Social.instagram,
              username: instagramController.text.trim()),
        if (isTwitter)
          Social(
              title: Social.twitter, username: twitterController.text.trim()),
        if (isSnapchat)
          Social(
              title: Social.snapchat, username: snapchatController.text.trim()),
        if (isSpotify)
          Social(
              title: Social.spotify, username: spotifyController.text.trim()),
      ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initializeData();
    });
  }

//Images
  List<String> images = [];
  ImagePicker imagePicker = ImagePicker();

  bool isUploading = false;

  Future<String?> uploadFile(XFile file) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$performerId/${path.basename(file.path)}}');
    try {
      UploadTask uploadTask = storageReference.putFile(File(file.path));
      await uploadTask;
      return await storageReference.getDownloadURL();
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return const ErrorDialog(message: "Upload Failed");
          });
    }
    return null;
  }

  onImageClick() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SizeService.innerHorizontalPadding,
                          vertical: SizeService.innerPadding,
                        ),
                        child: Text(
                          "Choose Source",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          setState(() {
                            isUploading = true;
                          });
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.camera);
                          await uploadFile(file!).then((url) {
                            setState(() {
                              images.add(url!);
                            });
                            setState(() {
                              isUploading = false;
                            });
                          }).then((value) {
                            Navigator.pop(context);
                          });
                        },
                        leading: const Icon(Icons.camera_alt),
                        title: const Text("Camera"),
                      ),
                      ListTile(
                        onTap: () async {
                          setState(() {
                            isUploading = true;
                          });
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          await uploadFile(file!).then((url) {
                            setState(() {
                              images.add(url!);
                            });
                            setState(() {
                              isUploading = false;
                            });
                          }).then((value) {
                            Navigator.pop(context);
                          });
                        },
                        leading: const Icon(Icons.photo_library),
                        title: const Text("Gallery"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

//Submit
  Future<void> onSubmit() async {
    Performer performer = Performer(
      email: emailController.text.trim(),
      id: performerId,
      name: nameController.text.trim(),
      bio: bioController.text.trim(),
      genre: tags,
      country: countryController.text.trim(),
      avatarURL: avatarURLController.text.trim(),
      socials: socials,
      images: images,
    );
    if (widget.isEdit) {
      FirebaseFirestore.instance
          .collection("Performer")
          .doc(performerId)
          .update(performer.toJson())
          .then((value) => Navigator.pop(context));
    } else {
      FirebaseFirestore.instance
          .collection("Performer")
          .doc(performerId)
          .set(performer.toJson())
          .then((value) => Navigator.pop(context));
    }
  }

  String? val;
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
        child: GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0.0,
                    title: Text(
                        widget.isEdit ? "Edit Performer" : "Add Performer"),
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
                                          borderRadius: BorderRadius.circular(
                                              SizeService.borderRadius),
                                        ),
                                        title: const Text("Are You Sure?"),
                                        content: const Text(
                                            "Do you want to delete this performer?"),
                                        actions: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  SizeService.innerPadding),
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                              padding: const EdgeInsets.all(
                                                  SizeService.innerPadding),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection("Performer")
                                                      .doc(widget.performer!.id)
                                                      .delete()
                                                      .then((value) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Successfully Deleted Performer ${widget.performer!.name}");
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        SizeService
                                                            .borderRadius,
                                                      ),
                                                    ),
                                                    primary: Colors.red[600]),
                                                child: Text(
                                                  "Delete",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
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
                      padding: const EdgeInsets.all(SizeService.innerPadding),
                      child: Column(
                        children: [
                          AvatarUI(
                              userId: widget.person.userId,
                              avatarURLController: avatarURLController),
                          const SizedBox(
                              height: SizeService.separatorHeight * 4),
                          CustomTextField(
                            textEditingController: nameController,
                            lableText: "Name",
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          CustomTextField(
                            textEditingController: bioController,
                            lableText: "Bio",
                            maxLines: 4,
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          CustomTextField(
                            textEditingController: emailController,
                            lableText: "Email",
                          ),
                          const SizedBox(height: SizeService.separatorHeight),
                          CustomTextField(
                            textEditingController: countryController,
                            lableText: "Country",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SizeService.innerPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 0,
                            children: tags
                                .map(
                                  (e) => InputChip(
                                    padding: const EdgeInsets.all(2.0),
                                    avatar: CircleAvatar(
                                      backgroundColor:
                                          DarkTheme.mainBackgroundColor,
                                      child: Text(e[0]),
                                    ),
                                    label: Text(
                                      e,
                                      style: TextStyle(
                                          color: _isSelected
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    selected: _isSelected,
                                    selectedColor: Colors.blue.shade600,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _isSelected = selected;
                                      });
                                    },
                                    onDeleted: () {
                                      setState(() {
                                        tags.remove(e);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          Container(
                            key: widget.key,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(
                                  SizeService.borderRadius),
                              boxShadow: [
                                ThemeService.boxShadow(context),
                              ],
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(
                                  SizeService.borderRadius),
                              underline: const Center(),
                              value: val,
                              hint: Text(
                                "Select Genres",
                                style: GoogleFonts.lato(
                                  fontSize: 14.0,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              items: dropdownItems,
                              onChanged: (val) {
                                // setState(() {
                                //   val = val!;
                                // });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: SizeService.separatorHeight),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Social",
                            key: widget.key,
                            style: GoogleFonts.lato(
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SizeService.innerPadding),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8.0,
                        children: [
                          IconButton(
                            onPressed: toggleFacebook,
                            icon: Icon(
                              FontAwesomeIcons.facebook,
                              color: isFacebook
                                  ? Colors.blue
                                  : Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleInstagram,
                            icon: Icon(
                              FontAwesomeIcons.instagram,
                              color: isInstagram
                                  ? Colors.pink
                                  : Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleTwitter,
                            icon: Icon(
                              FontAwesomeIcons.twitter,
                              color: isTwitter
                                  ? Colors.blue[300]
                                  : Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleSnapchat,
                            icon: Icon(
                              FontAwesomeIcons.snapchat,
                              color: isSnapchat
                                  ? Colors.yellow
                                  : Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleSpotify,
                            icon: Icon(
                              FontAwesomeIcons.spotify,
                              color: isSpotify
                                  ? Colors.green
                                  : Theme.of(context).primaryIconTheme.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(SizeService.innerPadding),
                      child: Column(
                        children: [
                          if (isFacebook)
                            CustomSocialTextField(
                              textEditingController: facebookController,
                              lableText: "Facebook",
                              prefix: const Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue,
                              ),
                              suffix: IconButton(
                                onPressed: toggleFacebook,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          if (isInstagram)
                            CustomSocialTextField(
                              textEditingController: instagramController,
                              lableText: "Instagram",
                              prefix: const Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.pink,
                              ),
                              suffix: IconButton(
                                onPressed: toggleInstagram,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          if (isTwitter)
                            CustomSocialTextField(
                              textEditingController: twitterController,
                              lableText: "Twitter",
                              prefix: Icon(
                                FontAwesomeIcons.twitter,
                                color: Colors.blue[300],
                              ),
                              suffix: IconButton(
                                onPressed: toggleTwitter,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          if (isSnapchat)
                            CustomSocialTextField(
                              textEditingController: snapchatController,
                              lableText: "Snapchat",
                              prefix: const Icon(
                                FontAwesomeIcons.snapchat,
                                color: Colors.yellow,
                              ),
                              suffix: IconButton(
                                onPressed: toggleSnapchat,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          if (isSpotify)
                            CustomSocialTextField(
                              textEditingController: spotifyController,
                              lableText: "Spotify",
                              prefix: const Icon(
                                FontAwesomeIcons.spotify,
                                color: Colors.green,
                              ),
                              suffix: IconButton(
                                onPressed: toggleSpotify,
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
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
                          //Address
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Images",
                              key: widget.key,
                              style: GoogleFonts.lato(
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                          ),
                          const SizedBox(height: SizeService.separatorHeight),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 6.0),
                                  height: SizeService(context).height * 0.2,
                                  width: SizeService(context).width * 0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(
                                        SizeService.borderRadius),
                                  ),
                                  child: IconButton(
                                    onPressed: onImageClick,
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                                Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children: images
                                      .map((e) => Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        SizeService
                                                            .borderRadius),
                                                child: Image.network(
                                                  e,
                                                  height: SizeService(context)
                                                          .height *
                                                      0.2,
                                                  width: SizeService(context)
                                                          .width *
                                                      0.25,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    boxShadow: [
                                                      ThemeService.boxShadow(
                                                          context),
                                                    ],
                                                  ),
                                                  child: IconButton(
                                                    iconSize: 12.0,
                                                    onPressed: () {
                                                      setState(() {
                                                        images.remove(e);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.clear,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(SizeService.innerPadding),
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
                    padding: const EdgeInsets.all(SizeService.innerPadding),
                    child: ElevatedButton(
                      onPressed: isUploading ? null : onSubmit,
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
          ],
        ),
      ),
    ));
  }
}
