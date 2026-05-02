import '../entities/leaderboard_entry.dart';
import '../../data/repositories/leaderboard_repository.dart';

class FetchLeaderboardUseCase {
  final LeaderboardRepository _repository;
  FetchLeaderboardUseCase(this._repository);

  Future<List<LeaderboardEntry>> execute() {
    return _repository.fetchRankings();
  }
}
