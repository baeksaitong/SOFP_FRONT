# SOFP_FRONT
# 약속(Yacsok)

## 디벨로퍼

| ![손창민](assets/손창민.jpg) | ![성명근](assets/성명근.jpg) | ![신창윤](assets/신창윤.jpg) | ![이한조](assets/이한조.jpg) |
|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| 손창민 | 성명근  | 신창윤 | 이한조 |



## 목차
1. [프로젝트 설명](#프로젝트-설명)
2. [주요 기능](#주요-기능)
3. [기술 스택](#기술-스택)
4. [개발 도구](#개발-도구)
5. [설치 방법](#설치-방법)
6. [라이센스](#라이센스)
7. [프로젝트 배경 및 목표](#프로젝트-배경-및-목표)
8. [시연 영상 및 스크린샷](#시연-영상-및-스크린샷)
9. [문서](#문서)
10. [문제 해결](#문제-해결)
11. [폴더 구조](#폴더-구조)

## 프로젝트 설명
**약속(Yacsok)**은 사용자가 알약 정보를 쉽게 검색하고 관리할 수 있도록 돕는 모바일 어플리케이션입니다. 이 어플리케이션은 Flutter를 사용하여 개발되었으며, 사용자 친화적인 인터페이스와 다양한 기능을 제공합니다.

## 주요 기능
1. **텍스트 검색**: 약 이름과 성분을 기반으로 한 검색 기능을 제공합니다.
2. **모양으로 검색**: 색상, 모양, 제형, 분할선 등의 필터 조건을 통해 약을 검색할 수 있습니다.
3. **이미지로 검색**: 카메라를 사용하여 알약의 사진을 찍거나 갤러리에서 이미지를 선택하여 검색할 수 있습니다. 인공지능 분석을 통해 약물 정보를 확인할 수 있습니다.
4. **검색 결과**: 텍스트 및 모양 검색 결과를 리스트로 제공하며, 사용자가 복용 중인 약 추가 기능과 주의 사항을 쉽게 확인할 수 있습니다.
5. **즐겨찾기**: 자주 사용하는 약물을 즐겨찾기에 추가하여 빠르게 접근할 수 있습니다.
6. **회원 가입 및 관리**: 이메일과 소셜 계정을 통해 회원 가입을 지원하며, 회원 정보 수정, 질병 및 알레르기 정보 관리 기능을 제공합니다.
7. **캘린더 연동**: 복용 일정과 알림 서비스를 제공하여 사용자가 약물 복용을 놓치지 않도록 합니다.

## 기술 스택

| **기술 스택**    | **도구**     | **협업 도구**   |
|-----------------|-------------|----------------|
| Spring Boot     | Figma       | GitHub         |
| Flutter         | Git         | Notion         |
| Java Persistence|             | Discord        |
| TensorFlow      |             |                |
| Jenkins         |             |                |
| Redis           |             |                |
| Docker          |             |                |
| MongoDB         |             |                |


### 의존성 및 라이브러리

- **프론트엔드 (Flutter)**
  - `intl`: ^0.17.0
  - `table_calendar`: ^3.0.6
  - `fluttertoast`: ^8.0.7
  - `image_picker`: ^1.1.1
  - `http`: ^1.2.1
  - `permission_handler`: ^11.3.1
  - `camera`: ^0.10.6
  - `provider`: ^6.1.2
  - `flutter_secure_storage`: ^6.1.0
  - `jwt_decoder`: ^2.0.1
  - `lottie`: ^1.2.0
  - `shared_preferences`: ^2.2.3
  - `cupertino_icons`: ^1.0.6
  - `xml`: ^6.5.0
  - `path_provider`: ^2.1.3
  - `html`: ^0.15.0
  - `flutter_webview_plugin`: ^0.4.0
  - `dio`: ^5.4.3
  - `flutter_spinkit`: ^5.1.0
  - `google_maps_flutter`: ^2.6.1
  - `google_maps_flutter_web`: ^0.5.7
  - `json_serializable`: ^6.8.0
  - `location`: ^6.0.2
  - `syncfusion_flutter_maps`: ^25.2.5
  - `geolocator`: ^7.6.2
  - `import_sorter`: ^4.6.0
  - `flutter_dotenv`: ^5.0.2

## 개발 도구
- **디자인**: Figma
- **버전 관리**: Git
- **협업 도구**: GitHub, Notion, Discord

## 설치 방법
```bash
# 저장소 클론
git clone [https://github.com/baeksaitong/SOFP_FRONT.git]

# 프로젝트 디렉토리로 이동
cd 너의 프로젝트 디렉토리 주소

# 의존성 설치
flutter pub get

# 애플리케이션 실행
flutter run
```
설치 전에 Flutter 개발 환경이 올바르게 설정되어 있는지 확인하세요.
설치 후에 Flutter doctor 명령어를 이용하여 설치가 완료되었는지 확인하세요!

## 라이센스
이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조해 주세요.

## 프로젝트 배경 및 목표
**약속(Yacsok)**은 사용자가 다양한 약물 정보를 쉽게 검색하고 관리할 수 있도록 돕기 위해 개발되었습니다. 이 프로젝트는 복잡한 약물 정보를 효율적으로 제공하여 사용자들이 올바른 약물 복용을 할 수 있도록 지원하는 것을 목표로 합니다.

## 시연 영상 및 스크린샷
**시연 영상** : https://www.youtube.com/watch?v=BSpjq0oVcI4&t=1s

## 문서
**API Swagger** : [http://15.164.18.65:8080/swagger-ui/index.html)]

## 문제 해결
### 일반적인 문제와 해결 방법
- **문제 예시**: 어떠한 문제!
  - **해결 방법**:
    1. `flutter doctor` 명령어를 사용하여 필요한 구성 요소가 모두 설치되었는지 확인합니다.
    2. `Flutter clean` -> `Flutter pub get` -> `Flutter run 혹은 버튼을 눌러 실행`

## 폴더 구조
```plaintext
SOFP_FRONT/
│
├── .dart_tool/
├── .github/
├── .idea/
├── android/
├── assets/
├── build/
├── ios/
├── lib/
│   ├── constans/
│   │   ├── colors.dart
│   │   ├── gaps.dart
│   │   └── text_styles.dart
│   ├── managers/
│   │   ├── locations/
│   │   ├── managers_api_client.dart
│   │   ├── managers_global_response.dart
│   │   └── managers_jwt.dart
│   ├── providers/
│   │   ├── provider.dart
│   │   └── provider_loading.dart
│   ├── screens/
│   │   ├── calendar/
│   │   │   └── calenderPage.dart
│   │   ├── disease_allergy/
│   │   │   └── disease_allergy_add.dart
│   │   ├── map/
│   │   │   └── map_pharmacy.dart
│   │   ├── multi_profile/
│   │   │   ├── multi_profile_add.dart
│   │   │   └── multi_profile_edit.dart
│   │   ├── mypage/
│   │   │   ├── mypage.dart
│   │   │   ├── mypage_bookmark_page.dart
│   │   │   ├── mypage_edit.dart
│   │   │   ├── mypage_pill_recent_history.dart
│   │   │   ├── mypage_profile_edit.dart
│   │   │   ├── mypage_service_center.dart
│   │   │   └── mypage_settings_page.dart
│   │   ├── pill/
│   │   │   ├── category_details.dart
│   │   │   ├── pill_category_detail.dart
│   │   │   ├── pill_category_plus.dart
│   │   │   └── pill_tasking_list.dart
│   │   ├── search/
│   │   │   ├── result/
│   │   │   │   ├── search_result.dart
│   │   │   │   ├── search_result_image.dart
│   │   │   │   ├── serach_result_pill_detail.dart
│   │   │   ├── search_image.dart
│   │   │   ├── search_shape.dart
│   │   │   └── search_text.dart
│   │   ├── sign/
│   │   │   ├── sign_in.dart
│   │   │   ├── sign_naver.dart
│   │   │   └── sign_up.dart
│   ├── widgets/
│   │   ├── calender/
│   │   │   ├── calender_bottomdialog.dart
│   │   │   ├── calender_eventlist.dart
│   │   │   ├── calender_eventmarker.dart
│   │   │   └── calender_header.dart
│   │   ├── common/
│   │   │   ├── custom_appbar.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── info_tile.dart
│   │   │   └── settings_tile.dart
│   │   ├── disease_allergy/
│   │   │   ├── disease_allergy_bottom_sheet.dart
│   │   │   ├── disease_allergy_search_field.dart
│   │   │   └── disease_allergy_select_chip.dart
│   │   ├── multi_profile/
│   │   │   ├── birthdate_picker.dart
│   │   │   ├── color_selector.dart
│   │   │   ├── gender_selector.dart
│   │   │   └── profile_image_picker.dart
│   ├── home.dart
│   ├── main.dart
│   └── navigates.dart
├── .env
├── .flutter-plugins
├── .flutter-plugins-dependencies
├── .gitignore
├── .import_sorter.yaml
├── analysis_options.yaml
├── pubspec.lock
├── pubspec.yaml
└── README.md

```
