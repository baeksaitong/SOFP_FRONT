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

class DrugInfoDetailProvider with ChangeNotifier {
  DrugInfoDetail? _currentPillInfoDetailProvider;

  DrugInfoDetail? get currentDrugInfoDetail => _currentPillInfoDetailProvider;

  void setCurrentDrugInfoDetail(DrugInfoDetail drugInfoDetail) {
    _currentPillInfoDetailProvider = drugInfoDetail;
    notifyListeners();
  }
}