
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
}
