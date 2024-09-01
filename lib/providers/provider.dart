// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../models/models_drug_info_detail.dart';
import '../models/models_profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _currentProfile;
  List<Profile> _profileList = [];

  Profile? get currentProfile => _currentProfile;
  List<Profile> get profileList => _profileList;

  void setCurrentProfile(Profile profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  void setProfileList(List<Profile> profiles) {
    _profileList = profiles;
    notifyListeners();
  }

  void loadProfiles(List<Profile> profiles) {
    _profileList = profiles;
    notifyListeners(); // UI 업데이트
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
