import 'package:flutter/material.dart';
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
  String? emailCode; // 인증번호
  Timer? startTimer; // 타이머 선언
  final TextEditingController _dateOfBirthController = TextEditingController();
  bool _timerStarted = false; // 타이머 시작 여부
  final int _minutes = 5;
  final int _seconds = 0;
  bool privacyPolicyAccepted = false; // 개인정보 처리방침 동의 여부 필수체크
  bool emailSubscriptionAccepted = false; // 광고성이메일 수신 동의 여부 선택체크

  final AuthService authService = AuthService();  // AuthService 객체 생성

  @override
  void dispose() {
    startTimer?.cancel();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  // 공통 다이얼로그 함수
  void showCustomDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.softTeal, // 버튼 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '확인',
                style: TextStyle(
                  color: AppColors.deepTeal, // 글씨 색상
                  fontWeight: FontWeight.bold, // 글씨 bold
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 인증번호 전송 버튼 클릭 시 수행되는 함수
  void onSendVerificationButtonClicked() async {
    try {
      await authService.mailSend(email);
      setState(() {
        buttonLabel = '인증번호 확인';
        _timerStarted = true;
      });
      showCustomDialog(context, '인증번호 전송 완료', '이메일로 인증번호가 전송되었습니다.');
    } catch (e) {
      showCustomDialog(context, '인증번호 전송 실패', '메일 전송에 실패했습니다. 다시 시도해주세요.');
    }
  }

  void onVerificationButtonClicked() async {
    try {
      bool isVerified = await authService.mailCheck(email, emailCode!);
      if (isVerified) {
        showCustomDialog(context, '인증 성공', '이메일 인증이 성공적으로 완료되었습니다.');
      } else {
        showCustomDialog(context, '인증 실패', '인증번호가 올바르지 않습니다.');
      }
    } catch (e) {
      showCustomDialog(context, '인증 실패', e.toString());
    }
  }

  // 성별 선택 시 수행되는 함수
  void onGenderChanged(String? value) {
    setState(() {
      gender = value ?? ''; // 선택된 성별을 저장
    });
  }

  void onSignupButtonClicked() async {
    if (name.isEmpty || email.isEmpty || gender.isEmpty || dateOfBirth == null || _password == null || emailCode == null || !privacyPolicyAccepted) {
      // 필수 입력 항목이 채워지지 않았을 때 모달
      showCustomDialog(context, '회원가입 실패', '모든 필수 입력란을 채워주시고, 개인정보 처리방침에 동의해주세요.');
    } else {
      try {
        // 이메일 인증 번호 확인
        bool isVerified = await authService.mailCheck(email, emailCode!);
        if (!isVerified) {
          // 인증번호가 맞지 않으면 모달 띄우기
          showCustomDialog(context, '인증 실패', '인증번호가 올바르지 않습니다.');
        } else {
          // 모든 필수 입력란이 채워져 있으면 회원가입 진행
          await authService.signUp(
              name,
              dateOfBirth!.replaceAll('.', '-'),
              email,
              gender == '남자' ? 'MALE' : 'FEMALE',
              _password!,
              emailSubscriptionAccepted
          );
          // 회원가입 성공 모달
          showCustomDialog(context, '회원가입 완료', '회원가입이 성공적으로 완료되었습니다.');
        }
      } catch (e) {
        // 회원가입 오류 처리
        showCustomDialog(context, '회원가입 실패', '회원가입 중 오류가 발생했습니다. 다시 시도해주세요.');
      }
    }
  }

  void _onDateOfBirthChanged(String value) {
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
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
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
                    name = value;
                  });
                },
              ),
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
                        color: AppColors.gr600,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: AppColors.gr600,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: AppColors.gr600,
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
                            height: 50,
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
                            height: 50,
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
                          email = value;
                        });
                      },
                    ),
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
                    ),
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
                          emailCode = value;
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
                        try {
                          await authService.mailCheck(email, emailCode!);
                          showCustomDialog(context, '이메일 인증 완료', '이메일 인증이 완료되었습니다.');
                        } catch (error) {
                          showCustomDialog(context, '인증 실패', '인증번호가 올바르지 않습니다.');
                        }
                      },
                    ),
                  ),
                ],
              ),
              Gaps.h20,
              PasswordFieldsContainer(
                onPasswordChanged: (password) {
                  setState(() {
                    _password = password;
                  });
                },
              ),
              Gaps.h20,
              LabeledCheckboxExample(
                label: '개인정보 처리방침에 동의합니다.',
                value: privacyPolicyAccepted,
                onChanged: (bool newValue) {
                  setState(() {
                    privacyPolicyAccepted = newValue;
                  });
                },
              ),
              LabeledCheckboxExample(
                label: '이메일 수신에 동의합니다.',
                value: emailSubscriptionAccepted,
                onChanged: (bool newValue) {
                  setState(() {
                    emailSubscriptionAccepted = newValue;
                  });
                },
              ),
              Gaps.h32,
              ElevatedButton(
                onPressed: () async {
                  onSignupButtonClicked();
                  final String? Birth = dateOfBirth?.replaceAll('.', '-');
                  if (gender == "남자") {
                    await authService.signUp(
                        name, Birth!, email, "male", _password!, true);
                  } else {
                    await authService.signUp(
                        name, Birth!, email, "female", _password!, true);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.deepTeal),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 30.0)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '회원가입',
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
          padding: EdgeInsets.only(top: 0.0),
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
                      color: AppColors.gr600,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: AppColors.gr600,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: AppColors.gr600,
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
                    color: AppColors.gr600),
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
  final Function(String) onPasswordChanged;

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
            widget.onPasswordChanged(value);
          },
        ),
        Gaps.h40,
        PasswordCheckTextBox(
          onConfirmPasswordChanged: (value) {
            _confirmPassword = value;
            _passwordsMatch = _password == _confirmPassword;
            if (_passwordsMatch) {
              widget.onPasswordChanged(_password);
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
            letterSpacing: 1.5,
          ),
          onChanged: onPasswordChanged,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
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
            letterSpacing: 1.5,
          ),
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
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
              _isDefaultText = value.isEmpty;
            });
            widget.onChanged(value);
          },
          onTap: () {
            if (_isDefaultText) {
              _controller.clear();
            }
          },
          style: TextStyle(
            color: _isDefaultText ? Colors.grey : Colors.black,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            hintText: _isDefaultText ? 'promise@gmail.com' : null,
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5),
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
              _isDefaultText = value.isEmpty;
            });
            widget.onChanged(value);
          },
          onTap: () {
            if (_isDefaultText) {
              _controller.clear();
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
                color: AppColors.gr600,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(
                color: AppColors.gr600,
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            labelText: _isDefaultText ? null : '',
            hintText: _isDefaultText ? '홍길동' : null,
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
      padding: EdgeInsets.only(top: 18.0),
      child: SizedBox(
        height: 48.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.softTeal),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: Text(
            '인증번호 확인',
            style: AppTextStyles.body5M14.copyWith(color: AppColors.deepTeal),
          ),
        ),
      ),
    );
  }
}

class SendVerificationButton extends StatelessWidget {
  final String email;
  final VoidCallback onPressed;

  const SendVerificationButton({
    super.key,
    required this.email,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: SizedBox(
            height: 48.0,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.softTeal),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: Text(
                '인증번호 전송',
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
