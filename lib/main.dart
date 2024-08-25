
import 'package:flutter/material.dart';

import 'Views/Splash Screen.dart';

main() async {
 
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
