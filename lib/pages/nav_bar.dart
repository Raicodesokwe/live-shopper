import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:liveshopper/pages/add_page.dart';
import 'package:liveshopper/pages/home_page.dart';
import 'package:liveshopper/pages/messages_page.dart';
import 'package:liveshopper/pages/profile_page.dart';
import 'package:liveshopper/pages/search_page.dart';
import 'package:liveshopper/widgets/custom_border.dart';

import '../utils/app_color.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selectedIndex = 0;
  List pages = [
    HomePage(),
    SearchPage(),
    AddPage(),
    MessagesPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppColor.greenColor,
            unselectedItemColor: AppColor.whiteColor,
            onTap: _onItemTapped,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: selectedIndex,
            backgroundColor: AppColor.whiteColor.withOpacity(0.1),
            items: [
              BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(
                    Icons.holiday_village,
                  )),
              BottomNavigationBarItem(
                  label: 'Search',
                  icon: Icon(
                    Icons.search,
                  )),
              BottomNavigationBarItem(
                  label: 'Add',
                  icon: CustomOutlineButton(
                    height: 50,
                    width: 50,
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
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  )),
              BottomNavigationBarItem(
                  label: 'Message',
                  icon: Icon(
                    Icons.message,
                  )),
              BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(
                    Icons.person,
                  )),
            ]),
        body: PageTransitionSwitcher(
            duration: Duration(seconds: 1),
            transitionBuilder: (child, animation, secondaryAnimation) =>
                FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                ),
            child: pages[selectedIndex]));
  }
}
