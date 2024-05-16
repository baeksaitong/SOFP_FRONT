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