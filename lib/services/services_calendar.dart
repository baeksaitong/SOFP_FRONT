import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_jwt.dart';
import '../providers/provider.dart';

import 'package:http/http.dart' as http;

class CalendarService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  var logger = Logger();

  Future<void> calendarGet(BuildContext context, String id) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/calendar/$id');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
    } else {
      // 실패 처리
      logger.e('프로필 캘린더 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> calendarPut(BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final profileList = Provider.of<ProfileProvider>(context, listen: false).profileList;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/calendar/${currentProfile?.id}');
    final response = await http.put(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    },
      body: jsonEncode(<String, dynamic>{
        "addTargetProfileIdList": [
          profileList[0].id,profileList[1].id,
        ],
        "deleteTargetProfileIdList": [
          profileList[2].id,
        ]
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
    } else {
      // 실패 처리
      logger.e('일부 캘린더 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
