import '../model/api_response.dart';
import '../request/http_request.dart';
import '../typedef.dart';

/// Abstract HTTP client.
///
/// Business code should depend only on this interface,
/// never on the underlying HTTP implementation.
abstract interface class ApiClient {
  /// Sends an HTTP request.
  ///
  /// The server response is expected to follow the unified format:
  ///
  /// ```json
  /// {
  ///   "code": 0,
  ///   "message": "",
  ///   "data": ...
  /// }
  /// ```
  ///
  /// When the business status code is not successful, an
  /// `ApiException` should be thrown by the implementation.
  ///
  /// The optional [decoder] converts the raw `data` field into
  /// a strongly typed object.
  ///
  /// Examples:
  ///
  /// Parse an object:
  /// ```dart
  /// final response = await client.request<User>(
  ///   request,
  ///   decoder: (json) => Parser.object(json, User.fromJson),
  /// );
  /// ```
  ///
  /// Parse a list:
  /// ```dart
  /// final response = await client.request<List<User>>(
  ///   request,
  ///   decoder: (json) => Parser.list(json, User.fromJson),
  /// );
  /// ```
  ///
  /// Parse a primitive:
  /// ```dart
  /// final response = await client.request<String>(
  ///   request,
  ///   decoder: Parser.value,
  /// );
  /// ```
  Future<ApiResponse<T>> request<T>(
    HttpRequest request, {
    DataDecoder<T>? decoder,
  });
}