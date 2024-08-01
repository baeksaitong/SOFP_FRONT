import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sopf_front/managers/managers_jwt.dart';

class APIClient {
  static String? baseUrl = dotenv.env['API_URL'];

  Uri buildUri(String endpoint) {
    // baseUrl과 endpoint를 결합하여 완전한 URL을 만듭니다.
    return Uri.parse('$baseUrl$endpoint');
  }
}
