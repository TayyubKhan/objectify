class DetectionResult {
  final String tag;
  final List<double> box;
  final double confidence;
  final double distanceInCm;

  const DetectionResult({
    required this.tag,
    required this.box,
    required this.confidence,
    required this.distanceInCm,
  });
}