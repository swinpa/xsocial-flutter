/// Global HTTP configuration.
///
/// This class is transport-layer independent and contains only
/// configuration shared by all requests.
final class HttpOptions {
  const HttpOptions({
    this.headers = const {},
    this.connectTimeout,
    this.receiveTimeout,
    this.sendTimeout,
    this.contentType,
    this.extra = const {},
  });

  /// Default request headers.
  final Map<String, dynamic> headers;

  /// Connection timeout.
  final Duration? connectTimeout;

  /// Receive timeout.
  final Duration? receiveTimeout;

  /// Send timeout.
  final Duration? sendTimeout;

  /// Default request content type.
  ///
  /// Example:
  /// - application/json
  /// - multipart/form-data
  /// - application/x-www-form-urlencoded
  final String? contentType;

  /// Transport metadata.
  ///
  /// Never sent to the server.
  final Map<String, dynamic> extra;

  HttpOptions copyWith({
    Map<String, dynamic>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    String? contentType,
    Map<String, dynamic>? extra,
  }) {
    return HttpOptions(
      headers: headers ?? this.headers,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      contentType: contentType ?? this.contentType,
      extra: extra ?? this.extra,
    );
  }

  HttpOptions merge(HttpOptions? other) {
    if (other == null) {
      return this;
    }

    return HttpOptions(
      headers: {
        ...headers,
        ...other.headers,
      },
      connectTimeout: other.connectTimeout ?? connectTimeout,
      receiveTimeout: other.receiveTimeout ?? receiveTimeout,
      sendTimeout: other.sendTimeout ?? sendTimeout,
      contentType: other.contentType ?? contentType,
      extra: {
        ...extra,
        ...other.extra,
      },
    );
  }

  @override
  String toString() {
    return 'HttpOptions('
        'headers: $headers, '
        'connectTimeout: $connectTimeout, '
        'receiveTimeout: $receiveTimeout, '
        'sendTimeout: $sendTimeout, '
        'contentType: $contentType, '
        'extra: $extra'
        ')';
  }
}