import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String question;
  final List<String> options;
  final String answer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
  });

  // Factory constructor to map Firestore data as shown in your console
  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      question: data['question'] ?? '',
      // Ensures options are handled as a List of strings from the DB
      options: List<String>.from(data['options'] ?? []),
      answer: data['answer'] ?? '',
    );
  }
}