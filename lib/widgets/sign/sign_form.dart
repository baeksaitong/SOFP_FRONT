import 'package:flutter/material.dart';

class SignForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final String buttonText;

  const SignForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    this.buttonText = '로그인',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: '이메일'),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: '비밀번호'),
          obscureText: true,
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: onSignIn,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
