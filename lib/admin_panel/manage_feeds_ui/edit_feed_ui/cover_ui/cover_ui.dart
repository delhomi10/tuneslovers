import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/edit_feed_ui_bloc.dart';
import 'package:tunes_lovers/custom_widgets/error_dialog/error_dialog.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class CoverUI extends StatefulWidget {
  final Person person;
  final TextEditingController coverController;
  final EditFeedUIBloc editFeedUIBloc;
  const CoverUI({
    Key? key,
    required this.person,
    required this.coverController,
    required this.editFeedUIBloc,
  }) : super(key: key);
  @override
  State<CoverUI> createState() => _CoverUIState();
}

class _CoverUIState extends State<CoverUI> {
  ImagePicker imagePicker = ImagePicker();
  Future<String?> uploadFile(XFile file) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('cover/${path.basename(file.path)}}');
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
    } finally {
      widget.editFeedUIBloc.update(isUploading: false);
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
                          widget.editFeedUIBloc.update(isUploading: true);
                          Navigator.pop(context);

                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.camera);
                          await uploadFile(file!).then((url) {
                            setState(() {
                              widget.coverController.text = url!;
                            });
                          });
                        },
                        leading: const Icon(Icons.camera_alt),
                        title: const Text("Camera"),
                      ),
                      ListTile(
                        onTap: () async {
                          widget.editFeedUIBloc.update(isUploading: true);
                          Navigator.pop(context);

                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          await uploadFile(file!).then((url) {
                            setState(() {
                              widget.coverController.text = url!;
                            });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(SizeService.borderRadius),
      ),
      height: SizeService(context).height * 0.25,
      child: widget.coverController.text == ""
          ? TextButton.icon(
              onPressed: onImageClick,
              icon: const Icon(
                Icons.camera_alt,
                color: LightTheme.secondaryTextColor,
                size: 30.0,
              ),
              label: Text(
                "Choose Cover",
                style: GoogleFonts.lato(
                  color: LightTheme.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(SizeService.borderRadius),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.coverController.text.trim(),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      key: widget.key,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          ThemeService.boxShadow(context),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 20.0,
                        onPressed: onImageClick,
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
