import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id:    json['userId'] as int,
        name:  json['name']   as String,
        email: json['email']  ?? '',
        token: json['token']  as String,
      );
}
