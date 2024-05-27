import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sopf_front/home.dart';
import 'dart:convert';
import 'package:sopf_front/jwtManager.dart';
import 'package:sopf_front/provider.dart';
import 'package:sopf_front/jwtManager.dart';
import 'globalResponseManager.dart';
import 'navigates.dart';


class APIClient {
  static const String baseUrl = 'http://15.164.18.65:8080';
  final JWTmanager _jwtManager = JWTmanager();

  Future<void> signUp(String name, String birthday, String email, String gender, String pwd, bool advertisement) async {
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

  Future<void> profileAdd(String name, String birthday, String gender, String color, String? profileImg) async {
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
        Provider.of<ProfileProvider>(context, listen: false).setCurrentProfile(profileResponse.profileList[0]);
      }

      if(jsonResponse['isNew']==false) {
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
    final url = Uri.parse('$baseUrl/app/member');
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

  Future<void> diseaseAllergyList() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/disease-allergy');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',  // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('불러오기 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('불러오기 실패 : $jsonResponse');
    }
  }

  Future<void> searchTextAndShape(
      BuildContext context,
      String? keyword,
      String? shape,
      String? sign,
      String? color,
      String? formulation,
      String? line
      ) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();

    final url = Uri.parse('$baseUrl/app/search/keyword?profileId=${currentProfile?.id}');
    print(keyword);
    print(accessToken);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',  // 인증 헤더 추가
      },
      body: jsonEncode(<String, dynamic>{
        "keyword": keyword,
        "shape": shape,
        "sign": sign,
        "color": color,
        "formulation": formulation,
        "line": line,
        "page": 0,
        "limit": 5,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      GlobalManager().updateDrugs(utf8.decode(response.bodyBytes));
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchInfoPill(String pillSerialNumber, BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    print('$pillSerialNumber, ${currentProfile?.id}');
    final url = Uri.parse('$baseUrl/app/search/info?pillSerialNumber=$pillSerialNumber?profileId=${currentProfile?.id.toString()}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',  // 인증 헤더 추가
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      GlobalManager().updateDrugs(utf8.decode(response.bodyBytes));
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> favoriteAdd(String searchType, String serialNumber, String image) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/favorite/add');
    print(accessToken);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',  // 인증 헤더 추가
      },
      body: jsonEncode(<String, dynamic>{
        "searchType": searchType,
        "pillSearchNumber": serialNumber,
        "image": image,
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      GlobalManager().updateDrugs(utf8.decode(response.bodyBytes));
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}