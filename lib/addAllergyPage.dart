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

// void main() {
//   runApp(MaterialApp(
//     title: 'First App',
//     theme: ThemeData(primarySwatch: Colors.blue),
//     home: AddAllergyPage(),
//   ));
// }

// class AddAllergyPage extends StatefulWidget {
//   const AddAllergyPage({super.key});

//   @override
//   _AddAllergyPageState createState() => _AddAllergyPageState();
// }

// class _AddAllergyPageState extends State<AddAllergyPage> {
//   List<String> allergies = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadAllergies();
//   }

//   void _saveAllergies() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('allergies', allergies);
//   }

//   void _loadAllergies() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       allergies = prefs.getStringList('allergies') ?? [];
//     });
//   }

//   void _addAllergy(String input) {
//     setState(() {
//       allergies.add(input);
//       _saveAllergies();
//     });
//   }

//   void _removeAllergy(int index) {
//     setState(() {
//       allergies.removeAt(index);
//       _saveAllergies();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               ', 환영합니다',
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
//               height: 100,
//               child: Wrap(
//                 spacing: 8.0,
//                 runSpacing: 8.0,
//                 children: [
//                   for (int i = 0; i < allergies.length; i++)
//                     Chip(
//                       backgroundColor: AppColors.softTeal,
//                       label: Text(
//                         allergies[i],
//                         style: TextStyle(
//                           color: AppColors.deepTeal,
//                         ),
//                       ),
//                       deleteIconColor: AppColors.deepTeal,
//                       onDeleted: () => _removeAllergy(i),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(
//                           color: AppColors.softTeal,
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
//                 onPressed: () {
//                   // Add functionality for showing a new screen or dialog if needed
//                 },
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
//                       navigateToHome();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       backgroundColor: AppColors.deepTeal,
//                     ),
//                     child: Text(
//                       '약속 시작하기',
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
