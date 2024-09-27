import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';
import 'package:sopf_front/services/services_pill.dart';

import '../managers/managers_drugs.dart';
import '../managers/managers_favorites.dart';
import '../managers/managers_jwt.dart';
import '../models/models_drug_info_detail.dart';
import '../providers/provider.dart';
import 'package:http/http.dart' as http;

class SearchService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  Future<void> searchTextAndShape(
      BuildContext context,
      String? keyword,
      String? shape,
      String? sign,
      String? color,
      String? formulation,
      String? line,
      String? lastId, // String으로 처리
      ) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();

    final url = buildUri('/app/search/keyword'
        '?profileId=${currentProfile?.id}'
        '&limit=10'
        '&lastId=$lastId'
        '&keyword=$keyword'
        '&shape=$shape'
        '&sign=$sign'
        '&color=$color'
        '&formulation=$formulation'
        '&line=$line');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);

      // DrugsManager를 사용하여 응답 업데이트
      DrugsManager().addDrugs(jsonResponse);
      print('검색 완료: ${DrugsManager().drugs.length}개의 알약이 검색됨');
    } else {
      print('검색 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchInfoPill(
      String pillSerialNumber, BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    print('$pillSerialNumber, ${currentProfile?.id}');
    final url = buildUri('/app/search/info?pillSerialNumber=$pillSerialNumber?profileId=${currentProfile?.id.toString()}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      DrugsManager().updateDrugs(utf8.decode(response.bodyBytes));
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchGet(BuildContext context, int pillSerialNumber) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    print('$pillSerialNumber, ${currentProfile?.id}');
    final url = buildUri('/app/search/$pillSerialNumber?profileId=${currentProfile?.id}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final PillService pillService = PillService();

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final drugInfoDetail = DrugInfoDetail.fromJson(jsonResponse);
      Provider.of<DrugInfoDetailProvider>(context, listen: false).setCurrentDrugInfoDetail(drugInfoDetail);
      pillService.recentViewPillGet(context);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}

