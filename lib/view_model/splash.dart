import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_safety_app/res/const/firebase_const.dart';
import 'package:women_safety_app/views/child/home/home_screen.dart';
import 'package:women_safety_app/views/child/auth/login_screen.dart';
import 'package:women_safety_app/views/parents/parent_home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_fadeController);

    // Start the fade animation
    _fadeController.forward();

    // Start the timer for navigation after splash screen
    SplashScreenMethod().startTimer(context);
  }

  @override
  void dispose() {
    _fadeController.dispose(); // Clean up the controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo in the center
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              // Text under the logo
              Text(
                'Her Safety, Our Mission',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreenMethod {
  void startTimer(BuildContext context) {
    Timer(const Duration(seconds: 2), () async {
      if (auth.currentUser == null) {
        Get.off(() => const LoginScreen());
      } else {
        firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) {
          if (value['type'] == 'parent') {
            Get.off(() => const ParentHomeScreen());
          } else {
            Get.off(() => const HomeScreen());
          }
        });
      }
    });
  }
}
