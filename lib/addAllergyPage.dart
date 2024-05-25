import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopf_front/apiClient.dart';
import 'package:sopf_front/navigates.dart';
import 'package:sopf_front/provider.dart';

import 'globalResponseManager.dart';

// void main() {
//   runApp(MaterialApp(
//     title: 'First App',
//     theme: ThemeData(primarySwatch: Colors.blue),
//     home: AddAllergyPage(),
//   ));
// }

class AddAllergyPage extends StatefulWidget {
  const AddAllergyPage({super.key});

  @override
  _AddAllergyPageState createState() => _AddAllergyPageState();
}

class _AddAllergyPageState extends State<AddAllergyPage> {
  List<String> allergies = [];

  @override
  void initState() {
    super.initState();
  }

  void _addAllergy(String input) {
    setState(() {
      allergies.add(input);
    });
  }

  void _removeAllergy(int index) {
    setState(() {
      allergies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = Provider.of<ProfileProvider>(context).currentProfile;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currentProfile?.name},환영합니다',
              // 'ㅋ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '현재 앓고있는 알레르기가 있다면 추가 해주세요',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 100, // 리스트의 높이를 설정하세요
              child: Wrap(
                spacing: 8.0, // 아이템 사이의 간격
                runSpacing: 8.0, // 줄 사이의 간격
                children: [
                  for (int i = 0; i < allergies.length; i++)
                    Chip(
                      backgroundColor: Color(0xFFE6F6F4), // 배경색
                      label: Text(
                        allergies[i],
                        style: TextStyle(
                          color: Color(0xFF00AD98), // 텍스트 색상
                        ),
                      ),
                      deleteIconColor: Color(0xFF00AD98), // 삭제 아이콘 색상
                      onDeleted: () => _removeAllergy(i),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Color(0xFFE6F6F4), // 테두리 색상
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String inputText = '';
                      return AlertDialog(
                        title: Text('알레르기 추가'),
                        content: TextField(
                          autofocus: true, // 커서가 자동으로 들어감
                          onChanged: (value) {
                            inputText = value;
                          },
                          decoration: InputDecoration(
                            hintText: '알레르기를 입력하세요',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('추가'),
                            onPressed: () {
                              _addAllergy(inputText);
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('취소'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('+ 추가하기'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // 버튼이 눌렸을 때 실행할 동작 추가
                      navigateToHome();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 모서리 둥글기 설정
                      ),
                      backgroundColor: Color(0xFF00AD98), // 배경색 지정
                    ),
                    child: Text(
                      '약속 시작하기', // 버튼 텍스트
                      style: TextStyle(
                        color: Colors.white, // 텍스트 색상
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
