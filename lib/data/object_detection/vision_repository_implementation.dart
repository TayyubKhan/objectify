import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';

import '../../app/constant.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/object_detection/object_detection_entity.dart';
import '../../domain/object_detection/object_metrics_entity.dart';
import 'object_detection_repository.dart';


class VisionRepositoryImpl implements VisionRepository {
  late FlutterVision _vision;
  final Map<String, ObjectMetrics> _objectMetrics = {
    'bottle': ObjectMetrics(realWidth: 8.0, calibrationDistance: 60.0, calibrationPixels: 67.99305),
    'person': ObjectMetrics(realWidth: 46.0, calibrationDistance: 150.0, calibrationPixels: 179.37023),
    'book': ObjectMetrics(realWidth: 16.0, calibrationDistance: 40.0, calibrationPixels: 180.96644),
    'cup': ObjectMetrics(realWidth: 8.0, calibrationDistance: 30.0, calibrationPixels: 120.0),
    'tv': ObjectMetrics(realWidth: 52.0, calibrationDistance: 200.0, calibrationPixels: 150.0),
    'keyboard': ObjectMetrics(realWidth: 44.0, calibrationDistance: 60.0, calibrationPixels: 200.0),
  };

  VisionRepositoryImpl() {
    _vision = FlutterVision();
  }

  @override
  Future<void> loadModel() async {
    try {
      await _vision.loadYoloModel(
        labels: AppConstants.labelsPath,
        modelPath: AppConstants.modelPath,
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true,
      );
    } catch (e) {
      throw VisionException('Failed to load model', e.toString());
    }
  }

  @override
  Future<List<DetectionResult>> processImage(CameraImage image) async {
    try {
      final bytesList = image.planes.map((plane) => plane.bytes).toList();

      final results = await _vision.yoloOnFrame(
        bytesList: bytesList,
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: AppConstants.iouThreshold,
        confThreshold: AppConstants.confidenceThreshold,
        classThreshold: AppConstants.classThreshold,
      );

      return results.map((result) {
        final tag = result['tag'] as String;
        final box = (result['box'] as List).map((e) => e as double).toList();
        final confidence = result['confidence'] as double;

        final distance = _calculateDistance(
          tag,
          box[2] - box[0],
          image.width.toDouble(),
        );

        return DetectionResult(
          tag: tag,
          box: box,
          confidence: confidence,
          distanceInCm: distance,
        );
      }).toList();
    } catch (e) {
      throw VisionException('Failed to process image', e.toString());
    }
  }

  double _calculateDistance(String tag, double boxWidth, double imageWidth) {
    final metrics = _objectMetrics[tag];
    if (metrics == null) return 0.0;

    final focalLength = (metrics.calibrationPixels * metrics.calibrationDistance) /
        metrics.realWidth;
    return (metrics.realWidth * focalLength) / (boxWidth * imageWidth);
  }

  @override
  Future<void> dispose() async {
    try {
      await _vision.closeYoloModel();
    } catch (e) {
      throw VisionException('Failed to dispose vision', e.toString());
    }
  }
}