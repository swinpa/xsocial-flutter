import './exception/api_exception.dart';

sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends ApiResult<T> {
  const Failure(this.error);

  final ApiException error;
}

extension ApiResultX<T> on ApiResult<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiException error) failure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Failure<T>(error: final error) => failure(error),
    };
  }

  T getOrThrow() {
    return switch (this) {
      Success<T>(data: final data) => data,
      Failure<T>(error: final error) => throw error,
    };
  }
}