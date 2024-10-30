// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/screens/multi_profile/multi_profile_add.dart';
import '../../constans/gaps.dart';
import '../../managers/managers_jwt.dart';
import '../sign/sign_in.dart';
import 'mypage_edit.dart';
import 'mypage_profile_edit.dart';
import '../../providers/provider.dart';

class Profile {
  final String id;
  final String name;
  final String color;
  final String? imgURL;

  Profile({
    required this.id,
    required this.name,
    required this.color,
    this.imgURL,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'imgURL': imgURL,
  };
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class MultiProfileBottomSheet extends StatelessWidget {
  final Function() onProfileAdd;

  const MultiProfileBottomSheet({Key? key, required this.onProfileAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColors.wh,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.h20,
              Text(
                '멀티 프로필',
                style: AppTextStyles.title3S18.copyWith(color: AppColors.gr800),
              ),
              Gaps.h16,
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: profileProvider.profileList.length,
                itemBuilder: (context, index) {
                  final profile = profileProvider.profileList[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          profileProvider.setCurrentProfile(profile);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 48,
                          color: AppColors.gr150,
                          child: Row(
                            children: [
                              Container(
                                width: 2,
                                color: getColorFromText(profile.color),
                              ),
                              Gaps.w12,
                              CircleAvatar(
                                backgroundColor: getColorFromText(profile.color),
                                radius: 10,
                              ),
                              Gaps.w12,
                              Text(
                                profile.name,
                                style: AppTextStyles.body2M16.copyWith(color: AppColors.gr900),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index != profileProvider.profileList.length - 1) Gaps.h10,
                    ],
                  );
                },
              ),
              Center(
                child: Container(
                  width: 335,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onProfileAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softTeal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '프로필 추가하기',
                      style: AppTextStyles.body1S16.copyWith(color: AppColors.vibrantTeal),
                    ),
                  ),
                ),
              ),
              Gaps.h24,
            ],
          ),
        ),
      ),
    );
  }
}

class _MyPageState extends State<MyPage> {
  List<String> _allergiesanddisease = [];
  List<String> _medications = [];
  final List<String> _selectedAllergiesanddisease = [];
  final List<String> _selectedMedications = [];
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    print('Fetching profile...');
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final currentProfile = profileProvider.currentProfile;
      if (currentProfile != null) {
        setState(() {
          profile = currentProfile.toJson();
        });
        print('Profile fetched successfully: $profile');
        await fetchAllergiesAndDiseases();
        await fetchMedications();
      } else {
        print('No current profile found.');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> fetchAllergiesAndDiseases() async {
    if (profile != null && profile!['id'] != null) {
      print('Fetching allergies and diseases...');
      try {
        final accessToken = await JWTManager().getValidAccessToken();
        final response = await http.get(
          Uri.parse('http://3.39.8.147:8080/app/disease-allergy/${profile!['id']}'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          setState(() {
            _allergiesanddisease =
            List<String>.from(json.decode(utf8.decode(response.bodyBytes))['DiseaseAllergyList']);
          });
          print('Allergies and diseases fetched successfully: $_allergiesanddisease');
        } else {
          print('Failed to load allergies and diseases. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching allergies and diseases: $e');
      }
    } else {
      print('Profile ID is null, cannot fetch allergies and diseases.');
    }
  }

  Future<void> fetchMedications() async {
    if (profile != null && profile!['id'] != null) {
      print('Fetching medications...');
      try {
        final accessToken = await JWTManager().getValidAccessToken();
        final response = await http.get(
          Uri.parse('http://3.39.8.147:8080/app/pill?profileId=${profile!['id']}'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          setState(() {
            _medications = List<String>.from(
                json.decode(utf8.decode(response.bodyBytes))['pillInfoList'].map((pill) => pill['name']));
          });
          print('Medications fetched successfully: $_medications');
        } else {
          print('Failed to load medications. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching medications: $e');
      }
    } else {
      print('Profile ID is null, cannot fetch medications.');
    }
  }

  Future<void> updateAllergiesAndDiseases() async {
    try {
      final accessToken = await JWTManager().getValidAccessToken();
      final response = await http.patch(
        Uri.parse('http://3.39.8.147:8080/app/disease-allergy/${profile!['id']}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'addDiseaseAllergyList': _selectedAllergiesanddisease,
          'removeDiseaseAllergyList': _allergiesanddisease
              .where((item) => !_selectedAllergiesanddisease.contains(item))
              .toList(),
        }),
      );
      if (response.statusCode == 200) {
        print('Allergies and diseases updated successfully.');
        fetchAllergiesAndDiseases();
      } else {
        print('Failed to update allergies and diseases. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating allergies and diseases: $e');
    }
  }

  Future<void> updateMedications() async {
    try {
      final accessToken = await JWTManager().getValidAccessToken();
      final response = await http.post(
        Uri.parse('http://3.39.8.147:8080/app/pill/${profile!['id']}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'pillSerialNumberList': _selectedMedications,
        }),
      );
      if (response.statusCode == 200) {
        print('Medications updated successfully.');
        fetchMedications();
      } else {
        print('Failed to update medications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating medications: $e');
    }
  }

  void showEditAllergiesBottomSheet(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    List<String> searchResults = [];
    _selectedAllergiesanddisease.clear();
    _selectedAllergiesanddisease.addAll(_allergiesanddisease);

    Future<void> onSearch(String value) async {
      try {
        final accessToken = await JWTManager().getValidAccessToken();
        final response = await http.get(
          Uri.parse('http://3.39.8.147:8080/app/disease-allergy/search?keyword=$value'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            searchResults = List<String>.from(json.decode(utf8.decode(response.bodyBytes))['DiseaseAllergyList']);
          });
        } else {
          print('Failed to search allergies. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error searching allergies: $e');
      }
    }

    showModalBottomSheet(
      backgroundColor: AppColors.wh,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("알레르기 & 질병 수정", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Gaps.h10,
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "알레르기나 질병 입력",
                        suffixIcon: SizedBox(
                          width: 12,
                          child: TextButton(
                            child: Text(
                              "추가 +",
                              style: TextStyle(color: AppColors.wh, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          onSearch(value);
                        });
                      },
                    ),
                    Gaps.h10,
                    searchResults.isNotEmpty
                        ? Container(
                      height: 150,
                      child: ListView(
                        children: searchResults.map((item) {
                          bool isSelected = _selectedAllergiesanddisease.contains(item);
                          return ListTile(
                            title: Text(item),
                            trailing: isSelected ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              setModalState(() {
                                toggleSelection(item);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    )
                        : Container(),
                    Gaps.h20,
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        updateAllergiesAndDiseases();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softTeal,
                        minimumSize: Size(double.infinity, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "저장하기",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'pretendard',
                          color: AppColors.vibrantTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showEditMedicationsBottomSheet(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    List<String> searchResults = [];
    _selectedMedications.clear();
    _selectedMedications.addAll(_medications);

    Future<void> onSearch(String value) async {
      try {
        final accessToken = await JWTManager().getValidAccessToken();
        final response = await http.get(
          Uri.parse('http://3.39.8.147:8080/app/pill/search?keyword=$value'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            searchResults = List<String>.from(
                json.decode(utf8.decode(response.bodyBytes))['pillInfoList'].map((pill) => pill['name']));
          });
        } else {
          print('Failed to search medications. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error searching medications: $e');
      }
    }

    showModalBottomSheet(
      backgroundColor: AppColors.wh,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("내가 복용 중인 약 수정", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Gaps.h10,
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "복용중인 약 이름 입력",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // 추후 추가 기능 구현
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          onSearch(value);
                        });
                      },
                    ),
                    Gaps.h10,
                    searchResults.isNotEmpty
                        ? Container(
                      height: 150,
                      child: ListView(
                        children: searchResults.map((item) {
                          bool isSelected = _selectedMedications.contains(item);
                          return ListTile(
                            title: Text(item),
                            trailing: isSelected ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              setModalState(() {
                                toggleSelectionMedications(item);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    )
                        : Container(),
                    Gaps.h20,
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        updateMedications();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softTeal,
                        minimumSize: Size(double.infinity, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "저장하기",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'pretendard',
                          color: AppColors.vibrantTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void toggleSelection(String item) {
    setState(() {
      if (_selectedAllergiesanddisease.contains(item)) {
        _selectedAllergiesanddisease.remove(item);
      } else {
        _selectedAllergiesanddisease.add(item);
      }
    });
  }

  void toggleSelectionMedications(String item) {
    setState(() {
      if (_selectedMedications.contains(item)) {
        _selectedMedications.remove(item);
      } else {
        _selectedMedications.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final currentProfile = profileProvider.currentProfile;

    return Scaffold(
      backgroundColor: AppColors.wh,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gaps.h60,
          buildProfileHeader(),
          Gaps.h60,
          buildInfoSection(context, '내 알레르기 및 질병', "알레르기 및 질병 정보를 입력하세요.", 'allergy'),
          buildInfoSection(context, '내가 복용 중인 약', "복용 중인 약 정보를 입력하세요.", 'medication'),
          buildPageNavigationSection(context),
        ],
      ),
    );
  }

  Widget buildProfileHeader() {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final currentProfile = profileProvider.currentProfile;

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.gr200,
            backgroundImage: currentProfile?.imgURL != null && currentProfile!.imgURL!.isNotEmpty
                ? NetworkImage(currentProfile.imgURL!)
                : AssetImage('assets/mypageEdit/user-icon.png') as ImageProvider,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '${currentProfile?.name ?? '이름없음'} 님',
                  style: TextStyle(fontSize: 24, fontFamily: 'Pretendard', fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (currentProfile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPageEdit(profileId: currentProfile.id),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 20),
                ),
                child: Text('회원정보 변경',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      color: AppColors.gr550,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPageProfileEdit(profileId: currentProfile?.id ?? ''),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                ),
                child: Text('프로필 정보 수정',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      color: AppColors.gr550,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInfoSection(BuildContext context, String title, String prompt, String type) {
    List<String> selectedItems = type == 'allergy' ? _allergiesanddisease : _medications;
    Function showEditSheet = type == 'allergy' ? showEditAllergiesBottomSheet : showEditMedicationsBottomSheet;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gr150,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Gaps.h10,
          Wrap(
            spacing: 8,
            children: selectedItems.map((item) {
              return Chip(
                backgroundColor: AppColors.vibrantTeal,
                label: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    color: AppColors.wh,
                  ),
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppColors.vibrantTeal),
                ),
              );
            }).toList(),
          ),
          Gaps.h10,
          ElevatedButton(
            onPressed: () {
              if (title == '내가 복용 중인 약') {
                navigateToMedicationsTaking();
              } else {
                showEditSheet(context);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 36),
              backgroundColor: AppColors.wh,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '수정하기',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageNavigationSection(BuildContext context) {
    return Column(
      children: [
        buildNavigationItem(context, Icons.person, "멀티 프로필", () {
          showModalBottomSheet(
            context: context,
            builder: (context) => MultiProfileBottomSheet(
              onProfileAdd: () {
                Navigator.pop(context);
              },
            ),
          ).then((_) {
            fetchProfile();
          });
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.star, "즐겨찾기", () {
          navigateToFavorite();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.history, "검색 히스토리", () {
          navigateToRecentHistory();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.headset_mic, "고객센터", () {
          navigateToCustomerService();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.settings, "환경설정", () {
          navigateToPreference();
        }),
        Gaps.h16,
        buildNavigationItem(context, Icons.logout, "로그아웃", () {
          _logout(context);
        }),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    await JWTManager().deleteTokens();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false,
    );
  }

  Widget buildNavigationItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gr700),
      title: Text(
        title,
        style: AppTextStyles.body1S16.copyWith(color: AppColors.gr700),
      ),
      onTap: onTap,
    );
  }
}
