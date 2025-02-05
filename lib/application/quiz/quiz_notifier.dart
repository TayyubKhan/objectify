import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnito/application/quiz/quiz_state.dart';
import '../../data/quiz/quiz_provider.dart';
import '../../data/quiz/quiz_repository.dart';

class QuizNotifier extends StateNotifier<QuizState> {
  final QuestionRepository _repository;

  QuizNotifier(this._repository) : super(QuizState()) {
    _loadQuestions();
  }

  /// Loads questions from the repository and updates the state
  Future<void> _loadQuestions() async {
    try {
      final questions = await _repository.fetchQuestions();
      state = state.copyWith(
        questions: questions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load questions. Please try again.',
      );
    }
  }

  /// Handles answer submission and updates the score and state
  void submitAnswer(String answer) {
    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = currentQuestion.correctAnswer == answer;

    state = state.copyWith(
      score: isCorrect ? state.score + 1 : state.score,
      currentIndex: hasMoreQuestions() ? state.currentIndex + 1 : state.currentIndex,
    );
  }

  /// Checks if there are more questions available
  bool hasMoreQuestions() {
    return state.currentIndex < state.questions.length - 1;
  }

  /// Resets the quiz to the initial state
  void resetQuiz() {
    state = QuizState();
    _loadQuestions();
  }
}

final quizNotifierProvider = StateNotifierProvider<QuizNotifier, QuizState>(
      (ref) => QuizNotifier(ref.read(questionRepositoryProvider)),
);
