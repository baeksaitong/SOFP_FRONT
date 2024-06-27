// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:sopf_front/managers/managers_api_client.dart';
import 'package:sopf_front/navigates.dart';
import '../../constans/gaps.dart';

import 'package:intl/intl.dart'; // 추가: 시간을 형식에 맞게 변환하기 위해 사용
import '../../constans/colors.dart'; // 색상 정의 파일
import '../../constans/text_styles.dart'; // 텍스트 스타일 정의 파일

class PillCategoryPlus extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? category;

  const PillCategoryPlus({super.key, required this.onSave, this.category});

  @override
  _PillCategoryPlusState createState() => _PillCategoryPlusState();
}

class _PillCategoryPlusState extends State<PillCategoryPlus> {
  bool _pushNotificationEnabled = true;
  final List<String> displayRoutines = []; // UI에 표시할 시간 리스트
  final List<String> apiRoutines = []; // API에 보낼 시간 리스트
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final List<bool> _selectedWeekdays = [false, false, false, false, false, false, false];
  final APIClient apiClient = APIClient();
  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _categoryNameController.text = widget.category!['name'] ?? '';
      _periodController.text = widget.category!['period'] ?? '';
      final List<String> days = widget.category!['days'] ?? [];
      for (int i = 0; i < _selectedWeekdays.length; i++) {
        _selectedWeekdays[i] = days.contains(['월', '화', '수', '목', '금', '토', '일'][i]);
      }
      displayRoutines.addAll(widget.category!['displayTimes'] ?? []);
      apiRoutines.addAll(widget.category!['times'] ?? []);
    }
  }

  void _saveCategory() async {
    final List<String> apiDays = _selectedWeekdays
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][entry.key])
        .toList();

    final newCategory = {
      'name': _categoryNameController.text,
      'intakeDayList': apiDays,
      'intakeTimeList': apiRoutines,
      'alarm': _pushNotificationEnabled,
      'period': _periodController.text,
    };

    await apiClient.categoryPost(context, newCategory);

    widget.onSave(newCategory);
    Navigator.pop(context);
    navigateToMedicationsTaking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('복용중인 알약', style: AppTextStyles.body1S16),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('카테고리 이름', style: AppTextStyles.body2M16),
            Gaps.h8,
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '감기약',
              ),
            ),
            Gaps.h16,
            Text('섭취 요일', style: AppTextStyles.body2M16),
            Gaps.h8,
            WeekdaySelector(
              selectedWeekdays: _selectedWeekdays,
              onChanged: (index, selected) {
                setState(() {
                  _selectedWeekdays[index] = selected;
                });
              },
            ),
            Gaps.h8,
            RoutineSelector(
              routines: displayRoutines,
              onAdd: () {
                _showTimePickerDialog(context);
              },
              onRemove: (index) {
                setState(() {
                  displayRoutines.removeAt(index);
                  apiRoutines.removeAt(index);
                });
              },
            ),
            Gaps.h16,
            Text('섭취 기간', style: AppTextStyles.body2M16),
            Gaps.h8,
            TextField(
              controller: _periodController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'YYYY-MM-DD',
              ),
            ),
            Gaps.h16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('푸시알림', style: AppTextStyles.body2M16),
                Switch(
                  value: _pushNotificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _pushNotificationEnabled = value;
                    });
                  },
                  activeColor: AppColors.deepTeal,
                  inactiveThumbColor: AppColors.gr600,
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveCategory,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: AppColors.deepTeal,
              ),
              child: Text('저장',
                  style: AppTextStyles.body1S16.copyWith(color: AppColors.wh)),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePickerDialog(BuildContext context) {
    int selectedPeriodIndex = 0; // 0 for AM, 1 for PM
    int selectedHour = 1;
    int selectedMinute = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('섭취 시간 추가'),
          content: SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      selectedPeriodIndex = index;
                    },
                    children: const [
                      Text('오전'),
                      Text('오후'),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      selectedHour = index + 1;
                    },
                    children: List<Widget>.generate(12, (int index) {
                      return Text('${index + 1}시');
                    }),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      selectedMinute = index;
                    },
                    children: List<Widget>.generate(60, (int index) {
                      return Text('$index분');
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final String period = selectedPeriodIndex == 0 ? '오전' : '오후';
                final String hour = selectedHour.toString().padLeft(2, '0');
                final String minute = selectedMinute.toString().padLeft(2, '0');
                final String displayTime = '$period $hour시 $minute분';

                final int apiHour = (selectedPeriodIndex == 1 && selectedHour != 12)
                    ? selectedHour + 12
                    : (selectedPeriodIndex == 0 && selectedHour == 12)
                    ? 0
                    : selectedHour;
                final String apiTime = '${apiHour.toString().padLeft(2, '0')}:$minute';

                setState(() {
                  displayRoutines.add(displayTime);
                  apiRoutines.add(apiTime);
                });
                Navigator.of(context).pop();
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }
}

class WeekdaySelector extends StatelessWidget {
  final List<bool> selectedWeekdays;
  final Function(int, bool) onChanged;

  const WeekdaySelector({
    super.key,
    required this.selectedWeekdays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.8,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
      ),
      itemCount: weekdays.length,
      itemBuilder: (context, index) {
        return ChoiceChip(
          label: Text(weekdays[index]),
          selected: selectedWeekdays[index],
          onSelected: (bool selected) {
            onChanged(index, selected);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: selectedWeekdays[index]
                ? BorderSide(color: AppColors.deepTeal, width: 1.0)
                : BorderSide(color: AppColors.gr300, width: 1.0),
          ),
          backgroundColor: AppColors.gr300,
          selectedColor: AppColors.softTeal,
          showCheckmark: false,
        );
      },
    );
  }
}

class RoutineSelector extends StatelessWidget {
  final List<String> routines;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const RoutineSelector({
    super.key,
    required this.routines,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('섭취 루틴', style: AppTextStyles.body2M16),
            Spacer(),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add),
              label: Text('추가'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        Gaps.h10,
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: routines
                .asMap()
                .entries
                .map(
                  (entry) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.value),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => onRemove(entry.key),
                  ),
                ],
              ),
            )
                .toList(),
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
