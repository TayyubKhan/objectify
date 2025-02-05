import 'package:flutter/material.dart';
import 'package:learnito/app/routes_name.dart';
import 'package:learnito/shared/constants/screen_arguments.dart';

import '../../../app/theme.dart';
import '../../../shared/utils/audioplayer_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioManager _audioManager = AudioManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioManager.playMusic("bgm/bg1.mp3"); // Replace with your file
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      {'title': 'Quiz', 'icon': Icons.quiz, 'route': RoutesName.quiz},
      {
        'title': 'Coloring',
        'icon': Icons.brush,
        'route': RoutesName.categoryScreen
      },
      {'title': 'Drawing', 'icon': Icons.create, 'route': RoutesName.drawing},
      {
        'title': 'Geometry Shapes',
        'icon': Icons.category,
        'route': RoutesName.geometryShapes
      },
      {
        'title': 'Object Detection',
        'icon': Icons.camera_alt,
        'route': RoutesName.objectDetection
      },
      {
        'title': 'Voice Recognition',
        'icon': Icons.record_voice_over,
        'route': RoutesName.voiceRecognition
      },
    ];
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Learnito",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  feature['route'] as String,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      feature['title'] as String,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
