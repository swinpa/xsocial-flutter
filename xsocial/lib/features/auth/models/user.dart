import '../../../common/network/typedef.dart';

final class User {
  const User({
    required this.id,
    required this.nickname,
    this.avatar,
  });

  final String id;
  final String nickname;
  final String? avatar;

  factory User.fromJson(Json json) {
    return User(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Json toJson() => {
    'id': id,
    'nickname': nickname,
    'avatar': avatar,
  };
}
