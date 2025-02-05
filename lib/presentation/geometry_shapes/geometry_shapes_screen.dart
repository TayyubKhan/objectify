import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/geometry_shapes/shapeProvider.dart';

class GeometryShapesScreen extends ConsumerStatefulWidget {
  const GeometryShapesScreen({super.key});

  @override
  _GeometryShapesScreenState createState() => _GeometryShapesScreenState();
}

class _GeometryShapesScreenState extends ConsumerState<GeometryShapesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final shapes = ref.watch(shapesProvider);

    if (shapes.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No shapes available.')),
      );
    }


    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          "Learn Geometry Shapes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: AppColors.primary,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: shapes.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final shape = shapes[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: shape.name,
                          child: Image.asset(
                            shape.imagePath,
                            width: 180,
                            height: 180,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          shape.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,  // Apply dynamic text color
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
