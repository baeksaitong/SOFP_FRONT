import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';

import 'api-docs.dart';

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
            onPressed: () async { // 여기에 async 키워드를 추가해 비동기 함수를 호출
              await loginAcess(_emailController.text,_passwordController.text);
            },
            child: Text('로그인'),
          )
        ],
      ),
    );
  }
}
