// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:sopf_front/screens/disease_allergy/disease_allergy_add.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/screens/pill/pill_category_detail.dart';
import 'package:sopf_front/screens/pill/pill_category_plus.dart';
import 'package:sopf_front/screens/mypage/mypage_bookmark_page.dart';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/managers/globalResponseManager.dart';
import 'package:sopf_front/screens/mypage/mypage.dart';
import 'package:sopf_front/screens/search/result/serach_result_pill_detail.dart';
import 'package:sopf_front/screens/mypage/mypage_settings_page.dart';
import 'package:sopf_front/screens/mypage/mypage_pill_recent_history.dart';
import 'package:sopf_front/screens/search/result/search_result.dart';
import 'package:sopf_front/screens/pill/pill_tasking_list.dart';
import 'package:sopf_front/screens/search/search_text.dart';
import 'package:sopf_front/screens/sign/sign_up.dart';
import 'screens/pill/pill_category_plus.dart';
import 'screens/mypage/mypage_service_center.dart';
import 'home.dart';
import 'providers/provider_loading.dart';
import 'main.dart';
import 'screens/multi_profile/multi_profile_add.dart';

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
    MaterialPageRoute(builder: (context) => PillDetails(serialNumber: serialNumber, imgUrl: '')),
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

void navigateToMyPage() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => MyPage()),
  );
}

void navigateToMedicationsTaking() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => MedicationPage()),
  );
}

void navigateToMultiProfileAdd() {
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (context) => MultiProfileAdd()),
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
