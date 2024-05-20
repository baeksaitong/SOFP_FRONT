import 'dart:convert';

class GlobalResponseManager {
  static final GlobalResponseManager _instance = GlobalResponseManager._internal();
  List<String> responses = [];

  factory GlobalResponseManager() {
    return _instance;
  }

  GlobalResponseManager._internal();

  void addResponse(String response) {
    responses.add(response);
  }

  List<String> getResponses() {
    return responses;
  }
}

class DrugInfo {
  final String name;
  final String classification;
  final String enterprise;
  final String imgUrl;

  DrugInfo({required this.name, required this.classification, required this.enterprise, required this.imgUrl});

  factory DrugInfo.fromJson(Map<String, dynamic> json) {
    return DrugInfo(
      name: json['name'],
      classification: json['classification'],
      enterprise: json['enterprise'],
      imgUrl: json['imgUrl'],
    );
  }
}

class GlobalManager {
  static final GlobalManager _instance = GlobalManager._internal();

  List<DrugInfo> drugs = [];

  factory GlobalManager() {
    return _instance;
  }

  GlobalManager._internal();

  void updateDrugs(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['result'] as List;
    drugs = data.map((json) => DrugInfo.fromJson(json)).toList();
  }
}