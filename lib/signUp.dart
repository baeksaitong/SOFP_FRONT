import 'package:flutter/material.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/appColors.dart';
import 'package:sopf_front/appTextStyles.dart';
import 'package:sopf_front/exColorsText.dart';
import 'package:sopf_front/gaps.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MaterialApp(
    title: 'First App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SignUpPage(),
  ));
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String name = ''; // 이름
  String email = ''; // 이메일
  String gender = ''; // 성별을 저장하는 변수
  String buttonLabel = '인증번호 전송'; // 버튼 레이블 초기값 설정
  String? selectedYear; // 선택된 년도
  String? selectedMonth; // 선택된 월
  String? selectedDay; // 선택된 일
  String? _password; //비밀번호
  String? emailCode; //인증번호
  late Timer startTimer; // 타이머 선언

  // 인증번호 전송 버튼 클릭 시 수행되는 함수
  void onSendVerificationButtonClicked() {
    setState(() {
      buttonLabel = '인증번호 확인';
    });
  }

  // 성별 선택 시 수행되는 함수
  void onGenderChanged(String? value) {
    setState(() {
      gender = value ?? ''; // 선택된 성별을 저장
    });
  }

  void onSignupButtonClicked() {
    // 필수 입력란이 모두 채워져 있는지 확인
    if (name.isEmpty ||
        email.isEmpty ||
        gender.isEmpty ||
        selectedYear == null ||
        selectedMonth == null ||
        selectedDay == null ||
        _password == null ||
        emailCode == null) {
      // 필수 입력란 중 하나라도 비어 있으면 토스트 메시지 출력
      Fluttertoast.showToast(
        msg: '모든 필수 입력란을 채워주세요.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      // 모든 필수 입력란이 채워져 있으면 회원가입 정보 출력
      print('회원가입 정보:');
      print('이름: $name');
      print('생년월일: $selectedYear년 $selectedMonth월 $selectedDay일');
      print('성별: $gender');
      print('이메일: $email');
      print('비밀번호: $_password');

      // 여기에 실제 회원가입 로직을 추가할 수 있습니다.

      // 회원가입 완료 메시지 출력
      Fluttertoast.showToast(
        msg: '회원가입이 완료되었습니다.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // 왼쪽 버튼이 클릭되었을 때 수행될 동작
            print('왼쪽 버튼이 클릭되었습니다.');
          },
          icon: Icon(Icons.arrow_back_ios), // 버튼에 아이콘 추가
        ),
        title: SizedBox(
          width: double.infinity,
          child: Text(
            '회원가입',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Gaps.h40, // 공간 추가
              NameTextBox(
                onChanged: (value) {
                  setState(() {
                    name = value; // 이름 값 업데이트
                  });
                },
              ), // 이름 입력란
              Gaps.h20, // 공간 추가
              DateOfBirthDropdown(
                // 생년월일 드롭다운
                selectedYear: selectedYear,
                selectedMonth: selectedMonth,
                selectedDay: selectedDay,
                onYearChanged: (value) {
                  setState(() {
                    selectedYear = value; // 선택된 년도 값 업데이트
                  });
                },
                onMonthChanged: (value) {
                  setState(() {
                    selectedMonth = value; // 선택된 월 값 업데이트
                  });
                },
                onDayChanged: (value) {
                  setState(() {
                    selectedDay = value; // 선택된 일 값 업데이트
                  });
                },
              ),
              Gaps.h20, // 공간 추가
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('성별 선택: '), // 성별 선택 안내 문구
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
              Gaps.h20, // 공간 추가
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: EmailTextBox(
                      onChanged: (value) {
                        setState(() {
                          email = value; // 이메일 값 업데이트
                        });
                      },
                    ), // 이메일 입력란
                  ),
                  SizedBox(width: 16), // 간격 추가
                  Expanded(
                    flex: 1,
                    child: SendVerificationButton(email: email), // 인증번호 전송 버튼
                  ),
                ],
              ),
              Gaps.h20, // 공간 추가
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Verification(
                      onChanged: (value) {
                        setState(() {
                          emailCode = value; // 인증번호 업데이트
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: VerificationButton(
                      onPressed: () async {
                        // 인증번호 확인 로직 구현
                        print('인증번호 확인 버튼이 클릭되었습니다.');
                        //await mailTokenCheck(email, code);
                      },
                    ),
                  ),
                ],
              ), // 인증번호 확인 버튼

              Gaps.h40, // 공간 추가
              PasswordFieldsContainer(
                onPasswordChanged: (password) {
                  setState(() {
                    _password = password; // 비밀번호 상태 업데이트
                  });
                },
              ), // 비밀번호 입력란
              Gaps.h32, // 공간 추가
              LabeledCheckboxExample(), // 이용약관 동의 체크박스
              LabeledCheckboxExample(), // 개인정보 처리방침 동의 체크박스
              LabeledCheckboxExample(), // 이메일 수신 동의 체크박스
              Gaps.h32, // 공간 추가
              ElevatedButton(
                onPressed: () async {
                  //await signUp(name, selectedYear!, selectedMonth!,
                  //    selectedDay!, email, gender, _password!, true);
                }, // 회원가입 버튼 클릭 시 함수 실행
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF00AD98)), // 배경색 설정
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // 모서리를 둥근 사각형으로 설정
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 30.0)), // 패딩값 설정
                ),
                child: SizedBox(
                  width: double.infinity, // 가로폭을 최대한으로 설정
                  child: Center(
                    child: Text(
                      '회원가입', // 회원가입 버튼 텍스트
                      style: TextStyle(
                        color: Color(0xFFFFFFFF), // 글씨색 설정
                      ),
                    ),
                  ),
                ),
              ),

              Gaps.h40, // 공간 추가
            ],
          ),
        ),
      ),
    );
  }
}

class Verification extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const Verification({super.key, required this.onChanged});

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  int _minutes = 5;
  int _seconds = 0;
  final bool _timerStarted = false; // 타이머 시작 여부를 나타내는 변수

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '인증번호',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 18.0), // 위쪽에 18.0의 패딩 추가
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                controller: _controller,
                onChanged: (value) {
                  widget.onChanged(value);
                },
                style: TextStyle(
                  letterSpacing: 1.5,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                  border: OutlineInputBorder(),
                ),
              ),
              Positioned(
                right: 10,
                child: Text(
                  '$_minutes:${_seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00AD98),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            _timer.cancel();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
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
  final Function(String) onPasswordChanged; // 비밀번호 변경 핸들러 추가

  const PasswordFieldsContainer({super.key, required this.onPasswordChanged});

  @override
  _PasswordFieldsContainerState createState() =>
      _PasswordFieldsContainerState();
}

class _PasswordFieldsContainerState extends State<PasswordFieldsContainer> {
  String _password = '';
  String _confirmPassword = '';
  bool _passwordsMatch = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordTextBox(
          onPasswordChanged: (value) {
            _password = value;
            widget.onPasswordChanged(value); // 부모 위젯에 비밀번호 전달
          },
        ),
        Gaps.h40,
        PasswordCheckTextBox(
          onConfirmPasswordChanged: (value) {
            _confirmPassword = value;
            _passwordsMatch = _password == _confirmPassword;
            if (_passwordsMatch) {
              widget.onPasswordChanged(_password); // 비밀번호 확인이 일치하면 업데이트
            }
          },
          passwordsMatch: _passwordsMatch,
        ),
      ],
    );
  }
}

class PasswordTextBox extends StatelessWidget {
  final ValueChanged<String> onPasswordChanged;

  const PasswordTextBox({super.key, required this.onPasswordChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        letterSpacing: 1.5, // 글자 간격 조절
      ),
      onChanged: onPasswordChanged,
      obscureText: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
        border: OutlineInputBorder(),
        labelText: '비밀번호',
      ),
    );
  }
}

class PasswordCheckTextBox extends StatelessWidget {
  final ValueChanged<String> onConfirmPasswordChanged;
  final bool passwordsMatch;

  const PasswordCheckTextBox({
    super.key,
    required this.onConfirmPasswordChanged,
    required this.passwordsMatch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onConfirmPasswordChanged,
      style: TextStyle(
        letterSpacing: 1.5, // 글자 간격 조절
      ),
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
        border: OutlineInputBorder(),
        labelText: '비밀번호 확인',
        errorText: passwordsMatch ? null : '비밀번호가 일치하지 않습니다',
      ),
    );
  }
}

// 이메일 텍스트박스

class EmailTextBox extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const EmailTextBox({super.key, required this.onChanged});

  @override
  _EmailTextBoxState createState() => _EmailTextBoxState();
}

class _EmailTextBoxState extends State<EmailTextBox> {
  final TextEditingController _controller =
      TextEditingController(text: 'promise@gmail.com');

  bool _isDefaultText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이메일',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _isDefaultText = value.isEmpty; // 입력값이 없으면 기본 텍스트 표시
            });
            widget.onChanged(value);
          },
          onTap: () {
            if (_isDefaultText) {
              _controller.clear(); // 텍스트 박스 클릭 시 기본 텍스트 지우기
            }
          },
          style: TextStyle(
            color:
                _isDefaultText ? Colors.grey : Colors.black, // 기본 텍스트는 회색으로 표시
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            border: OutlineInputBorder(),
            labelText: _isDefaultText ? null : '이메일', // 기본 텍스트는 라벨로 표시하지 않음
            hintText:
                _isDefaultText ? 'promise@gmail.com' : null, // 기본 텍스트는 힌트로 표시
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5), // 기본 텍스트는 불투명하게 표시
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

//이름 텍스트박스

class NameTextBox extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const NameTextBox({super.key, required this.onChanged});

  @override
  _NameTextBoxState createState() => _NameTextBoxState();
}

class _NameTextBoxState extends State<NameTextBox> {
  final TextEditingController _controller = TextEditingController(text: '홍길동');

  bool _isDefaultText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이름',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _isDefaultText = value.isEmpty; // 입력값이 없으면 기본 텍스트 표시
            });
            widget.onChanged(value);
          },
          onTap: () {
            if (_isDefaultText) {
              _controller.clear(); // 텍스트 박스 클릭 시 기본 텍스트 지우기
            }
          },
          style: TextStyle(
            letterSpacing: 3.5,
            color: _isDefaultText ? Colors.grey : Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            border: OutlineInputBorder(),
            labelText: _isDefaultText ? null : '이름', // 기본 텍스트는 라벨로 표시하지 않음
            hintText: _isDefaultText ? '홍길동' : null, // 기본 텍스트는 힌트로 표시
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class VerificationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const VerificationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.0), // 위쪽에 18.0의 패딩 추가
      child: SizedBox(
        height: 48.0, // 버튼의 위아래 크기를 텍스트 박스와 동일하게 설정
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFFE6F6F4)), // 배경색 설정
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // 모서리를 둥근 사각형으로 설정
              ),
            ),
          ),
          child: Text(
            '인증번호 확인', // 버튼 텍스트 설정
            style: TextStyle(
              color: Color(0xFF00574B), // 글씨색 설정
            ),
          ),
        ),
      ),
    );
  }
}

class SendVerificationButton extends StatelessWidget {
  final String email; // 이메일 프로퍼티 추가

  const SendVerificationButton(
      {super.key, required this.email}); // 생성자에서 이메일을 받도록 수정

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 18.0), // 버튼 위쪽에 10.0의 패딩 추가
          child: SizedBox(
            height: 48.0, // 버튼의 위아래 크기를 텍스트 박스와 동일하게 설정
            child: ElevatedButton(
              onPressed: () async {
                // 인증번호 전송 로직 구현
                print('인증번호 전송 버튼이 클릭되었습니다.');
                //await mailTokenSend(email);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFFE6F6F4)), // 배경색 설정
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // 모서리를 둥근 사각형으로 설정
                  ),
                ),
              ),
              child: Text(
                '인증번호 전송', // 버튼 텍스트 설정
                style: TextStyle(
                  color: Color(0xFF00574B), // 글씨색 설정
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class CheckIDButton extends StatelessWidget {
//   final String email; // 이메일 프로퍼티 추가

//   const CheckIDButton({super.key, required this.email}); // 생성자에서 이메일을 받도록 수정

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         ElevatedButton(
//           onPressed: () async {
//             // 로그인 접근 함수를 비동기로 호출, 이메일을 사용
//             await idCheck(email);
//           },
//           child: const Text('아이디 중복 검사'), // 버튼 텍스트 설정
//         ),
//       ],
//     );
//   }
// }

class DateOfBirthDropdown extends StatefulWidget {
  const DateOfBirthDropdown({
    super.key,
    this.selectedYear,
    this.selectedMonth,
    this.selectedDay,
    required this.onYearChanged,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  final String? selectedYear;
  final String? selectedMonth;
  final String? selectedDay;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<String?> onDayChanged;

  @override
  _DateOfBirthDropdownState createState() => _DateOfBirthDropdownState();
}

class _DateOfBirthDropdownState extends State<DateOfBirthDropdown> {
  String? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;

  // 생년월일을 저장하는 변수
  String? dateOfBirth;

  final List<String> years = List.generate(
      100, (index) => (DateTime.now().year - 80 + index).toString());
  final List<String> months =
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> days =
      List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear;
    _selectedMonth = widget.selectedMonth;
    _selectedDay = widget.selectedDay;
  }

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
                    widget.onYearChanged(newValue); // 부모 위젯으로 선택된 연도 전달
                    updateDateOfBirth(); // 업데이트 함수 호출
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
                    widget.onMonthChanged(newValue); // 부모 위젯으로 선택된 월 전달
                    updateDateOfBirth(); // 업데이트 함수 호출
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
                    widget.onDayChanged(newValue); // 부모 위젯으로 선택된 일 전달
                    updateDateOfBirth(); // 업데이트 함수 호출
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

  // 생년월일을 업데이트하는 함수
  void updateDateOfBirth() {
    setState(() {
      if (_selectedYear != null &&
          _selectedMonth != null &&
          _selectedDay != null) {
        dateOfBirth = '$_selectedYear년 $_selectedMonth월 $_selectedDay일';
      } else {
        dateOfBirth = null;
      }
    });
  }
}
