import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveshopper/pages/home_page.dart';
import 'package:liveshopper/services/video_service.dart';
import 'package:liveshopper/utils/app_color.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../widgets/custom_border.dart';

class CaptionScreen extends StatefulWidget {
  final File videoFile;

  final String videoPath;
  const CaptionScreen(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  @override
  State<CaptionScreen> createState() => _CaptionScreenState();
}

class _CaptionScreenState extends State<CaptionScreen> {
  double progress = 0.0;
  late VideoPlayerController controller;
  TextEditingController captionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  final _captionForm = GlobalKey<FormState>();
  late String caption;
  bool isLoading = false;
  checkFields() {
    final form = _captionForm.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  var message = 'Something went wrong';
  User? user = FirebaseAuth.instance.currentUser;
  int? len;
  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: size.width,
              height: size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Form(
                      key: _captionForm,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColor.whiteColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: captionController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a caption';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              caption = value;
                            },
                            cursorColor: Colors.white30,
                            style: GoogleFonts.prompt(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.closed_caption),
                                prefixIconColor: Colors.white,
                                hintText: 'caption',
                                hintStyle:
                                    GoogleFonts.prompt(color: Colors.white),
                                border: InputBorder.none),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (!isKeyboard)
                      captionController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () async {
                                if (checkFields()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    final DocumentSnapshot userData =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .get();

                                    String url =
                                        await VideoService.uploadVideoUrl(
                                            user!, widget.videoPath);
                                    String thumbnailUrl =
                                        await VideoService.uploadThumbnail(
                                            user!, widget.videoPath);

                                    await FirebaseFirestore.instance
                                        .collection('videos')
                                        .add({
                                      'caption': caption,
                                      'video_url': url,
                                      'thumbnail_url': thumbnailUrl,
                                      'image_url': userData['image_url'],
                                      'username': userData['username']
                                    });
                                    Navigator.of(context).pop();
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (e.message != null) {
                                      message = e.message!;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(e.message.toString())));
                                  }
                                }
                              },
                              child: CustomOutlineButton(
                                padding: EdgeInsets.all(3),
                                strokeWidth: 3,
                                radius: 20,
                                gradient: LinearGradient(
                                    colors: [
                                      AppColor.pinkColor,
                                      AppColor.greenColor,
                                    ],
                                    stops: [
                                      0.2,
                                      0.6,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                child: Container(
                                  child: Center(
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              color: AppColor.whiteColor,
                                            )
                                          : Text(
                                              'Share',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColor.pinkColor
                                                .withOpacity(0.5),
                                            blurRadius: 45,
                                            spreadRadius: 15,
                                            offset: Offset(0, 0)),
                                        BoxShadow(
                                            color: AppColor.greenColor
                                                .withOpacity(0.5),
                                            blurRadius: 45,
                                            spreadRadius: 15,
                                            offset: Offset(0, 0)),
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.pinkColor.withOpacity(0.5),
                                          AppColor.greenColor.withOpacity(0.5),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                height: 50,
                                width: size.width * 0.7,
                              ),
                            )
                          : CustomOutlineButton(
                              padding: EdgeInsets.all(3),
                              strokeWidth: 3,
                              radius: 20,
                              gradient: LinearGradient(
                                  colors: [
                                    AppColor.pinkColor,
                                    AppColor.greenColor,
                                  ],
                                  stops: [
                                    0.2,
                                    0.6,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              child: Container(
                                child: Center(
                                    child: Text(
                                  'Share',
                                  style: TextStyle(color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                    color: AppColor.whiteColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              height: 50,
                              width: size.width * 0.7,
                            ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
