import 'package:flutter/material.dart';
import 'package:sopf_front/addAllergyPage.dart';
import 'package:sopf_front/searchResult.dart';
import 'package:sopf_front/signUp.dart';
import 'package:sopf_front/textSearch.dart';
import 'package:sopf_front/preferencesPage.dart';
import 'package:sopf_front/favoritePage.dart';

import 'home.dart';
import 'main.dart';

void navigateToAddAllergy() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => AddAllergyPage()),
  );
}

void navigateToHome() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => HomePage()),
  );
}

void navigateToTextSearchDetail() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => TextSearchDetail()),
  );
}

void navigateToSearchResult() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => SearchResult()),
  );
}

void navigateToSignUp() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => SignUpPage()),
  );
}

void navigateToPreference() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => SettingsPage()),
  );
}

void navigateToFavorite() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => FavoritesPage()),
  );
}
