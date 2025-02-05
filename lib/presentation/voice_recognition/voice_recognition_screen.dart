import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnito/domain/voice_recognition/voice_recognition_entity.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import '../../app/theme.dart';
import '../../application/voice_recognition/voice_recognition_state.dart';
import '../../data/quiz/quiz_mock_questions.dart';
import '../../data/voice_recognition/voice_recognition_questions.dart';
import '../../domain/quiz/quiz_entity.dart';




class PronunciationChecker extends ConsumerStatefulWidget {
  const PronunciationChecker({super.key});

  @override
  _PronunciationCheckerState createState() => _PronunciationCheckerState();
}

class _PronunciationCheckerState extends ConsumerState<PronunciationChecker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _speech = ref.read(speechProvider);
    _flutterTts = ref.read(ttsProvider);
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          _startListening();
        }
      },
      onError: (error) => print('Speech error: $error'),
    );
    if (available) {
      _startListening();
    } else {
      print("Speech recognition not available");
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          ref.read(spokenWordProvider.notifier).state = result.recognizedWords.toLowerCase();
          if (result.recognizedWords.isNotEmpty) {
            _checkPronunciation();
          }
        },
      );
    }
  }

  void _checkPronunciation() {
    final spokenWord = ref.read(spokenWordProvider);
    final targetWord = ref.read(voiceRecognitionProvider).correctAnswer;

    if (spokenWord.isNotEmpty) {
      double similarity = spokenWord.similarityTo(targetWord);
      ref.read(accuracyProvider.notifier).state = similarity * 100;
      _controller.forward();
      _provideFeedback();
    }
  }

  void _provideFeedback() async {
    final accuracyScore = ref.read(accuracyProvider);
    String feedback;
    if (accuracyScore >= 80) {
      feedback = "Excellent pronunciation!";
    } else if (accuracyScore >= 60) {
      feedback = "Good try! Keep practicing.";
    } else {
      feedback = "Let's try again!";
    }
    await _flutterTts.speak(feedback);
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = ref.watch(voiceRecognitionProvider);
    final accuracyScore = ref.watch(accuracyProvider);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        title: const Text(
          'Coloring',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(currentQuestion.assetPath, height: 120),
            SizedBox(height: 30),
            Text(
              currentQuestion.correctAnswer.toUpperCase(),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/animations/soundanimation.json',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            if (accuracyScore > 0)
              Column(
                children: [
                  ScaleTransition(
                    scale: _controller,
                    child: Text(
                      '${accuracyScore.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 30,
                        color: accuracyScore >= 80 ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Lottie.asset(
                    accuracyScore >= 80 ? 'assets/success.json' : 'assets/try_again.json',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    _flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }
}
