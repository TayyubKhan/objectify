// lib/features/object_detection/domain/models/object_detection_state.dart
import 'package:flutter/foundation.dart';

import '../../domain/object_detection/object_detection_entity.dart';

class ObjectDetectionState {
  final bool isInitialized;
  final bool isDetecting;
  final List<DetectionResult> detections;
  final String? error;
  final bool isLoading;

  const ObjectDetectionState({
    this.isInitialized = false,
    this.isDetecting = false,
    this.detections = const [],
    this.error,
    this.isLoading = false,
  });

  ObjectDetectionState copyWith({
    bool? isInitialized,
    bool? isDetecting,
    List<DetectionResult>? detections,
    String? error,
    bool? isLoading,
  }) {
    return ObjectDetectionState(
      isInitialized: isInitialized ?? this.isInitialized,
      isDetecting: isDetecting ?? this.isDetecting,
      detections: detections ?? this.detections,
      error: error,  // Setting to null if not provided
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ObjectDetectionState &&
        other.isInitialized == isInitialized &&
        other.isDetecting == isDetecting &&
        other.error == error &&
        other.isLoading == isLoading &&
        listEquals(other.detections, detections);
  }

  @override
  int get hashCode {
    return Object.hash(
      isInitialized,
      isDetecting,
      Object.hashAll(detections),
      error,
      isLoading,
    );
  }
}