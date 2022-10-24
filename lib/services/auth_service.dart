import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:liveshopper/pages/nav_bar.dart';

import '../pages/landing_screen.dart';
import '../pages/splash_screen.dart';

class AuthService {
  static handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return LandingScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return SplashScreen();
          }
          return NavBar();
        });
  }

  static signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LandingScreen()));
    } on FirebaseAuthException catch (e) {
      var message = 'Something went wrong';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  static resetPasswordLink(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
