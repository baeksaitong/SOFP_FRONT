import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/services/services_api_client.dart';
import '../models/models_member_info.dart';

class MemberService extends APIClient {
  final JWTManager jwtManager = JWTManager();

  Future<MemberInfo?> fetchMemberInfo() async {
    final url = buildUri('/app/member');

    try {
      final accessToken = await jwtManager.getValidAccessToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('Response body: $responseBody');
        return MemberInfo.fromJson(json.decode(responseBody));
      } else {
        print('Failed to load member info: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching member info: $e');
      return null;
    }
  }

  Future<bool> saveMemberData(String password, bool isSubscribed) async {
    try {
      final accessToken = await jwtManager.getValidAccessToken();

      final url = buildUri('/app/member');
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'password': password,
          'advertisement': isSubscribed,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error saving member data: $e');
      return false;
    }
  }
}
