import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../models/models_profile.dart';
import '../providers/provider.dart';
import '../managers/managers_global_response.dart';
import 'services_disease_allergy.dart';
import 'services_pill.dart';
import 'services_profile.dart';

class AuthService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  Future<void> naverLogin(BuildContext context, String code) async {
    final response = await get(Uri.parse('/app/oauth/naver?code=$code'));

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      final tokenData = jsonResponse['token'];
      final accessToken = tokenData['accessToken'];
      final refreshToken = tokenData['refreshToken'];

      if (tokenData == null) {
        print('Error: Missing token data in response');
      }

      await _jwtManager.saveTokens(accessToken, refreshToken);
      print('로그인 성공: $jsonResponse');

      ProfileResponse? profileResponse = await ProfileService().profileAll();
      if (profileResponse!.profileList.isNotEmpty) {
        if (context.mounted) {
          Provider.of<ProfileProvider>(context, listen: false).setCurrentProfile(profileResponse.profileList[0]);
          print('프로필 설정 완료: ${profileResponse.profileList[0].name}');
        }
      }
      DiseaseAllergyService().diseaseAllergyList();
      if (context.mounted) {
        await PillService().recentViewPillGet(context);
      }
    } else {
      print(response.statusCode);
      print('로그인 실패: $jsonResponse');
    }
  }

  Future<void> signUp(String name, String birthday, String email, String gender, String pwd, bool advertisement) async {
    final response = await post(Uri.parse('/app/auth/sign-up'), body: {
      "name": name,
      "birthday": birthday,
      "email": email,
      "gender": gender,
      "password": pwd,
      "advertisement": advertisement,
    });

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('회원가입 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('회원가입 실패: $jsonResponse');
    }
  }

  Future<void> idCheck(String email) async {
    final response = await post(Uri.parse('/app/auth/id-check'), body: {"email": email});

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('사용 가능한 아이디 : $decodedResponse');
      mailSend(email);
    } else {
      print(response.statusCode);
      print('이미 사용 중인 아이디 : $decodedResponse');
    }
  }

  Future<void> mailSend(String email) async {
    final response = await post(Uri.parse('/app/verification/mail/send'), body: {"email": email});

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('전송 성공 : $decodedResponse');
    } else {
      print(response.statusCode);
      print('전송 실패 : $decodedResponse');
    }
  }

  Future<void> mailCheck(String email, String code) async {
    final response = await post(Uri.parse('/app/verification/mail/check'), body: {"email": email, "code": code});

    var decodedResponse = utf8.decode(response.bodyBytes);

    try {
      var jsonResponse = jsonDecode(decodedResponse);
      if (response.statusCode == 200) {
        print('전송 성공 : $jsonResponse');
      } else {
        print(response.statusCode);
        print('전송 실패 : $jsonResponse');
      }
    } catch (e) {
      if (response.statusCode == 200) {
        print('전송 성공 : $decodedResponse');
      } else {
        print(response.statusCode);
        print('전송 실패 : $decodedResponse');
      }
    }
  }

  Future<void> login(BuildContext context, String email, String pwd) async {
    final response = await post(
      Uri.parse('${APIClient.baseUrl}/app/auth/login'),
      body: {"email": email, "password": pwd},
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    if (decodedResponse.isEmpty) {
      print('서버 응답이 없습니다.');
      return;
    }

    var jsonResponse;
    try {
      jsonResponse = jsonDecode(decodedResponse);
    } catch (e) {
      print('JSON 디코딩 오류: $e');
      return;
    }

    if (response.statusCode == 200) {
      final tokenData = jsonResponse['token'];
      final accessToken = tokenData['accessToken'];
      final refreshToken = tokenData['refreshToken'];

      if (tokenData == null) {
        print('Error: Missing token data in response');
        return;
      }

      await _jwtManager.saveTokens(accessToken, refreshToken);
      print('로그인 성공: $jsonResponse');

      ProfileResponse? profileResponse = await ProfileService().profileAll();
      if (profileResponse != null && profileResponse.profileList.isNotEmpty) {
        if (context.mounted) {
          Provider.of<ProfileProvider>(context, listen: false).setProfileList(profileResponse.profileList);
          Provider.of<ProfileProvider>(context, listen: false).setCurrentProfile(profileResponse.profileList[0]);
        }
      }
    } else {
      print(response.statusCode);
      print('로그인 실패: $jsonResponse');
    }
  }

  Future<void> logout() async {
    await _jwtManager.deleteTokens();
  }
}
