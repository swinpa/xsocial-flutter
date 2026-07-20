import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/network/client/dio_api_client.dart';
import '../../../common/network/http_options.dart';
import '../../../common/network/interceptor/http_interceptor.dart';
import '../../../common/network/network_config.dart';
import '../models/login_response.dart';
import '../repository/auth_repository.dart';

// ---------------------------------------------------------------------------
// 1. NetworkConfig
// ---------------------------------------------------------------------------
final networkConfigProvider = Provider<NetworkConfig>((ref) {
  return const NetworkConfig(
    baseUrl: 'https://api.example.com',
    defaultOptions: HttpOptions(
      headers: {
        'Accept-Language': 'zh-CN',
        'Platform': 'mobile',
      },
    ),
    interceptors: [AuthTokenInterceptor()],
  );
});

// ---------------------------------------------------------------------------
// 2. ApiClient – 动态注入 token
// ---------------------------------------------------------------------------
final apiClientProvider = Provider<DioApiClient>((ref) {
  final config = ref.watch(networkConfigProvider);
  return DioApiClient(
    config: config,
    headersProvider: () {
      final token = AuthResult.info?.user_token;
      return {
        'Accept-Language': 'zh-CN',
        'Platform': 'mobile',
        'App-Version': '1.0.0',
        if (token != null) 'Authorization': 'Bearer $token',
      };
    },
  );
});

// ---------------------------------------------------------------------------
// 3. AuthRepository
// ---------------------------------------------------------------------------
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

// ---------------------------------------------------------------------------
// 4. APP 启动时调用，从缓存恢复登录状态
// ---------------------------------------------------------------------------
final authInitProvider = FutureProvider<void>((ref) async {
  await AuthResult.load();
});

// ---------------------------------------------------------------------------
// Token interceptor
// ---------------------------------------------------------------------------
final class AuthTokenInterceptor implements HttpInterceptor {
  const AuthTokenInterceptor();

  @override
  Map<String, dynamic> onRequest(Map<String, dynamic> headers) {
    return headers;
  }

  @override
  void onResponse(dynamic response) {}

  @override
  void onError(Object error) {}
}
