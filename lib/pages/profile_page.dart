import 'package:flutter/material.dart';
import 'package:liveshopper/services/auth_service.dart';
import 'package:liveshopper/widgets/background_neon.dart';

import '../utils/app_color.dart';
import '../widgets/custom_border.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundNeon(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                AuthService.signOut(context);
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColor.pinkColor.withOpacity(0.5),
                        AppColor.greenColor.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.logout,
                      size: 56,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Log out',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
