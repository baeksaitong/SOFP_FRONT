import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// Project imports:
import 'package:sopf_front/managers/managers_api_client.dart';

import 'package:sopf_front/navigates.dart';

class SignNaver extends StatefulWidget {
  final String authUrl;

  SignNaver(this.authUrl);

  @override
  State<SignNaver> createState() => _SignNaverState();
}

class _SignNaverState extends State<SignNaver> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final APIClient apiClient = APIClient();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print('URL changed: $url');
      if (url.startsWith('http://15.164.18.65:8080/app/oauth/naver')) {
        Uri uri = Uri.parse(url);
        String? code = uri.queryParameters['code'];

        if (code != null) {
          // 인가 코드를 성공적으로 받음
          print('Authorization Code: $code');
          try {
            await apiClient.naverLogin(context, code);
            print('Login successful');
            flutterWebviewPlugin.close();
            if (context.mounted) {
              Navigator.pop(context);
              navigateToAddAllergy(); // 로그인 성공 후 navigateToAddAllergy로 이동
            }
          } catch (e) {
            print('Error during naverLogin: $e');
          }
        } else {
          print('Authorization code not found');
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