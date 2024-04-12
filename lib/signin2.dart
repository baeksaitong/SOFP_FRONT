import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // 추가: 토스트 메시지를 위한 패키지
import 'package:sofp_front/gaps.dart';

void main() => runApp(SigninPage());

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String name = ''; // 이름
  String email = ''; // 이메일
  String gender = ''; // 성별을 저장하는 변수
  String buttonLabel = '인증번호 전송';

  void onSendVerificationButtonClicked() {
    setState(() {
      buttonLabel = '인증번호 확인';
    });
  }

  void onGenderChanged(String? value) {
    setState(() {
      gender = value ?? ''; // 선택된 성별을 저장
    });
  }

  void onSignupButtonClicked() {
    // 모든 필수 입력란이 채워졌는지 확인
    if (name.isEmpty || email.isEmpty || gender.isEmpty) {
      // 비어있는 필드가 있을 경우 토스트 메시지 표시
      Fluttertoast.showToast(
        msg: '모든 필수 입력란을 채워주세요.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      // 모든 필수 입력란이 채워져 있을 경우 회원가입 로직 실행
      // 여기에 회원가입 로직을 추가하면 됩니다.
      print('회원가입 완료');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
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
                Gaps.h40,
                NameTextBox(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ), // 이름
                Gaps.h20,
                DateOfBirthDropdown(),
                Gaps.h20,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('성별 선택: '),
                      Radio<String>(
                        value: '남자',
                        groupValue: gender,
                        onChanged: onGenderChanged,
                      ),
                      Text('남자'),
                      Radio<String>(
                        value: '여자',
                        groupValue: gender,
                        onChanged: onGenderChanged,
                      ),
                      Text('여자'),
                    ],
                  ),
                ),
                Gaps.h20,
                EmailTextBox(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ), // 이메일
                Gaps.h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    CheckIDButton(), // 아이디 중복 검사 버튼 추가
                    SendVerificationButton(),
                  ],
                ), // 인증번호 전송
                Gaps.h20,
                Verification(), // 인증번호
                Gaps.h20,
                VerificationButton(), // 인증번호 확인 버튼 추가
                Gaps.h20,
                PasswordFieldsContainer(),
                Gaps.h32,
                LabeledCheckboxExample(),
                LabeledCheckboxExample(),
                LabeledCheckboxExample(),
                Gaps.h32,
                // 추가: 회원가입 버튼
                ElevatedButton(
                  onPressed: onSignupButtonClicked,
                  child: Text('회원가입'),
                ),
                Gaps.h40,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Verification extends StatelessWidget {
  const Verification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0), // 위아래 패딩 설정
        border: OutlineInputBorder(),
        labelText: '   인증번호',
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledCheckboxExample extends StatefulWidget {
  const LabeledCheckboxExample({super.key});

  @override
  State<LabeledCheckboxExample> createState() => _LabeledCheckboxExampleState();
}

class _LabeledCheckboxExampleState extends State<LabeledCheckboxExample> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: '이용 약관에 동의합니다.',
      value: _isSelected,
      onChanged: (bool newValue) {
        setState(() {
          _isSelected = newValue;
        });
      },
    );
  }
}

class PasswordFieldsContainer extends StatefulWidget {
  const PasswordFieldsContainer({Key? key}) : super(key: key);

  @override
  _PasswordFieldsContainerState createState() =>
      _PasswordFieldsContainerState();
}

class _PasswordFieldsContainerState extends State<PasswordFieldsContainer> {
  String _password = '';
  String _confirmPassword = '';
  bool _passwordsMatch = true;

  void _updatePassword(String password) {
    setState(() {
      _password = password;
      _passwordsMatch = _password == _confirmPassword;
    });
  }

  void _updateConfirmPassword(String confirmPassword) {
    setState(() {
      _confirmPassword = confirmPassword;
      _passwordsMatch = _password == _confirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordTextBox(
          onPasswordChanged: _updatePassword,
        ),
        Gaps.h40,
        PasswordCheckTextBox(
          onConfirmPasswordChanged: _updateConfirmPassword,
          passwordsMatch: _passwordsMatch,
        ),
      ],
    );
  }
}

class PasswordTextBox extends StatelessWidget {
  final ValueChanged<String> onPasswordChanged;

  const PasswordTextBox({Key? key, required this.onPasswordChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onPasswordChanged,
      obscureText: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        border: OutlineInputBorder(),
        labelText: '   비밀번호',
      ),
    );
  }
}

class PasswordCheckTextBox extends StatelessWidget {
  final ValueChanged<String> onConfirmPasswordChanged;
  final bool passwordsMatch;

  const PasswordCheckTextBox({
    Key? key,
    required this.onConfirmPasswordChanged,
    required this.passwordsMatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onConfirmPasswordChanged,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0), // 위아래 패딩 설정
        border: OutlineInputBorder(),
        labelText: '   비밀번호 확인',
        errorText: passwordsMatch ? null : '비밀번호가 일치하지 않습니다',
      ),
    );
  }
}

class EmailTextBox extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EmailTextBox({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0), // 위아래 패딩 설정
        border: OutlineInputBorder(),
        labelText: '   이메일',
      ),
    );
  }
}

class NameTextBox extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const NameTextBox({Key? key, required this.onChanged}) : super(key: key);

  @override
  _NameTextBoxState createState() => _NameTextBoxState();
}

class _NameTextBoxState extends State<NameTextBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0), // 위아래 패딩 설정
        border: OutlineInputBorder(),
        labelText: '   이름',
      ),
    );
  }
}

class VerificationButton extends StatelessWidget {
  const VerificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
      children: [
        ElevatedButton(
          onPressed: () {
            // 인증번호 확인 로직 구현
            print('인증번호 확인 버튼이 클릭되었습니다.');
          },
          child: const Text('인증번호 확인'), // 버튼 텍스트 설정
        ),
      ],
    );
  }
}

class SendVerificationButton extends StatelessWidget {
  const SendVerificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            // 인증번호 전송 로직 구현
            print('인증번호 전송 버튼이 클릭되었습니다.');
          },
          child: const Text('인증번호 전송'), // 버튼 텍스트 설정
        ),
      ],
    );
  }
}

class CheckIDButton extends StatelessWidget {
  const CheckIDButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 여기에 아이디 중복 검사 로직을 구현할 수 있습니다.
    void checkID() {
      // 아이디 중복 검사 로직 추가
      print('아이디 중복 검사 버튼이 클릭되었습니다.');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: checkID,
          child: const Text('아이디 중복 검사'), // 버튼 텍스트 설정
        ),
      ],
    );
  }
}

class DateOfBirthDropdown extends StatefulWidget {
  const DateOfBirthDropdown({Key? key}) : super(key: key);

  @override
  _DateOfBirthDropdownState createState() => _DateOfBirthDropdownState();
}

class _DateOfBirthDropdownState extends State<DateOfBirthDropdown> {
  String? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;

  final List<String> years = List.generate(
      100, (index) => (DateTime.now().year - 80 + index).toString());
  final List<String> months =
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> days =
      List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('생년월일', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '년',
                  border: OutlineInputBorder(),
                ),
                value: _selectedYear,
                onChanged: (newValue) {
                  setState(() {
                    _selectedYear = newValue;
                  });
                },
                items: years
                    .map((year) => DropdownMenuItem<String>(
                          value: year,
                          child: SizedBox(
                            width: 70, // 버튼 너비 조절
                            child: Text(year),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '월',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMonth,
                onChanged: (newValue) {
                  setState(() {
                    _selectedMonth = newValue;
                  });
                },
                items: months
                    .map((month) => DropdownMenuItem<String>(
                          value: month,
                          child: SizedBox(
                            width: 50, // 버튼 너비 조절
                            child: Text(month),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '일',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDay,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDay = newValue;
                  });
                },
                items: days
                    .map((day) => DropdownMenuItem<String>(
                          value: day,
                          child: SizedBox(
                            width: 50, // 버튼 너비 조절
                            child: Text(day),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
