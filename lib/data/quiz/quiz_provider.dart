
// Define a provider for the QuestionRepository
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnito/data/quiz/quiz_repository.dart';

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepository();
});