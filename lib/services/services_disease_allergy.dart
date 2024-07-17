import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../providers/provider.dart';

class DiseaseAllergyService extends APIClient {
  Future<void> diseaseAllergyList() async {
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/disease-allergy'));

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('질병 및 알레르기 목록 조회 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('질병 및 알레르기 목록 조회 실패: $jsonResponse');
    }
  }

  Future<void> diseaseAllergySearch(String keyword) async {
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/disease-allergy/search?keyword=$keyword'));

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('검색 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('검색 실패: $jsonResponse');
    }
  }

  Future<void> diseaseAllergyGet(BuildContext context, String keyword) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/disease-allergy/${currentProfile?.id}'));

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('질병 및 알레르기 목록 조회 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('질병 및 알레르기 목록 조회 실패: $jsonResponse');
    }
  }

  Future<void> diseaseAllergyAddOrDelete(BuildContext context, String? addDiseaseAllergyList, String? removeDiseaseAllergyList) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await patch(
      Uri.parse('${APIClient.baseUrl}/app/disease-allergy/${currentProfile?.id}'),
      body: {
        "addDiseaseAllergyList": [addDiseaseAllergyList],
        "removeDiseaseAllergyList": [removeDiseaseAllergyList]
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('추가 및 삭제 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('추가 및 삭제 실패: $jsonResponse');
    }
  }
}
