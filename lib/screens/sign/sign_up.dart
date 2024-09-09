import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:sopf_front/constans/gaps.dart';
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:flutter/services.dart';
import 'package:sopf_front/services/services_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = ''; // 이름
  String email = ''; // 이메일
  String gender = ''; // 성별을 저장하는 변수
  String buttonLabel = '인증번호 전송'; // 버튼 레이블 초기값 설정
  String? dateOfBirth; // 생년월일
  String? _password; // 비밀번호
  String? _confirmPassword; // 비밀번호 확인
  String? emailCode; // 인증번호
  bool _isEmailVerified = false; // 이메일 인증 완료 여부
  Timer? startTimer; // 타이머 선언
  final TextEditingController _dateOfBirthController = TextEditingController();
  bool _timerStarted = false; // 타이머 시작 여부
  final int _minutes = 5;
  final int _seconds = 0;
  bool privacyPolicyAccepted = false; // 개인정보 처리방침 동의 여부 필수체크
  bool emailSubscriptionAccepted = false; // 광고성이메일 수신 동의 여부 선택체크
  final AuthService authService = AuthService();

  @override
  void dispose() {
    startTimer?.cancel();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  // 인증번호 전송 버튼 클릭 시 수행되는 함수
  void onSendVerificationButtonClicked() {
    if (!_timerStarted) {
      setState(() {
        buttonLabel = '인증번호 확인';
        _timerStarted = true;
      });
    }
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
        dateOfBirth == null ||
        _password == null ||
        emailCode == null ||
        !privacyPolicyAccepted) { // 개인정보 처리방침 동의 확인
      // 필수 입력란 중 하나라도 비어 있으면 토스트 메시지 출력
      Fluttertoast.showToast(
        msg: '모든 필수 입력란을 채워주세요.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // 비밀번호와 비밀번호 확인이 일치하는지 확인
    if (_password != _confirmPassword) {
      Fluttertoast.showToast(
        msg: '비밀번호가 일치하지 않습니다.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // 이메일 인증이 완료되었는지 확인 (emailCode를 확인)
    if (!_isEmailVerified) {
      Fluttertoast.showToast(
        msg: '이메일 인증을 완료해주세요.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // 모든 필수 입력란이 채워져 있고, 비밀번호가 일치하며, 이메일 인증이 완료된 경우 회원가입 진행
    print('회원가입 정보:');
    print('이름: $name');
    print('생년월일: $dateOfBirth');
    print('성별: $gender');
    print('이메일: $email');
    print('비밀번호: $_password');

    // 회원가입 로직을 여기에 추가
    Fluttertoast.showToast(
      msg: '회원가입이 완료되었습니다.',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void _onDateOfBirthChanged(String value) {
    // 점을 추가하는 로직
    final newValue = value.replaceAll('.', '');
    if (newValue.length > 8) return;

    String formattedValue = '';
    if (newValue.length == 8) {
      formattedValue =
      '${newValue.substring(0, 4)}.${newValue.substring(4, 6)}.${newValue.substring(6, 8)}';
    } else {
      formattedValue = newValue;
    }

    _dateOfBirthController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );

    setState(() {
      dateOfBirth = formattedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // 왼쪽 버튼이 클릭되었을 때 수행될 동작
            print('왼쪽 버튼이 클릭되었습니다.');
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios), // 버튼에 아이콘 추가
        ),
        title: SizedBox(
          width: double.infinity,
          child: Text(
            '회원가입',
            textAlign: TextAlign.center,
            style: AppTextStyles.body1S16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Gaps.h40,
              NameTextBox(
                onChanged: (value) {
                  setState(() {
                    name = value; // 이름 값 업데이트
                  });
                },
              ), // 이름 입력란
              Gaps.h20,
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '생년월일',
                    style: AppTextStyles.body5M14,
                  ),
                ),
              ),
              SizedBox(
                height: 55,
                child: TextField(
                  controller: _dateOfBirthController,
                  onChanged: _onDateOfBirthChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  cursorColor: AppColors.gr600,
                  decoration: InputDecoration(
                    hintText: '8자리 생년월일을 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: AppColors.gr600, // The color of the border
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: AppColors
                            .gr600, // The color of the border when enabled
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: AppColors
                            .gr600, // The color of the border when focused
                      ),
                    ),
                    hintStyle: TextStyle(color: AppColors.gr500),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              Gaps.h20,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('성별', style: AppTextStyles.body5M14),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50, // Adjust the height as needed
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  gender = '남자';
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: gender == '남자'
                                    ? AppColors.softTeal
                                    : Colors.white,
                                side: BorderSide(
                                  color: gender == '남자'
                                      ? AppColors.deepTeal
                                      : Colors.grey,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                '남성',
                                style: TextStyle(
                                  color: gender == '남자'
                                      ? AppColors.deepTeal
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 50, // Adjust the height as needed
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  gender = '여자';
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: gender == '여자'
                                    ? AppColors.softTeal
                                    : Colors.white,
                                side: BorderSide(
                                  color: gender == '여자'
                                      ? AppColors.deepTeal
                                      : Colors.grey,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                '여성',
                                style: TextStyle(
                                  color: gender == '여자'
                                      ? AppColors.deepTeal
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              Gaps.h20,
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: EmailTextBox(
                      onChanged: (value) {
                        setState(() {
                          email = value; // 이메일 값 업데이트
                        });
                      },
                    ), // 이메일 입력란
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: SendVerificationButton(
                      email: email,
                      onPressed: () async {
                        onSendVerificationButtonClicked();
                        await authService.idCheck(email);
                      },
                    ), // 인증번호 전송 버튼
                  ),
                ],
              ),

              Gaps.h20,
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Verification(
                      onChanged: (value) {
                        setState(() {
                          emailCode = value; // 인증번호 업데이트
                        });
                      },
                      minutes: _minutes,
                      seconds: _seconds,
                      timerStarted: _timerStarted,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: VerificationButton(
                      onPressed: () async {
                        // 인증번호 확인 로직 구현
                        print('인증번호 확인 버튼이 클릭되었습니다.');
                        await authService.mailCheck(email, emailCode!);

                        // 인증이 성공했다고 가정하고 성공 메시지 출력 (메서드 내부에서 성공 여부를 관리)
                        setState(() {
                          _isEmailVerified = true; // 이메일 인증 완료
                        });

                        Fluttertoast.showToast(
                          msg: '이메일 인증이 완료되었습니다.',
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      },
                    ),
                  ),


                ],
              ),

              Gaps.h20,
              PasswordFieldsContainer(
                onPasswordChanged: (password) {
                  setState(() {
                    _password = password; // 비밀번호 상태 업데이트
                  });
                },
              ), // 비밀번호 입력란
              Gaps.h20,
              LabeledCheckboxExample(
                label: '개인정보 처리방침에 동의합니다.',
                value: privacyPolicyAccepted,
                onChanged: (bool newValue) {
                  setState(() {
                    privacyPolicyAccepted = newValue;
                  });
                },
              ), // 개인정보 처리방침 동의 체크박스
              LabeledCheckboxExample(
                label: '이메일 수신에 동의합니다.',
                value: emailSubscriptionAccepted,
                onChanged: (bool newValue) {
                  setState(() {
                    emailSubscriptionAccepted = newValue;
                  });
                },
              ), // 이메일 수신 동의 체크박스
              Gaps.h32,
              ElevatedButton(
                onPressed: () async {
                  onSignupButtonClicked();
                  print('회원가입 버튼 클릭');
                  final String? Birth = dateOfBirth?.replaceAll('.', '-');
                  print(Birth);
                  if (gender == "남자") {
                    await authService.signUp(
                        name, Birth!, email, "male", _password!, true);
                  } else {
                    await authService.signUp(
                        name, Birth!, email, "female", _password!, true);
                  }
                }, // 회원가입 버튼 클릭 시 함수 실행
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.deepTeal), // 배경색 설정
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
                      style:
                      AppTextStyles.body5M14.copyWith(color: AppColors.wh),
                    ),
                  ),
                ),
              ),
              Gaps.h40,
            ],
          ),
        ),
      ),
    );
  }
}

class Verification extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final int minutes;
  final int seconds;
  final bool timerStarted;

  const Verification({
    super.key,
    required this.onChanged,
    required this.minutes,
    required this.seconds,
    required this.timerStarted,
  });

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _minutes = widget.minutes;
    _seconds = widget.seconds;
    if (widget.timerStarted) {
      startTimer();
    }
  }

  @override
  void didUpdateWidget(Verification oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timerStarted && !oldWidget.timerStarted) {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '인증번호',
          style: AppTextStyles.body5M14,
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.0), // 위쪽에 0.0의 패딩 추가
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                cursorColor: AppColors.gr600,
                controller: _controller,
                onChanged: (value) {
                  widget.onChanged(value);
                },
                style: TextStyle(
                  letterSpacing: 1.5,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: AppColors.gr600, // The color of the border
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: AppColors
                          .gr600, // The color of the border when enabled
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: AppColors
                          .gr600, // The color of the border when focused
                    ),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                ),
              ),
              Positioned(
                right: 10,
                child: Text(
                  '$_minutes:${_seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepTeal,
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

class LabeledCheckboxExample extends StatelessWidget {
  const LabeledCheckboxExample({
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
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body5M14.copyWith(
                    color: AppColors.gr600), // Apply the new text style
              ),
            ),
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
            setState(() {
              _password = value;
              _passwordsMatch = _password == _confirmPassword;
            });
            widget.onPasswordChanged(value); // 부모 위젯에 비밀번호 전달
          },
        ),
        Gaps.h40,
        PasswordCheckTextBox(
          onConfirmPasswordChanged: (value) {
            setState(() {
              _confirmPassword = value;
              _passwordsMatch = _password == _confirmPassword;
            });
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호',
          style: AppTextStyles.body5M14,
        ),
        TextField(
          cursorColor: AppColors.gr600,
          style: TextStyle(
            letterSpacing: 1.5, // 글자 간격 조절
          ),
          onChanged: onPasswordChanged,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when enabled
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when focused
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
          ),
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호 확인',
          style: AppTextStyles.body5M14,
        ),
        TextField(
          cursorColor: AppColors.gr600,
          onChanged: onConfirmPasswordChanged,
          style: TextStyle(
            letterSpacing: 1.5, // 글자 간격 조절
          ),
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when enabled
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when focused
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            errorText: passwordsMatch ? null : '비밀번호가 일치하지 않습니다',
          ),
        ),
      ],
    );
  }
}

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
          style: AppTextStyles.body5M14,
        ),
        TextField(
          cursorColor: AppColors.gr600,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when enabled
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when focused
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
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
          style: AppTextStyles.body5M14,
        ),
        TextField(
          cursorColor: AppColors.gr600,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when enabled
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600, // The color of the border when focused
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            labelText: _isDefaultText ? null : '', // 기본 텍스트는 라벨로 표시하지 않음
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
            MaterialStateProperty.all<Color>(AppColors.softTeal), // 배경색 설정
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // 모서리를 둥근 사각형으로 설정
              ),
            ),
          ),
          child: Text(
            '인증번호 확인', // 버튼 텍스트 설정
            style: AppTextStyles.body5M14.copyWith(color: AppColors.deepTeal),
          ),
        ),
      ),
    );
  }
}

class SendVerificationButton extends StatelessWidget {
  final String email; // 이메일 프로퍼티 추가
  final VoidCallback onPressed; // onPressed 콜백 추가

  const SendVerificationButton({
    super.key,
    required this.email,
    required this.onPressed, // onPressed 콜백 받기
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 18.0), // 버튼 위쪽에 10.0의 패딩 추가
          child: SizedBox(
            height: 48.0, // 버튼의 위아래 크기를 텍스트 박스와 동일하게 설정
            child: ElevatedButton(
              onPressed: onPressed, // onPressed 콜백 사용
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.softTeal), // 배경색 설정
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10.0), // 모서리를 둥근 사각형으로 설정
                  ),
                ),
              ),
              child: Text(
                '인증번호 전송', // 버튼 텍스트 설정
                style:
                AppTextStyles.body5M14.copyWith(color: AppColors.deepTeal),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
