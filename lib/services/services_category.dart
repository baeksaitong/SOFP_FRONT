import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_category.dart';
import '../managers/managers_jwt.dart';
import '../providers/provider.dart';
import 'package:http/http.dart' as http;

class CategoryService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  var logger = Logger();

  Future<void> categoryGet(BuildContext context, String categoryId) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/category/$categoryId');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      CategoryDetailsManager().updateCategoryDetails(jsonResponse);
    } else {
      // 실패 처리
      logger.e('카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<String> categoryGetAll(BuildContext context, String id) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/category?profileId=$id');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      CategoryManager().updateCategories(jsonResponse);  // CategoryManager 업데이트
      return jsonResponse;
    } else {
      // 실패 처리
      logger.e('모든 카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
      return '';
    }
  }

  Future<String> categoryDayGet(BuildContext context, String id, String day) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/category/$id/$day');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      return jsonResponse;
    } else {
      // 실패 처리
      logger.e('요일 카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
      return '';
    }
  }

  Future<void> categoryPost(BuildContext context, Map<String, dynamic>? category) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/category/${currentProfile?.id}');
    final response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    },
      body: jsonEncode(<String, dynamic>{
        "name": category?['name'],
        "intakeDayList": category?['intakeDayList'],
        "intakeTimeList": category?['intakeTimeList'],
        "period": category?['period'],
        "alarm": category?['alarm'],
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      logger.e('카테고리 추가 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      logger.e('카테고리 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> categoryDelete(BuildContext context, String categoryId, bool isAllDelete) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/category/$categoryId?isAllDelete=$isAllDelete');
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      logger.e('카테고리 삭제 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      logger.e('카테고리 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
