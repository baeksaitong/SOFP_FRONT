import 'package:flutter/material.dart';
import 'package:sofp_front/api-docs.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NaverLoginScreen extends StatefulWidget {
  @override
  _NaverLoginScreenState createState() => _NaverLoginScreenState();
}

class _NaverLoginScreenState extends State<NaverLoginScreen> {
  WebViewController? _controller;
  final String clientId = 's_sU87qUfaHToSi_ky8R'; // 네이버 클라이언트 ID
  final String redirectUri = 'http://localhost:8080/app/oauth/naver'; // 네이버 리디렉션 URI
  final String state = 'sofp'; // CSRF 방지를 위한 상태 토큰

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&state=$state',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(redirectUri)) {
            Uri uri = Uri.parse(request.url);
            if (uri.queryParameters.containsKey('code')) {
              String? code = uri.queryParameters['code'];
              loginNaverAcess(code!);
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
