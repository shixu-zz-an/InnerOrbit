import 'package:dio/dio.dart';

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
    final response = await _dio.get<Object?>(
      path,
      queryParameters: query,
      options: await _options(),
    );
    return _unwrap(response.data, parse);
  }

  Future<T> post<T>(
    String path,
    Object? body,
    T Function(Object? json) parse,
  ) async {
    final response = await _dio.post<Object?>(
      path,
      data: body,
      options: await _options(),
    );
    return _unwrap(response.data, parse);
  }

  Future<T> put<T>(
    String path,
    Object? body,
    T Function(Object? json) parse,
  ) async {
    final response = await _dio.put<Object?>(
      path,
      data: body,
      options: await _options(),
    );
    return _unwrap(response.data, parse);
  }

  Future<T> delete<T>(
    String path,
    Object? body,
    T Function(Object? json) parse,
  ) async {
    final response = await _dio.delete<Object?>(
      path,
      data: body,
      options: await _options(),
    );
    return _unwrap(response.data, parse);
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
