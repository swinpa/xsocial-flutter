import 'package:dio/dio.dart';

import '../exception/api_exception.dart';
import '../http_options.dart';
import '../model/api_response.dart';
import '../network_config.dart';
import '../dio/dio_factory.dart';
import '../request/http_request.dart';
import '../typedef.dart';
import 'api_client.dart';

final class DioApiClient implements ApiClient {
  DioApiClient({
    required NetworkConfig config,
    HttpOptions? options,
    Dio? dio,
  })  : _config = config,
        _options = config.defaultOptions.merge(options),
        _dio = dio ?? DioFactory.create(config) {
    _applyOptions();
  }

  final Dio _dio;
  final NetworkConfig _config;
  final HttpOptions _options;

  /// Applies the per-client [HttpOptions] overrides on top of
  /// the global [NetworkConfig] defaults already baked into _dio.
  void _applyOptions() {
    final opts = _dio.options;
    opts.connectTimeout = _options.connectTimeout ?? _config.connectTimeout;
    opts.receiveTimeout = _options.receiveTimeout ?? _config.receiveTimeout;
    opts.sendTimeout = _options.sendTimeout ?? _config.sendTimeout;

    if (_options.headers.isNotEmpty) {
      opts.headers.addAll(_options.headers);
    }

    if (_options.contentType != null) {
      opts.contentType = _options.contentType;
    }
  }

  @override
  Future<ApiResponse<T>> request<T>(
    HttpRequest request, {
    DataDecoder<T>? decoder,
  }) async {
    try {
      // 合并层级：config.defaultOptions < client._options < request.options
      final mergedOptions = _options.merge(request.options);

      final response = await _dio.request<dynamic>(
        request.path,
        data: request.body,
        queryParameters: request.query,
        cancelToken: request.cancelToken,
        onSendProgress: request.onSendProgress,
        onReceiveProgress: request.onReceiveProgress,
        options: _buildOptions(mergedOptions, request),
      );

      return _parseResponse<T>(response.data, decoder);
    } on DioException catch (e) {
      throw _mapException(e);
    } catch (e) {
      throw ApiException.unknown(
        message: e.toString(),
      );
    }
  }

  Options _buildOptions(HttpOptions mergedOptions, HttpRequest request) {
    return Options(
      method: request.method.value,
      headers: {
        ...mergedOptions.headers,
        ...request.headers,
      },
      contentType: request.contentType ?? mergedOptions.contentType,
      extra: {
        ...mergedOptions.extra,
        ...request.extra,
      },
      responseType: ResponseType.json,
    );
  }

  ApiResponse<T> _parseResponse<T>(
    dynamic json,
    DataDecoder<T>? decoder,
  ) {
    if (json is! Json) {
      throw const ApiException.invalidResponse(
        message: 'Response is not a JSON object.',
      );
    }

    final raw = ApiResponse<Object?>.fromJson(json);

    if (!raw.isSuccess) {
      throw ApiException.server(
        code: raw.code,
        message: raw.message,
      );
    }

    T? data;

    if (raw.data != null) {
      if (decoder != null) {
        data = decoder(raw.data);
      } else {
        // When no decoder is provided, attempt a safe cast.
        // In debug mode, assert the runtime type matches T.
        assert(
          raw.data is T,
          'Type mismatch: expected $T, got ${raw.data.runtimeType}',
        );
        data = raw.data as T;
      }
    }

    return ApiResponse<T>(
      code: raw.code,
      message: raw.message,
      data: data,
    );
  }

  ApiException _mapException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException.connectionTimeout();

      case DioExceptionType.sendTimeout:
        return const ApiException.sendTimeout();

      case DioExceptionType.receiveTimeout:
        return const ApiException.receiveTimeout();

      case DioExceptionType.badCertificate:
        return const ApiException.badCertificate();

      case DioExceptionType.cancel:
        return const ApiException.cancel();

      case DioExceptionType.connectionError:
        return ApiException.network(
          message: exception.message ?? 'Network error',
        );

      case DioExceptionType.badResponse:
        return ApiException.http(
          statusCode: exception.response?.statusCode,
          message: exception.message ?? 'HTTP error',
        );

      case DioExceptionType.unknown:
        return ApiException.unknown(
          message: exception.message ?? 'Unknown error',
        );
      default:
        return ApiException.unknown(
          message: exception.message ?? 'Unknown error',
        );
    }
  }
}
