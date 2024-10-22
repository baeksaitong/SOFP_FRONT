import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sopf_front/services/services_api_client.dart';
import 'package:http/http.dart' as http;

import '../managers/managers_jwt.dart';
import '../models/models_pharmacy_info.dart';  // Pharmacy 모델 임포트

class PharmacyService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  var logger = Logger();

  Future<List<Pharmacy>?> pharmacyAroundGet(BuildContext context, String longitude, String latitude) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/pharmacy/around?longitude=$longitude&latitude=$latitude&distance=100000.0');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(jsonResponse)['aroundPharmacyList'];
      return jsonList.map((item) => Pharmacy.fromJson(item)).toList();
    } else {
      logger.e('주변 약국 조회 실패: ${response.statusCode}, 응답: ${utf8.decode(response.bodyBytes)}');
      return null;
    }
  }

  Future<List<Pharmacy>?> pharmacyNightGet(BuildContext context, String longitude, String latitude) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/pharmacy/night?longitude=$longitude&latitude=$latitude&distance=100000.0');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(jsonResponse)['aroundPharmacyList'];
      return jsonList.map((item) => Pharmacy.fromJson(item)).toList();
    } else {
      logger.e('야간 약국 조회 실패: ${response.statusCode}, 응답: ${utf8.decode(response.bodyBytes)}');
      return null;
    }
  }
}
