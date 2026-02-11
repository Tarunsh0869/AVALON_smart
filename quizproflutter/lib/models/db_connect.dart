import './question.dart';

List<Question> questions = [
  Question(
    id: '1',
    title: 'What is the main language used for Flutter?',
    options: {'Java': false, 'Python': false, 'Dart': true, 'C++': false},
  ),
  Question(
    id: '2',
    title: 'Who developed Flutter?',
    options: {
      'Facebook': false,
      'Google': true,
      'Microsoft': false,
      'Apple': false,
    },
  ),
];
