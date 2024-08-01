import 'dart:convert';

import 'package:sopf_front/services/services_api_client.dart';

import 'package:http/http.dart' as http;
import '../managers/managers_jwt.dart';
import '../models/models_profile.dart';

class ProfileService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  Future<void> profileAdd(String name, String birthday, String gender,
      String color, String? profileImg) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/profile/add');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "birthday": birthday,
        "gender": gender,
        "color": color,
        "profileImg": profileImg,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      // 회원가입 성공 처리
      print('회원가입 성공: $jsonResponse');
    } else {
      // 에러 처리
      print(response.statusCode);
      print('회원가입 실패: $jsonResponse');
    }
  }

  Future<ProfileResponse?> profileAll() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/profile');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('모든 멤버 출력: $decodedResponse');

      Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
      return ProfileResponse.fromJson(jsonResponse);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패했습니다: ${response.body}');
      return null;
    }
  }
}
