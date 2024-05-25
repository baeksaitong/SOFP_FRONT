import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // DateFormat 사용을 위해 intl 패키지 임포트
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appTextStyles.dart'; // 원하는 글꼴 스타일이 정의된 파일을 임포트
import 'appColors.dart'; // 색상 정의 파일을 임포트
import 'gaps.dart';
import 'dart:convert'; // JSON 변환을 위해 임포트

// void main() {
//   // 날짜 형식을 초기화하고 앱을 시작합니다.
//   initializeDateFormatting().then((_) {
//     runApp(const CalendarApp());
//   });
// }

// CalendarApp 클래스: 앱의 루트 위젯
class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '달력 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(),
    );
  }
}

// MedicineEvent 클래스 수정
class MedicineEvent {
  final String name;
  final Color color; // 색상 추가
  bool isTaken12;
  bool isTaken15;
  bool isTaken18;

  MedicineEvent(this.name, this.color,
      {this.isTaken12 = false, this.isTaken15 = false, this.isTaken18 = false});

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color.value, // 색상을 int로 저장
        'isTaken12': isTaken12,
        'isTaken15': isTaken15,
        'isTaken18': isTaken18,
      };

  static MedicineEvent fromJson(Map<String, dynamic> json) => MedicineEvent(
        json['name'],
        Color(json['color']), // int에서 Color로 변환
        isTaken12: json['isTaken12'],
        isTaken15: json['isTaken15'],
        isTaken18: json['isTaken18'],
      );
}

// CalendarPage 클래스: 달력 페이지의 상태를 관리
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

// _CalendarPageState 클래스: CalendarPage의 상태를 정의
class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay; // 현재 집중된 날짜
  late DateTime _selectedDay; // 선택된 날짜
  CalendarFormat _calendarFormat = CalendarFormat.month; // 달력 형식 (월간)
  Map<DateTime, List<MedicineEvent>> _events = {}; // 약 이벤트 데이터
  String _selectedAccount = ''; // 선택된 계정
  Color _selectedColor = AppColors.customBlue; // 선택된 계정 색상

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now(); // 현재 날짜로 초기화
    _selectedDay = _focusedDay; // 선택된 날짜도 현재 날짜로 초기화
    _loadEvents();
  }

  // 날짜를 선택할 때 호출되는 함수
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay; // 선택된 날짜를 업데이트
      _focusedDay = focusedDay; // 집중된 날짜를 업데이트
    });
  }

  // 달력 형식이 변경될 때 호출되는 함수
  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format; // 달력 형식을 업데이트
    });
  }

  // 선택된 날짜에 해당하는 약 이벤트 목록 반환
  List<MedicineEvent> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_focusedDay.year}년 ${_focusedDay.month}월',
          style: AppTextStyles.title2B20,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _showBottomSheet,
        ),
      ],
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomDialog(onOptionSelected: _onOptionSelected);
      },
    );
  }

  Future<void> _onOptionSelected(Map<String, Color> selectedAccounts) async {
    setState(() {
      _selectedAccount = selectedAccounts.keys.join(', ');
      _selectedColor = selectedAccounts.values.first;
    });

    // 예시 데이터
    Map<DateTime, List<MedicineEvent>> exampleEvents = {
      DateTime.utc(2024, 5, 20): [
        if (selectedAccounts.containsKey('계정 1'))
          MedicineEvent('감기약', selectedAccounts['계정 1']!,
              isTaken12: false, isTaken15: false),
        if (selectedAccounts.containsKey('계정 2'))
          MedicineEvent('배탈약', selectedAccounts['계정 2']!,
              isTaken12: false, isTaken15: false, isTaken18: false),
      ],
      DateTime.utc(2024, 5, 21): [
        if (selectedAccounts.containsKey('계정 1'))
          MedicineEvent('감기약', selectedAccounts['계정 1']!,
              isTaken12: false, isTaken15: false),
      ],
      DateTime.utc(2024, 5, 22): [
        if (selectedAccounts.containsKey('계정 2'))
          MedicineEvent('배탈약', selectedAccounts['계정 2']!,
              isTaken12: false, isTaken15: false, isTaken18: false),
        if (selectedAccounts.containsKey('계정 3'))
          MedicineEvent('계정 3 약', selectedAccounts['계정 3']!,
              isTaken12: false, isTaken15: false),
      ],
    };

    setState(() {
      _events = exampleEvents;
    });

    // 로컬에 저장
    await _saveEvents();
  }

  // 이벤트 데이터를 로컬 저장소에 저장하는 함수
  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = _events.map((key, value) =>
        MapEntry(key.toString(), value.map((e) => e.toJson()).toList()));
    await prefs.setString('events', json.encode(eventsJson));
  }

  // 이벤트 데이터를 로컬 저장소에서 불러오는 함수
  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString('events');
    if (eventsJson != null) {
      final decodedEvents = Map<String, dynamic>.from(json.decode(eventsJson));
      setState(() {
        _events = decodedEvents.map((key, value) => MapEntry(
            DateTime.parse(key),
            (value as List<dynamic>)
                .map((e) => MedicineEvent.fromJson(e))
                .toList()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 화면 전체에 패딩 추가
          child: Column(
            children: [
              _buildCalendarHeader(),
              SizedBox(
                child: TableCalendar(
                  locale: 'ko_KR', // 한국어 로케일 설정
                  firstDay: DateTime.utc(2010, 10, 16), // 달력의 시작 날짜
                  lastDay: DateTime.utc(2030, 3, 14), // 달력의 마지막 날짜
                  focusedDay: _focusedDay, // 현재 집중된 날짜
                  calendarFormat: _calendarFormat, // 현재 달력 형식
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day); // 선택된 날짜를 표시
                  },
                  onDaySelected: _onDaySelected, // 날짜를 선택할 때 호출되는 함수
                  onFormatChanged: _onFormatChanged, // 달력 형식이 변경될 때 호출되는 함수
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay; // 페이지가 변경될 때 집중된 날짜를 업데이트
                  },
                  eventLoader: _getEventsForDay, // 이벤트 로더 설정
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false, // 달력 외부의 날짜를 숨김
                    cellMargin: const EdgeInsets.all(2.0), // 날짜 셀의 마진을 키움
                    cellPadding: const EdgeInsets.only(
                        top: 1.0, bottom: 5.0), // 날짜 셀의 패딩을 위쪽으로 설정
                    defaultTextStyle:
                        AppTextStyles.caption3M10, // 기본 텍스트 스타일 적용
                    weekendTextStyle:
                        AppTextStyles.caption3M10, // 주말 텍스트 스타일 적용
                    selectedDecoration: BoxDecoration(
                      color: AppColors.gr150,
                      shape: BoxShape.rectangle, // Circular shape
                      border: Border.all(
                        color: _selectedColor,
                        width: 0.5,
                      ),
                    ),
                    selectedTextStyle:
                        AppTextStyles.caption3M10, // 선택된 날짜 텍스트 스타일 적용
                    todayTextStyle: AppTextStyles.caption3M10.copyWith(
                        color: AppColors.deepTeal), // 오늘 날짜 텍스트 스타일 적용
                    todayDecoration: const BoxDecoration(),
                    holidayTextStyle:
                        AppTextStyles.caption3M10, // 공휴일 텍스트 스타일 적용
                    cellAlignment: Alignment.topCenter, // 셀의 정렬을 위쪽 가운데로 설정
                  ),
                  daysOfWeekHeight: 50, // 요일 행의 높이 설정
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: AppTextStyles.body2M16, // 평일 텍스트 스타일 적용
                    weekendStyle: AppTextStyles.body2M16, // 주말 텍스트 스타일 적용
                    dowTextFormatter: (date, locale) =>
                        DateFormat.E(locale).format(date), // 요일 텍스트 형식 설정
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false, // 형식 변경 버튼을 숨김
                    titleCentered: true, // 달력 제목을 가운데 정렬
                    leftChevronVisible: false, // 왼쪽 화살표 숨김
                    rightChevronVisible: false, // 오른쪽 화살표 숨김
                    titleTextStyle: AppTextStyles.title2B20, // 헤더 제목 스타일 적용
                  ),
                  headerVisible: false, // 기본 헤더를 숨김
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: _buildEventsMarker(date, events),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0), // 달력과 약 목록 사이에 공간 추가
              _buildEventList(), // 약 목록 표시
            ],
          ),
        ),
      ),
    );
  }

  // 약 이벤트 마커 생성
  Widget _buildEventsMarker(DateTime date, List events) {
    return Row(
      children: events.map((event) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.0), // 마커 간 간격 설정
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (event as MedicineEvent).color, // 각 이벤트의 색상 사용
          ),
          width: 7.0,
          height: 7.0,
        );
      }).toList(),
    );
  }

  // 약 이벤트 목록 생성
  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay);
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), // 이 리스트는 스크롤하지 않음
      shrinkWrap: true, // 부모의 크기에 맞게 축소
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: event.color,
                width: 5.0, // 원하는 두께로 설정
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.name,
                    style: AppTextStyles.body2M16,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // 이벤트 세부 정보 페이지로 이동하는 동작을 여기에 정의합니다.
                    },
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Checkbox(
                    value: event.isTaken12,
                    onChanged: (bool? value) {
                      setState(() {
                        event.isTaken12 = value ?? false;
                      });
                      _saveEvents();
                    },
                    activeColor: event.color, // 체크박스 색상 설정
                  ),
                  const SizedBox(width: 8.0),
                  const Text('12:00'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: event.isTaken15,
                    onChanged: (bool? value) {
                      setState(() {
                        event.isTaken15 = value ?? false;
                      });
                      _saveEvents();
                    },
                    activeColor: event.color, // 체크박스 색상 설정
                  ),
                  const SizedBox(width: 8.0),
                  const Text('15:00'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: event.isTaken18,
                    onChanged: (bool? value) {
                      setState(() {
                        event.isTaken18 = value ?? false;
                      });
                      _saveEvents();
                    },
                    activeColor: event.color, // 체크박스 색상 설정
                  ),
                  const SizedBox(width: 8.0),
                  const Text('18:00'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomDialog extends StatefulWidget {
  final void Function(Map<String, Color>) onOptionSelected;

  const BottomDialog({required this.onOptionSelected, super.key});

  @override
  _BottomDialogState createState() => _BottomDialogState();
}

class _BottomDialogState extends State<BottomDialog> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  void toggleCheck(int index) {
    setState(() {
      if (index == 1) {
        isChecked1 = !isChecked1;
      } else if (index == 2) {
        isChecked2 = !isChecked2;
      } else if (index == 3) {
        isChecked3 = !isChecked3;
      }
    });
  }

  void showSelectedOption() {
    Map<String, Color> selectedOptions = {};
    if (isChecked1) {
      selectedOptions['계정 1'] = AppColors.customBlue;
    }
    if (isChecked2) {
      selectedOptions['계정 2'] = AppColors.customTeal;
    }
    if (isChecked3) {
      selectedOptions['계정 3'] = AppColors.customCyan;
    }

    String selectedOptionText = selectedOptions.isNotEmpty
        ? '선택된 계정: ${selectedOptions.keys.join(', ')}'
        : '선택된 계정이 없습니다';

    print(selectedOptionText);

    widget.onOptionSelected(selectedOptions);

    Navigator.pop(context); // 다이얼로그 닫기
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 가로를 꽉 채우기
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildOptionButton(context, '옵션 1', isChecked1, () => toggleCheck(1),
              AppColors.customBlue),
          Gaps.h10,
          buildOptionButton(context, '옵션 2', isChecked2, () => toggleCheck(2),
              AppColors.customTeal),
          Gaps.h10,
          buildOptionButton(context, '옵션 3', isChecked3, () => toggleCheck(3),
              AppColors.customCyan),
          Gaps.h20,
          buildTextButton(context, '텍스트 버튼 1', showSelectedOption),
        ],
      ),
    );
  }

  Widget buildOptionButton(BuildContext context, String text, bool isChecked,
      VoidCallback onPressed, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // Padding 제거
          elevation: 0, // Elevation 제거
        ),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: isChecked ? color : AppColors.gr150,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
              topRight: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
            border: Border(
              left: BorderSide(
                color: color,
                width: 5.0, // 원하는 두께로 설정
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            children: [
              Icon(
                isChecked
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isChecked ? Colors.white : color,
              ),
              const SizedBox(width: 16.0),
              Text(
                text,
                style: AppTextStyles.body2M16.copyWith(
                  color: isChecked ? Colors.white : color,
                ), // 텍스트 색상 적용
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.deepTeal,
          backgroundColor: AppColors.softTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.body2M16, // 텍스트 스타일 적용
        ),
      ),
    );
  }
}
