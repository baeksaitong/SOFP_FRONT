import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_jwt.dart';
import '../providers/provider.dart';
import 'package:http/http.dart' as http;

class DiseaseAllergyService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  // Future<void> diseaseAllergyList() async {
  //   final String? accessToken = await _jwtManager.getAccessToken();
  //   final url = buildUri('/app/disease-allergy');
  //   final response = await http.get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
  //     },
  //   );
  //
  //   var decodedResponse = utf8.decode(response.bodyBytes);
  //   var jsonResponse = jsonDecode(decodedResponse);
  //   if (response.statusCode == 200) {
  //     print('질병 및 알레르기 불러오기 성공 : $jsonResponse');
  //   } else {
  //     print(response.statusCode);
  //     print('질병 및 알레르기 불러오기 실패 : $jsonResponse');
  //   }
  // }
  //
  // Future<void> diseaseAllergySearch(String keyword) async {
  //   final String? accessToken = await _jwtManager.getAccessToken();
  //   final url = buildUri('/app/disease-allergy/search?keyword=$keyword');
  //   final response = await http.get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
  //     },
  //   );
  //
  //   var decodedResponse = utf8.decode(response.bodyBytes);
  //   var jsonResponse = jsonDecode(decodedResponse);
  //   if (response.statusCode == 200) {
  //     print('검색 성공 : $jsonResponse');
  //   } else {
  //     print(response.statusCode);
  //     print('검색 실패 : $jsonResponse');
  //   }
  // }
  //
  // Future<void> diseaseAllergyGet(BuildContext context, String keyword) async {
  //   final currentProfile =
  //       Provider.of<ProfileProvider>(context, listen: false).currentProfile;
  //   final String? accessToken = await _jwtManager.getAccessToken();
  //   final url = buildUri('/app/disease-allergy/${currentProfile?.id}');
  //   final response = await http.get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
  //     },
  //   );
  //
  //   var decodedResponse = utf8.decode(response.bodyBytes);
  //   var jsonResponse = jsonDecode(decodedResponse);
  //   if (response.statusCode == 200) {
  //     print('질병 및 알레르기 목록 조회 성공 : $jsonResponse');
  //   } else {
  //     print(response.statusCode);
  //     print('질병 및 알레르기 목록 조회 실패 : $jsonResponse');
  //   }
  // }

  Future<List<String>?> diseaseAllergyList(BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    if (currentProfile == null) return null;

    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/disease-allergy/${currentProfile.id}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return List<String>.from(jsonResponse['DiseaseAllergyList']);
    } else {
      print('질병 및 알레르기 목록 조회 실패: ${response.statusCode}');
      return null;
    }
  }

  Future<List<String>?> diseaseAllergySearch(String keyword, {int page = 1, int pageSize = 30}) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/disease-allergy/search?keyword=$keyword&page=$page&pageSize=$pageSize');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final List<String> diseaseAllergyList = List<String>.from(jsonResponse['DiseaseAllergyList']);

      // 갯수 출력
      print('검색된 질병 및 알레르기 수: ${diseaseAllergyList.length}');
      print('질병 및 알레르기 검색 중: $jsonResponse');

      return diseaseAllergyList;
    } else {
      print('질병 및 알레르기 검색 실패: ${response.statusCode}');
      return null;
    }
  }

  Future<List<String>?> diseaseAllergyGet(BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    if (currentProfile == null) return null;

    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/disease-allergy/${currentProfile.id}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print('질병 및 알레르기 목록 조회 성공: $jsonResponse');
      return List<String>.from(jsonResponse['DiseaseAllergyList']);
    } else {
      print('질병 및 알레르기 목록 조회 실패: ${response.statusCode}');
      return null;
    }
  }

  Future<void> diseaseAllergyAddOrDelete(BuildContext context,
      String? addDiseaseAllergyList, String? removeDiseaseAllergyList) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/disease-allergy/${currentProfile?.id}');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
      body: jsonEncode(<String, dynamic>{
        "addDiseaseAllergyList": [addDiseaseAllergyList],
        "removeDiseaseAllergyList": [removeDiseaseAllergyList]
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('추가 및 삭제 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('추가 및 삭제 실패 : $jsonResponse');
    }
  }
}
