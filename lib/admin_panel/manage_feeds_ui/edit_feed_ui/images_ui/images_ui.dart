import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/admin_panel/manage_feeds_ui/edit_feed_ui/edit_feed_ui_bloc.dart';
import 'package:tunes_lovers/custom_widgets/error_dialog/error_dialog.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/services/size_service/size_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImagesUI extends StatefulWidget {
  final Person person;
  final List<String> images;
  final EditFeedUIBloc editFeedUIBloc;

  const ImagesUI({
    Key? key,
    required this.person,
    required this.images,
    required this.editFeedUIBloc,
  }) : super(key: key);

  @override
  State<ImagesUI> createState() => _ImagesUIState();
}

class _ImagesUIState extends State<ImagesUI> {
  ImagePicker imagePicker = ImagePicker();
//Images

  Future<String?> uploadFile(XFile file) async {
    String uuid = const Uuid().v4();

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$uuid/${path.basename(file.path)}}');
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
                            widget.images.add(url!);
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
                            widget.images.add(url!);
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 6.0),
            height: SizeService(context).height * 0.15,
            width: SizeService(context).width * 0.4,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(SizeService.borderRadius),
            ),
            child: IconButton(
              onPressed: onImageClick,
              icon: const Icon(Icons.add),
            ),
          ),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: widget.images
                .map((e) => Stack(
                      children: [
                        ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeService.borderRadius),
                            child: CachedNetworkImage(
                              imageUrl: e,
                              height: SizeService(context).height * 0.15,
                              width: SizeService(context).width * 0.4,
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconButton(
                              iconSize: 15.0,
                              onPressed: () {
                                setState(() {
                                  widget.images.remove(e);
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
    );
  }
}
