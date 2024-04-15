import 'package:flutter/material.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, Key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''), // 빈 제목으로 설정
          centerTitle: true, // 제목을 가운데 정렬
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/login_image.png', // 이미지 파일의 경로
                    fit: BoxFit.contain, // 이미지가 화면에 맞게 조절되도록 설정
                  ),
                ),
              ),
              Row(
                children: const [
                  Expanded(
                    child: LoginButton(),
                  ),
                  SizedBox(width: 20.0), // 버튼 사이 간격 조절
                  Expanded(
                    child: SignUpButton(),
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

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 로그인 버튼이 눌렸을 때 수행할 동작
        print('로그인 버튼이 눌렸습니다.');
      },
      child: Text('로그인'),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 회원가입 버튼이 눌렸을 때 수행할 동작
        print('회원가입 버튼이 눌렸습니다.');
      },
      child: Text('회원가입'),
    );
  }
}
