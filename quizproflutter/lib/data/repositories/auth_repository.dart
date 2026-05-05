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
    
    // Save token AND user data (id, name, email — NO password)
    await TokenStorage.saveToken(user.token);
    await TokenStorage.saveUserData({
      'id': user.id,
      'name': user.name,
      'email': user.email,
    });
    
    return user;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final data = await ApiService.post(
      ApiConstants.register,
      {'name': name, 'email': email, 'password': password},
    );
    final user = UserModel.fromJson(data);
    
    // Save token AND user data
    await TokenStorage.saveToken(user.token);
    await TokenStorage.saveUserData({
      'id': user.id,
      'name': user.name,
      'email': user.email,
    });
    
    return user;
  }

  Future<void> logout() => TokenStorage.clearAll();
  
  // ── Auto-login: restore user from stored data ──────────────────────────────────
  
  Future<UserModel?> restoreSession() async {
    final hasToken = await TokenStorage.hasToken();
    if (!hasToken) return null;
    
    final userData = await TokenStorage.getUserData();
    if (userData == null) return null;
    
    final token = await TokenStorage.getToken();
    return UserModel(
      id: userData['id'] as int,
      name: userData['name'] as String,
      email: userData['email'] as String,
      token: token!,
    );
  }
}
