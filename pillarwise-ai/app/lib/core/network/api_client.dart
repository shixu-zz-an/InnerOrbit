import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../storage/local_store.dart';

class ApiClient {
  ApiClient(this.config, this.store)
    : _dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

  final AppConfig config;
  final LocalStore store;
  final Dio _dio;

  Future<T> get<T>(
    String path,
    T Function(Object? json) parse, {
    Map<String, Object?>? query,
  }) async {
    return _send(
      'GET',
      path,
      () async => _dio.get<Object?>(
        path,
        queryParameters: query,
        options: await _options(),
      ),
      parse,
    );
  }

  Future<T> post<T>(
    String path,
    Object? body,
    T Function(Object? json) parse,
  ) async {
    return _send(
      'POST',
      path,
      () async =>
          _dio.post<Object?>(path, data: body, options: await _options()),
      parse,
    );
  }

  Future<T> put<T>(
    String path,
    Object? body,
    T Function(Object? json) parse,
  ) async {
    return _send(
      'PUT',
      path,
      () async =>
          _dio.put<Object?>(path, data: body, options: await _options()),
      parse,
    );
  }

  Future<T> delete<T>(
    String path,
    Object? body,
    T Function(Object? json) parse,
  ) async {
    return _send(
      'DELETE',
      path,
      () async =>
          _dio.delete<Object?>(path, data: body, options: await _options()),
      parse,
    );
  }

  Future<T> _send<T>(
    String method,
    String path,
    Future<Response<Object?>> Function() request,
    T Function(Object? json) parse,
  ) async {
    final url = '${config.apiBaseUrl}$path';
    debugPrint('[Pillarwise][API] $method $url');
    try {
      final response = await request();
      debugPrint(
        '[Pillarwise][API] $method $url -> ${response.statusCode} '
        'payload=${response.data.runtimeType}',
      );
      return _unwrap(response.data, parse);
    } on ApiException catch (error) {
      debugPrint('[Pillarwise][API] $method $url API_ERROR $error');
      rethrow;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      final message =
          error.message ?? error.error?.toString() ?? 'Network request failed.';
      debugPrint(
        '[Pillarwise][API] $method $url DIO_ERROR '
        'type=${error.type} status=$status error=${error.error} message=$message',
      );
      throw ApiException(
        'NETWORK_ERROR',
        'Network request failed: $message',
        details: {
          'method': method,
          'path': path,
          'status': status,
          'type': error.type.name,
        },
      );
    } catch (error) {
      debugPrint('[Pillarwise][API] $method $url UNKNOWN_ERROR $error');
      rethrow;
    }
  }

  Future<Options> _options() async {
    final token = await store.readToken();
    return Options(
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        'X-Request-Id': 'app_${DateTime.now().microsecondsSinceEpoch}',
      },
    );
  }

  T _unwrap<T>(Object? payload, T Function(Object? json) parse) {
    if (payload is! Map<String, dynamic>) {
      throw ApiException('INTERNAL_ERROR', 'Unexpected response format.');
    }
    if (payload['success'] == true) {
      return parse(payload['data']);
    }
    final error = payload['error'];
    if (error is Map<String, dynamic>) {
      throw ApiException(
        error['code']?.toString() ?? 'INTERNAL_ERROR',
        error['message']?.toString() ?? 'Something went wrong.',
        details: error['details'] is Map
            ? Map<String, Object?>.from(error['details'] as Map)
            : const {},
      );
    }
    throw ApiException('INTERNAL_ERROR', 'Something went wrong.');
  }
}

class ApiException implements Exception {
  const ApiException(this.code, this.message, {this.details = const {}});

  final String code;
  final String message;
  final Map<String, Object?> details;

  @override
  String toString() => '$code: $message';
}
