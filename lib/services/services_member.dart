import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/services/services_api_client.dart';
import '../models/models_member_info.dart';

class MemberService extends APIClient {
  final JWTManager jwtManager = JWTManager();

  var logger = Logger();

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
        return MemberInfo.fromJson(json.decode(responseBody));
      } else {
        logger.e('Failed to load member info: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching member info: $e');
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

      return response.statusCode == 200;
    } catch (e) {
      logger.e('Error saving member data: $e');
      return false;
    }
  }
}
