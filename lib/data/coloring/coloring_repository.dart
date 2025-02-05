// Data Layer: Repository Interface
import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract class ImageRepository {
  Future<Uint8List?> pickImage();
  Future<Uint8List?> convertToSketch(Uint8List image);
  Future<Uint8List?> colorSketch(Uint8List sketchImage, Color color);
  Future<bool> saveImage(Uint8List image);
}
