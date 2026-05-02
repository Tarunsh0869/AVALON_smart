import '../../data/models/question_model.dart';
import '../../data/repositories/quiz_repository.dart';

class FetchQuizUseCase {
  final QuizRepository _repository;
  FetchQuizUseCase(this._repository);

  Future<List<QuestionModel>> execute(int categoryId) {
    return _repository.getQuestions(categoryId);
  }
}
