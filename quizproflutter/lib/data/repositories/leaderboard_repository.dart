import '../../core/constants/api_constants.dart';
import '../../core/services/api_service.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../models/leaderboard_model.dart';

class LeaderboardRepository {
  Future<List<LeaderboardEntry>> fetchRankings() async {
    final data = await ApiService.get(ApiConstants.leaderboard) as List;
    return data.map((e) => LeaderboardModel.fromJson(e)).toList();
  }
}
