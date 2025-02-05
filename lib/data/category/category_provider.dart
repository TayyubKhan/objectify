import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryImagesProvider = FutureProvider.family<List<String>, String>((ref, assetPath) async {
  try {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final categoryAssets = manifestMap.keys
        .where((String key) =>
    key.startsWith(assetPath) &&
        key.toLowerCase().endsWith('.png'))
        .toList();

    return categoryAssets;
  } catch (e) {
    print('Error loading images: $e');
    return [];
  }
});
