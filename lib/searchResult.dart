import 'package:flutter/material.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'First App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SearchResult(),
//     );
//   }
// }

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 330,
              height: 48,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 3, color: Color(0xFF53DACA)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: 310,
                      height: 98,
                      decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
                    ),
                  ],
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 123, 50, 50)),
                  ),
                ),
                Positioned(
                  left: 106,
                  top: 12,
                  child: Text('제품명 :'),
                ),
                Positioned(
                  left: 106,
                  top: 32,
                  child: Text('약효분류 :'),
                ),
                Positioned(
                  left: 106,
                  top: 52,
                  child: Text('효능 :'),
                ),
                Positioned(
                  right: 15,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPressed = !_isPressed;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isPressed ? Colors.yellow : Colors.transparent,
                      ),
                      child: Image.asset(
                        'assets/free-icon-star-5708819.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
