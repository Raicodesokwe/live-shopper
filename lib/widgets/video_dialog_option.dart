import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import 'custom_border.dart';

class VideoDialogOption extends StatelessWidget {
  final IconData icon;
  final String label;
  const VideoDialogOption({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomOutlineButton(
          padding: EdgeInsets.all(4),
          strokeWidth: 4,
          radius: 70,
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
                icon,
                size: 45,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          height: 70,
          width: 70,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
