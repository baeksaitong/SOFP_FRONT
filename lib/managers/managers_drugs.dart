
import 'dart:convert';

import '../models/models_drug_info.dart';

class DrugsManager {
  static final DrugsManager _instance = DrugsManager._internal();
  List<DrugInfo> drugs = [];

  factory DrugsManager() {
    return _instance;
  }

  DrugsManager._internal();

  void updateDrugs(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['result'] as List;
    drugs = data.map((json) => DrugInfo.fromJson(json)).toList();
  }

  // 기존 데이터에 새 데이터를 추가
  void addDrugs(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['result'] as List;
    drugs.addAll(data.map((json) => DrugInfo.fromJson(json)).toList());
  }
}
