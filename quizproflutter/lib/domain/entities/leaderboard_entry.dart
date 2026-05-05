class LeaderboardEntry {
  final int rank;
  final int userId;
  final String name;
  final String category;
  final int bestScore;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.name,
    required this.category,
    required this.bestScore,
  });
}
