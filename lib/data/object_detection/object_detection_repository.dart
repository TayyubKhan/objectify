import 'package:camera/camera.dart';

import '../../domain/object_detection/object_detection_entity.dart';

abstract class CameraRepository {
  Future<List<CameraDescription>> getAvailableCameras();
  Future<void> initializeCamera(CameraDescription camera);
  Future<void> startImageStream(Function(CameraImage) onImage);
  Future<void> stopImageStream();
  Future<void> dispose();
  CameraController get controller;
}

// lib/features/object_detection/domain/repositories/vision_repository.dart
abstract class VisionRepository {
  Future<void> loadModel();
  Future<List<DetectionResult>> processImage(CameraImage image);
  Future<void> dispose();
}
