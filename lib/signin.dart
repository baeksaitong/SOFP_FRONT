import 'package:flutter/material.dart';
import 'package:sofp_front/gaps.dart';

const List<String> yearDropDownList = <String>['2000', '2001', '2002', '2003'];

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: const [
                Gaps.h40,
                Center(
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Gaps.h40,
                    nameTextBox(),
                    Gaps.h40,
                    Row(
                      children: [
                        // Checkbox(value: , onChanged: (value))
                      ],
                    ),
                    emailTextBox(),
                    Gaps.h40,
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '인증번호',
                      ),
                    ),
                    Gaps.h40,
                    passworldTextBox(),
                    Gaps.h40,
                    passWorldCheckTextBox(),
                    Gaps.h40,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "CheckBox",
//       home: agreeCheckBox(),
//     );
//   }
// }

// class agreeCheckBox extends StatefulWidget {
//   const agreeCheckBox({Key? key}) : super(key: key);

//   @override
//   _agreeCheckBoxState createState() => _agreeCheckBoxState();
// }

// class _agreeCheckBoxState extends State<agreeCheckBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class passWorldCheckTextBox extends StatelessWidget {
  const passWorldCheckTextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호 확인',
      ),
    );
  }
}

class passworldTextBox extends StatelessWidget {
  const passworldTextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호',
      ),
    );
  }
}

class emailTextBox extends StatelessWidget {
  const emailTextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이메일',
      ),
    );
  }
}

class nameTextBox extends StatelessWidget {
  const nameTextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이름',
      ),
    );
  }
}
