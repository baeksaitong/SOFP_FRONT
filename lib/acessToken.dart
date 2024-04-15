class AuthTokenManager {
  static final AuthTokenManager _instance = AuthTokenManager._internal();
  String? _authToken;

  factory AuthTokenManager() {
    return _instance;
  }

  AuthTokenManager._internal();

  void setToken(String token) {
    _authToken = token;
  }

  String? getToken() {
    return _authToken;
  }
}
