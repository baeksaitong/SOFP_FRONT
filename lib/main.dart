import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';
import 'package:sofp_front/searchResult.dart';
import 'mypage.dart';
import 'shapeSearch.dart';
import 'bookmark.dart';

void main() {
  runApp(const MyApp());
}

void navigateToMyPagePage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyPagePage()),
  );
}

void navigateToSearchResult(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SearchResult()),
  );
}

void navigateToBookMark(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BookMarkUI()),
  );
}

void navigateToMyApp(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
  );
}

void popCurrentScreen(BuildContext context) {
  Navigator.pop(context);
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
        body: BodyTotal(),
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
          onPressed: () => navigateToMyPagePage(context),
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

class BodyTotal extends StatelessWidget {
  const BodyTotal({super.key});

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

// class BottomBarTotal extends StatefulWidget {
//   const BottomBarTotal({super.key});
//
//   @override
//   State<BottomBarTotal> createState() => _BottomBarTotalState();
// }
//
// class _BottomBarTotalState extends State<BottomBarTotal> {
//   int _selectedIndex=1;
//
//   static final List<Widget> _widgetOptions = <Widget>[
//     BookMarkUI(),
//     MyApp(),
//     MyApp(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex=index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: <BottomNavigationBarItem>[
//
//         BottomNavigationBarItem(
//           icon: Image.asset(
//             'assets/bottom_icon_bookmark.png',
//             width: 30,
//             height: 30,
//           ),
//           label: '즐겨찾기',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(
//               Icons.circle_outlined,
//               size: 50,
//               color: Color(0xFF53DACA)
//           ),
//           label: '홈',
//         ),
//         BottomNavigationBarItem(
//           icon: Image.asset(
//             'assets/bottom_icon_mypage.png',
//             width: 30,
//             height: 30,
//           ),
//           label: '마이페이지',
//         ),
//       ],
//       currentIndex: _selectedIndex,
//       onTap: _onItemTapped,
//     );
//   }
// }

// class BottomBarTotal extends StatelessWidget {
//   BottomBarTotal({Key? key}) : super(key: key);
//
//   final List<BottomNavigationBarItem> _bottomBarItems = [
//     BottomNavigationBarItem(
//       icon: Image.asset('assets/bottom_icon_bookmark.png', width: 30, height: 30),
//       label: '즐겨찾기',
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(Icons.circle_outlined, size: 50, color: Color(0xFF53DACA)),
//       label: '홈',
//     ),
//     BottomNavigationBarItem(
//       icon: Image.asset('assets/bottom_icon_mypage.png', width: 30, height: 30),
//       label: '마이페이지',
//     ),
//   ];
//
//   void _onItemTapped(BuildContext context, int index) {
//     switch (index) {
//       case 0:
//         navigateToBookMark(context);
//         break;
//       case 1:
//         navigateToMyApp(context);
//         break;
//       case 2:
//         navigateToMyPagePage(context);
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: _bottomBarItems,
//       onTap: (index) => _onItemTapped(context, index),
//     );
//   }
// }

class BottomBarTotal extends StatefulWidget {
  const BottomBarTotal({Key? key}) : super(key: key);

  @override
  _BottomBarTotalState createState() => _BottomBarTotalState();
}

class _BottomBarTotalState extends State<BottomBarTotal> {
  int _selectedIndex = 1; // 기본 선택 인덱스를 홈으로 설정

  void _onItemTapped(BuildContext context, int index) {
    // 현재 선택된 인덱스와 같은 인덱스를 탭하면 아무 것도 하지 않음
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        navigateToBookMark(context);
        break;
      case 1:
        navigateToMyApp(context);
        break;
      case 2:
        navigateToMyPagePage(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/bottom_icon_bookmark.png', width: 30, height: 30),
          label: '즐겨찾기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle_outlined, size: 50, color: Color(0xFF53DACA)),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/bottom_icon_mypage.png', width: 30, height: 30),
          label: '마이페이지',
        ),
      ],
    );
  }
}

// class BottomBarTotal extends StatefulWidget {
//   const BottomBarTotal({Key? key}) : super(key: key);
//
//   @override
//   _BottomBarTotalState createState() => _BottomBarTotalState();
// }
//
// class _BottomBarTotalState extends State<BottomBarTotal> {
//   int _selectedIndex = 1; // 기본 선택 인덱스를 홈으로 설정
//
//   static const List<Widget> _widgetOptions = <Widget>[
//     BookMarkUI(),
//     MyApp(),
//     MyPage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bookmark),
//             label: '즐겨찾기',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '홈',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: '마이페이지',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

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