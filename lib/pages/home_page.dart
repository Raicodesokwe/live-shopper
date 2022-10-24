import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:liveshopper/widgets/background_neon.dart';
import 'package:liveshopper/widgets/circle_animation.dart';
import 'package:liveshopper/widgets/video_display.dart';

import '../utils/app_color.dart';
import '../widgets/custom_border.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List videosList = [];
  late Stream<QuerySnapshot<Map<String, dynamic>>> videoStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoStream = FirebaseFirestore.instance.collection('videos').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
      child: StreamBuilder(
          stream: videoStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.docs.length == 0) {
              return Center(
                child: Text(
                  'Add \nVideos',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColor.whiteColor,
              ));
            }
            final videolist = snapshot.data!.docs;
            videosList.map((e) {
              Map<String, dynamic> data = e.data() as Map<String, dynamic>;
            }).toList();
            return PageView.builder(
                itemCount: videolist.length,
                scrollDirection: Axis.vertical,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                itemBuilder: (context, index) {
                  final details = videolist[index];
                  return Stack(
                    children: [
                      VideoDisplay(videoUrl: details['video_url']),
                      Positioned(
                        bottom: size.height * 0.11,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              details['username'],
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              width: size.width * 0.5,
                              height: size.height * 0.1,
                              child: Text(
                                details['caption'],
                                style: GoogleFonts.prompt(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: size.height * 0.17,
                          right: 20,
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CustomOutlineButton(
                                    padding: EdgeInsets.all(2),
                                    strokeWidth: 4,
                                    radius: 60,
                                    gradient: LinearGradient(
                                        colors: [
                                          AppColor.pinkColor,
                                          AppColor.pinkColor.withOpacity(0),
                                          AppColor.greenColor.withOpacity(0.1),
                                          AppColor.greenColor
                                        ],
                                        stops: [
                                          0.2,
                                          0.4,
                                          0.6,
                                          1
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  details['image_url']))),
                                    ),
                                    height: 60,
                                    width: 60,
                                  ),
                                  Positioned(
                                      bottom: -10,
                                      right: 20,
                                      child: Container(
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: AppColor.pinkColor,
                                            shape: BoxShape.circle),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Icon(
                                FontAwesomeIcons.heart,
                                color: AppColor.pinkColor,
                                size: 35,
                              ),
                              Text(
                                '2',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Icon(
                                Icons.message,
                                color: Colors.white,
                              ),
                              Text(
                                '1',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Icon(
                                FontAwesomeIcons.share,
                                color: Colors.white,
                              ),
                              Text(
                                '0',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              CircleAnimation()
                            ],
                          ))
                    ],
                  );
                });
          }),
    );
  }
}
