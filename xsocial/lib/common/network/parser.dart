import 'typedef.dart';

/// Utility methods for converting raw JSON into strongly typed objects.
final class Parser {
  const Parser._();

  /// Parses a JSON object.
  ///
  /// Example:
  /// ```dart
  /// final user = Parser.object(json, User.fromJson);
  /// ```
  static T object<T>(
    Object? value,
    JsonParser<T> parser,
  ) {
    if (value == null) {
      throw const FormatException(
        'Expected JSON object but received null.',
      );
    }

    if (value is! Json) {
      throw FormatException(
        'Expected Map<String, dynamic>, '
        'got ${value.runtimeType}.',
      );
    }

    return parser(value);
  }

  /// Parses a JSON array.
  ///
  /// Example:
  /// ```dart
  /// final users = Parser.list(json, User.fromJson);
  /// ```
  static List<T> list<T>(
    Object? value,
    JsonParser<T> parser,
  ) {
    if (value == null) {
      return const [];
    }

    if (value is! List) {
      throw FormatException(
        'Expected List, got ${value.runtimeType}.',
      );
    }

    return value.map((element) {
      if (element is! Json) {
        throw FormatException(
          'Expected Map<String, dynamic>, '
          'got ${element.runtimeType}.',
        );
      }

      return parser(element);
    }).toList(growable: false);
  }

  /// Parses a nullable JSON object.
  static T? nullable<T>(
    Object? value,
    JsonParser<T> parser,
  ) {
    if (value == null) {
      return null;
    }

    return object(value, parser);
  }

  /// Returns the value as-is after runtime type checking.
  ///
  /// Useful for primitive types or already decoded objects.
  ///
  /// Example:
  /// ```dart
  /// final token = Parser.value<String>(json);
  /// ```
  static T value<T>(Object? value) {
    if (value is T) {
      return value;
    }

    throw FormatException(
      'Expected $T, got ${value.runtimeType}.',
    );
  }

  /// Returns a nullable value after runtime type checking.
  static T? nullableValue<T>(Object? value) {
    if (value == null) {
      return null;
    }

    return Parser.value<T>(value);
  }
}