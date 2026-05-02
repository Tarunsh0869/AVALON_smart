import '../../core/constants/api_constants.dart';
import '../../core/services/api_service.dart';
import '../../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    final data = await ApiService.post(
      ApiConstants.login,
      {'email': email, 'password': password},
    );
    final user = UserModel.fromJson(data);
    await TokenStorage.saveToken(user.token);
    return user;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final data = await ApiService.post(
      ApiConstants.register,
      {'name': name, 'email': email, 'password': password},
    );
    final user = UserModel.fromJson(data);
    await TokenStorage.saveToken(user.token);
    return user;
  }

  Future<void> logout() => TokenStorage.clearToken();
}
