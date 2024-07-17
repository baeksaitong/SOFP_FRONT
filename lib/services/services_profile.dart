import 'dart:convert';

import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_global_response.dart';
import '../models/models_profile.dart';

class ProfileService extends APIClient {
  Future<void> profileAdd(String name, String birthday, String gender, String color, String? profileImg) async {
    final response = await post(
      Uri.parse('${APIClient.baseUrl}/app/profile/add'),
      body: {
        "name": name,
        "birthday": birthday,
        "gender": gender,
        "color": color,
        "profileImg": profileImg,
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('프로필 추가 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('프로필 추가 실패: $jsonResponse');
    }
  }

  Future<ProfileResponse?> profileAll() async {
    final response = await get(
      Uri.parse('${APIClient.baseUrl}/app/profile'),
    );

    if (response.statusCode == 200) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('모든 프로필 조회 성공: $decodedResponse');
      Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
      return ProfileResponse.fromJson(jsonResponse);
    } else {
      print(response.statusCode);
      print('프로필 조회 실패: ${response.body}');
      return null;
    }
  }
}
