import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnito/presentation/quiz/quiz_result.dart';
import '../../app/theme.dart';
import '../../application/quiz/quiz_notifier.dart';
import '../../shared/widgets/glossy_button.dart';

class QuizPage extends ConsumerWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider);

    if (quizState.isLoading) {
      return const QuizLoading();
    }
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Quiz: Question ${quizState.currentIndex + 1}/${quizState.questions.length}',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: QuizContent(quizState: quizState),
    );
  }
}

class QuizLoading extends StatelessWidget {
  const QuizLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Quiz'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
    );
  }
}

class QuizContent extends ConsumerWidget {
  final dynamic quizState;

  QuizContent({required this.quizState, super.key});
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestion = quizState.questions[quizState.currentIndex];
    final isAudio = currentQuestion.assetPath.endsWith('.wav') ||
        currentQuestion.assetPath.endsWith('.mp3');
    if (isAudio) {
      final relativePath = currentQuestion.assetPath.startsWith('assets/')
          ? currentQuestion.assetPath.replaceFirst('assets/', '')
          : currentQuestion.assetPath;
      _audioPlayer.play(AssetSource(relativePath));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Display question image
          Expanded(
            flex: 4,
            child: isAudio
                ? InkWell(
                    onTap: () async {
                      final relativePath =
                          currentQuestion.assetPath.startsWith('assets/')
                              ? currentQuestion.assetPath
                                  .replaceFirst('assets/', '')
                              : currentQuestion.assetPath;
                      await _audioPlayer.play(AssetSource(relativePath));
                      print(currentQuestion.assetPath);
                    },
                    child: const Icon(Icons.audiotrack,
                        size: 100, color: Colors.orange))
                : Image.asset(
                    currentQuestion.assetPath,
                    fit: BoxFit.contain,
                    height: 250,
                    width: double.infinity,
                  ),
          ),

          // Display question text
          Expanded(
            flex: 2,
            child: Text(
              currentQuestion.questionText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Display options
          Expanded(
            flex: 4,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: currentQuestion.options.length,
              itemBuilder: (context, index) {
                final option = currentQuestion.options[index];
                return GlossyButton(
                  label: option,
                  onPressed: () {
                    ref
                        .read(quizNotifierProvider.notifier)
                        .submitAnswer(option);
                    if (!ref
                        .read(quizNotifierProvider.notifier)
                        .hasMoreQuestions()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuizResultPage(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
