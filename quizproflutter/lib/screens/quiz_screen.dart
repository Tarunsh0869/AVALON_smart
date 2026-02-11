import 'package:flutter/material.dart';
import '../globals.dart';
import 'main_navigation_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  int score = 0;

  final Map<String, List<Map<String, dynamic>>> _questionBank = {
    'Python': [
      {
        'q': 'Who developed Python?',
        'a': [
          'Guido van Rossum',
          'Dennis Ritchie',
          'James Gosling',
          'Bjarne Stroustrup',
        ],
        'c': 'Guido van Rossum',
      },
      {
        'q': 'Keyword for functions?',
        'a': ['function', 'def', 'fun', 'define'],
        'c': 'def',
      },
      {
        'q': 'Not a Python data type?',
        'a': ['List', 'Tuple', 'Array', 'Dictionary'],
        'c': 'Array',
      },
      {
        'q': 'Output of type([])?',
        'a': ["list", "dict", "tuple", "set"],
        'c': "list",
      },
      {
        'q': 'Method to add element to list?',
        'a': ['append()', 'push()', 'add()', 'insert()'],
        'c': 'append()',
      },
      {
        'q': 'Correct way to create a dictionary?',
        'a': ['{}', '[]', '()', '<>'],
        'c': '{}',
      },
      {
        'q': 'Symbol for comments?',
        'a': ['#', '//', '/*', '--'],
        'c': '#',
      },
      {
        'q': 'What does len() do?',
        'a': ['Length', 'Type', 'Sum', 'Max'],
        'c': 'Length',
      },
      {
        'q': 'A mutable data type?',
        'a': ['List', 'Tuple', 'String', 'Int'],
        'c': 'List',
      },
      {
        'q': 'Output of 2 ** 3?',
        'a': ['6', '8', '9', '5'],
        'c': '8',
      },
    ],
    'SQL': [
      {
        'q': 'What does SQL stand for?',
        'a': [
          'Structured Query Language',
          'Simple Query Language',
          'Strong Query Language',
          'System Query Language',
        ],
        'c': 'Structured Query Language',
      },
      {
        'q': 'Command to fetch data?',
        'a': ['GET', 'OPEN', 'SELECT', 'FETCH'],
        'c': 'SELECT',
      },
      {
        'q': 'Command to remove a table?',
        'a': ['DELETE', 'DROP', 'REMOVE', 'ERASE'],
        'c': 'DROP',
      },
      {
        'q': 'Statement to update data?',
        'a': ['MODIFY', 'CHANGE', 'UPDATE', 'ALTER'],
        'c': 'UPDATE',
      },
      {
        'q': 'What does WHERE clause do?',
        'a': ['Sorts', 'Filters', 'Groups', 'Joins'],
        'c': 'Filters',
      },
      {
        'q': 'Command to add new records?',
        'a': ['ADD', 'INSERT', 'CREATE', 'NEW'],
        'c': 'INSERT',
      },
      {
        'q': 'What does COUNT(*) do?',
        'a': ['Sum', 'Count', 'Max', 'Avg'],
        'c': 'Count',
      },
      {
        'q': 'Keyword to sort results?',
        'a': ['ORDER BY', 'SORT BY', 'GROUP BY', 'ARRANGE'],
        'c': 'ORDER BY',
      },
      {
        'q': 'What does JOIN do?',
        'a': ['Deletes', 'Combines', 'Sorts', 'Groups'],
        'c': 'Combines',
      },
      {
        'q': 'Constraint for unique values?',
        'a': ['PRIMARY KEY', 'UNIQUE', 'CHECK', 'NOT NULL'],
        'c': 'UNIQUE',
      },
    ],
    'UI/UX': [
      {
        'q': 'What does UX stand for?',
        'a': [
          'User Experience',
          'Universal Exchange',
          'Utility Execution',
          'Unified Expression',
        ],
        'c': 'User Experience',
      },
      {
        'q': 'Principle for visual hierarchy?',
        'a': ['Contrast', 'Symmetry', 'Balance', 'Proximity'],
        'c': 'Contrast',
      },
      {
        'q': 'Target size for mobile?',
        'a': ['24px', '44px', '64px', '88px'],
        'c': '44px',
      },
      {
        'q': 'Reduces cognitive load?',
        'a': ['Minimalism', 'Complexity', 'Clutter', 'Density'],
        'c': 'Minimalism',
      },
      {
        'q': 'Target acquisition law?',
        'a': ['Jakob', 'Fitts', 'Hick', 'Miller'],
        'c': 'Fitts',
      },
      {
        'q': 'Key element of visual design?',
        'a': ['Color', 'Database', 'Server', 'Algorithm'],
        'c': 'Color',
      },
      {
        'q': 'Purpose of personas?',
        'a': ['Code', 'Target users', 'Database', 'Network'],
        'c': 'Target users',
      },
      {
        'q': 'Early UI testing technique?',
        'a': ['Wireframing', 'Deployment', 'Compilation', 'Packaging'],
        'c': 'Wireframing',
      },
      {
        'q': 'Accessibility in UI means?',
        'a': ['Internet', 'All users', 'Database', 'Server'],
        'c': 'All users',
      },
      {
        'q': 'Most accessible color pair?',
        'a': ['Red/Green', 'Blue/Orange', 'Black/White', 'Purple/Yellow'],
        'c': 'Black/White',
      },
    ],
    'Data Science': [
      {
        'q': 'Library for manipulation?',
        'a': ['NumPy', 'Pandas', 'Matplotlib', 'Scikit'],
        'c': 'Pandas',
      },
      {
        'q': 'Purpose of visualization?',
        'a': ['Store', 'Insights', 'Delete', 'Encrypt'],
        'c': 'Insights',
      },
      {
        'q': 'Algorithm for classification?',
        'a': ['Linear', 'K-Means', 'Decision Tree', 'PCA'],
        'c': 'Decision Tree',
      },
      {
        'q': 'What is overfitting?',
        'a': ['Simple', 'Train well/Test poor', 'Fast', 'Slow'],
        'c': 'Train well/Test poor',
      },
      {
        'q': 'Central tendency measure?',
        'a': ['Range', 'Mean', 'Variance', 'Std Dev'],
        'c': 'Mean',
      },
      {
        'q': 'Correlation range?',
        'a': ['0 to 1', '-1 to 1', '1 to 10', '0 to 100'],
        'c': '-1 to 1',
      },
      {
        'q': 'Supervised technique?',
        'a': ['K-Means', 'PCA', 'Linear Regression', 'DBSCAN'],
        'c': 'Linear Regression',
      },
      {
        'q': 'What is EDA?',
        'a': ['Access', 'Arch', 'Exploratory Analysis', 'Aggregation'],
        'c': 'Exploratory Analysis',
      },
      {
        'q': 'Library for plots?',
        'a': ['Requests', 'Soup', 'Matplotlib', 'Flask'],
        'c': 'Matplotlib',
      },
      {
        'q': 'Metric for regression?',
        'a': ['Accuracy', 'Precision', 'Recall', 'MSE'],
        'c': 'MSE',
      },
    ],
    'Ambitions': [
      {
        'q': 'First step in goal setting?',
        'a': ['Action', 'Define goals', 'Mentor', 'Resources'],
        'c': 'Define goals',
      },
      {
        'q': 'Why break down goals?',
        'a': ['Easier', 'Complexity', 'Delegation', 'Time'],
        'c': 'Easier',
      },
      {
        'q': 'Most important trait?',
        'a': ['Perfect', 'Persistence', 'Speed', 'Compete'],
        'c': 'Persistence',
      },
      {
        'q': 'Role of planning?',
        'a': ['Limit', 'Uncertain', 'Direction', 'Flex'],
        'c': 'Direction',
      },
      {
        'q': 'SMART element?',
        'a': ['Easy', 'Specific', 'Temporary', 'Similar'],
        'c': 'Specific',
      },
      {
        'q': 'Why share goals?',
        'a': ['Compete', 'Accountable', 'Impress', 'Delegate'],
        'c': 'Accountable',
      },
      {
        'q': 'Facing obstacles?',
        'a': ['Give up', 'Change goals', 'Adjust strategy', 'Ignore'],
        'c': 'Adjust strategy',
      },
      {
        'q': 'How to stay motivated?',
        'a': ['Result', 'Small wins', 'Compare', 'Alone'],
        'c': 'Small wins',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final questions =
        _questionBank[widget.category] ??
        [
          {
            'q': 'Back',
            'a': ['Back'],
            'c': 'Back',
          },
        ];

    if (questionIndex >= questions.length) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                "Assessment Complete",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "User: $currentUserName",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                "Score: $score / ${questions.length}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  sessionLeaderboard.add({
                    'name': currentUserName,
                    'score': score,
                    'category': widget.category,
                  });
                  sessionLeaderboard.sort(
                    (a, b) => b['score'].compareTo(a['score']),
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigationScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text("Save Score & Return"),
              ),
            ],
          ),
        ),
      );
    }

    final currentQ = questions[questionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("${widget.category} Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (questionIndex + 1) / questions.length,
              minHeight: 8,
            ),
            const SizedBox(height: 40),
            Text(
              currentQ['q'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: (currentQ['a'] as List<String>).map((opt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (opt == currentQ['c']) score++;
                          setState(() {
                            questionIndex++;
                          });
                        },
                        child: Text(opt),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
