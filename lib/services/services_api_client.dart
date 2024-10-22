import 'dart:convert';

import 'package:sopf_front/managers/managers_jwt.dart';

class APIClient {
  static String baseUrl = const String.fromEnvironment('API_URL', defaultValue: 'http://default-url.com');
  final JWTManager _jwtManager = JWTManager();

  Uri buildUri(String endpoint) {
    if (baseUrl.isEmpty) {
      throw ArgumentError('Base URL not set');
    }
    // Ensure the endpoint is correctly formatted
    return Uri.parse('$baseUrl$endpoint');
  }
  Future<String> getValidAccessToken() async {
    return await _jwtManager.getValidAccessToken();
  }
}
