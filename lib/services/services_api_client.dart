import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sopf_front/managers/managers_jwt.dart';

class APIClient {
  static String? baseUrl = dotenv.env['API_URL'];
  final JWTManager _jwtManager = JWTManager();

  Future<http.Response> get(Uri endpoint, {Map<String, String>? headers}) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    return await http.get(
      endpoint,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        ...?headers,
      },
    );
  }

  Future<http.Response> post(Uri endpoint, {Map<String, String>? headers, dynamic body}) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    return await http.post(
      endpoint,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        ...?headers,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(Uri endpoint, {Map<String, String>? headers, dynamic body}) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    return await http.patch(
      endpoint,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        ...?headers,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(Uri endpoint, {Map<String, String>? headers}) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    return await http.delete(
      endpoint,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
        ...?headers,
      },
    );
  }
}
