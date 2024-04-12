import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('로그인'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 로그인 버튼 클릭 시 동작할 내용 추가
                },
                child: Text('로그인'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 버튼 클릭 시 동작할 내용 추가
                },
                child: Text('회원가입'),
              ),
              SizedBox(height: 20),
              Text(
                '소셜 로그인',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // 구글 로그인 버튼 클릭 시 동작할 내용 추가
                    },
                    icon: Icon(Icons.account_circle),
                    label: Text('구글'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // 네이버 로그인 버튼 클릭 시 동작할 내용 추가
                    },
                    icon: Icon(Icons.account_circle),
                    label: Text('네이버'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // 카카오 로그인 버튼 클릭 시 동작할 내용 추가
                    },
                    icon: Icon(Icons.account_circle),
                    label: Text('카카오'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
