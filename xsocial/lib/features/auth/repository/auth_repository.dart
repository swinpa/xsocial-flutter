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
  Future<LoginResponse> login(String phone, String password) async {
    final response = await _client.request<LoginResponse>(
      HttpRequest.post(
        '/auth/login',
        body: {
          'phone': phone,
          'password': password,
        },
      ),
      decoder: (json) => Parser.object(json, LoginResponse.fromJson),
    );
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
