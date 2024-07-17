import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../providers/provider.dart';

class CalendarService extends APIClient {
  Future<void> calendarGet(BuildContext context, String id) async {
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/calendar/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('프로필 캘린더 조회 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('프로필 캘린더 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> calendarPut(BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final profileList = Provider.of<ProfileProvider>(context, listen: false).profileList;
    final response = await patch(
      Uri.parse('${APIClient.baseUrl}/app/calendar/${currentProfile?.id}'),
      body: {
        "addTargetProfileIdList": [
          profileList[0].id, profileList[1].id,
        ],
        "deleteTargetProfileIdList": [
          profileList[2].id,
        ]
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('일부 캘린더 조회 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('일부 캘린더 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
