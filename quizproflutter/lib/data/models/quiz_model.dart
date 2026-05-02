import '../../domain/entities/quiz.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.questionText,
    required super.options,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        id:           json['id'] as int,
        questionText: json['questionText'] as String,
        options:      List<String>.from(json['options']),
      );
}
