
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/voice_recognition/voice_recognition_questions.dart';
import '../../domain/voice_recognition/voice_recognition_entity.dart';

final speechProvider = Provider((ref) => stt.SpeechToText());
final ttsProvider = Provider((ref) => FlutterTts());

final voiceRecognitionProvider = StateNotifierProvider<VoiceRecognitionController, VoiceRecognitionEntity>((ref) {
  return VoiceRecognitionController();
});

final accuracyProvider = StateProvider<double>((ref) => 0.0);
final spokenWordProvider = StateProvider<String>((ref) => '');
class VoiceRecognitionController extends StateNotifier<VoiceRecognitionEntity> {
  VoiceRecognitionController() : super(voiceRecognitionQuestions[0]) {
    setNewQuestion();
  }

  void setNewQuestion() {
    final random = DateTime.now().millisecondsSinceEpoch % voiceRecognitionQuestions.length;
    state = voiceRecognitionQuestions[random];
  }
}
