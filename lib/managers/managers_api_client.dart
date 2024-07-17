// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:sopf_front/managers/managers_jwt.dart';
import 'package:sopf_front/providers/provider.dart';
import '../models/models_drug_info_detail.dart';
import '../models/models_profile.dart';
import 'managers_category.dart';
import 'managers_drugs.dart';
import 'managers_favorites.dart';
import 'managers_global_response.dart';
import '../navigates.dart';
import 'managers_recent_histories.dart';
import 'managers_tasking_drugs.dart';

class APIClient {
  static String? baseUrl = dotenv.env['API_URL'];
  final JWTManager _jwtManager = JWTManager();

  Future<void> naverLogin(BuildContext context, String code) async {
    final String url = '$baseUrl/app/oauth/naver?code=$code';
    final response = await http.get(
      Uri.parse(url),
      headers: {'accept': '*/*'},
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // Check if tokens are not null
      final tokenData = jsonResponse['token'];
      final accessToken = tokenData['accessToken'];
      final refreshToken = tokenData['refreshToken'];

      if (tokenData == null) {
        print('Error: Missing token data in response');
      }

      await _jwtManager.saveTokens(accessToken, refreshToken);
      print('로그인 성공: $jsonResponse');

      ProfileResponse? profileResponse = await profileAll();
      if (profileResponse != null && profileResponse.profileList.isNotEmpty) {
        if (context.mounted) {
          // context가 여전히 유효한지 확인
          Provider.of<ProfileProvider>(context, listen: false)
              .setCurrentProfile(profileResponse.profileList[0]);
          print('프로필 설정 완료: ${profileResponse.profileList[0].name}');
        }
      }
      diseaseAllergyList();
      if(context.mounted) {
        recentViewPillGet(context);
      }
    } else {
      print(response.statusCode);
      print('로그인 실패: $jsonResponse');
    }
  }

  Future<void> signUp(String name, String birthday, String email, String gender,
      String pwd, bool advertisement) async {
    final url = Uri.parse('$baseUrl/app/auth/sign-up');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "birthday": birthday,
        "email": email,
        "gender": gender,
        "password": pwd,
        "advertisement": advertisement
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      // 회원가입 성공 처리

      print('회원가입 성공: $jsonResponse');
    } else {
      // 에러 처리
      print(response.statusCode);
      print('회원가입 실패: $jsonResponse');
    }
  }

  Future<void> profileAdd(String name, String birthday, String gender,
      String color, String? profileImg) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/profile/add');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "birthday": birthday,
        "gender": gender,
        "color": color,
        "profileImg": profileImg,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      // 회원가입 성공 처리
      print('회원가입 성공: $jsonResponse');
    } else {
      // 에러 처리
      print(response.statusCode);
      print('회원가입 실패: $jsonResponse');
    }
  }

  Future<void> idCheck(String email) async {
    final url = Uri.parse('$baseUrl/app/auth/id-check');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('사용 가능한 아이디 : $decodedResponse'); // 성공 메시지가 일반 텍스트인 경우
      mailSend(email);
    } else {
      print(response.statusCode);
      print('이미 사용 중인 아이디 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
    }
  }

  Future<void> mailSend(String email) async {
    final url = Uri.parse('$baseUrl/app/verification/mail/send');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      print('전송 성공 : $decodedResponse'); // 성공 메시지가 일반 텍스트인 경우
    } else {
      print(response.statusCode);
      print('전송 실패 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
    }
  }

  Future<void> mailCheck(String email, String code) async {
    final url = Uri.parse('$baseUrl/app/verification/mail/check');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "code": code,
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);

    try {
      var jsonResponse = jsonDecode(decodedResponse);
      if (response.statusCode == 200) {
        print('전송 성공 : $jsonResponse');
      } else {
        print(response.statusCode);
        print('전송 실패 : $jsonResponse');
      }
    } catch (e) {
      if (response.statusCode == 200) {
        print('전송 성공 : $decodedResponse'); // 성공 메시지가 일반 텍스트인 경우
      } else {
        print(response.statusCode);
        print('전송 실패 : $decodedResponse'); // 오류 메시지가 일반 텍스트인 경우
      }
    }
  }

  Future<void> login(BuildContext context, String email, String pwd) async {
    final url = Uri.parse('$baseUrl/app/auth/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'accept': '*/*',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "password": pwd,
      }),
    );
    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);

    if (response.statusCode == 200) {
      // Check if tokens are not null
      final tokenData = jsonResponse['token'];
      final accessToken = tokenData['accessToken'];
      final refreshToken = tokenData['refreshToken'];

      if (tokenData == null) {
        print('Error: Missing token data in response');
      }

      await _jwtManager.saveTokens(accessToken, refreshToken);
      print('로그인 성공: $jsonResponse');

      ProfileResponse? profileResponse = await profileAll();
      if (profileResponse != null && profileResponse.profileList.isNotEmpty) {
        // Ensure `context` is passed with `listen: false`
        if(context.mounted) {
          Provider.of<ProfileProvider>(context, listen: false).setProfileList(profileResponse.profileList);
          Provider.of<ProfileProvider>(context, listen: false)
              .setCurrentProfile(profileResponse.profileList[0]);
        }
      }
      diseaseAllergyList();
      if (context.mounted) {
        await recentViewPillGet(context); // await 추가
        await pillGet(context, null); // await 추가
      }
      if (jsonResponse['isNew'] == false) {
        navigateToAddAllergy();
      } else {
        navigateToHome();
      }
    } else {
      print(response.statusCode);
      print('로그인 실패: $jsonResponse');
    }
  }

  Future<void> logout() async {
    await _jwtManager.deleteTokens();
  }

  Future<String> getValidAccessToken() async {
    return await _jwtManager.getValidAccessToken();
  }

  Future<void> memberInfo() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/member');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('멤버 출력: $decodedResponse');
      GlobalResponseManager().addResponse(decodedResponse); // 응답을 전역 배열에 추가
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패했습니다: ${response.body}');
    }
  }


  Future<ProfileResponse?> profileAll() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/profile');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('모든 멤버 출력: $decodedResponse');

      Map<String, dynamic> jsonResponse = jsonDecode(decodedResponse);
      return ProfileResponse.fromJson(jsonResponse);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패했습니다: ${response.body}');
      return null;
    }
  }

  Future<void> profilePost(
      String name, String birthday, String gender, String color, XFile? _image
      ) async {
    final String? accessToken = await _jwtManager.getAccessToken();

    var url = Uri.parse('$baseUrl/app/profile');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // 이미지 파일을 base64로 인코딩
    String? base64Image;
    if (_image != null) {
      List<int> imageBytes = await _image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    var body = jsonEncode({
      'name': name,
      'birthday': birthday,
      'gender': gender,
      'color': color,
      'profileImg': base64Image, // 이미지 파일이 있을 경우 추가
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('프로필이 성공적으로 저장되었습니다');
    } else {
      print('Failed to save profile');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> recentViewPillGet(BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/recent-view/${currentProfile?.id}?count=10');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('최근 조회 알약 조회 성공 : $jsonResponse');
      RecentHistoriesManager().updateFavorites(utf8.decode(response.bodyBytes));
    } else {
      print(response.statusCode);
      print('최근 조회 알약 조회 실패 : $jsonResponse');
    }
  }

  Future<bool> recentViewPillDelete(int pillSerialNumber, BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/recent-view/${currentProfile?.id}?pillSerialNumber=$pillSerialNumber');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes); // 응답을 UTF-8로 디코딩
    if (response.statusCode == 200) {
      print('최근 조회 알약 삭제 성공 : $decodedResponse');
      return true;
    } else {
      print(response.statusCode);
      print('최근 조회 알약 삭제 실패 : $decodedResponse');
      return false;
    }
  }


  Future<void> diseaseAllergyList() async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/disease-allergy');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('질병 및 알레르기 불러오기 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('질병 및 알레르기 불러오기 실패 : $jsonResponse');
    }
  }

  Future<void> diseaseAllergySearch(String keyword) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url =
        Uri.parse('$baseUrl/app/disease-allergy/search?keyword=$keyword');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('검색 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('검색 실패 : $jsonResponse');
    }
  }

  Future<void> diseaseAllergyGet(BuildContext context, String keyword) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/disease-allergy/${currentProfile?.id}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('질병 및 알레르기 목록 조회 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('질병 및 알레르기 목록 조회 실패 : $jsonResponse');
    }
  }

  Future<void> diseaseAllergyAddOrDelete(BuildContext context,
      String? addDiseaseAllergyList, String? removeDiseaseAllergyList) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/disease-allergy/${currentProfile?.id}');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
      body: jsonEncode(<String, dynamic>{
        "addDiseaseAllergyList": [addDiseaseAllergyList],
        "removeDiseaseAllergyList": [removeDiseaseAllergyList]
      }),
    );

    var decodedResponse = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(decodedResponse);
    if (response.statusCode == 200) {
      print('추가 및 삭제 성공 : $jsonResponse');
    } else {
      print(response.statusCode);
      print('추가 및 삭제 실패 : $jsonResponse');
    }
  }

  Future<void> searchTextAndShape(
      BuildContext context,
      String? keyword,
      String? shape,
      String? sign,
      String? color,
      String? formulation,
      String? line) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/search/keyword'
        '?profileId=${currentProfile?.id}'
        '&limit=10'
        '&keyword=$keyword'
        '&shape=$shape'
        '&sign=$sign'
        '&color=$color'
        '&formulation=$formulation'
        '&line=$line');
    print(keyword);
    print(url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );
    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      DrugsManager().updateDrugs(utf8.decode(response.bodyBytes));
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchInfoPill(
      String pillSerialNumber, BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    print('$pillSerialNumber, ${currentProfile?.id}');
    final url = Uri.parse(
        '$baseUrl/app/search/info?pillSerialNumber=$pillSerialNumber?profileId=${currentProfile?.id.toString()}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      DrugsManager().updateDrugs(utf8.decode(response.bodyBytes));
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> searchGet(BuildContext context, int pillSerialNumber) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    print('$pillSerialNumber, ${currentProfile?.id}');
    final url = Uri.parse('$baseUrl/app/search/$pillSerialNumber?profileId=${currentProfile?.id}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('검색완료: ${utf8.decode(response.bodyBytes)}');
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final drugInfoDetail = DrugInfoDetail.fromJson(jsonResponse);
      Provider.of<DrugInfoDetailProvider>(context, listen: false).setCurrentDrugInfoDetail(drugInfoDetail);
      recentViewPillGet(context);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> favoritePost(
      BuildContext context, int serialNumber, String imageUrl) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/favorite/${currentProfile?.id}');
    print(accessToken);

    // Download the image
    var response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    // Save the image as a temporary file
    final documentDirectory = await getTemporaryDirectory();
    final file = File('${documentDirectory.path}/temp_image.jpg');
    await file.writeAsBytes(response.bodyBytes);

    // Create multipart request
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });

    // Add fields
    request.fields['pillSerialNumber'] = serialNumber.toString(); // Ensure it is a string

    // Add file
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    // Send the request
    var streamedResponse = await request.send();
    response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('즐겨찾기 추가 완료: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('즐겨찾기 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }

    // Clean up the temporary file
    await file.delete();
  }

  Future<void> favoriteDelete(BuildContext context, int serialNumber) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/favorite/${currentProfile?.id}?pillSerialNumber=$serialNumber');
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('즐겨찾기 삭제 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('즐겨찾기 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> favoriteGet(BuildContext context) async {
    final currentProfile = Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse('$baseUrl/app/favorite/${currentProfile?.id}');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('즐겨찾기 조회 성공: ${utf8.decode(response.bodyBytes)}');
      FavoritesManager().updateFavorites(utf8.decode(response.bodyBytes));

    } else {
      // 실패 처리
      print(response.statusCode);
      print('즐겨찾기 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillPost(BuildContext context, int serialNumber) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/pill/${currentProfile?.id}');
    final response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
      },
      body: jsonEncode(<String, dynamic>{
        "pillSeriallNumberList": [serialNumber],
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('복용 중인 알약 추가 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('복용 중인 알약 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillDelete(BuildContext context, int serialNumber) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/pill/${currentProfile?.id}?pillSerialNumber=$serialNumber');
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('복용 중인 알약 삭제 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('복용 중인 알약 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillPatch(BuildContext context, int serialNumber, String categoryId) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/pill/${currentProfile?.id}');
    final response = await http.patch(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    },
      body: jsonEncode(<String, dynamic>{
        "pillSerialNumber": serialNumber,
        "categoryId": categoryId
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('복용 중인 알약 이동 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('복용 중인 알약 이동 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pillGet(BuildContext context, String? categoryId) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final Uri url;

    if (categoryId != null) {
      url = Uri.parse('$baseUrl/app/pill?categoryId=$categoryId');
    } else {
      url = Uri.parse(
          '$baseUrl/app/pill?profileId=${currentProfile?.id}&categoryId=$categoryId');
    }
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);

      print('복용 중인 알약 조회 성공: ${utf8.decode(response.bodyBytes)}');
      TakingDrugsManager().updateDrugs(jsonResponse);
      print(TakingDrugsManager().drugs);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('복용 중인 알약 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> categoryGet(BuildContext context, String categoryId) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/category/$categoryId');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('카테고리 조회 성공: ${utf8.decode(response.bodyBytes)}');
      CategoryDetailsManager().updateCategoryDetails(jsonResponse);
    } else {
      // 실패 처리
      print(response.statusCode);
      print('카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<String> categoryGetAll(BuildContext context, String id) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/category?profileId=$id');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('모든 카테고리 조회 성공: ${utf8.decode(response.bodyBytes)}');
      CategoryManager().updateCategories(jsonResponse);  // CategoryManager 업데이트
      return jsonResponse;
    } else {
      // 실패 처리
      print(response.statusCode);
      print('모든 카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
      return '';
    }
  }

  Future<String> categoryDayGet(BuildContext context, String id, String day) async {
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/category/$id/$day');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('요일 카테고리 조회 성공: ${utf8.decode(response.bodyBytes)}');
      return jsonResponse;
    } else {
      // 실패 처리
      print(response.statusCode);
      print('요일 카테고리 조회 실패: ${utf8.decode(response.bodyBytes)}');
      return '';
    }
  }

  Future<void> categoryPost(BuildContext context, Map<String, dynamic>? category) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/category/${currentProfile?.id}');
    final response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    },
      body: jsonEncode(<String, dynamic>{
        "name": category?['name'],
        "intakeDayList": category?['intakeDayList'],
        "intakeTimeList": category?['intakeTimeList'],
        "period": category?['period'],
        "alarm": category?['alarm'],
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      print('카테고리 추가 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('카테고리 추가 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> categoryDelete(BuildContext context, String categoryId, bool isAllDelete) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/category/$categoryId?isAllDelete=$isAllDelete');
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('카테고리 삭제 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('카테고리 삭제 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> calendarGet(BuildContext context, String id) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/calendar/$id');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('프로필 캘린더 조회 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('프로필 캘린더 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> calendarPut(BuildContext context) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final profileList = Provider.of<ProfileProvider>(context, listen: false).profileList;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/calendar/${currentProfile?.id}');
    final response = await http.put(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    },
      body: jsonEncode(<String, dynamic>{
        "addTargetProfileIdList": [
          profileList[0].id,profileList[1].id,
        ],
        "deleteTargetProfileIdList": [
          profileList[2].id,
        ]
      }),
    );

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('일부 캘린더 조회 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('일부 캘린더 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }

  Future<void> pharmacyAroundGet(BuildContext context, String longitude, String latitude) async {
    final currentProfile =
        Provider.of<ProfileProvider>(context, listen: false).currentProfile;
    final String? accessToken = await _jwtManager.getAccessToken();
    final url = Uri.parse(
        '$baseUrl/app/pharmacy/around?longitude=$longitude&latitude=$latitude&distance=1000.0');
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken', // 인증 헤더 추가
    });

    if (response.statusCode == 200) {
      // 성공적으로 처리된 경우
      final jsonResponse = utf8.decode(response.bodyBytes);
      print('주변 약국 조회 성공: ${utf8.decode(response.bodyBytes)}');
    } else {
      // 실패 처리
      print(response.statusCode);
      print('주변 약국 조회 실패: ${utf8.decode(response.bodyBytes)}');
    }
  }
}