import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_recent_histories.dart';
import '../managers/managers_tasking_drugs.dart';
import '../providers/provider.dart';
import '../managers/managers_global_response.dart';

class PillService extends APIClient {
  Future<void> pillPost(BuildContext context, int serialNumber) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await post(
      Uri.parse('${APIClient.baseUrl}/app/pill/${currentProfile?.id}'),
      body: {
        "pillSeriallNumberList": [serialNumber],
      },
    );

    if (response.statusCode == 200) {
      print('복용 중인 알약 추가 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      print(response.statusCode);
      print('복용 중인 알약 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillDelete(BuildContext context, int serialNumber) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await delete(
      Uri.parse('${APIClient.baseUrl}/app/pill/${currentProfile?.id}?pillSerialNumber=$serialNumber'),
    );

    if (response.statusCode == 200) {
      print('복용 중인 알약 삭제 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      print(response.statusCode);
      print('복용 중인 알약 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillPatch(BuildContext context, int serialNumber, String categoryId) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await patch(
      Uri.parse('${APIClient.baseUrl}/app/pill/${currentProfile?.id}'),
      body: {
        "pillSerialNumber": serialNumber,
        "categoryId": categoryId,
      },
    );

    if (response.statusCode == 200) {
      print('복용 중인 알약 이동 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      print(response.statusCode);
      print('복용 중인 알약 이동 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillGet(BuildContext context, String? categoryId) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String profileId = currentProfile?.id ?? '';
    final response = await get(
      Uri.parse('${APIClient.baseUrl}/app/pill?profileId=$profileId&categoryId=$categoryId'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('복용 중인 알약 조회 성공: ${utf8.decode(response.bodyBytes)}');
      TakingDrugsManager().updateDrugs(jsonResponse);
      print(TakingDrugsManager().drugs);
    } else {
      print(response.statusCode);
      print('복용 중인 알약 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> recentViewPillGet(BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await get(
      Uri.parse('${APIClient.baseUrl}/app/recent-view/${currentProfile?.id}?count=10'),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('최근 조회 알약 조회 성공: $jsonResponse');
      RecentHistoriesManager().updateFavorites(utf8.decode(response.bodyBytes));
    } else {
      print(response.statusCode);
      print('최근 조회 알약 조회 실패: $jsonResponse');
    }
  }

  Future<void> recentViewPillDelete(int pillSerialNumber, BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await delete(
      Uri.parse('${APIClient.baseUrl}/app/recent-view/${currentProfile?.id}?pillSerialNumber=$pillSerialNumber'),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      print('최근 조회 알약 삭제 성공: $decodedResponse');
    } else {
      print(response.statusCode);
      print('최근 조회 알약 삭제 실패: $decodedResponse');
    }
  }
}
