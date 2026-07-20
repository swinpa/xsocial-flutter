import 'package:dio/dio.dart';

import '../interceptor/http_interceptor.dart';
import '../network_config.dart';

final class DioFactory {
  const DioFactory._();

  static Dio create(NetworkConfig config) {
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
      dio.interceptors.addAll(
        config.interceptors.map(_toDioInterceptor).toList(growable: false),
      );
    }

    return dio;
  }

  /// Converts an [HttpInterceptor] to a Dio [Interceptor].
  static Interceptor _toDioInterceptor(HttpInterceptor interceptor) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final additionalHeaders = interceptor.onRequest(
          Map<String, dynamic>.from(options.headers),
        );
        options.headers.addAll(additionalHeaders);
        handler.next(options);
      },
      onResponse: (response, handler) {
        interceptor.onResponse(response);
        handler.next(response);
      },
      onError: (error, handler) {
        interceptor.onError(error);
        handler.next(error);
      },
    );
  }
}
