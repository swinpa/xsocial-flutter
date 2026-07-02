import 'package:dio/dio.dart';

import '../network_config.dart';

final class DioFactory {
  const DioFactory._();

  static Dio create(
    NetworkConfig config,
  ) {
    final options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: Map<String, dynamic>.from(config.defaultOptions.headers),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
    );

    final dio = Dio(options);

    if (config.interceptors.isNotEmpty) {
      dio.interceptors.addAll(config.interceptors);
    }

    return dio;
  }
}
