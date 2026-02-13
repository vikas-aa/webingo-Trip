import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_exception.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 40),
            receiveTimeout: const Duration(seconds: 40),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ),
        ) {
    // Optional: Logs for debugging (remove in production)
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: jsonEncode(body ?? {}),
      );

      // Sometimes Dio returns already decoded map
      dynamic raw = response.data;

      // If response is String -> decode it
      if (raw is String) {
        raw = jsonDecode(raw);
      }

      if (raw is! Map<String, dynamic>) {
        throw ApiException("Invalid response format");
      }

      final data = raw;

      // Handle error format:
      // { "error": "...", "status": 500 }
      if (data.containsKey("error")) {
        throw ApiException(
          data["error"].toString(),
          statusCode: data["status"] is int ? data["status"] : null,
        );
      }

      // Handle normal API fail format:
      // { status: "fail", message: "..." }
      if (data["status"] != null &&
          data["status"].toString().toLowerCase() != "success") {
        throw ApiException(data["message"]?.toString() ?? "Something went wrong");
      }

      return data;
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? "Network error";
      throw ApiException(msg, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
