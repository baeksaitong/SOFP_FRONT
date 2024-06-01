import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:sopf_front/apiClient.dart';

class NaverWebViewPage extends StatelessWidget {
  final String authUrl;

  NaverWebViewPage(this.authUrl);

  @override
  Widget build(BuildContext context) {
    final flutterWebviewPlugin = FlutterWebviewPlugin();
    final APIClient apiClient = APIClient();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.startsWith('http://15.164.18.65:8080/app/oauth/naver')) {
        Uri uri = Uri.parse(url);
        String? code = uri.queryParameters['code'];

        if (code != null) {
          // 인가 코드를 성공적으로 받음
          print('Authorization Code: $code');
          apiClient.naverLogin(code);
          // 이후 필요한 처리
          flutterWebviewPlugin.close();
          Navigator.pop(context);
        }
      }
    });

    return WebviewScaffold(
      url: authUrl,
      appBar: AppBar(
        title: Text('Naver OAuth Login'),
      ),
    );
  }
}