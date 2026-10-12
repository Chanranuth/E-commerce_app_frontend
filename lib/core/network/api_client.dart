import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../errors/api_exception.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  static Uri buildUri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (auth) {
      final token = await SecureStorageService.readToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static dynamic decodeJson(http.Response response) {
    if (response.body.isEmpty) {
      return {};
    }

    try {
      return jsonDecode(response.body);
    } on FormatException {
      return {};
    }
  }

  static ApiException _toException(http.Response response) {
    final decoded = decodeJson(response);
    String message = 'Request failed';

    if (decoded is Map<String, dynamic>) {
      final dynamic payloadMessage = decoded['message'];
      if (payloadMessage is String && payloadMessage.isNotEmpty) {
        message = payloadMessage;
      }

      final dynamic errors = decoded['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          message = firstError.first.toString();
        }
      }
    }

    return ApiException(message, statusCode: response.statusCode);
  }

  static Future<http.Response> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = buildUri(path);
    final headers = await _headers(auth: auth);

    http.Response response;

    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: headers);
        break;
      default:
        throw UnsupportedError('Unsupported HTTP method: $method');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _toException(response);
    }

    return response;
  }
}
