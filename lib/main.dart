import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';
import 'DetailPage.dart';
import 'shapeSearch.dart';
import 'bookmark.dart';

void main() {
  runApp(const BookMarkUI());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            scrolledUnderElevation: 0,
            title: Center(child: AppBarTotal()),
          ),
        ),
        body: ShapeSearchTotal(),
        bottomNavigationBar: BottomBarTotal(),
      ),
    );
  }
}
class AppBarTotal extends StatelessWidget {
  const AppBarTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        AppBarKeywordSearch(),
        Gaps.w10,
        Icon(
          Icons.search,
          size: 40,
        ),
      ],
    );
  }
}

class AppBarKeywordSearch extends StatelessWidget {
  const AppBarKeywordSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 3,
                color: Color(0xFF53DACA)
            ),
          ),
          child: Row(
            children: [
              Flexible(child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  hintText: '검색 키워드를 입력하세요',
                ),
              )),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.camera_alt_outlined),
              ),
            ],
          ),
        )
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: Color(0xFF53DACA),
          ),
          borderRadius: BorderRadius.circular(36)
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: const [
          UserProfileImageName(),
          Gaps.h10,
          UserProfileFeature(),
        ],
      ),
    );
  }
}

class UserProfileImageName extends StatelessWidget {
  const UserProfileImageName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage(
              'assets/회원사진.png'
          ),
          height: 90,
          width: 90,
        ),
        Gaps.w10,
        Text(
          '육수백이',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios_outlined),
        ),
      ],
    );
  }
}

class UserProfileFeature extends StatelessWidget {
  const UserProfileFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/pillow.png',
              width: 40,
              height: 40,
            ),
            Gaps.w8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('현재 복용 중인 약',
                    style: TextStyle(fontSize: 10)),
                SizedBox(height: 5,),
                Text('- 감기약\n- 몸에 좋은 약',
                  style: TextStyle(fontSize: 9),),
              ],
            )
          ],
        ),
        Container(
          width: 2,
          height: 40,
          color: Colors.black12,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        Row(
          children: [
            Image.asset(
              'assets/allergy.png',
              width: 40,
              height: 40,
            ),
            Gaps.w8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('알레르기 현황',
                    style: TextStyle(fontSize: 10)),
                SizedBox(height: 5,),
                Text('- 새우\n- 장구',
                  style: TextStyle(fontSize: 9),),
              ],
            )
          ],
        )
      ],
    );
  }
}

class ShapeSearchTotal extends StatelessWidget {
  const ShapeSearchTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserProfile(),
        Gaps.h10,
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Color(0xFF53DACA),
              ),
              borderRadius: BorderRadius.circular(36)
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: const [
              Text(
                '모양으로 약 찾기',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ShapeSearhSelect(),
            ],
          ),
        )
      ],
    );
  }
}

class BottomBarTotal extends StatelessWidget {
  const BottomBarTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[

        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/bottom_icon_bookmark.png',
            width: 30,
            height: 30,
          ),
          label: '즐겨찾기',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              Icons.circle_outlined,
              size: 50,
              color: Color(0xFF53DACA)
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/bottom_icon_mypage.png',
            width: 30,
            height: 30,
          ),
          label: '마이페이지',
        ),
      ],
    );
  }
}

Widget customColorButton(String colorName, Color color, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 50,
      height: 30,
      color: color,
      child: Center(
        child: Text(
          colorName,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.0,
          ),
        ),
      ),
    ),
  );
}