import '../entities/user.dart';
import '../../data/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<UserEntity> execute(String email, String password) {
    return _repository.login(email, password);
  }
}
