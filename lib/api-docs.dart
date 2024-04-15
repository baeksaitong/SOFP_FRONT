import 'dart:convert';
import 'package:http/http.dart' as http;

import 'acessToken.dart';

Future<void> loginAcess(String email, String password) async {
  final url = Uri.parse('http://15.164.18.65:8080/app/auth/login');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "password": password,
    }),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody['token'] != null) {
      AuthTokenManager().setToken(responseBody['token']);
      print('Token 저장 완료: ${AuthTokenManager().getToken()}');
    }
  } else if (response.statusCode == 404) {
    // 에러 처리
    print(response.statusCode);
    print('로그인 실패: ${response.body}');
  } else {
    print('예상치 못한 오류 : ${response.statusCode}');
  }
}

Future<void> signUp(String name, String selectedYear, String selectedMonth, String selectedDay, String email, String gender, String pwd, bool advertisement) async {
  final birthday="$selectedYear-$selectedMonth-$selectedDay";
  final url = Uri.parse('http://15.164.18.65:8080/app/auth/sign-up');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "name": name,
      "birthday": birthday,
      "email": email,
      "gender": "male",
      "password": pwd,
      "advertisement": advertisement
    }),
  );

  if (response.statusCode == 200) {
    // 회원가입 성공 처리
    print('회원가입 성공: ${response.body}');
  } else {
    // 에러 처리
    print(response.statusCode);
    print('회원가입 실패: ${response.body}');
  }
}

Future<void> mailTokenSend(String email) async {
  final url = Uri.parse('http://15.164.18.65:8080/app/verification/mail/send');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email
    }),
  );

  if (response.statusCode == 200) {
    // 회원가입 성공 처리
    print('발송완료 가능합니다: ${response.body}');
  } else {
    // 에러 처리
    print(response.statusCode);
    print('실패했습니다: ${response.body}');
  }
}

Future<void> mailTokenCheck(String email, String code) async {
  final url = Uri.parse('http://15.164.18.65:8080/app/verification/mail/check');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "code" : code,
    }),
  );

  if (response.statusCode == 200) {
    // 회원가입 성공 처리
    print('인증완료: ${response.body}');
  } else {
    // 에러 처리
    print(response.statusCode);
    print('실패했습니다: ${response.body}');
  }
}

Future<void> loginNaverAcess(String code) async {
  final url = Uri.parse('http://15.164.18.65:8080/app/oauth/naver');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "code" : code,
    }),
  );

  if (response.statusCode == 200) {
    // 회원가입 성공 처리
    print('인증완료: ${response.body}');
  } else {
    // 에러 처리
    print(response.statusCode);
    print('실패했습니다: ${response.body}');
  }
}

Future<void> searchTextnShape(String keyword) async {
  final url = Uri.parse('http://15.164.18.65:8080/app/search/keyword');
  print(keyword);
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AuthTokenManager().getToken()}',  // 인증 토큰 추가
    },
    body: jsonEncode(<String, dynamic>{
      "keyword": keyword,
      "shape": null,
      "sign": null,
      "color": null,
      "formulation": null,
      "line": null,
      "page": 0,
      "limit": 5,
    }),
  );

  if (response.statusCode == 200) {
    // 성공적으로 처리된 경우
    print('인증완료: ${utf8.decode(response.bodyBytes)}');
  } else {
    // 실패 처리
    print(response.statusCode);
    print('실패했습니다: ${response.body}');
  }
}


