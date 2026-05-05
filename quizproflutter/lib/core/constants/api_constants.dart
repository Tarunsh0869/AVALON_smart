class ApiConstants {
  // Change to localhost:5000 for desktop, 10.0.2.2:5000 for Android emulator
  static const String baseUrl = 'http://192.168.107.112:5000/api';

  static const String login      = '/auth/login';
  static const String register   = '/auth/register';
  static const String categories = '/categories';
  static String questions(int categoryId) => '/questions/$categoryId';
  static const String submitQuiz  = '/quiz/submit';
  static const String leaderboard = '/leaderboard';
}
