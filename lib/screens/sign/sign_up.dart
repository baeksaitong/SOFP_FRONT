// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/constans/colors.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/widgets/common/custom_appbar.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '회원가입'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '이름',
                labelStyle: TextStyle(color: AppColors.gr400),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr800),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '이메일',
                labelStyle: TextStyle(color: AppColors.gr400),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr800),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                labelStyle: TextStyle(color: AppColors.gr400),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr400),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.gr800),
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
                        await apiClient.idCheck(email);
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
                        await apiClient.mailCheck(email, emailCode!);
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
                  print(name);
                  print(email);
                  print(_password);
                  if (gender == "남자") {
                    await apiClient.signUp(
                        name, Birth!, email, "male", _password!, true);
                  } else {
                    await apiClient.signUp(
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
              child: Text('회원가입', style: AppTextStyles.body1S16),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softTeal,
                foregroundColor: AppColors.deepTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
