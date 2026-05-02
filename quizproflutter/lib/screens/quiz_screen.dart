// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<QuizProvider>().loadQuiz(widget.categoryId));
  }

  Widget _buildResultUI(QuizProvider quiz) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
              const SizedBox(height: 16),
              Text('Quiz Completed!',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              if (quiz.score != null)
                Text('Score: ${quiz.score} / ${quiz.total}',
                    style: const TextStyle(fontSize: 22)),
              if (quiz.resultMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(quiz.resultMessage!,
                      style: const TextStyle(color: Colors.grey)),
                ),
              if (quiz.error != null)
                Text(quiz.error!,
                    style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    if (quiz.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show result screen after submission
    if (quiz.score != null) return _buildResultUI(quiz);

    // All questions answered — trigger backend submission
    if (quiz.isFinished) {
      Future.microtask(() => quiz.submitQuiz(widget.categoryId));
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    if (quiz.totalQuestions == 0) {
      return const Scaffold(
          body: Center(child: Text('No questions found.')));
    }

    final q = quiz.currentQuestion!;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.categoryName} Assessment')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
                value: (quiz.currentIndex + 1) / quiz.totalQuestions),
            const SizedBox(height: 8),
            Text(
              'Question ${quiz.currentIndex + 1} of ${quiz.totalQuestions}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(q.questionText,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...q.options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    // Store answer locally — backend checks correctness
                    onPressed: () => quiz.selectAnswer(q.id, option),
                    child: Text(option),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
