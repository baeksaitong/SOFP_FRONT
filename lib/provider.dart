import 'package:flutter/material.dart';

import 'globalResponseManager.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _currentProfile;

  Profile? get currentProfile => _currentProfile;

  void setCurrentProfile(Profile profile) {
    _currentProfile = profile;
    notifyListeners();
  }
}