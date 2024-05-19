import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> signUp(String name, String birthday, String email, String gender, String pwd, bool advertisement) async {
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

Future<void> idCheck(String email) async {
  final url = Uri.parse('http://15.164.18.65:8080/app/auth/id-check');
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
  final url = Uri.parse('http://15.164.18.65:8080/app/verification/mail/send');
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
  final url = Uri.parse('http://15.164.18.65:8080/app/verification/mail/check');
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

Future<void> login(String email, String pwd) async {
  final url = Uri.parse('http://15.164.18.65:8080/app/auth/login');
  final response = await http.post(
    url,
    headers: <String, String>{
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

    print('로그인 성공: $jsonResponse');

  } else {

    print(response.statusCode);
    print('로그인 실패: $jsonResponse');
  }
}