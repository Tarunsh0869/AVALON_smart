import '../../data/repositories/quiz_repository.dart';

class SyncScoreUseCase {
  final QuizRepository _repository;
  SyncScoreUseCase(this._repository);

  Future<Map<String, dynamic>> execute(
      int categoryId, List<Map<String, dynamic>> answers) {
    return _repository.submitQuiz(
        categoryId: categoryId, answers: answers);
  }
}
