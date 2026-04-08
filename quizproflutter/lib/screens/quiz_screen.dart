// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/quiz_provider.dart';
import '../view_models/user_view.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<QuizProvider>().loadQuiz(widget.category));
  }

  Widget _buildCompletionUI(BuildContext context, QuizProvider quiz, UserViewModel user) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
            Text("Quiz Completed!", style: Theme.of(context).textTheme.headlineMedium),
            Text("Score: ${quiz.score} / ${quiz.totalQuestions}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await quiz.syncScoreToFirebase(user.userName, widget.category);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("Save & Exit"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use the provider we just updated
    final quiz = context.watch<QuizProvider>();
    final user = context.read<UserViewModel>();

    if (quiz.isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    // End of quiz logic
    if (quiz.currentIndex >= quiz.totalQuestions && quiz.totalQuestions > 0) {
      return _buildCompletionUI(context, quiz, user);
    }

    if (quiz.totalQuestions == 0) {
      return const Scaffold(body: Center(child: Text("No questions found.")));
    }

    final q = quiz.currentQuestion;

    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Assessment")),
      body: Column(
        children: [
          LinearProgressIndicator(
              value: (quiz.currentIndex + 1) / quiz.totalQuestions),
          const SizedBox(height: 20),
          Text(q['question'] ?? '',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // Generate buttons from the shuffled list in provider
          ...(q['options'] as List? ?? []).map((option) => ElevatedButton(
                onPressed: () =>
                    quiz.checkAnswer(option, q['answer'] ?? ''),
                child: Text(option),
              )),
        ],
      ),
    );
  }
}
