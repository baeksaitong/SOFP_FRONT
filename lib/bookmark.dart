import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';

import 'main.dart';

class BookMarkUI extends StatelessWidget {
  const BookMarkUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => popCurrentScreen(context),
              icon: Icon(
                  Icons.arrow_back,
              ),
            ),
            Gaps.w12,
            Text(
                '즐겨찾기',
              style: TextStyle(
                color: Color(0xffd9d9d9),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        thickness: 4.0,
        radius: Radius.circular(8.0),
        child: ListView(
          children: const <Widget>[
            BoomarkItem(),
            BoomarkItem(),
            BoomarkItem(),
            BoomarkItem(),
            BoomarkItem(),
            BoomarkItem(),
            BoomarkItem(),
            BoomarkItem(),
            BoomarkItem(),
          ],
        ),
      ),
    );
  }
}

class BoomarkItem extends StatefulWidget {
  const BoomarkItem({super.key});

  @override
  State<BoomarkItem> createState() => _BoomarkItemState();
}

class _BoomarkItemState extends State<BoomarkItem> {
  @override
  Widget build(BuildContext context) {
    return  Flexible(
      child: Container(
        color: Color(0xffF0F0F0),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
        padding: EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 16),
        child: Stack(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/pill.png',
                  width: 72,
                  height: 72,
                ),
                SizedBox(width: 16), // 간격 조정
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('제품명 : '),
                      SizedBox(height: 2), // 간격 조정
                      Text('약효분류 : '),
                      SizedBox(height: 2), // 간격 조정
                      Text('효능 : '),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: ToggleIconButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleIconButton extends StatefulWidget {
  const ToggleIconButton({super.key});

  @override
  _ToggleIconButtonState createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ToggleIconButton> {
  Color iconColor = Color(0xffB0B0B0);

  void _toggleIconColor() {
    setState(() {
      if (iconColor == Color(0xffB0B0B0)) {
        iconColor = Colors.yellow;
      } else {
        iconColor = Color(0xffB0B0B0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleIconColor,
      icon: Icon(
        Icons.star,
        color: iconColor,
      ),
    );
  }
}