import 'package:flutter/material.dart';
import 'package:sopf_front/addAllergyPage.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/pillDetails.dart';
import 'package:sopf_front/addAllergy.dart';
import 'package:sopf_front/recentHistoryPill.dart';
import 'package:sopf_front/searchResult.dart';
import 'package:sopf_front/signUp.dart';
import 'package:sopf_front/textSearch.dart';
import 'package:sopf_front/preferencesPage.dart';
import 'package:sopf_front/favoritePage.dart';

import 'category.dart';
import 'categoryPlus.dart';
import 'customerServiceCenter.dart';
import 'home.dart';
import 'main.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'loading_provider.dart';

void showLoading(BuildContext context, {bool delayed = false}) {
  final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  loadingProvider.showLoading(delayed: delayed);
}

void hideLoading(BuildContext context) {
  final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
  loadingProvider.hideLoading();
}

Widget loadingOverlay(BuildContext context) {
  final loadingProvider = Provider.of<LoadingProvider>(context);

  return loadingProvider.isLoading
      ? Container(
          color: AppColors.gr700,
          child: Center(
            child: SpinKitRing(
              color: Colors.white,
              size: 55.0,
            ),
          ),
        )
      : SizedBox.shrink();
}

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

void navigateToPillDetail() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => PillDetails()),
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

void navigateToCategory() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => MedicationPage()),
  );
}

void navigateToRecentHistory() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => RecentHistoryPill()),
  );
}

void navigateToCustomerService() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => CustomerServicePage()),
  );
}
