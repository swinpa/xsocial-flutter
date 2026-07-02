/// Base exception for all network related errors.
class ApiException implements Exception {
  const ApiException({
    required this.type,
    required this.message,
    this.code,
    this.statusCode,
  });

  /// Exception category.
  final ApiExceptionType type;

  /// Business error code.
  final int? code;

  /// HTTP status code.
  final int? statusCode;

  /// Error message.
  final String message;

  const ApiException.network({
    String message = 'Network error',
  }) : this(
          type: ApiExceptionType.network,
          message: message,
        );

  const ApiException.connectionTimeout({
    String message = 'Connection timeout',
  }) : this(
          type: ApiExceptionType.connectionTimeout,
          message: message,
        );

  const ApiException.sendTimeout({
    String message = 'Send timeout',
  }) : this(
          type: ApiExceptionType.sendTimeout,
          message: message,
        );

  const ApiException.receiveTimeout({
    String message = 'Receive timeout',
  }) : this(
          type: ApiExceptionType.receiveTimeout,
          message: message,
        );

  const ApiException.cancel({
    String message = 'Request cancelled',
  }) : this(
          type: ApiExceptionType.cancel,
          message: message,
        );

  const ApiException.badCertificate({
    String message = 'Bad certificate',
  }) : this(
          type: ApiExceptionType.badCertificate,
          message: message,
        );

  const ApiException.http({
    int? statusCode,
    String message = 'Http error',
  }) : this(
          type: ApiExceptionType.http,
          statusCode: statusCode,
          message: message,
        );

  const ApiException.server({
    required int code,
    required String message,
  }) : this(
          type: ApiExceptionType.server,
          code: code,
          message: message,
        );

  const ApiException.invalidResponse({
    String message = 'Invalid response',
  }) : this(
          type: ApiExceptionType.invalidResponse,
          message: message,
        );

  const ApiException.unknown({
    String message = 'Unknown error',
  }) : this(
          type: ApiExceptionType.unknown,
          message: message,
        );

  @override
  String toString() {
    return 'ApiException('
        'type: $type, '
        'code: $code, '
        'statusCode: $statusCode, '
        'message: $message'
        ')';
  }
}

enum ApiExceptionType {
  /// Device network unavailable / DNS / SocketException.
  network,

  /// Dio connection timeout.
  connectionTimeout,

  /// Dio send timeout.
  sendTimeout,

  /// Dio receive timeout.
  receiveTimeout,

  /// Request cancelled.
  cancel,

  /// SSL certificate error.
  badCertificate,

  /// HTTP status code error (404/500...).
  http,

  /// Business error returned by server (code != 0).
  server,

  /// Response format is invalid.
  invalidResponse,

  /// Unknown exception.
  unknown,
}