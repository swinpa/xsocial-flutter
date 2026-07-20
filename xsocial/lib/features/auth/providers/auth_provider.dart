import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/network/client/dio_api_client.dart';
import '../../../common/network/http_options.dart';
import '../../../common/network/interceptor/http_interceptor.dart';
import '../../../common/network/network_config.dart';
import '../repository/auth_repository.dart';

// ---------------------------------------------------------------------------
// 1. NetworkConfig – initiated once at app start
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
// 2. ApiClient – created from config
// ---------------------------------------------------------------------------
final apiClientProvider = Provider((ref) {
  final config = ref.watch(networkConfigProvider);
  return DioApiClient(
    config: config,
    // 每次请求前动态获取通用请求头，支持响应式更新。
    headersProvider: () => {
      'Accept-Language': 'zh-CN',
      'Platform': 'mobile',
      'App-Version': '1.0.0',
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
// Token interceptor
// ---------------------------------------------------------------------------
final class AuthTokenInterceptor implements HttpInterceptor {
  const AuthTokenInterceptor();

  @override
  Map<String, dynamic> onRequest(Map<String, dynamic> headers) {
    // Read token from SecureStorage and attach it.
    // final token = storage.getString('token');
    // if (token != null) {
    //   headers['Authorization'] = 'Bearer $token';
    // }
    return headers;
  }

  @override
  void onResponse(dynamic response) {}

  @override
  void onError(Object error) {}
}
