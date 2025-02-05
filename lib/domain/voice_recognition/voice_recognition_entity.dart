class VoiceRecognitionEntity {
  final String id;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String assetPath; // Path to the photo or sound asset

  VoiceRecognitionEntity({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.assetPath,
  });
}
