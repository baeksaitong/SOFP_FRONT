import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_jwt.dart';
import '../managers/managers_recent_histories.dart';
import '../managers/managers_taking_drugs.dart';
import '../providers/provider.dart';
import 'package:http/http.dart' as http;

class PillService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  var logger = Logger();

  Future<void> pillPost(BuildContext context, int serialNumber) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/pill/${currentProfile?.id}');
    final response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    },
      body: jsonEncode(<String, dynamic>{
        "pillSeriallNumberList": [serialNumber],
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      logger.e('복용 중인 알약 추가 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      logger.e('복용 중인 알약 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillDelete(BuildContext context, int serialNumber) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/pill/${currentProfile?.id}?pillSerialNumber=$serialNumber');
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      logger.e('복용 중인 알약 삭제 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      logger.e('복용 중인 알약 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillPatch(BuildContext context, int serialNumber, String categoryId) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/pill/${currentProfile?.id}');
    final response = await http.patch(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    },
      body: jsonEncode(<String, dynamic>{
        "pillSerialNumber": serialNumber,
        "categoryId": categoryId
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      logger.e('복용 중인 알약 이동 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      logger.e('복용 중인 알약 이동 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillGet(BuildContext context, String? categoryId) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final Uri url;

    if (categoryId != null) {
      url = buildUri('/app/pill?categoryId=$categoryId');
    } else {
      url = buildUri('/app/pill?profileId=${currentProfile?.id}&categoryId=$categoryId');
    }
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      TakingDrugsManager().updateDrugs(jsonResponse);
    } else {
      // 실패 처리
      logger.e('복용 중인 알약 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> recentViewPillGet(BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/recent-view/${currentProfile?.id}?count=10');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      RecentHistoriesManager().updateFavorites(utf8.decode(response.bodyBytes));
    } else {
      logger.e('최근 조회 알약 조회 실패 : $jsonResponse');
    }
  }

  Future<bool> recentViewPillDelete(int pillSerialNumber, BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/recent-view/${currentProfile?.id}?pillSerialNumber=$pillSerialNumber');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes); // 응답을 UTF-8로 디코딩
    if (response.statusCode == 200) {
      return true;
    } else {
      logger.e('최근 조회 알약 삭제 실패 : $decodedResponse');
      return false;
    }
  }
}
