import 'dart:convert';

import '../models/models_favorite_info.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  List<FavoriteInfo> favorites = [];

  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal();

  void updateFavorites(String jsonResponse) {
    final data = jsonDecode(jsonResponse)['favoriteList'] as List;
    favorites = data.map((json) => FavoriteInfo.fromJson(json)).toList();
  }
}
