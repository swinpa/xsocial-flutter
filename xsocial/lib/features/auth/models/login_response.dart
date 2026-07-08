import '../../../common/network/typedef.dart';
import 'user.dart';

final class LoginResponse {
  const LoginResponse({
    required this.token,
    required this.user,
  });

  final String token;
  final User user;

  factory LoginResponse.fromJson(Json json) {
    return LoginResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Json),
    );
  }
}
