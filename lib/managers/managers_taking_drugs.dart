import 'dart:convert';

import '../models/models_taking_drugs_info.dart';

class TakingDrugsManager {
  static final TakingDrugsManager _instance = TakingDrugsManager._internal();
  List<TakingDrugsInfo> drugs = [];

  factory TakingDrugsManager() {
    return _instance;
  }

  TakingDrugsManager._internal();

  void updateDrugs(String jsonResponse) {
    final decoded = jsonDecode(jsonResponse);
    if (decoded != null && decoded['pillInfoList'] != null) {
      final data = decoded['pillInfoList'] as List;
      drugs = data.map((json) => TakingDrugsInfo.fromJson(json)).toList();
    } else {
      drugs = [];
    }
  }
}
