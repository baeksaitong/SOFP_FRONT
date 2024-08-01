import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sopf_front/services/services_api_client.dart';
import 'package:http/http.dart' as http;

import '../managers/managers_jwt.dart';

class PharmacyService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  Future<void> pharmacyAroundGet(BuildContext context, String longitude, String latitude) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/pharmacy/around?longitude=$longitude&latitude=$latitude&distance=1000.0');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('주변 약국 조회 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('주변 약국 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
