class QuizEntity {
  final int id;
  final String questionText;
  final List<String> options;
  // No 'answer' field — correct answers stay on the backend

  const QuizEntity({
    required this.id,
    required this.questionText,
    required this.options,
  });
}
