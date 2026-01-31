import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pos_v2/constants/app_constants.dart';

class ApiService extends GetxService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({required this.baseUrl, Map<String, String>? headers})
    : defaultHeaders = headers ?? {'Content-Type': 'application/json'};

  Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(
        queryParameters: queryParameters?.map(
          (k, v) => MapEntry(k, v.toString()),
        ),
      );
      final response = await http.get(
        uri,
        headers: {...defaultHeaders, ...?headers},
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: $e', data: null);
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http.post(
        uri,
        headers: {...defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error', data: null);
    }
  }

  Future<dynamic> postMultipart(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      if (headers != null) request.headers.addAll(headers);

      // Add fields
      if (fields != null) request.fields.addAll(fields);

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'Network error: $e', data: null);
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      AppConstants.logoutUser();

      throw ApiException(
        message: 'Session expired. Please login again.',
        data: null,
        statusCode: 401,
      );
    }

    try {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (_) {
      throw ApiException(
        message: 'Invalid response from server',
        data: null,
        statusCode: response.statusCode,
      );
    }
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final dynamic data;
  final int? statusCode;

  ApiException({required this.message, this.data, this.statusCode});

  @override
  String toString() => message;
}
