import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:learnito/data/object_detection/vision_repository_implementation.dart';

import 'object_detection_repository.dart';
import 'object_detection_repository_impl.dart';


final cameraRepositoryProvider = Provider<CameraRepository>((ref) {
  return CameraRepositoryImpl();
});

final visionRepositoryProvider = Provider<VisionRepository>((ref) {
  return VisionRepositoryImpl();
});

final cameraControllerProvider = Provider<CameraController>((ref) {
  return (ref.watch(cameraRepositoryProvider) as CameraRepositoryImpl).controller;
});
