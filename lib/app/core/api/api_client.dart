import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';

class ApiClient {
  factory ApiClient() => _instance;

  ApiClient._()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.serverBaseUrl,
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  static final ApiClient _instance = ApiClient._();

  final Dio dio;

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await dio.get<dynamic>(path);
      return _asJsonMap(response.data);
    } on DioException catch (error) {
      throw ApiException(
        _messageFor(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dio.post<dynamic>(path, data: data);
      return _asJsonMap(response.data);
    } on DioException catch (error) {
      throw ApiException(
        _messageFor(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Map<String, dynamic> _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const ApiException('Format respons backend tidak valid.');
  }

  String _messageFor(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi ke backend melewati batas waktu.';
      case DioExceptionType.connectionError:
        return 'Backend tidak dapat diakses.';
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        if (data is Map && data['detail'] != null) {
          return data['detail'].toString();
        }
        return 'Backend mengembalikan error ${error.response?.statusCode ?? ''}.'
            .trim();
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return 'Terjadi gangguan saat menghubungi backend.';
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
