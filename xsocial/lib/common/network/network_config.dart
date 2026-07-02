import 'package:dio/dio.dart';

import 'http_options.dart';

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

  /// Global Dio interceptors.
  ///
  /// These are added to the Dio instance on initialization.
  final List<Interceptor> interceptors;

  NetworkConfig copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    HttpOptions? defaultOptions,
    List<Interceptor>? interceptors,
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
