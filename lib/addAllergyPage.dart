// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'appColors.dart';
// import 'appTextStyles.dart';
// import 'gaps.dart';
// import 'package:provider/provider.dart';
// import 'apiClient.dart';
// import 'navigates.dart';
// import 'provider.dart';
//
// // void main() {
// //   runApp(MaterialApp(
// //     title: 'First App',
// //     theme: ThemeData(primarySwatch: Colors.blue),
// //     home: AddAllergyPage(),
// //   ));
// // }
//
// class AddAllergyPage extends StatefulWidget {
//   const AddAllergyPage({super.key});
//
//   @override
//   _AddAllergyPageState createState() => _AddAllergyPageState();
// }
//
// class _AddAllergyPageState extends State<AddAllergyPage> {
//   List<String> allergies = [];
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadAllergies();
// //   }
//
//   void _saveAllergies() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('allergies', allergies);
//   }
//
// //   void _loadAllergies() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       allergies = prefs.getStringList('allergies') ?? [];
// //     });
// //   }
//
// //   void _addAllergy(String input) {
// //     setState(() {
// //       allergies.add(input);
// //       _saveAllergies();
// //     });
// //   }
//
// //   void _removeAllergy(int index) {
// //     setState(() {
// //       allergies.removeAt(index);
// //       _saveAllergies();
// //     });
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               ', 환영합니다',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //             Text(
// //               '현재 앓고있는 알레르기가 있다면 추가 해주세요',
// //               style: TextStyle(
// //                 fontSize: 16,
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             SizedBox(
// //               height: 100,
// //               child: Wrap(
// //                 spacing: 8.0,
// //                 runSpacing: 8.0,
// //                 children: [
// //                   for (int i = 0; i < allergies.length; i++)
// //                     Chip(
// //                       backgroundColor: AppColors.softTeal,
// //                       label: Text(
// //                         allergies[i],
// //                         style: TextStyle(
// //                           color: AppColors.deepTeal,
// //                         ),
// //                       ),
// //                       deleteIconColor: AppColors.deepTeal,
// //                       onDeleted: () => _removeAllergy(i),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                         side: BorderSide(
// //                           color: AppColors.softTeal,
// //                         ),
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //             ),
// //             Gaps.h20,
// //             Container(
// //               width: double.infinity,
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: ElevatedButton(
// //                 onPressed: () {
// //                   // Add functionality for showing a new screen or dialog if needed
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 child: Text(
// //                   '+ 추가하기',
// //                   style: AppTextStyles.body1S16
// //                       .copyWith(color: AppColors.deepTeal),
// //                 ),
// //               ),
// //             ),
// //             Gaps.h20,
// //             Expanded(
// //               child: Align(
// //                 alignment: Alignment.bottomCenter,
// //                 child: Container(
// //                   margin: EdgeInsets.only(bottom: 20),
// //                   width: double.infinity,
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       navigateToHome();
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       backgroundColor: AppColors.deepTeal,
// //                     ),
// //                     child: Text(
// //                       '약속 시작하기',
// //                       style: AppTextStyles.body1S16
// //                           .copyWith(color: AppColors.softTeal),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//   void _addAllergy(String input) {
//     setState(() {
//       allergies.add(input);
//       _saveAllergies();
//     });
//   }
//
//   void _removeAllergy(int index) {
//     setState(() {
//       allergies.removeAt(index);
//       _saveAllergies();
//     });
//   }
//
//   void _showBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // 키보드가 올라올 때 모달도 같이 올라오도록 설정
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         String inputText = '';
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets, // 키보드 크기만큼 패딩 추가
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('알레르기 & 질병 추가', style: AppTextStyles.title1B24),
//                 TextField(
//                   autofocus: true, // 커서가 자동으로 들어감
//                   onChanged: (value) {
//                     inputText = value;
//                   },
//                   onSubmitted: (value) {
//                     _addAllergy(value);
//                     Navigator.of(context).pop();
//                   },
//                   decoration: InputDecoration(
//                     hintText: '알레르기를 입력하세요',
//                     hintStyle: AppTextStyles.body5M14,
//                   ),
//                 ),
//                 Gaps.h20,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       child: Text(
//                         '추가',
//                         style: AppTextStyles.body5M14,
//                       ),
//                       onPressed: () {
//                         _addAllergy(inputText);
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     TextButton(
//                       child: Text(
//                         '취소',
//                         style: AppTextStyles.body5M14,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//                 Gaps.h20,
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final currentProfile = Provider.of<ProfileProvider>(context).currentProfile;
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${currentProfile?.name}님,환영합니다',
//               // 'ㅋ',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               '현재 앓고있는 알레르기가 있다면 추가 해주세요',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 10),
//             SizedBox(
//               height: 100, // 리스트의 높이를 설정하세요
//               child: Wrap(
//                 spacing: 8.0, // 아이템 사이의 간격
//                 runSpacing: 8.0, // 줄 사이의 간격
//                 children: [
//                   for (int i = 0; i < allergies.length; i++)
//                     Chip(
//                       backgroundColor: AppColors.softTeal, // 배경색
//                       label: Text(
//                         allergies[i],
//                         style: TextStyle(
//                           color: AppColors.deepTeal, // 텍스트 색상
//                         ),
//                       ),
//                       deleteIconColor: AppColors.deepTeal, // 삭제 아이콘 색상
//                       onDeleted: () => _removeAllergy(i),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(
//                           color: AppColors.softTeal, // 테두리 색상
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Gaps.h20,
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ElevatedButton(
//                 onPressed: _showBottomSheet,
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   '+ 추가하기',
//                   style: AppTextStyles.body1S16
//                       .copyWith(color: AppColors.deepTeal),
//                 ),
//               ),
//             ),
//             Gaps.h20,
//             Expanded(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 20),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // 버튼이 눌렸을 때 실행할 동작 추가
//                       navigateToHome();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10), // 모서리 둥글기 설정
//                       ),
//                       backgroundColor: AppColors.deepTeal, // 배경색 지정
//                     ),
//                     child: Text(
//                       '약속 시작하기', // 버튼 텍스트
//                       style: AppTextStyles.body1S16
//                           .copyWith(color: AppColors.softTeal),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }