// lib/core/errors/exceptions.dart
class CameraException implements Exception {
  final String message;
  final String details;

  CameraException(this.message, this.details);

  @override
  String toString() => '$message: $details';
}
class VisionException implements Exception {
  final String message;
  final String details;

  VisionException(this.message, this.details);

  @override
  String toString() => '$message: $details';
}
