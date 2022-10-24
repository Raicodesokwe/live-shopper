import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liveshopper/utils/app_color.dart';

import 'custom_border.dart';

class PicModal extends StatefulWidget {
  final void Function(File _pickedImg) imagePickFunktion;

  const PicModal({Key? key, required this.imagePickFunktion}) : super(key: key);

  @override
  State<PicModal> createState() => _PicModalState();
}

class _PicModalState extends State<PicModal> {
  File? _pickedImg;
  void _openGallery(BuildContext context) async {
    final picture = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 80, maxWidth: 150);
    final pickedImageFile = File(picture!.path);
    setState(() {
      _pickedImg = pickedImageFile;
    });
    widget.imagePickFunktion(pickedImageFile);
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    final picture = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80, maxWidth: 150);
    final pickedImageFile = File(picture!.path);
    setState(() {
      _pickedImg = pickedImageFile;
    });
    widget.imagePickFunktion(pickedImageFile);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showSelectionDialog(BuildContext context) {
      return Platform.isIOS
          ? showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: CupertinoAlertDialog(
                    title: Text(
                      'PICK IMAGE FROM :',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.prompt(fontWeight: FontWeight.w700),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Theme.of(context).backgroundColor),
                          child: Center(
                            child: GestureDetector(
                              child: Text(
                                "Gallery",
                                style: GoogleFonts.prompt(
                                    fontWeight: FontWeight.w600),
                              ),
                              onTap: () {
                                _openGallery(context);
                              },
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(8.0)),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Theme.of(context).backgroundColor),
                          child: Center(
                            child: GestureDetector(
                              child: Text(
                                "Camera",
                                style: GoogleFonts.prompt(
                                    fontWeight: FontWeight.w600),
                              ),
                              onTap: () {
                                _openCamera(context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
          : showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: AppColor.blackColor,
                  title: const Text(
                    'PICK IMAGE FROM :',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openGallery(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: AppColor.whiteColor.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text(
                              "Gallery",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        onTap: () {
                          _openCamera(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: AppColor.whiteColor.withOpacity(0.1)),
                          child: Center(
                            child: Text("Camera",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
    }

    return GestureDetector(
      onTap: () {
        _showSelectionDialog(context);
      },
      child: CustomOutlineButton(
        padding: EdgeInsets.all(4),
        strokeWidth: 4,
        radius: 100,
        gradient: LinearGradient(colors: [
          AppColor.pinkColor,
          AppColor.pinkColor.withOpacity(0),
          AppColor.greenColor.withOpacity(0.1),
          AppColor.greenColor
        ], stops: [
          0.2,
          0.4,
          0.6,
          1
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        child: Container(
          decoration: _pickedImg == null
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.whiteColor.withOpacity(0.1))
              : BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 4),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: FileImage(_pickedImg!))),
          child: _pickedImg == null
              ? Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 56,
                    color: AppColor.whiteColor,
                  ),
                )
              : Container(),
        ),
        height: 100,
        width: 100,
      ),
    );
    // return Column(
    //   children: [
    //     Container(
    //       padding: const EdgeInsets.all(10),
    //       decoration: decorator.copyWith(
    //           shape: BoxShape.circle, color: Theme.of(context).backgroundColor),
    //       child: Container(
    //         height: 80,
    //         width: 80,
    //         child: _pickedImg == null
    //             ? Center(
    //                 child: Image.asset(
    //                 'assets/images/puppy.png',
    //                 scale: 2,
    //               ))
    //             : Container(),
    //         decoration: _pickedImg == null
    //             ? BoxDecoration(
    //                 color: Colors.greenAccent,
    //                 border: Border.all(color: Colors.black54, width: 4),
    //                 shape: BoxShape.circle,
    //               )
    //             : BoxDecoration(
    //                 border: Border.all(color: Colors.black54, width: 4),
    //                 shape: BoxShape.circle,
    //                 image: DecorationImage(
    //                     fit: BoxFit.cover, image: FileImage(_pickedImg!))),
    //       ),
    //     ),
    //     ElevatedButton.icon(
    //       onPressed: () {
    //         _showSelectionDialog(context);
    //       },
    //       //pointer to function

    //       label: Text(
    //         'Add Avatar',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       icon: Icon(FontAwesomeIcons.cameraRetro),
    //       style: ButtonStyle(
    //           elevation: MaterialStateProperty.all(7),
    //           backgroundColor: MaterialStateProperty.all(Colors.black)),
    //     ),
    //   ],
    // );
  }
}
