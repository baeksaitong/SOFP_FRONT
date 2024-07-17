import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_category.dart';
import '../providers/provider.dart';
import '../managers/managers_global_response.dart';

class CategoryService extends APIClient {
  Future<void> categoryGet(BuildContext context, String categoryId) async {
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/category/$categoryId'));

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('카테고리 조회 성공: $jsonResponse');
      CategoryDetailsManager().updateCategoryDetails(jsonResponse);
    } else {
      print(response.statusCode);
      print('카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<String> categoryGetAll(BuildContext context, String id) async {
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/category?profileId=$id'));

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('모든 카테고리 조회 성공: $jsonResponse');
      CategoryManager().updateCategories(jsonResponse);
      return jsonResponse;
    } else {
      print(response.statusCode);
      print('모든 카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
      return '';
    }
  }

  Future<String> categoryDayGet(BuildContext context, String id, String day) async {
    final response = await get(Uri.parse('${APIClient.baseUrl}/app/category/$id/$day'));

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('요일 카테고리 조회 성공: $jsonResponse');
      return jsonResponse;
    } else {
      print(response.statusCode);
      print('요일 카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
      return '';
    }
  }

  Future<void> categoryPost(BuildContext context, Map<String, dynamic>? category) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final response = await post(
      Uri.parse('${APIClient.baseUrl}/app/category/${currentProfile?.id}'),
      body: {
        "name": category?['name'],
        "intakeDayList": category?['intakeDayList'],
        "intakeTimeList": category?['intakeTimeList'],
        "period": category?['period'],
        "alarm": category?['alarm'],
      },
    );

    if (response.statusCode == 200) {
      print('카테고리 추가 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      print(response.statusCode);
      print('카테고리 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> categoryDelete(BuildContext context, String categoryId, bool isAllDelete) async {
    final response = await delete(Uri.parse('${APIClient.baseUrl}/app/category/$categoryId?isAllDelete=$isAllDelete'));

    if (response.statusCode == 200) {
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('카테고리 삭제 성공: $jsonResponse');
    } else {
      print(response.statusCode);
      print('카테고리 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
