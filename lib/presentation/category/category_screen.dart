import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../../app/routes_name.dart';
import '../../app/theme.dart';
import '../../application/coloring/coloring_state.dart';
import '../../data/category/category_provider.dart';

// Provider to manage category images

class CategoryScreen extends ConsumerWidget {
  CategoryScreen({super.key});

  final List<CategoryItem> categories = [
    CategoryItem(
      title: 'Alphabet',
      icon: Icons.abc,
      color: Colors.blue,
      assetPath: 'assets/Coloring/alphabet',
    ),
    CategoryItem(
      title: 'Animals',
      icon: Icons.pets,
      color: Colors.green,
      assetPath: 'assets/Coloring/animals',
    ),
    CategoryItem(
      title: 'Cartoons',
      icon: Icons.child_care,
      color: Colors.purple,
      assetPath: 'assets/Coloring/cartoons',
    ),
    CategoryItem(
      title: 'Fruits',
      icon: Icons.apple,
      color: Colors.red,
      assetPath: 'assets/Coloring/fruits',
    ),
    CategoryItem(
      title: 'Numbers',
      icon: Icons.numbers,
      color: Colors.orange,
      assetPath: 'assets/Coloring/numbers',
    ),
    CategoryItem(
      title: 'Plants',
      icon: Icons.local_florist,
      color: Colors.teal,
      assetPath: 'assets/Coloring/plants',
    ),
    CategoryItem(
      title: 'Shapes',
      icon: Icons.shape_line,
      color: Colors.pink,
      assetPath: 'assets/Coloring/shapes',
    ),
    CategoryItem(
      title: 'Vehicles',
      icon: Icons.directions_car,
      color: Colors.amber,
      assetPath: 'assets/Coloring/Vehicle',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Category Screen',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            category: categories[index],
            onTap: () => _navigateToImages(context, ref, categories[index]),
          );
        },
      ),
    );
  }

  void _navigateToImages(
      BuildContext context, WidgetRef ref, CategoryItem category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageGridScreen(category: category, ref: ref),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color,
                category.color.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                category.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageGridScreen extends ConsumerWidget {
  final CategoryItem category;
  final WidgetRef ref;

  const ImageGridScreen({
    super.key,
    required this.category,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          category.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: category.color,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ref.watch(categoryImagesProvider(category.assetPath)).when(
            data: (images) {
              if (images.isEmpty) {
                return const Center(
                  child: Text(
                    'No images found in this category',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        ref.read(imageProvider.notifier).state = images[index];
                        Navigator.pushNamed(context, RoutesName.coloring);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                color: category.color,
              ),
            ),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading images: $error',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
    );
  }
}

class CategoryItem {
  final String title;
  final IconData icon;
  final Color color;
  final String assetPath;

  CategoryItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.assetPath,
  });
}
