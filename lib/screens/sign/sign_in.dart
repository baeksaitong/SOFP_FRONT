import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/main.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/screens/sign/sign_naver.dart';
import 'package:sopf_front/services/services_api_client.dart';
import 'package:sopf_front/services/services_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final APIClient apiClient = APIClient();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var logger = Logger();

  void initSate() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final accessToken = await apiClient.getValidAccessToken();
      navigateToHome();
    } catch (e) {
      logger.e('Error checking login status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        elevation: 0, // 그림자를 없애서 색 변화 방지
        backgroundColor: AppColors.wh,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 전체적으로 위로 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가운데 정렬
            children: [
              Image.asset(
                'assets/signinpill.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20), // 이미지 아래 간격
              CustomTextField(
                label: '아이디',
                hintText: '아이디를 입력하세요',
                controller: idController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                label: '비밀번호',
                hintText: '비밀번호를 입력하세요',
                isPassword: true,
                controller: passwordController,
              ),
              SizedBox(height: 20),
              LoginButton(idController: idController, passwordController: passwordController),
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
                children: [
                  NaverButton(),
                  const SizedBox(width: 10),
                  const KakaoButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'pretendard',
            color: AppColors.bk,
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.wh),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.wh),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.wh),
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'pretendard',
              fontWeight: FontWeight.w600,
              color: AppColors.gr400,
            ),
            filled: true,
            fillColor: AppColors.gr150,
          ),
        ),
      ],
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
          navigateToSignUp();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          backgroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          '회원가입',
          style: TextStyle(
            color: Color(0xFF0BC2AC),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({
    super.key,
    required this.passwordController,
    required this.idController,
  });

  final TextEditingController passwordController;
  final TextEditingController idController;
  final AuthService authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // await authService.login(context, idController.text, passwordController.text);
          await authService.login(context, "rktgkswh935@naver.com", "1q2w3e4r");
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          backgroundColor: const Color(0xFF0BC2AC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Text(
          '로그인',
          style: TextStyle(
            color: Colors.white,
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
        image: const AssetImage('assets/kakao_icon.png'),
        width: 50,
        height: 50,
      ),
    );
  }
}

class NaverButton extends StatelessWidget {
  NaverButton({super.key});

  static String baseUrl = const String.fromEnvironment('API_URL', defaultValue: 'http://default-url.com');
  final String clientId = const String.fromEnvironment('NAVER_CLIENT_ID', defaultValue: 'null');
  final String redirectUri = '$baseUrl/app/oauth/naver';
  final String state = 'sofp';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final String authUrl = 'https://nid.naver.com/oauth2.0/authorize'
            '?response_type=code'
            '&client_id=$clientId'
            '&redirect_uri=$redirectUri'
            '&state=$state';
        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => SignNaver(authUrl)));
      },
      child: Ink.image(
        image: const AssetImage('assets/naver_icon.png'),
        width: 50,
        height: 50,
      ),
    );
  }
}
