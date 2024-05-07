import 'package:flutter/material.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/appTextStyles.dart';

class NewMyPage extends StatelessWidget {
  const NewMyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Map<String, dynamic>? memberInfo = {'name': '이한조'};
  final List<String> _allergiesanddisease = [
    "꽃가루",
    "먼지",
    "견과류",
    "우유",
    "생선",
    "달걀",
    "조개류",
    "밀",
    "대두",
    "땅콩"
  ];
  final List<String> _medications = [
    "이부프로펜",
    "아세트아미노펜",
    "아목시실린",
    "메트포르민",
    "암로디핀",
    "시모바스타틴",
    "오메프라졸",
    "로사르탄",
    "아스피린",
    "가바펜틴"
  ];
  List<String> _filteredAllergiesanddisease = [];
  List<String> _filteredMedications = [];
  List<String> _selectedAllergiesanddisease = [];
  List<String> _selectedMedications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              buildProfileHeader(),
              SizedBox(height: 60),
              Wrap(
                children: [
                  buildInfoSection(
                      context, '내 알레르기 및 질병', "알레르기 및 질병 정보를 입력하세요.",
                      'allergy'),
                  buildInfoSection(context, '내가 복용 중인 약', "복용 중인 약 정보를 입력하세요.",
                      'medication'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFDFE0E3),
            child: Image.asset('assets/user-icon.png', width: 70, height: 70),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 200),
                child: Text(
                  '${memberInfo?['name']} 님',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () {
                  print("정보 수정 기능 구현 필요");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(right: 220),
                ),
                child: Text('정보 수정', style: TextStyle(
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

  Widget buildInfoSection(BuildContext context, String title, String type,
      String s) {
    List<String> selectedItems = type == 'allergy'
        ? _selectedAllergiesanddisease
        : _selectedMedications;
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
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: selectedItems.map((item) =>
                Chip(
                  label: Text(item),
                  onDeleted: () {
                    setState(() {
                      selectedItems.remove(item);
                    });
                  },
                )).toList(),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => showEditBottomSheet(context, title, type),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 36),
              backgroundColor: Colors.white,
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

  void showEditBottomSheet(BuildContext context, String title, String type) {
    List<String> fullList = (type == 'allergy')
        ? _medications
        : _allergiesanddisease;
    List<String> selectedList = (type == 'allergy')
        ? _selectedMedications
        : _selectedAllergiesanddisease;
    List<String> filteredList = fullList;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.all(20),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          filteredList = fullList
                              .where((item) =>
                              item.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                          if (filteredList.length > 10) {
                            filteredList = filteredList.sublist(
                                0, 10); // 최대 10개의 결과만 보여줍니다.
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: '검색',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(filteredList[index]),
                            value: selectedList.contains(filteredList[index]),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value!) {
                                  if (!selectedList.contains(
                                      filteredList[index])) {
                                    selectedList.add(filteredList[index]);
                                  } else {
                                    selectedList.remove(filteredList[index]);
                                  }
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 하단 시트 닫기
                          setState(() {}); // 메인 화면 업데이트를 위해 상태 업데이트
                        },
                        child: Text('저장'),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
    );
  }
}