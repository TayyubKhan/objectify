import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnito/app/routes_name.dart';
import 'package:learnito/presentation/quiz/quiz_screen.dart';
import '../../app/theme.dart';
import '../../application/quiz/quiz_notifier.dart';

class QuizResultPage extends ConsumerWidget {
  const QuizResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider);
    final score = quizState.score ?? 0;
    final totalQuestions = quizState.questions.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Quiz Results',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Colors.orange.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildScoreDisplay(score, totalQuestions),
            const SizedBox(height: 30),
            _buildRestartButton(context, ref),
          ],
        ),
      ),
    );
  }

  // Widget to display the score
  Widget _buildScoreDisplay(int score, int totalQuestions) {
    final scorePercentage = (score / totalQuestions) * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$score / $totalQuestions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: scorePercentage >= 60 ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(15),
            value: score / totalQuestions,
            color: scorePercentage >= 60 ? Colors.green : Colors.red,
            backgroundColor: Colors.grey[300],
            minHeight: 10,
          ),
        ],
      ),
    );
  }

  // Restart button widget
  Widget _buildRestartButton(BuildContext context, ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(quizNotifierProvider.notifier).resetQuiz();
        Navigator.pushReplacementNamed(context, RoutesName.quiz);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Restart Quiz',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
      ),
    );
  }
}
