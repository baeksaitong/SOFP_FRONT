import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/services/services_api_client.dart';
import 'package:sopf_front/services/services_pill.dart';

import '../managers/managers_drugs.dart';
import '../managers/managers_jwt.dart';
import '../models/models_drug_info_detail.dart';
import '../providers/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path; // 파일 경로에서 이름과 확장자를 얻기 위한 패키지

class SearchService extends APIClient {
  final JWTManager _jwtManager = JWTManager();

  var logger = Logger();

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
      logger.e('검색 완료: ${DrugsManager().drugs.length}개의 알약이 검색됨');
    } else {
      logger.e('검색 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchInfoPill(
      String pillSerialNumber, BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri(
        '/app/search/info?pillSerialNumber=$pillSerialNumber?profileId=${currentProfile?.id.toString()}');
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
      DrugsManager().updateDrugs(utf8.decode(response.bodyBytes));
    } else {
      // 실패 처리
      logger.e('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchGet(BuildContext context, int pillSerialNumber) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = buildUri(
        '/app/search/$pillSerialNumber?profileId=${currentProfile?.id}');
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
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final drugInfoDetail = DrugInfoDetail.fromJson(jsonResponse);
      Provider.of<DrugInfoDetailProvider>(context, listen: false)
          .setCurrentDrugInfoDetail(drugInfoDetail);
      pillService.recentViewPillGet(context);
    } else {
      // 실패 처리
      logger.e('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchImagePost(
      BuildContext context, XFile? firstImage, XFile? secondImage) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();

    if (accessToken == null) {
      print('엑세스 토큰이 없습니다.');
      return;
    }

    final url = Uri.parse('http://3.39.8.147:8080/app/search/image');
    var headers = {
      'Authorization': 'Bearer $accessToken',
    };

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['profileId'] = currentProfile!.id;
    request.fields['lastId'] = ''; // 필요시 수정
    request.fields['limit'] = '10'; // 필요시 수정

    // 첫 번째 이미지 추가
    request.files.add(
      await http.MultipartFile.fromPath(
        'images', // 서버에서 받을 필드명
        firstImage!.path,
        filename: path.basename(firstImage.path), // 파일명 설정
      ),
    );

    // 두 번째 이미지 추가
    request.files.add(
      await http.MultipartFile.fromPath(
        'images',
        secondImage!.path,
        filename: path.basename(secondImage.path),
      ),
    );

    // Create a client with a custom timeout
    final client = http.Client();

    try {
      // Send the request with a custom timeout
      var response = await client
          .send(request)
          .timeout(Duration(seconds: 30)); // 30초로 타임아웃 설정
      if (response.statusCode == 200) {
        final jsonResponse = await response.stream.bytesToString();
        DrugsManager().addDrugs(jsonResponse);
        print('검색 완료 정보: $jsonResponse');
        print('검색 완료: ${DrugsManager().drugs.length}개의 알약이 검색됨');
      } else {
        print('검색 실패: $response');
        print('검색 실패: 상태 코드 ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      print('타임아웃 발생: 요청 시간이 초과되었습니다. $e');
    } on SocketException catch (e) {
      print('SocketException 발생: $e');
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
    } finally {
      client.close(); // 클라이언트 종료
    }
  }
}
