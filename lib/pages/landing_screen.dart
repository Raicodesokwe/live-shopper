import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveshopper/pages/sign_up_screen.dart';
import 'package:liveshopper/utils/app_color.dart';
import 'package:liveshopper/widgets/background_neon.dart';
import 'package:liveshopper/widgets/custom_border.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late AnimationController controllerTwo;
  late Animation<double> fadeAnimationTwo;
  late AnimationController controllerThree;
  late Animation<double> fadeAnimationThree;
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(controller);

    controllerTwo =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    fadeAnimationTwo = Tween(begin: 0.0, end: 1.0).animate(controllerTwo);

    controllerThree =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    fadeAnimationThree = Tween(begin: 0.0, end: 1.0).animate(controllerThree);
    scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 550),
    );
    scaleAnimation =
        CurvedAnimation(parent: scaleController, curve: Curves.elasticInOut);
    Future.delayed(Duration(seconds: 1), () {
      controller.forward();
    });

    Future.delayed(Duration(seconds: 2), () {
      controllerTwo.forward();
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      controllerThree.forward().then((value) => scaleController.forward());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    controllerTwo.dispose();
    controllerThree.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
        child: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.07,
        ),
        Center(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: CustomOutlineButton(
              padding: EdgeInsets.all(4),
              strokeWidth: 4,
              radius: size.width * 0.8,
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
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/video.png"))),
              ),
              height: size.width * 0.8,
              width: size.width * 0.8,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.07,
        ),
        FadeTransition(
          opacity: fadeAnimationTwo,
          child: Center(
              child: Text(
            'Live shopping experience',
            style: TextStyle(fontSize: 25, color: Colors.white),
          )),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        FadeTransition(
          opacity: fadeAnimationThree,
          child: Center(
              child: Text(
            'Experience it, feel it',
            style: GoogleFonts.prompt(fontSize: 20, color: Colors.white60),
          )),
        ),
        SizedBox(
          height: size.height * 0.07,
        ),
        Center(
          child: ScaleTransition(
            scale: scaleAnimation,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: CustomOutlineButton(
                padding: EdgeInsets.all(3),
                strokeWidth: 3,
                radius: 20,
                gradient: LinearGradient(colors: [
                  AppColor.pinkColor,
                  AppColor.greenColor,
                ], stops: [
                  0.2,
                  0.6,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                child: Container(
                  child: Center(
                      child: Text(
                    'Hi,let me in',
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
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
            ),
          ),
        ),
      ],
    )));
  }
}
