import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardModel extends LeaderboardEntry {
  const LeaderboardModel({
    required super.rank,
    required super.userId,
    required super.name,
    required super.category,
    required super.bestScore,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) =>
      LeaderboardModel(
        rank:      json['rank']      as int,
        userId:    json['userId']    as int,
        name:      json['userName']  as String,
        category:  json['category']  as String,
        bestScore: json['bestScore'] as int,
      );
}
