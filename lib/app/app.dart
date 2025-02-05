import 'package:flutter/material.dart';
import 'package:learnito/app/routes.dart';
import 'package:learnito/app/routes_name.dart';
import 'package:learnito/app/theme.dart';

import '../presentation/coloring/coloring_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme.lightTheme,
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoutes);
    // home: DrawingScreen(),
    // );
  }
}
