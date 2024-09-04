
import 'package:flutter/material.dart';

import 'Views/Splash Screen.dart';

main() async {
 
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
    );
  }
}
