import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liveshopper/pages/caption_screen.dart';
import 'package:liveshopper/widgets/video_dialog_option.dart';

import '../utils/app_color.dart';
import 'custom_border.dart';

class VideoPicker extends StatefulWidget {
  const VideoPicker({Key? key}) : super(key: key);

  @override
  State<VideoPicker> createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CaptionScreen(
                videoFile: File(video.path),
                videoPath: video.path,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
        backgroundColor: AppColor.blackColor,
        title: Text(
          'Pick video',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () {
                    pickVideo(ImageSource.camera, context);
                  },
                  child:
                      VideoDialogOption(icon: Icons.camera, label: 'Camera')),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  pickVideo(ImageSource.gallery, context);
                },
                child: VideoDialogOption(
                    icon: Icons.photo_camera_back, label: 'Gallery'),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
