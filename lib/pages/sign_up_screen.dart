import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveshopper/pages/nav_bar.dart';
import 'package:liveshopper/services/auth_service.dart';
import 'package:liveshopper/utils/app_color.dart';
import 'package:liveshopper/widgets/background_neon.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/custom_border.dart';
import '../widgets/pic_modal.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  final _emailForm = GlobalKey<FormState>();

  checkFields() {
    final form = _emailForm.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  File? imgFile;
  String? url;
  void _pickedImg(File img) {
    imgFile = img;
  }

  late String email;

  late String name;

  late String password;

  late String confirmPassword;

  bool isLoading = false;

  var message = 'Something went wrong';

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
        child: Form(
      key: _emailForm,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PicModal(imagePickFunktion: _pickedImg),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: emailNameController,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  cursorColor: Colors.white30,
                  style: GoogleFonts.prompt(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'email',
                      hintStyle: GoogleFonts.prompt(color: Colors.white),
                      border: InputBorder.none),
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  cursorColor: Colors.white30,
                  style: GoogleFonts.prompt(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'password',
                      hintStyle: GoogleFonts.prompt(color: Colors.white),
                      border: InputBorder.none),
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    color: AppColor.whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return 'Please enter a valid username, at least 4 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  cursorColor: Colors.white30,
                  style: GoogleFonts.prompt(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'username',
                      hintStyle: GoogleFonts.prompt(color: Colors.white),
                      border: InputBorder.none),
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            if (!isKeyboard)
              emailNameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      nameController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () async {
                        if (checkFields()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            // AuthService.signUp(
                            //     email, password, imgFile!, nameController.text);
                            String url;
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email.trim(),
                                    password: password.trim())
                                .then((value) async {
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('user_images')
                                  .child('${value.user!.uid}.jpg');
                              await ref.putFile(imgFile!);
                              url = await ref.getDownloadURL();

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(value.user!.uid)
                                  .set({
                                'username': name.trim(),
                                'image_url': url
                              });
                            });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavBar()));
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isLoading = false;
                            });

                            if (e.message != null) {
                              message = e.message!;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message.toString())));
                          }
                        }
                      },
                      child: CustomOutlineButton(
                        padding: EdgeInsets.all(3),
                        strokeWidth: 3,
                        radius: 20,
                        gradient: LinearGradient(
                            colors: [
                              AppColor.pinkColor,
                              AppColor.greenColor,
                            ],
                            stops: [
                              0.2,
                              0.6,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        child: Container(
                          child: Center(
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: AppColor.whiteColor,
                                    )
                                  : Text(
                                      'Sign in',
                                      style: TextStyle(color: Colors.white),
                                    )),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: AppColor.pinkColor.withOpacity(0.5),
                                    blurRadius: 45,
                                    spreadRadius: 15,
                                    offset: Offset(0, 0)),
                                BoxShadow(
                                    color: AppColor.greenColor.withOpacity(0.5),
                                    blurRadius: 45,
                                    spreadRadius: 15,
                                    offset: Offset(0, 0)),
                              ],
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
                      ))
                  : CustomOutlineButton(
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
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: AppColor.whiteColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      height: 50,
                      width: size.width * 0.7,
                    ),
          ],
        ),
      ),
    ));
  }
}
