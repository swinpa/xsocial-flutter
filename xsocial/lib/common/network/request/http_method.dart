/// HTTP request methods.
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  head('HEAD');

  const HttpMethod(this.value);

  /// HTTP method string.
  final String value;
}