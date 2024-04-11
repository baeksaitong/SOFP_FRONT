import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';
import 'package:sofp_front/home.dart';

import 'api-docs.dart';
import 'loginNaverTest.dart';

class TestLogin extends StatefulWidget {
  const TestLogin({super.key});

  @override
  State<TestLogin> createState() => _TestLoginState();
}

class _TestLoginState extends State<TestLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _printInfo() {
    print(_emailController.text);
    print(_passwordController.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: '이메일',
            ),
          ),
          Gaps.h10,
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '비밀번호',
            ),
          ),
          Gaps.h10,
          ElevatedButton(
            onPressed: () async {
              // 로그인 접근 함수를 비동기로 호출
              await loginAcess(_emailController.text, _passwordController.text);
              // 네비게이터를 사용하여 홈 페이지로 이동
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text('로그인'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NaverLoginScreen()),
              );
            },
            child: Text('네이버 로그인'),
          )
        ],
      ),
    );
  }
}
