import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_safety_app/data/background/background_services.dart';
import 'package:women_safety_app/data/shared_preferences/shared_preferences.dart';
import 'package:women_safety_app/model/contact_model.dart';
import 'package:women_safety_app/res/utils/utils.dart';
import 'package:women_safety_app/views/child/bottom_nav_bar.dart';
import 'package:women_safety_app/views/child/auth/login_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:women_safety_app/views/parents/parent_home_screen.dart';

import 'firebase_options.dart';
import 'package:hive/hive.dart';
import 'package:women_safety_app/view_model/auth/login_view_model.dart';  // Import LoginViewModel

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPrefernces.init();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register adapter
  Hive.registerAdapter(ContactModelAdapter());
  await Hive.openBox<ContactModel>('contactsData');

  await initiallizedLocalNotification();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize LoginViewModel here
  Get.put(LoginViewModel());  // Register LoginViewModel with GetX

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Woman Safety App',
      theme: ThemeData(
        textTheme: GoogleFonts.figtreeTextTheme(ThemeData.light().textTheme),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: SplashScreen(),  // Show SplashScreen initially
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Fade-in effect
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0; // Fade in to full opacity
      });
    });

    // Navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()), // Replace with your home screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1), // Fade-in effect duration
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Rounded Logo using ClipRRect
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Adjust the value as needed
                child: Image.asset(
                  'assets/logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(height: 20),
              // Text under the logo with the desired color
              Text(
                'Her Safety, Our Mission',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9c2542), // Color updated as requested
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MySharedPrefernces.getUserType(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingIndicator(); // Show a loading indicator if waiting
        }

        switch (snapshot.data) {
          case '':
            return const LoginScreen();
          case 'child':
            return const BottomNavPagesScreen();
          case 'parent':
            return const ParentHomeScreen();
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
