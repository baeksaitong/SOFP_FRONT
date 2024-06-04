import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sopf_front/addAllergyPage.dart';
import 'package:sopf_front/globalResponseManager.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/appTextStyles.dart';
import 'package:sopf_front/gaps.dart';
import 'package:sopf_front/pillDetails.dart';
import 'package:sopf_front/addAllergy.dart';
import 'package:sopf_front/recentHistoryPill.dart';
import 'package:sopf_front/searchResult.dart';
import 'package:sopf_front/signUp.dart';
import 'package:sopf_front/loginNaver.dart';
import 'package:sopf_front/textSearch.dart';
import 'package:sopf_front/preferencesPage.dart';
import 'package:sopf_front/favoritePage.dart';
import 'package:sopf_front/taskingPillList.dart';
import 'package:sopf_front/categoryPlus.dart';
import 'package:sopf_front/categoryDetail.dart';

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
          color: AppColors.wh,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitWaveSpinner(
                  color: AppColors.vibrantTeal,
                  size: 55.0,
                ),
                Gaps.h16,
                Text(
                  '정보를 가져오는 중 입니다.',
                  style: AppTextStyles.body5M14.copyWith(color: AppColors.gr600),
                ),
              ],
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

void navigateToPillDetail(int serialNumber) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => PillDetails(serialNumber)),
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

void navigateToMedicationsTaking() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => MedicationPage()),
  );
}

void navigateToMedicationsTakingPlus(
    BuildContext context, Function(Map<String, dynamic>) onSave,
    [CategoryDetails? category]) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => MedicationSchedulePage(
        onSave: onSave,
      ),
    ),
  );
}

void navigateToMedicationCategory(
    BuildContext context, CategoryDetails category) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => MedicationCategoryPage(category: category)),
  );
}
