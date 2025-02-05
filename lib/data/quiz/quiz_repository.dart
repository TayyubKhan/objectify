// features/quiz/data/question_repository.dart
import 'package:learnito/data/quiz/quiz_mock_questions.dart';

import '../../domain/quiz/quiz_entity.dart';

class QuestionRepository {
  Future<List<Question>> fetchQuestions() async {
    // Simulating a delay as if fetching from a remote source
    await Future.delayed(Duration(seconds: 1));
    return mockQuestions;
  }
}
