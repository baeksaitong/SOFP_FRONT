import 'package:flutter/material.dart';
import 'package:sopf_front/gaps.dart';

void main() {
  runApp(MaterialApp(
    title: 'First App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('promiss.png'),
            IdTextField(idController: idController),
            SizedBox(height: 20),
            PassTextField(passwordController: passwordController),
            SizedBox(height: 20),
            LoginButton(),
            SizedBox(height: 10),
            SignupButton(),
            SizedBox(height: 20),
            Gaps.h48,
            Text(
              'SNS 계정으로 로그인',
              style: TextStyle(fontSize: 11),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                NaverButton(),
                SizedBox(width: 10),
                KakaoButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle sign up button pressed
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: 16.0, horizontal: 12.0), // Adjust padding
          backgroundColor: Color(0xFFFFFFFF), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
        ),
        child: Text(
          '회원가입',
          style: TextStyle(
            color: Color(0xFF0BC2AC), // Text color
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Handle login button pressed
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: 16.0, horizontal: 12.0), // Adjust padding
          backgroundColor: Color(0xFF0BC2AC), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
        ),
        child: Text(
          '로그인',
          style: TextStyle(
            color: Colors.white, // Text color
          ),
        ),
      ),
    );
  }
}

class KakaoButton extends StatelessWidget {
  const KakaoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle Kakao login button pressed
      },
      child: Ink.image(
        image: AssetImage('assets/kakao_icon.png'), // Path to your image
        width: 50, // Adjust the width of the image
        height: 50, // Adjust the height of the image
      ),
    );
  }
}

class NaverButton extends StatelessWidget {
  const NaverButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle Naver login button pressed
      },
      child: Ink.image(
        image: AssetImage(
            'assets/naver_icon.png'), // Path to your Naver logo image
        width: 50, // Adjust the width of the image
        height: 50, // Adjust the height of the image
      ),
    );
  }
}

class PassTextField extends StatelessWidget {
  const PassTextField({
    super.key,
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: '비밀번호를 입력하세요', // Optional hint text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            contentPadding: EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 12.0), // Adjust padding
          ),
          obscureText: true,
        ),
      ],
    );
  }
}

class IdTextField extends StatelessWidget {
  const IdTextField({
    super.key,
    required this.idController,
  });

  final TextEditingController idController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '아이디',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: idController,
          decoration: InputDecoration(
            hintText: '아이디를 입력하세요', // Optional hint text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 12.0,
            ), // Adjust padding
          ),
        ),
      ],
    );
  }
}
