import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/custom_widgets/error_dialog/error_dialog.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUI extends StatefulWidget {
  final String userId;
  final TextEditingController avatarURLController;
  const AvatarUI(
      {Key? key, required this.userId, required this.avatarURLController})
      : super(key: key);

  @override
  State<AvatarUI> createState() => _AvatarUIState();
}

class _AvatarUIState extends State<AvatarUI> {
  ImagePicker imagePicker = ImagePicker();
  Future<String?> uploadFile(XFile file) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('${widget.userId}/${path.basename(file.path)}}');
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
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.camera);
                          await uploadFile(file!).then((url) {
                            setState(() {
                              widget.avatarURLController.text = url!;
                            });
                            Navigator.pop(context);
                          });
                        },
                        leading: const Icon(Icons.camera_alt),
                        title: const Text("Camera"),
                      ),
                      ListTile(
                        onTap: () async {
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          await uploadFile(file!).then((url) {
                            setState(() {
                              widget.avatarURLController.text = url!;
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
    return Stack(
      children: [
        Container(
          key: widget.key,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              ThemeService.boxShadow(context),
            ],
          ),
          child: widget.avatarURLController.text == ""
              ? CircleAvatar(
                  key: widget.key,
                  backgroundColor: Theme.of(context).cardTheme.color,
                  radius: 60.0,
                  child: Icon(
                    Icons.person,
                    key: widget.key,
                    color: Theme.of(context).iconTheme.color,
                    size: 50.0,
                  ),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.avatarURLController.text,
                  ),
                  backgroundColor: Theme.of(context).cardTheme.color,
                  radius: 60.0,
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            key: widget.key,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                ThemeService.boxShadow(context),
              ],
            ),
            child: IconButton(
              iconSize: 20.0,
              onPressed: () {
                onImageClick();
              },
              icon: const Icon(Icons.camera_alt),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
