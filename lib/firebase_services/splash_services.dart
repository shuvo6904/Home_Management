import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_management/ui/auth/login_screen.dart';
import 'package:home_management/ui/home/home_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final user = firebaseAuth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 3),
              () =>
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
              () =>
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen())));
    }
  }
}
