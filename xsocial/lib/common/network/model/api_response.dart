import '../typedef.dart';

/// Standard API response.
///
/// Server response format:
///
/// ```json
/// {
///   "code": 0,
///   "message": "success",
///   "data": {}
/// }
/// ```
final class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  /// Business status code.
  final int code;

  /// Business message.
  final String message;

  /// Parsed response data.
  final T? data;

  /// Whether the business request succeeded.
  bool get isSuccess => code == 0;

  /// Creates an [ApiResponse] from raw JSON.
  ///
  /// The `data` field is left unparsed and should be decoded
  /// separately by the network client.
  factory ApiResponse.fromJson(Json json) {
    return ApiResponse<T>(
      code: _parseCode(json['code']),
      message: (json['message'] ?? '').toString(),
      data: json['data'] as T?,
    );
  }

  static int _parseCode(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? -1;
    }

    return -1;
  }

  Json toJson() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'ApiResponse<$T>('
        'code: $code, '
        'message: $message, '
        'data: $data'
        ')';
  }
}