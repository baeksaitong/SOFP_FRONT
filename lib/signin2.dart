// import 'package:flutter/material.dart';
// import 'package:sofp_front/gaps.dart';
//
// void main() => runApp(SigninPage());
//
// class SigninPage extends StatelessWidget {
//   const SigninPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: const [
//                 Gaps.h40,
//                 Center(
//                   child: Text(
//                     '회원가입',
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 Gaps.h40,
//                 NameTextBox(), // 이름
//                 Gaps.h40,
//                 DateOfBirthDropdown(),
//                 Gaps.h40,
//                 EmailTextBox(), // 이메일
//                 Gaps.h10,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     CheckIDButton(), // 아이디 중복 검사 버튼 추가
//                     SendVerificationButton(),
//                   ],
//                 ), // 인증번호 전송
//                 Gaps.h20,
//                 Verification(), // 인증번호
//                 Gaps.h20,
//                 VerificationButton(), // 인증번호 확인 버튼 추가
//                 Gaps.h20,
//                 PasswordFieldsContainer(),
//                 Gaps.h40,
//                 LabeledCheckboxExample(),
//                 LabeledCheckboxExample(),
//                 LabeledCheckboxExample(),
//                 Gaps.h40,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Verification extends StatelessWidget {
//   const Verification({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: '인증번호',
//       ),
//     );
//   }
// }
//
// class LabeledCheckbox extends StatelessWidget {
//   const LabeledCheckbox({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.onChanged,
//   });
//
//   final String label;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         onChanged(!value);
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Row(
//           children: <Widget>[
//             Expanded(child: Text(label)),
//             Checkbox(
//               value: value,
//               onChanged: (bool? newValue) {
//                 onChanged(newValue!);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LabeledCheckboxExample extends StatefulWidget {
//   const LabeledCheckboxExample({super.key});
//
//   @override
//   State<LabeledCheckboxExample> createState() => _LabeledCheckboxExampleState();
// }
//
// class _LabeledCheckboxExampleState extends State<LabeledCheckboxExample> {
//   bool _isSelected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return LabeledCheckbox(
//       label: '이용 약관에 동의합니다.',
//       value: _isSelected,
//       onChanged: (bool newValue) {
//         setState(() {
//           _isSelected = newValue;
//         });
//       },
//     );
//   }
// }
//
// class PasswordFieldsContainer extends StatefulWidget {
//   const PasswordFieldsContainer({Key? key}) : super(key: key);
//
//   @override
//   _PasswordFieldsContainerState createState() =>
//       _PasswordFieldsContainerState();
// }
//
// class _PasswordFieldsContainerState extends State<PasswordFieldsContainer> {
//   String _password = '';
//   String _confirmPassword = '';
//   bool _passwordsMatch = true;
//
//   void _updatePassword(String password) {
//     setState(() {
//       _password = password;
//       _passwordsMatch = _password == _confirmPassword;
//     });
//   }
//
//   void _updateConfirmPassword(String confirmPassword) {
//     setState(() {
//       _confirmPassword = confirmPassword;
//       _passwordsMatch = _password == _confirmPassword;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         PasswordTextBox(
//           onPasswordChanged: _updatePassword,
//         ),
//         Gaps.h40,
//         PasswordCheckTextBox(
//           onConfirmPasswordChanged: _updateConfirmPassword,
//           passwordsMatch: _passwordsMatch,
//         ),
//       ],
//     );
//   }
// }
//
// class PasswordTextBox extends StatelessWidget {
//   final ValueChanged<String> onPasswordChanged;
//
//   const PasswordTextBox({Key? key, required this.onPasswordChanged})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: onPasswordChanged,
//       obscureText: true,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: '비밀번호',
//       ),
//     );
//   }
// }
//
// class PasswordCheckTextBox extends StatelessWidget {
//   final ValueChanged<String> onConfirmPasswordChanged;
//   final bool passwordsMatch;
//
//   const PasswordCheckTextBox({
//     Key? key,
//     required this.onConfirmPasswordChanged,
//     required this.passwordsMatch,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: onConfirmPasswordChanged,
//       obscureText: true,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: '비밀번호 확인',
//         errorText: passwordsMatch ? null : '비밀번호가 일치하지 않습니다',
//       ),
//     );
//   }
// }
//
// class EmailTextBox extends StatelessWidget {
//   const EmailTextBox({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: '이메일',
//       ),
//     );
//   }
// }
//
// class NameTextBox extends StatelessWidget {
//   const NameTextBox({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(),
//         labelText: '이름',
//       ),
//     );
//   }
// }
//
// class VerificationButton extends StatelessWidget {
//   const VerificationButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             // 인증번호 확인 로직 구현
//             print('인증번호 확인 버튼이 클릭되었습니다.');
//           },
//           child: const Text('인증번호 확인'), // 버튼 텍스트 설정
//         ),
//       ],
//     );
//   }
// }
//
// class SendVerificationButton extends StatelessWidget {
//   const SendVerificationButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             // 인증번호 전송 로직 구현
//             print('인증번호 전송 버튼이 클릭되었습니다.');
//           },
//           child: const Text('인증번호 전송'), // 버튼 텍스트 설정
//         ),
//       ],
//     );
//   }
// }
//
// class CheckIDButton extends StatelessWidget {
//   const CheckIDButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // 여기에 아이디 중복 검사 로직을 구현할 수 있습니다.
//     void checkID() {
//       // 아이디 중복 검사 로직 추가
//       print('아이디 중복 검사 버튼이 클릭되었습니다.');
//     }
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         ElevatedButton(
//           onPressed: checkID,
//           child: const Text('아이디 중복 검사'), // 버튼 텍스트 설정
//         ),
//       ],
//     );
//   }
// }
//
// class DateOfBirthDropdown extends StatefulWidget {
//   const DateOfBirthDropdown({Key? key}) : super(key: key);
//
//   @override
//   _DateOfBirthDropdownState createState() => _DateOfBirthDropdownState();
// }
//
// class _DateOfBirthDropdownState extends State<DateOfBirthDropdown> {
//   String? _selectedYear;
//   String? _selectedMonth;
//   String? _selectedDay;
//
//   final List<String> years = List.generate(
//       100, (index) => (DateTime.now().year - 80 + index).toString());
//   final List<String> months =
//       List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
//   final List<String> days =
//       List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('생년월일', style: TextStyle(fontWeight: FontWeight.bold)),
//         Row(
//           children: [
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: '년',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedYear,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedYear = newValue;
//                   });
//                 },
//                 items: years
//                     .map((year) => DropdownMenuItem<String>(
//                           value: year,
//                           child: Text(year),
//                         ))
//                     .toList(),
//               ),
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: '월',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedMonth,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedMonth = newValue;
//                   });
//                 },
//                 items: months
//                     .map((month) => DropdownMenuItem<String>(
//                           value: month,
//                           child: Text(month),
//                         ))
//                     .toList(),
//               ),
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: '일',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedDay,
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedDay = newValue;
//                   });
//                 },
//                 items: days
//                     .map((day) => DropdownMenuItem<String>(
//                           value: day,
//                           child: Text(day),
//                         ))
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:sofp_front/gaps.dart';
//
// void main() => runApp(const SigninPage());
//
// class SigninPage extends StatelessWidget {
//   const SigninPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: const [
//                 Gaps.h40,
//                 Center(
//                   child: Text(
//                     '회원가입',
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 Gaps.h40,
//                 SubmitButton(), // 회원가입 버튼 및 관련 필드 추가
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SubmitButton extends StatefulWidget {
//   const SubmitButton({Key? key}) : super(key: key);
//
//   @override
//   State<SubmitButton> createState() => _SubmitButtonState();
// }
//
// class _SubmitButtonState extends State<SubmitButton> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String? _selectedYear;
//   String? _selectedMonth;
//   String? _selectedDay;
//
//   final List<String> years = List.generate(100, (index) => (DateTime.now().year - 99 + index).toString());
//   final List<String> months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
//   final List<String> days = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _submitData() {
//     // 사용자 입력 데이터 출력
//     print('이름: ${_nameController.text}');
//     print('이메일: ${_emailController.text}');
//     print('비밀번호: ${_passwordController.text}');
//     print('생년월일: $_selectedYear-$_selectedMonth-$_selectedDay');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _nameController,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '이름',
//           ),
//         ),
//         Gaps.h40,
//         TextField(
//           controller: _emailController,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '이메일',
//           ),
//         ),
//         Gaps.h40,
//         TextField(
//           controller: _passwordController,
//           obscureText: true,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '비밀번호',
//           ),
//         ),
//         Gaps.h40,
//         Row(
//           children: [
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '년',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedYear,
//                 items: years.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedYear = newValue;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '월',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedMonth,
//                 items: months.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedMonth = newValue;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '일',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedDay,
//                 items: days.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedDay = newValue;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         Gaps.h40,
//         ElevatedButton(
//           onPressed: _submitData,
//           child: const Text('회원가입'),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sofp_front/gaps.dart';
//
// void main() => runApp(const SigninPage());
//
// class SigninPage extends StatelessWidget {
//   const SigninPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: const [
//                 Gaps.h40,
//                 Center(
//                   child: Text(
//                     '회원가입',
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 Gaps.h40,
//                 UserRegistrationForm(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class UserRegistrationForm extends StatefulWidget {
//   const UserRegistrationForm({Key? key}) : super(key: key);
//
//   @override
//   _UserRegistrationFormState createState() => _UserRegistrationFormState();
// }
//
// class _UserRegistrationFormState extends State<UserRegistrationForm> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _verificationCodeController = TextEditingController();
//
//   String? _selectedYear;
//   String? _selectedMonth;
//   String? _selectedDay;
//
//   bool _isEmailVerified = false;
//   bool _isIdAvailable = false;
//
//   final List<String> years = List.generate(100, (index) => (DateTime.now().year - 99 + index).toString());
//   final List<String> months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
//   final List<String> days = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _verificationCodeController.dispose();
//     super.dispose();
//   }
//
//   void _submitData() {
//     if (!_isEmailVerified) {
//       // 추가: 이메일 검증이 필요한 경우 알림
//       print('이메일을 먼저 인증해주세요.');
//       return;
//     }
//     if (!_isIdAvailable) {
//       // 추가: 아이디 중복검사가 필요한 경우 알림
//       print('아이디 중복검사를 해주세요.');
//       return;
//     }
//     // 사용자 입력 데이터 출력
//     print('이름: ${_nameController.text}');
//     print('이메일: ${_emailController.text}');
//     print('비밀번호: ${_passwordController.text}');
//     print('생년월일: $_selectedYear-$_selectedMonth-$_selectedDay');
//   }
//
//   void _checkEmailVerification() {
//     // 여기에 이메일 인증 로직 구현
//     // 예시를 위해 항상 인증 성공으로 가정
//     setState(() {
//       _isEmailVerified = true;
//     });
//     print('이메일 인증 완료');
//   }
//
//   void _checkIdAvailability() {
//     // 여기에 아이디 중복 검사 로직 구현
//     // 예시를 위해 항상 사용 가능으로 가정
//     setState(() {
//       _isIdAvailable = true;
//     });
//     print('아이디 사용 가능');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _nameController,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '이름',
//           ),
//         ),
//         Gaps.h40,
//         ElevatedButton(
//           onPressed: _checkIdAvailability,
//           child: const Text('아이디 중복 검사'),
//         ),
//         Gaps.h40,
//         TextField(
//           controller: _emailController,
//           decoration: InputDecoration(
//             border: const OutlineInputBorder(),
//             labelText: '이메일',
//             suffixIcon: IconButton(
//               onPressed: _checkEmailVerification,
//               icon: Icon(Icons.check, color: _isEmailVerified ? Colors.green : Colors.grey),
//             ),
//           ),
//         ),
//         Gaps.h40,
//         TextField(
//           controller: _verificationCodeController,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '인증번호',
//           ),
//         ),
//         Gaps.h20,
//         TextField(
//           controller: _passwordController,
//           obscureText: true,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '비밀번호',
//           ),
//         ),
//         Gaps.h40,
//
//         Gaps.h40,
//         Row(
//           children: [
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '년',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedYear,
//                 items: years.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedYear = newValue;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '월',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedMonth,
//                 items: months.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedMonth = newValue;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '일',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedDay,
//                 items: days.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedDay = newValue;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         Gaps.h40,
//         ElevatedButton(
//           onPressed: _submitData,
//           child: const Text('회원가입'),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sofp_front/gaps.dart';
//
// void main() => runApp(const SigninPage());
//
// class SigninPage extends StatelessWidget {
//   const SigninPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: const [
//                 Gaps.h40,
//                 Center(
//                   child: Text(
//                     '회원가입',
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 Gaps.h40,
//                 UserRegistrationForm(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class UserRegistrationForm extends StatefulWidget {
//   const UserRegistrationForm({Key? key}) : super(key: key);
//
//   @override
//   _UserRegistrationFormState createState() => _UserRegistrationFormState();
// }
//
// class _UserRegistrationFormState extends State<UserRegistrationForm> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _verificationCodeController = TextEditingController();
//
//   String? _selectedYear;
//   String? _selectedMonth;
//   String? _selectedDay;
//
//   bool _isEmailVerified = false;
//   bool _isIdAvailable = false;
//   bool _passwordsMatch = true;
//
//   final List<String> years = List.generate(100, (index) => (DateTime.now().year - 99 + index).toString());
//   final List<String> months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
//   final List<String> days = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _verificationCodeController.dispose();
//     super.dispose();
//   }
//
//   void _submitData() {
//     if (!_isEmailVerified) {
//       print('이메일을 먼저 인증해주세요.');
//       return;
//     }
//     if (!_isIdAvailable) {
//       print('아이디 중복검사를 해주세요.');
//       return;
//     }
//     if (!_passwordsMatch) {
//       print('비밀번호가 일치하지 않습니다.');
//       return;
//     }
//     print('이름: ${_nameController.text}');
//     print('이메일: ${_emailController.text}');
//     print('비밀번호: ${_passwordController.text}');
//     print('생년월일: $_selectedYear-$_selectedMonth-$_selectedDay');
//   }
//
//   void _checkIdAvailability() {
//     // 여기에 아이디 중복 검사 로직 구현
//     // 예시를 위해 항상 사용 가능으로 가정
//     setState(() {
//       _isIdAvailable = true;
//     });
//     print('아이디 사용 가능');
//   }
//
//   void _checkPasswordsMatch() {
//     setState(() {
//       _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _nameController,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '이름',
//           ),
//         ),
//         Gaps.h40,
//         ElevatedButton(
//           onPressed: _checkIdAvailability,
//           child: const Text('아이디 중복 검사'),
//         ),
//         Gaps.h40,
//         TextField(
//           controller: _emailController,
//           decoration: InputDecoration(
//             border: const OutlineInputBorder(),
//             labelText: '이메일',
//             suffixIcon: IconButton(
//               onPressed: () {
//                 // 이메일 인증 로직
//               },
//               icon: Icon(Icons.check, color: _isEmailVerified ? Colors.green : Colors.grey),
//             ),
//           ),
//         ),
//         Gaps.h40,
//         TextField(
//           controller: _passwordController,
//           obscureText: true,
//           onChanged: (_) => _checkPasswordsMatch(),
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: '비밀번호',
//           ),
//         ),
//         Gaps.h40,
//         TextField(
//           controller: _confirmPasswordController,
//           obscureText: true,
//           onChanged: (_) => _checkPasswordsMatch(),
//           decoration: InputDecoration(
//             border: const OutlineInputBorder(),
//             labelText: '비밀번호 확인',
//             errorText: _passwordsMatch ? null : '비밀번호가 일치하지 않습니다',
//           ),
//         ),
//         Gaps.h40,
//         // 이하 위젯들은 이전 코드와 동일하며, 필요한 로직 추가
//         Row(
//           children: [
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '년',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedYear,
//                 items: years.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedYear = newValue;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '월',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedMonth,
//                 items: months.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedMonth = newValue;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: '일',
//                   border: OutlineInputBorder(),
//                 ),
//                 value: _selectedDay,
//                 items: days.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedDay = newValue;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         Gaps.h40,
//         ElevatedButton(
//           onPressed: _submitData,
//           child: const Text('회원가입'),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // 토스트 메시지 패키지 추가
import 'package:sofp_front/gaps.dart';

import 'api-docs.dart';

void main() => runApp(const SigninPage());

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String name = ''; // 이름
  String email = ''; // 이메일
  String gender = ''; // 성별을 저장하는 변수
  String buttonLabel = '인증번호 전송'; // 버튼 레이블 초기값 설정
  String? selectedYear; // 선택된 년도
  String? selectedMonth; // 선택된 월
  String? selectedDay; // 선택된 일
  final String _password = ''; //비밀번호

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
        _password.isEmpty) {
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
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Gaps.h40, // 공간 추가
                Center(
                  child: Text(
                    '회원가입', // 화면 제목
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
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

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({Key? key}) : super(key: key);

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
class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
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

  bool _isEmailVerified = false;
  bool _passwordsMatch = true;

  final List<String> years = List.generate(100, (index) => (DateTime.now().year - 99 + index).toString());
  final List<String> months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> days = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (!_isEmailVerified) {
      print('이메일을 먼저 인증해주세요.');
      return;
    }
    if (!_passwordsMatch) {
      print('비밀번호가 일치하지 않습니다.');
      return;
    }
    // 사용자 입력 데이터 출력
    print('이름: ${_nameController.text}');
    print('이메일: ${_emailController.text}');
    print('비밀번호: ${_passwordController.text}');
    print('생년월일: $_selectedYear-$_selectedMonth-$_selectedDay');
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _checkEmailVerification() {
    // 여기에 이메일 인증 로직 구현
    // 예시를 위해 항상 인증 성공으로 가정
    setState(() {
      _isEmailVerified = true;
    });
    print('이메일 인증 완료');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gaps.h40,
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '이름',
          ),
        ),
        Gaps.h40,
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: '이메일',
            suffixIcon: IconButton(
              onPressed: _checkEmailVerification,
              icon: Icon(Icons.check, color: _isEmailVerified ? Colors.green : Colors.grey),
            ),
          ),
        ),
        Gaps.h40,
        ElevatedButton(
          onPressed: () async { // 여기에 async 키워드를 추가해 비동기 함수를 호출
            await mailTokenSend(_emailController.text);
          },
          child: const Text('아이디 중복 검사'),
        ),
        Gaps.h40,
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _verificationCodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '인증번호',
                ),
              ),
            ),
            Gaps.w10,
            ElevatedButton(
              onPressed: () async { // 여기에 async 키워드를 추가해 비동기 함수를 호출
                await mailTokenCheck(_emailController.text, _verificationCodeController.text);
              },
              child: const Text('발송'),
            ),
          ],
        ),
        Gaps.h40,
        TextField(
          controller: _passwordController,
          obscureText: true,
          onChanged: (_) => _checkPasswordsMatch(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '비밀번호',
          ),
        ),
        Gaps.h40,
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          onChanged: (_) => _checkPasswordsMatch(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: '비밀번호 확인',
            errorText: _passwordsMatch ? null : '비밀번호가 일치하지 않습니다',
          ),
        ),
        Gaps.h40,
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '년',
                  border: OutlineInputBorder(),
                ),
                value: _selectedYear,
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
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
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '월',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMonth,
                items: months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
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
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '일',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDay,
                items: days.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
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
        Gaps.h40,
        ElevatedButton(
          onPressed: () async { // 여기에 async 키워드를 추가해 비동기 함수를 호출
            await signUp(
                _nameController.text,
                _selectedYear!,
                _selectedMonth!,
                _selectedDay!,
                _emailController.text,
                "남",
                _passwordController.text,
                true);
          },
          // signUp(_usernameController.text, _passwordController.text);
          child: const Text('회원가입'),
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
