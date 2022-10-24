import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liveshopper/pages/home_page.dart';
import 'package:liveshopper/pages/landing_screen.dart';
import 'package:liveshopper/services/auth_service.dart';
import 'package:liveshopper/utils/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'grifterbold',
          scaffoldBackgroundColor: AppColor.blackColor),
      home: AuthService.handleAuth(),
    );
  }
}
