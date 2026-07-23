import 'package:flutter/foundation.dart';
import '../../../common/network/client/api_client.dart';
import '../../../common/network/parser.dart';
import '../../../common/network/request/http_request.dart';
import '../models/login_response.dart';
import '../models/user.dart';

/// Auth API repository.
///
/// All network logic is encapsulated here; widgets never touch
/// [ApiClient] or [HttpRequest] directly.
final class AuthRepository {
  const AuthRepository(this._client);

  final ApiClient _client;

  /// POST /auth/login
  ///
  /// Returns the raw [LoginResponse] from the server.
  Future<LoginResponse> login(Map<String,String> params) async {
    debugPrint("[AuthRepo] ➡️ POST /user/login/login  params=$params");
    final response = await _client.request<LoginResponse>(
      HttpRequest.post(
        '/user/login/login',
        body: params,
      ),
      decoder: (json) => Parser.object(json, LoginResponse.fromJson),
    );
    debugPrint("[AuthRepo] ✅ /user/login/login 成功");
    return response.data!;
  }

  
  /// POST /auth/social-login
  ///
  /// Log in with a third-party identity provider (Google, Apple, etc).
  Future<LoginResponse> loginWithSocial({
    required String provider,
    required String idToken,
    String? authorizationCode,
  }) async {
    debugPrint("[AuthRepo] ➡️ POST /auth/social-login  provider=$provider  idToken=${idToken.substring(0, (idToken.length > 20 ? 20 : idToken.length))}...");
    final response = await _client.request<LoginResponse>(
      HttpRequest.post(
        '/auth/social-login',
        body: {
          'provider': provider,
          'id_token': idToken,
          if (authorizationCode != null) 'authorization_code': authorizationCode,
        },
      ),
      decoder: (json) => Parser.object(json, LoginResponse.fromJson),
    );
    debugPrint("[AuthRepo] ✅ /auth/social-login 成功");
    return response.data!;
  }

  /// GET /user/profile
  Future<User> getProfile() async {
    final response = await _client.request<User>(
      HttpRequest.get('/user/profile'),
      decoder: (json) => Parser.object(json, User.fromJson),
    );
    return response.data!;
  }

  /// GET /user/search?keyword=xxx
  Future<List<User>> searchUsers(String keyword) async {
    final response = await _client.request<List<User>>(
      HttpRequest.get(
        '/user/search',
        query: {'keyword': keyword},
      ),
      decoder: (json) => Parser.list(json, User.fromJson),
    );
    return response.data ?? [];
  }
}
