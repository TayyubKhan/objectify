import '../../domain/quiz/quiz_entity.dart';

class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final int score;
  final bool isLoading;
  final String errorMessage;
  final String? selectedOption; // Add this property

  QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.isLoading = true,
    this.errorMessage = "",
    this.selectedOption, // Initialize it
  });

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    int? score,
    bool? isLoading,
    String? errorMessage,
    String? selectedOption, // Allow updating this property
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedOption: selectedOption ?? this.selectedOption, // Copy value
    );
  }
}
