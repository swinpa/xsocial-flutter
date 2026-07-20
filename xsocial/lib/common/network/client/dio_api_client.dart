import 'package:dio/dio.dart';

import '../exception/api_exception.dart';
import '../http_options.dart';
import '../model/api_response.dart';
import '../network_config.dart';
import '../dio/dio_factory.dart';
import '../request/http_request.dart';
import '../typedef.dart';
import 'api_client.dart';
import '../../appinfo/appinfo.dart';
import '../../crypt/LLCrypt.dart';
import 'package:characters/characters.dart';
import '../../language/lllanguage.dart';
import '../../datetime/lldatetime.dart';
import '../../logger/llloger.dart';

/// 通用请求头提供者。
///
/// 每次发起请求时会调用此函数来获取通用的请求头，
import '../../../features/auth/models/login_response.dart';
/// 支持从任何地方动态读取（如 ref.watch、SecureStorage 等）。
/// HttpRequest 的请求头优先级高于此处返回值。
typedef HeadersProvider = Map<String, dynamic> Function();

/// 默认的通用请求头，包含设备与应用信息。
///
/// 可通过 [DioApiClient.headersProvider] 覆盖。
HeadersProvider _defaultHeadersProvider = () {
  // 这些值应在 app 启动时根据实际情况初始化

  /*

  [
    "phoneBrand": "Apple", 
    "phoneType": "x86_64", 
    "osVersion": "26.3.1", 
    "lang": "en", 
    "timestamp": "1784518161", 
    "appVersion": "1.1.0", 
    "appType": "ios", 
    "phoneOsVersion": "iOS26.3.1", 
    "sign": "81349021bcfdab92cc358e9b47c6e8c2", 
    "osUuid": "0DCB28B3-7F71-46AD-A994-5E8317B6607F", 
    "osType": "2"]

  */
  Map<String, dynamic> headers = {
      'lang': 'en',
      'appVersion': AppInfo.obj.version,
      'appType': 'ios',
      'osType': '2',
      'osVersion': AppInfo.obj.osVersion,
      'osUuid': "0DCB28B3-7F71-46AD-A994-5E8317B6607F",//AppInfo.obj.osUuid,
      'phoneBrand': AppInfo.obj.phoneBrand,
      'phoneType': "x86_64",//AppInfo.obj.phoneType,
      'phoneOsVersion': AppInfo.obj.phoneOsVersion,
    };
    var keys = headers.keys.toList()..sort();
    var signString = keys.map((e) => "$e=${headers[e]}").join("&");
    
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    headers["timestamp"] = timestamp.toString();
    //appType=ios&appVersion=1.1.0&lang=en&osType=2&osUuid=0DCB28B3-7F71-46AD-A994-5E8317B6607F&osVersion=26.3.1&phoneBrand=Apple&phoneOsVersion=iOS26.3.1&phoneType=x86_64&1784527607
    signString += "&$timestamp";

    var iv = "435746de6c3ee5cf9f8183713325ba17";
    var scretKey = iv + timestamp.toString();//435746de6c3ee5cf9f8183713325ba171784527607
    //
    var md5 = LLCrypt.llmd5(scretKey);// b94c01e644277a934bbba4d59a1205eb
    var finalScretKey = md5.characters.toList().reversed.join();// be5021a95d4abbb439a772446e10c49b

    //4625354e40e2dc283fbff4a6790e2f1c
    var signValue = LLCrypt.hmac(signString, HmacAlgorithm.md5, finalScretKey);
    headers["sign"] = signValue;

    var token = AuthResult.userToken;
    if (token != null) {
      headers["userToken"] = token;
    }
    headers["utc"] = LLDateTime.utc;
    headers["timezone"] = LLDateTime.timezone;


    headers["localeIdentifier"] = LLLanguage.localeIdentifier;
    headers["bundle_id"] = "com.xs.social.test";
    headers["dlang"] = LLLanguage.sysLanguage;//"zh";
    headers["idfa"] = "00000000-0000-0000-0000-000000000000";

    logger.i("DioApiClient default headers:\n$headers");

    return headers;
};

final class DioApiClient implements ApiClient {
  DioApiClient({
    required NetworkConfig config,
    HttpOptions? options,
    Dio? dio,
    HeadersProvider? headersProvider,
  })  : _config = config,
        _headersProvider = headersProvider ?? _defaultHeadersProvider,
        _options = config.defaultOptions.merge(options),
        _dio = dio ?? DioFactory.create(config) {
    _applyOptions();
  }

  final Dio _dio;
  final NetworkConfig _config;
  final HttpOptions _options;

  /// 每次请求发起前会调用此函数获取通用请求头。
  final HeadersProvider _headersProvider;
  HeadersProvider get headersProvider => _headersProvider;
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
      // 合并层级（后者覆盖前者）：
      //   config.defaultOptions < client._options < headersProvider < request.headers
      final dynamicHeaders = _headersProvider();
      final mergedOptions = _options.merge(request.options);

      final response = await _dio.request<dynamic>(
        request.path,
        data: request.body,
        queryParameters: request.query,
        cancelToken: request.cancelToken,
        onSendProgress: request.onSendProgress,
        onReceiveProgress: request.onReceiveProgress,
        options: _buildOptions(mergedOptions, request, dynamicHeaders),
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

  Options _buildOptions(
    HttpOptions mergedOptions,
    HttpRequest request,
    Map<String, dynamic> dynamicHeaders,
  ) {
    return Options(
      method: request.method.value,
      headers: {
        ...mergedOptions.headers,
        ...dynamicHeaders,
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
