import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:sopf_front/jwtManager.dart';
import 'package:sopf_front/provider.dart';

import 'globalResponseManager.dart';
import 'navigates.dart';

class APIClient {
  static const String baseUrl = 'http://15.164.18.65:8080';
  final JWTManger _jwtManager = JWTManger();

  Future<void> naverLogin(String code) async {
    final String url = 'http://15.164.18.65:8080/app/oauth/naver?code=$code';
    final response = await http.get(
      Uri.parse(url),
      headers: {'accept': '*/*'},
    );

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받았을 때의 처리
      print('Response data: ${response.body}');
    } else {
      // 요청이 실패했을 때의 처리
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> signUp(String name, String birthday, String email, String gender,
      String pwd, bool advertisement) async {
    final url = Uri.parse('$baseUrl/app/auth/sign-up');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "birthday": birthday,
        "email": email,
        "gender": gender,
        "password": pwd,
        "advertisement": advertisement
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      // 회원가입 성공 처리

      print('회원가입 성공: $jsonResponse');
    } else {
      // 에러 처리
      print(response.statusCode);
      print('회원가입 실패: $jsonResponse');
    }
  }

  Future<void> profileAdd(String name, String birthday, String gender,
      String color, String? profileImg) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/profile/add');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "birthday": birthday,
        "gender": gender,
        "color": color,
        "profileImg": profileImg,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      // 회원가입 성공 처리
      print('회원가입 성공: $jsonResponse');
    } else {
      // 에러 처리
      print(response.statusCode);
      print('회원가입 실패: $jsonResponse');
    }
  }

  Future<void> idCheck(String email) async {
    final url = Uri.parse('$baseUrl/app/auth/id-check');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('사용 가능한 아이디 : $decodedResponse'); // 성공 메시지가 일반 텍스트인 경우
      mailSend(email);
    } else {
      print(response.statusCode);
      print('이미 사용 중인 아이디 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
    }
  }

  Future<void> mailSend(String email) async {
    final url = Uri.parse('$baseUrl/app/verification/mail/send');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('전송 성공 : $decodedResponse'); // 성공 메시지가 일반 텍스트인 경우
    } else {
      print(response.statusCode);
      print('전송 실패 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
    }
  }

  Future<void> mailCheck(String email, String code) async {
    final url = Uri.parse('$baseUrl/app/verification/mail/check');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "code": code,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    try {
      var jsonResponse = jsonDecode(decodedResponse);
      if (response.statusCode == 200) {
        print('전송 성공 : $jsonResponse');
      } else {
        print(response.statusCode);
        print('전송 실패 : $jsonResponse');
      }
    } catch (e) {
      if (response.statusCode == 200) {
        print('전송 성공 : $decodedResponse'); // 성공 메시지가 일반 텍스트인 경우
      } else {
        print(response.statusCode);
        print('전송 실패 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
      }
    }
  }

  Future<void> login(BuildContext context, String email, String pwd) async {
    final url = Uri.parse('$baseUrl/app/auth/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "password": pwd,
      }),
    );
    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // Check if tokens are not null
      final tokenData = jsonResponse['token'];
      final accessToken = tokenData['accessToken'];
      final refreshToken = tokenData['refreshToken'];

      if (tokenData == null) {
        print('Error: Missing token data in response');
      }

      await _jwtManager.saveTokens(accessToken, refreshToken);
      print('로그인 성공: $jsonResponse');

      ProfileResponse? profileResponse = await profileAll();
      if (profileResponse != null && profileResponse.profileList.isNotEmpty) {
        // Ensure `context` is passed with `listen: false`
        Provider.of<ProfileProvider>(context, listen: false)
            .setCurrentProfile(profileResponse.profileList[0]);
      }
      diseaseAllergyList();
      recentViewPillGet(context);
      if (jsonResponse['isNew'] == false) {
        navigateToAddAllergy();
      } else {
        navigateToHome();
      }
    } else {
      print(response.statusCode);
      print('로그인 실패: $jsonResponse');
    }
  }

  Future<void> logout() async {
    await _jwtManager.deleteTokens();
  }

  Future<String> getValidAccessToken() async {
    return await _jwtManager.getValidAccessToken();
  }

  Future<void> memberInfo() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/member/info');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('멤버 출력: $decodedResponse');
      GlobalResponseManager().addResponse(decodedResponse); // 응답을 전역 배열에 추가
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패했습니다: ${response.body}');
    }
  }

  Future<ProfileResponse?> profileAll() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/profile');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('모든 멤버 출력: $decodedResponse');

      Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
      return ProfileResponse.fromJson(jsonResponse);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패했습니다: ${response.body}');
      return null;
    }
  }

  Future<void> recentViewPillGet(BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/recent-view/${currentProfile?.id}?count=10');
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
      print('최근 조회 알약 조회 성공 : $jsonResponse');
      RecentHistoriesManager().updateFavorites(utf8.decode(response.bodyBytes));
    } else {
      print(response.statusCode);
      print('최근 조회 알약 조회 실패 : $jsonResponse');
    }
  }

  Future<bool> recentViewPillDelete(int pillSerialNumber, BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/recent-view/${currentProfile?.id}?pillSerialNumber=$pillSerialNumber');
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
      print('최근 조회 알약 삭제 성공 : $decodedResponse');
      return true;
    } else {
      print(response.statusCode);
      print('최근 조회 알약 삭제 실패 : $decodedResponse');
      return false;
    }
  }


  Future<void> diseaseAllergyList() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/disease-allergy');
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
      print('질병 및 알레르기 불러오기 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('질병 및 알레르기 불러오기 실패 : $jsonResponse');
    }
  }

  Future<void> diseaseAllergySearch(String keyword) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url =
        Uri.parse('$baseUrl/app/disease-allergy/search?keyword=$keyword');
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
      print('검색 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('검색 실패 : $jsonResponse');
    }
  }

  Future<void> diseaseAllergyGet(BuildContext context, String keyword) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/disease-allergy/${currentProfile?.id}');
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
      print('질병 및 알레르기 목록 조회 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('질병 및 알레르기 목록 조회 실패 : $jsonResponse');
    }
  }

  Future<void> diseaseAllergyAddOrDelete(BuildContext context,
      String? addDiseaseAllergyList, String? removeDiseaseAllergyList) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/disease-allergy/${currentProfile?.id}');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
      body: jsonEncode(<String, dynamic>{
        "addDiseaseAllergyList": [addDiseaseAllergyList],
        "removeDiseaseAllergyList": [removeDiseaseAllergyList]
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('추가 및 삭제 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('추가 및 삭제 실패 : $jsonResponse');
    }
  }

  Future<void> searchTextAndShape(
      BuildContext context,
      String? keyword,
      String? shape,
      String? sign,
      String? color,
      String? formulation,
      String? line) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/search/keyword'
        '?profileId=${currentProfile?.id}'
        '&limit=10'
        '&keyword=$keyword'
        '&shape=$shape'
        '&sign=$sign'
        '&color=$color'
        '&formulation=$formulation'
        '&line=$line');
    print(keyword);
    print(url);
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

  Future<void> searchInfoPill(
      String pillSerialNumber, BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    print('$pillSerialNumber, ${currentProfile?.id}');
    final url = Uri.parse(
        '$baseUrl/app/search/info?pillSerialNumber=$pillSerialNumber?profileId=${currentProfile?.id.toString()}');
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
    final url = Uri.parse('$baseUrl/app/search/$pillSerialNumber?profileId=${currentProfile?.id}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final drugInfoDetail = DrugInfoDetail.fromJson(jsonResponse);
      Provider.of<DrugInfoDetailProvider>(context, listen: false).setCurrentDrugInfoDetail(drugInfoDetail);
      recentViewPillGet(context);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> favoritePost(
      BuildContext context, int serialNumber, String imageUrl) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/favorite/${currentProfile?.id}');
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
    final url = Uri.parse(
        '$baseUrl/app/favorite/${currentProfile?.id}?pillSerialNumber=$serialNumber');
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
    final url = Uri.parse('$baseUrl/app/favorite/${currentProfile?.id}');
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
