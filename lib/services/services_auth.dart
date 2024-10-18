import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../models/models_profile.dart';
import '../navigates.dart';
import '../providers/provider.dart';
import 'package:http/http.dart' as http;
import 'services_disease_allergy.dart';
import 'services_pill.dart';
import 'services_profile.dart';

class AuthService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  final ProfileService profileService = ProfileService();
  final DiseaseAllergyService diseaseAllergyService = DiseaseAllergyService();
  final PillService pillService = PillService();

  var logger = Logger();

  Future<void> naverLogin(BuildContext context, String code) async {
    final Uri url = buildUri('/app/oauth/naver?code=$code');
    final response = await http.get(
      url,
      headers: {'accept': '*/*'},
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // Check if tokens are not null
      final tokenData = jsonResponse['token'];
      final accessToken = tokenData['accessToken'];
      final refreshToken = tokenData['refreshToken'];

      await _jwtManager.saveTokens(accessToken, refreshToken);

      ProfileResponse? profileResponse = await profileService.profileAll();
      if (profileResponse != null && profileResponse.profileList.isNotEmpty) {
        if (context.mounted) {
          // context가 여전히 유효한지 확인
          Provider.of<ProfileProvider>(context, listen: false)
              .setCurrentProfile(profileResponse.profileList[0]);
        }
      }
      if(context.mounted) {
        pillService.recentViewPillGet(context);
      }
    } else {
      logger.e('로그인 실패: $jsonResponse');
    }
  }

  Future<void> signUp(String name, String birthday, String email, String gender,
      String pwd, bool advertisement) async {
    final url = buildUri('/app/auth/sign-up');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "birthday": birthday,
        "email": email,
        "gender": gender,
        "password": pwd,
        "advertisement": advertisement
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

  Future<void> idCheck(String email) async {
    final url = buildUri('/app/auth/id-check');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      mailSend(email);
    } else {
      logger.e('이미 사용 중인 아이디 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
    }
  }

  Future<void> mailSend(String email) async {
    final url = buildUri('/app/verification/mail/send');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
    } else {
      logger.e('전송 실패 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
    }
  }

  Future<bool> mailCheck(String email, String code) async {
    final url = buildUri('/app/verification/mail/check');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "code": code,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    try {
      var jsonResponse = jsonDecode(decodedResponse);
      if (response.statusCode == 200) {
        return true;  // 인증 성공 시 true 반환
      } else {
        logger.e('전송 실패 : $jsonResponse');
        return false;  // 인증 실패 시 false 반환
      }
    } catch (e) {
      if (response.statusCode == 200) {
        return true;  // 성공 시 true 반환
      } else {
        logger.e('전송 실패 : $decodedResponse');
        return false;  // 실패 시 false 반환
      }
    }
  }


  Future<void> login(BuildContext context, String email, String pwd) async {
    final url = buildUri('/app/auth/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "password": pwd,
      }),
    );
    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // Check if tokens are not null
      final tokenData = jsonResponse['token'];
      final accessToken = tokenData['accessToken'];
      final refreshToken = tokenData['refreshToken'];

      if (tokenData == null) {
        logger.e('Error: Missing token data in response');
      }

      await _jwtManager.saveTokens(accessToken, refreshToken);

      ProfileResponse? profileResponse = await profileService.profileAll();
      if (profileResponse != null && profileResponse.profileList.isNotEmpty) {
        // Ensure `context` is passed with `listen: false`
        if(context.mounted) {
          Provider.of<ProfileProvider>(context, listen: false).setProfileList(profileResponse.profileList);
          Provider.of<ProfileProvider>(context, listen: false)
              .setCurrentProfile(profileResponse.profileList[0]);
        }
      }
      if (context.mounted) {
        await pillService.recentViewPillGet(context); // await 추가
        await pillService.pillGet(context, null); // await 추가
      }
      Navigator.pop(context); // 로그인 페이지 끄기
      if (jsonResponse['isNew'] == false) {
        navigateToAddAllergy();
      } else {
        navigateToHome();
      }
    } else {
      logger.e('로그인 실패: $jsonResponse');
    }
  }

  Future<void> logout() async {
    await _jwtManager.deleteTokens();
  }
}
