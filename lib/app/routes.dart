import 'package:flutter/material.dart';
import 'package:learnito/app/routes_name.dart';
import 'package:learnito/presentation/coloring/coloring_screen.dart';
import 'package:learnito/presentation/quiz/quiz_result.dart';
import 'package:learnito/presentation/quiz/quiz_screen.dart';
import '../presentation/category/category_screen.dart';
import '../presentation/drawing/drawing_screen.dart';
import '../presentation/geometry_shapes/geometry_shapes_screen.dart';
import '../presentation/home/widgets/home.dart';
import '../presentation/object_detection/object_detection_screen.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/voice_recognition/voice_recognition_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RoutesName.quiz:
        return MaterialPageRoute(
            builder: (BuildContext context) => const QuizPage());
      case RoutesName.quizResult:
        return MaterialPageRoute(
            builder: (BuildContext context) => QuizResultPage());
      case RoutesName.coloring:
        return MaterialPageRoute(
            builder: (BuildContext context) => ColoringScreen());
      case RoutesName.drawing:
        return MaterialPageRoute(
            builder: (BuildContext context) => DrawingScreen());
      case RoutesName.geometryShapes:
        return MaterialPageRoute(
            builder: (BuildContext context) => const GeometryShapesScreen());
      case RoutesName.objectDetection:
        return MaterialPageRoute(
            builder: (BuildContext context) => ObjectDetection());
      case RoutesName.categoryScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => CategoryScreen());
      case RoutesName.voiceRecognition:
        return MaterialPageRoute(
            builder: (BuildContext context) =>  PronunciationChecker());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('You are on the Wrong way'),
            ),
          );
        });
    }
  }
}
