import 'package:flutter/material.dart';
import 'package:liveshopper/widgets/background_neon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundNeon(
      child: Center(
        child: Text(
          'Live \nShopping',
          style: TextStyle(color: Colors.white, fontSize: 50),
        ),
      ),
    );
  }
}
