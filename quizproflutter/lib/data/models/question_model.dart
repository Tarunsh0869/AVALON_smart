class QuestionModel {
  final int id;
  final String questionText;
  final List<String> options;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'],
        questionText: json['questionText'],
        options: List<String>.from(json['options']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'questionText': questionText,
        'options': options,
      };
}
