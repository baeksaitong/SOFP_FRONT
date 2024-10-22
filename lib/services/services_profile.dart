import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import 'package:http/http.dart' as http;
import '../managers/managers_global_response.dart';
import '../managers/managers_jwt.dart';
import '../models/models_profile.dart';
import '../providers/provider.dart';

class ProfileService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  var logger = Logger();

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
    } else {
      // 에러 처리
      logger.e('회원가입 실패: $jsonResponse');
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

      Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
      return ProfileResponse.fromJson(jsonResponse);
    } else {
      // 실패 처리
      logger.e('실패했습니다: ${response.body}');
      return null;
    }
  }

  Future<void> profilePost(
      String name, String birthday, String gender, String color, XFile? _image
      ) async {
    final String? accessToken = await _jwtManager.getAccessToken();

    var url = buildUri('/app/profile');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // 이미지 파일을 base64로 인코딩
    String? base64Image;
    if (_image != null) {
      List<int> imageBytes = await _image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    var body = jsonEncode({
      'name': name,
      'birthday': birthday,
      'gender': gender,
      'color': color,
      'profileImg': base64Image, // 이미지 파일이 있을 경우 추가
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      logger.e('프로필이 성공적으로 저장되었습니다');
    } else {
      logger.e('Response body: ${response.body}');
    }
  }

  Future<ProfileDetail?> profileDetail(BuildContext context) async {
    // 현재 선택된 프로필 가져오기
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();

    // API 요청을 위한 URL 설정
    final url = buildUri('/app/profile/${currentProfile?.id}/detail');

    // API 요청
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    // 응답이 성공적인 경우
    if (response.statusCode == 200) {
      // 응답 데이터를 디코딩
      String decodedResponse = utf8.decode(response.bodyBytes);

      // JSON 응답을 Profile 객체로 변환
      Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);

      // Profile 객체로 반환
      return ProfileDetail.fromJson(jsonResponse);
    } else {
      // 실패 시 오류 처리
      logger.e('실패했습니다: ${response.body}');
      return null;
    }
  }

  Future<void> profilePut(
      String name, String birthdate, String gender, String color, XFile? _image, BuildContext context
      ) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final GlobalResponseManager responseManager = GlobalResponseManager();

    var url = buildUri('/app/profile/${currentProfile?.id}');
    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['name'] = name;
    request.fields['birthday'] = birthdate;
    request.fields['gender'] = gender;
    request.fields['color'] = color;

    if (_image != null && _image.path.isNotEmpty) {
      request.files.add(
          await http.MultipartFile.fromPath('profileImg', _image!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      responseManager.addResponse(responseString);

      final updatedProfiles = await profileAll();

      if (updatedProfiles != null) {
        // ProfileProvider에 프로필 목록과 현재 프로필 상태 갱신
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        profileProvider.setProfileList(updatedProfiles.profileList);
        profileProvider.setCurrentProfile(updatedProfiles.profileList[0]); // 예시로 첫번째 프로필 선택
      }
    } else {
      logger.e('Response body: ${await response.stream.bytesToString()}');
    }
  }
}
