import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';

import '../managers/managers_favorites.dart';
import '../managers/managers_jwt.dart';
import '../providers/provider.dart';
import 'package:http/http.dart' as http;

class FavoriteService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

    Future<void> favoritePost(
      BuildContext context, int serialNumber, String imageUrl) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/favorite/${currentProfile?.id}');
    print(accessToken);

    // Download the image
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    // Save the image as a temporary file
    final documentDirectory = await getTemporaryDirectory();
    final file = File('${documentDirectory.path}/temp_image.jpg');
    await file.writeAsBytes(response.bodyBytes);

    // Create multipart request
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

    // Add fields
    request.fields['pillSerialNumber'] = serialNumber.toString(); // Ensure it is a string

    // Add file
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    // Send the request
    var streamedResponse = await request.send();
    response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('즐겨찾기 추가 완료: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('즐겨찾기 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }

    // Clean up the temporary file
    await file.delete();
  }

  Future<void> favoriteDelete(BuildContext context, int serialNumber) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/favorite/${currentProfile?.id}?pillSerialNumber=$serialNumber');
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('즐겨찾기 삭제 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('즐겨찾기 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> favoriteGet(BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri('/app/favorite/${currentProfile?.id}');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('즐겨찾기 조회 성공: ${utf8.decode(response.bodyBytes)}');
      FavoritesManager().updateFavorites(utf8.decode(response.bodyBytes));

    } else {
      // 실패 처리
      print(response.statusCode);
      print('즐겨찾기 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}
