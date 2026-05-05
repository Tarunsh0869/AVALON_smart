// ignore_for_file: deprecated_member_use, use_build_context_synchronously
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

    // All questions answered — show submit button
    if (quiz.isFinished) {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.categoryName} Assessment')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text('All questions reviewed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Answered: ${quiz.answeredCount} / ${quiz.totalQuestions}'),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => quiz.submitQuiz(widget.categoryId),
                  child: const Text('Submit Quiz'),
                ),
                TextButton(
                  onPressed: () => quiz.previousQuestion(),
                  child: const Text('Review Answers'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (quiz.totalQuestions == 0) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  quiz.error != null
                      ? 'Error: ${quiz.error}'
                      : 'No questions found for this category.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () =>
                      context.read<QuizProvider>().loadQuiz(widget.categoryId),
                  child: const Text('Retry'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = quiz.currentQuestion!;
    final selectedAnswer = quiz.getAnswer(q.id);

    return Scaffold(
      appBar: AppBar(title: Text('${widget.categoryName} Assessment')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: selectedAnswer == option
                                ? Colors.indigo.withOpacity(0.1)
                                : null,
                            side: BorderSide(
                              color: selectedAnswer == option
                                  ? Colors.indigo
                                  : Colors.grey.shade300,
                              width: selectedAnswer == option ? 2 : 1,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => quiz.selectAnswer(q.id, option),
                          child: Row(
                            children: [
                              Icon(
                                selectedAnswer == option
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: selectedAnswer == option
                                    ? Colors.indigo
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(option)),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (quiz.canGoBack)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: quiz.previousQuestion,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                  ),
                if (quiz.canGoBack) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: selectedAnswer != null || quiz.isLastQuestion
                        ? quiz.nextQuestion
                        : null,
                    child: Text(quiz.isLastQuestion ? 'Finish' : 'Next'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: quiz.canGoNext ? quiz.skipQuestion : null,
                    child: const Text('Skip'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
