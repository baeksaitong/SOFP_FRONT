import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isDelayed = false;

  bool get isLoading => _isLoading;

  void showLoading({bool delayed = false}) {
    if (delayed) {
      _isDelayed = true;
      Future.delayed(Duration(seconds: 1), () {
        if (_isDelayed) {
          _isLoading = true;
          notifyListeners();
        }
      });
    } else {
      _isLoading = true;
      notifyListeners();
    }
  }

  void hideLoading() {
    _isLoading = false;
    _isDelayed = false;
    notifyListeners();
  }
}
