import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnito/app/routes_name.dart';

import '../../app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutesName.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Logo
          Center(
              child: Image(
            image: AssetImage('assets/logo.png'),
          )),
          const SizedBox(height: 20),
          // App Name
          const SizedBox(height: 10),
          // Loading Indicator
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ],
      ),
    );
  }
}
