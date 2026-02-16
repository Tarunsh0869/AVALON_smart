class Question {
  final String id;
  final String title;
  final Map<String, bool> options;

  Question({required this.id, required this.title, required this.options});

  // This is the "Dynamic" secret: A function to create a Question from a Map
  // This is helpful when reading from a file or a database
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      id: data['id'],
      title: data['title'],
      options: Map<String, bool>.from(data['options']),
    );
  }
}
