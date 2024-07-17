
import 'dart:convert';

import '../models/models_recent_history_info.dart';

class RecentHistoriesManager {
  static final RecentHistoriesManager _instance = RecentHistoriesManager._internal();
  List<RecentHistoryInfo> recentHistories = [];

  factory RecentHistoriesManager() {
    return _instance;
  }

  RecentHistoriesManager._internal();

  void updateFavorites(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['result'] as List;
    recentHistories = data.map((json) => RecentHistoryInfo.fromJson(json)).toList();
  }
}
