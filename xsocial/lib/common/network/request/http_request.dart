import 'package:dio/dio.dart';

import '../http_options.dart';
import 'http_method.dart';

/// Immutable HTTP request.
///
/// This is the unified request model used by the network layer.
/// It is independent of any HTTP library (such as Dio).
final class HttpRequest {
  const HttpRequest({
    required this.path,
    required this.method,
    this.body,
    this.query,
    this.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
    this.options,
  });

  /// Relative request path.
  ///
  /// Example:
  ///
  /// `/user/profile`
  final String path;

  /// HTTP method.
  final HttpMethod method;

  /// Request body.
  final Object? body;

  /// Query parameters to append to the URL.
  final Map<String, dynamic>? query;

  /// Cancel token for cancelling the request.
  final CancelToken? cancelToken;

  /// Upload progress callback.
  final ProgressCallback? onSendProgress;

  /// Download progress callback.
  final ProgressCallback? onReceiveProgress;

  /// Request options.
  final HttpOptions? options;

  // ---------------------------------------------------------------------------
  // Computed Properties (shortcuts into options)
  // ---------------------------------------------------------------------------

  /// Merged request headers.
  Map<String, dynamic> get headers => options?.headers ?? const {};

  /// Request content type.
  String? get contentType => options?.contentType;

  /// Merged extra metadata.
  Map<String, dynamic> get extra => options?.extra ?? const {};

  // ---------------------------------------------------------------------------
  // Factory Constructors
  // ---------------------------------------------------------------------------

  factory HttpRequest.get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpOptions? options,
  }) {
    return HttpRequest(
      path: path,
      method: HttpMethod.get,
      query: query,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  factory HttpRequest.post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpOptions? options,
  }) {
    return HttpRequest(
      path: path,
      method: HttpMethod.post,
      body: body,
      query: query,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  factory HttpRequest.put(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpOptions? options,
  }) {
    return HttpRequest(
      path: path,
      method: HttpMethod.put,
      body: body,
      query: query,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  factory HttpRequest.patch(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpOptions? options,
  }) {
    return HttpRequest(
      path: path,
      method: HttpMethod.patch,
      body: body,
      query: query,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  factory HttpRequest.delete(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpOptions? options,
  }) {
    return HttpRequest(
      path: path,
      method: HttpMethod.delete,
      body: body,
      query: query,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  // ---------------------------------------------------------------------------
  // Copy
  // ---------------------------------------------------------------------------

  HttpRequest copyWith({
    String? path,
    HttpMethod? method,
    Object? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpOptions? options,
  }) {
    return HttpRequest(
      path: path ?? this.path,
      method: method ?? this.method,
      body: body ?? this.body,
      query: query ?? this.query,
      cancelToken: cancelToken ?? this.cancelToken,
      onSendProgress: onSendProgress ?? this.onSendProgress,
      onReceiveProgress: onReceiveProgress ?? this.onReceiveProgress,
      options: options ?? this.options,
    );
  }

  @override
  String toString() {
    return '''
HttpRequest(
  method: ${method.value},
  path: $path,
  query: $query,
  body: $body,
  options: $options,
)
''';
  }
}
