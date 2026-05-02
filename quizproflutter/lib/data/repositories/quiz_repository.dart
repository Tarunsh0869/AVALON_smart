import '../../core/constants/api_constants.dart';
import '../../core/services/api_service.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';

class QuizRepository {
  Future<List<CategoryModel>> getCategories() async {
    final data = await ApiService.get(ApiConstants.categories) as List;
    return data.map((c) => CategoryModel.fromJson(c)).toList();
  }

  Future<List<QuestionModel>> getQuestions(int categoryId) async {
    final data = await ApiService.get(
      ApiConstants.questions(categoryId),
      auth: true,
    ) as List;
    return data.map((q) => QuestionModel.fromJson(q)).toList();
  }

  Future<Map<String, dynamic>> submitQuiz({
    required int categoryId,
    required List<Map<String, dynamic>> answers,
  }) async {
    return await ApiService.post(
      ApiConstants.submitQuiz,
      {'categoryId': categoryId, 'answers': answers},
      auth: true,
    );
  }
}
