import 'http_options.dart';
import 'interceptor/http_interceptor.dart';

/// Global network configuration.
///
/// This configuration is typically initialized once
/// when the application starts.
final class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
    this.defaultOptions = const HttpOptions(),
    this.interceptors = const [],
  });

  /// Base URL.
  ///
  /// Example:
  ///
  /// https://api.example.com
  final String baseUrl;

  /// Connection timeout.
  final Duration connectTimeout;

  /// Receive timeout.
  final Duration receiveTimeout;

  /// Send timeout.
  final Duration sendTimeout;

  /// Global request options.
  ///
  /// All requests will merge their own options with this object.
  final HttpOptions defaultOptions;

  /// Global interceptors.
  ///
  /// These are transport-layer agnostic and will be converted
  /// to the transport's native interceptor type by the client.
  final List<HttpInterceptor> interceptors;

  NetworkConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    HttpOptions? defaultOptions,
    List<HttpInterceptor>? interceptors,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      defaultOptions: defaultOptions ?? this.defaultOptions,
      interceptors: interceptors ?? this.interceptors,
    );
  }

  @override
  String toString() {
    return '''
NetworkConfig(
  baseUrl: $baseUrl,
  connectTimeout: $connectTimeout,
  receiveTimeout: $receiveTimeout,
  sendTimeout: $sendTimeout,
  defaultOptions: $defaultOptions,
  interceptors: ${interceptors.length} interceptor(s),
)
''';
  }
}
