import 'package:dio/dio.dart';

import '../exception/api_exception.dart';
import '../http_options.dart';
import '../model/api_response.dart';
import '../network_config.dart';
import '../request/http_request.dart';
import '../typedef.dart';
import 'api_client.dart';

final class DioApiClient implements ApiClient {
  DioApiClient({
    required NetworkConfig config,
    HttpOptions options = const HttpOptions(),
    Dio? dio,
  })  : _config = config,
        _options = options,
        _dio = dio ?? Dio() {
    _initialize();
  }

  final Dio _dio;
  final NetworkConfig _config;
  final HttpOptions _options;

  void _initialize() {
    _dio.options = BaseOptions(
      baseUrl: _config.baseUrl,
      headers: Map<String, dynamic>.from(_options.headers),
      connectTimeout: _options.connectTimeout,
      receiveTimeout: _options.receiveTimeout,
      sendTimeout: _options.sendTimeout,
      contentType: _options.contentType,
      responseType: ResponseType.json,
      followRedirects: false,
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
    );

    if (_config.interceptors.isNotEmpty) {
      _dio.interceptors.addAll(_config.interceptors);
    }
  }

  @override
  Future<ApiResponse<T>> request<T>(
    HttpRequest request, {
    DataDecoder<T>? decoder,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        request.path,
        data: request.body,
        queryParameters: request.query,
        cancelToken: request.cancelToken,
        onSendProgress: request.onSendProgress,
        onReceiveProgress: request.onReceiveProgress,
        options: _buildOptions(request),
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

  Options _buildOptions(HttpRequest request) {
    return Options(
      method: request.method.value,
      headers: {
        ..._options.headers,
        ...request.headers,
      },
      contentType: request.contentType ?? _options.contentType,
      extra: {
        ..._options.extra,
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
        data = raw.data as T?;
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
