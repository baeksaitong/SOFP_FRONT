import 'package:flutter/material.dart';
import '../../constans/colors.dart';
import '../../constans/text_styles.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback showBottomSheet;

  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.showBottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${focusedDay.year}년 ${focusedDay.month}월',
          style: AppTextStyles.title2B20,
        ),
        IconButton(
          icon: Image.asset(
            'assets/calendar.png',
            width: 30,
            height: 30,
          ),
          onPressed: showBottomSheet,
        ),
      ],
    );
  }
}
