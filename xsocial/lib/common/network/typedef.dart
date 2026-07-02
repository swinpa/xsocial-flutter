/// JSON object.
typedef Json = Map<String, dynamic>;

/// Converts a JSON object into a model.
///
/// Example:
/// ```dart
/// User.fromJson
/// ```
typedef JsonParser<T> = T Function(Json json);

/// Converts raw response data into a strongly typed object.
///
/// Unlike [JsonParser], this decoder accepts any JSON value,
/// including:
///
/// - Map<String, dynamic>
/// - List
/// - String
/// - num
/// - bool
/// - null
///
/// Examples:
///
/// ```dart
/// decoder: (json) => Parser.object(json, User.fromJson)
/// ```
///
/// ```dart
/// decoder: (json) => Parser.list(json, User.fromJson)
/// ```
///
/// ```dart
/// decoder: (json) => json as String
/// ```
typedef DataDecoder<T> = T Function(Object? value);

/// Upload / Download progress callback.
typedef ProgressCallback = void Function(
  int current,
  int total,
);