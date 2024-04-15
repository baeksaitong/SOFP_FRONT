import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: GetAllergyDisease()));
}

class GetAllergyDisease extends StatefulWidget {
  @override
  _GetAllergyDiseaseState createState() => _GetAllergyDiseaseState();
}

class _GetAllergyDiseaseState extends State<GetAllergyDisease> {
  String userName = "OOO"; // 사용자 이름
  String selectedAllergy = "알레르기 없음";
  String selectedDisease = "질병 없음";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                '$userName 님 안녕하세요!',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, bottom: 50),
              child: Text(
                '현재 앓고 있는 질병이나\n알레르기가 있다면 알려주세요!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
              ),
            ),
            _buildSelectionTile(context, "알레르기", selectedAllergy),
            _buildSelectionTile(context, "질병", selectedDisease),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 여기에 메인 화면으로 이동하는 코드를 넣어주세요
          // 예를 들어 Navigator.push() 또는 Navigator.pop() 등을 사용
        },
        child: Image.asset('assets/rightarrow.png'),
        elevation: 0,
        backgroundColor: Colors.transparent, // 배경색은 투명색
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // 버튼을 오른쪽 하단에 위치
    );
  }

  Widget _buildSelectionTile(BuildContext context, String title, String currentValue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.greenAccent, width: 2) // greenAccent 테두리
      ),
      child: ListTile(
        title: Text("$title: $currentValue"),
        onTap: () => _showSelectionDialog(context, title, ["None", "Example 1", "Example 2"], (value) {
          setState(() {
            if (title == "알레르기") {
              selectedAllergy = value;
            } else {
              selectedDisease = value;
            }
          });
        }),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  void _showSelectionDialog(BuildContext context, String type, List<String> options, Function(String) onSelect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("선택: $type"),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(options[index]),
                  onTap: () {
                    onSelect(options[index]);
                    Navigator.of(context). pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
