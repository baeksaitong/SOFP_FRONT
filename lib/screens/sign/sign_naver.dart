import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:logger/logger.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/services/services_auth.dart';

class SignNaver extends StatefulWidget {
  final String authUrl;

  SignNaver(this.authUrl);

  @override
  State<SignNaver> createState() => _SignNaverState();
}

class _SignNaverState extends State<SignNaver> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final AuthService authService = AuthService();
  static String baseUrl = const String.fromEnvironment('API_URL', defaultValue: 'http://default-url.com');

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.startsWith('$baseUrl/app/oauth/naver')) {
        Uri uri = Uri.parse(url);
        String? code = uri.queryParameters['code'];

        if (code != null) {
          // 인가 코드를 성공적으로 받음
          logger.e('Authorization Code: $code');
          try {
            await authService.naverLogin(context, code);
            // await apiClient.naverLogin(context, code);
            flutterWebviewPlugin.close();
            if (context.mounted) {
              Navigator.pop(context);
              navigateToAddAllergy(); // 로그인 성공 후 navigateToAddAllergy로 이동
            }
          } catch (e) {
            logger.e('Error during naverLogin: $e');
          }
        } else {
          logger.e('Authorization code not found');
        }
      }
    });
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.authUrl,
      appBar: AppBar(
        title: Text('Naver OAuth Login'),
      ),
    );
  }
}