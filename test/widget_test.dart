import 'package:flutter_test/flutter_test.dart';
import 'package:quizproflutter/main.dart';

void main() {
  testWidgets('AVAlON Home Screen Welcome Test', (WidgetTester tester) async {
    // Build our app.
    // Note: In a real test, you'd need to mock Firebase.
    await tester.pumpWidget(const QuizProApp());

    // Verify that the personalized welcome message exists.
    expect(find.textContaining('Welcome back, Tarun Sharma!'), findsOneWidget);
  });
}
