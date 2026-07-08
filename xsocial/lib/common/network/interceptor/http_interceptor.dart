/// Transport-layer agnostic interceptor interface.
///
/// Concrete implementations (e.g. auth token, logging) are
/// converted to the transport's native interceptor type
/// by the client implementation.
abstract interface class HttpInterceptor {
  const HttpInterceptor();

  /// Called before the request is sent.
  ///
  /// Return modified headers or an empty map.
  Map<String, dynamic> onRequest(Map<String, dynamic> headers) {
    return headers;
  }

  /// Called after a successful response is received.
  void onResponse(dynamic response) {}

  /// Called when an error occurs.
  void onError(Object error) {}




}
