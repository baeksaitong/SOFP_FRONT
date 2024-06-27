// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

// Project imports:
import 'package:sopf_front/managers/managers_api_client.dart';
import 'package:sopf_front/providers/provider.dart';
import 'package:sopf_front/screens/search/search_shape.dart';
import '../../constans/colors.dart';
import '../../constans/text_styles.dart';
import '../../constans/gaps.dart';

class CalendarDetails {
  final String id;
  final String name;
  final bool alarm;
  final String period;
  final List<String> intakeTimeList;
  final Color color; // 색상 필드 추가

  CalendarDetails({
    required this.id,
    required this.name,
    required this.alarm,
    required this.period,
    required this.intakeTimeList,
    required this.color, // 색상 필드 추가
  });

  factory CalendarDetails.fromJson(Map<String, dynamic> json, Color color) {
    return CalendarDetails(
      id: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      alarm: json['alarm'] ?? true,
      period: json['period'] ?? '',
      intakeTimeList: List<String>.from(json['intakeTime'] ?? []),
      color: color, // 색상 필드 추가
    );
  }

  factory CalendarDetails.fromJsonWithColor(Map<String, dynamic> json) {
    return CalendarDetails(
      id: json['id'],
      name: json['name'],
      alarm: json['alarm'],
      period: json['period'],
      intakeTimeList: List<String>.from(json['intakeTimeList']),
      color: Color(int.parse(json['color'])),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'alarm': alarm,
    'period': period,
    'intakeTimeList': intakeTimeList,
    'color': color.value.toString(), // 색상 필드 추가
  };
}

class CalendarDetailsManager {
  static final CalendarDetailsManager _instance = CalendarDetailsManager._internal();

  CalendarDetails? currentCalendar;
  Map<String, CalendarDetails> calendarDetailsMap = {};

  factory CalendarDetailsManager() {
    return _instance;
  }

  CalendarDetailsManager._internal();

  void updateCalendarDetails(String jsonResponse, Color color) {
    final data = jsonDecode(jsonResponse);
    currentCalendar = CalendarDetails.fromJson(data, color);
  }

  CalendarDetails? getCategoryDetails(String categoryId) {
    return calendarDetailsMap[categoryId];
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay; // 현재 집중된 날짜
  late DateTime _selectedDay; // 선택된 날짜
  CalendarFormat _calendarFormat = CalendarFormat.month; // 달력 형식 (월간)
  Map<DateTime, List<CalendarDetails>> _events = {}; // 약 이벤트 데이터
  String _selectedAccount = ''; // 선택된 계정
  Color _selectedColor = AppColors.customBlue; // 선택된 계정 색상
  List<String> _selectedProfileIds = []; // 선택된 프로필 ID 리스트
  final APIClient apiClient = APIClient();

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now(); // 현재 날짜로 초기화
    _selectedDay = _focusedDay; // 선택된 날짜도 현재 날짜로 초기화
    _loadEvents();
    _loadSelectedProfiles(); // 선택된 프로필 로드
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting().then((_) {
      setState(() {});
    });
  }

  // 다이얼로그 열었을때 하단시트 없애는 기능
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return BottomDialog(
          onOptionSelected: (selectedAccounts, selectedProfileIds) {
            _onOptionSelected(selectedAccounts, selectedProfileIds);
          },
        );
      },
    );
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
  List<CalendarDetails> _getEventsForDay(DateTime day) {
    final dayWithoutTime = DateTime(day.year, day.month, day.day);
    print("Getting events for day: $dayWithoutTime"); // 디버깅용 출력
    print("Events: ${_events[dayWithoutTime]}"); // 디버깅용 출력
    return _events[dayWithoutTime] ?? [];
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
          icon: Image.asset(
            'assets/calendar.png',
            width: 30,
            height: 30,
          ),
          onPressed: _showBottomSheet,
        ),
      ],
    );
  }

  Future<void> _onOptionSelected(Map<String, Color> selectedAccounts, List<String> selectedProfileIds) async {
    setState(() {
      _selectedAccount = selectedAccounts.keys.join(', ');
      _selectedColor = selectedAccounts.values.first;
      _selectedProfileIds = selectedProfileIds;
    });

    await _saveSelectedProfiles(); // 선택된 프로필 저장
    await _loadProfileEvents(selectedProfileIds, _focusedDay);

    // 로컬에 저장
    await _saveEvents();
  }

  Future<void> _loadProfileEvents(List<String> profileIds, DateTime month) async {
    Map<DateTime, List<CalendarDetails>> loadedEvents = {};
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profiles = profileProvider.profileList;

    for (String profileId in profileIds) {
      final profile = profiles.firstWhere((p) => p.id == profileId);
      Color profileColor = getColorFromText(profile.color) ?? Colors.grey; // 프로필 색상 가져오기

      for (String day in ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']) {
        String response = await apiClient.categoryDayGet(context, profileId, day);
        print("요일 카테고리 조회 성공: $response"); // 디버깅용 출력
        if (response.isNotEmpty) {
          Map<String, dynamic> jsonMap = jsonDecode(response);
          if (jsonMap['categoryList'] != null) {
            Map<String, dynamic> categoryList = jsonMap['categoryList'];
            categoryList.forEach((key, value) {
              List<dynamic> jsonList = value;
              List<CalendarDetails> events = jsonList.map((json) {
                try {
                  return CalendarDetails.fromJson(json, profileColor);
                } catch (e) {
                  print("Error parsing event: $e"); // 디버깅용 출력
                  return null;
                }
              }).where((event) => event != null).toList().cast<CalendarDetails>();

              for (CalendarDetails event in events) {
                DateTime startDate = DateTime(month.year, month.month, 1);
                DateTime endDate = _getEndOfMonth(startDate);
                DateTime currentDate = startDate;

                while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
                  if (currentDate.weekday == _dayMapping[day]) {
                    final eventDateWithoutTime = DateTime(currentDate.year, currentDate.month, currentDate.day);
                    print("Adding event on date: $eventDateWithoutTime"); // 디버깅용 출력
                    if (loadedEvents.containsKey(eventDateWithoutTime)) {
                      loadedEvents[eventDateWithoutTime]!.add(event);
                    } else {
                      loadedEvents[eventDateWithoutTime] = [event];
                    }
                  }
                  currentDate = currentDate.add(Duration(days: 1)); // 하루씩 더함
                }
              }
            });
          }
        }
      }
    }

    setState(() {
      _events.addAll(loadedEvents);
    });
    print("Loaded Events: $_events"); // 디버깅용 출력
  }

  DateTime _getEndOfMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return lastDay;
  }

  // 요일 약어를 DateTime의 weekday 값으로 매핑하는 함수
  final Map<String, int> _dayMapping = {
    'MON': DateTime.monday,
    'TUE': DateTime.tuesday,
    'WED': DateTime.wednesday,
    'THU': DateTime.thursday,
    'FRI': DateTime.friday,
    'SAT': DateTime.saturday,
    'SUN': DateTime.sunday,
  };

  DateTime _getNextDateForDay(DateTime fromDate, String day) {
    int dayOfWeek = _dayMapping[day]!;
    int daysUntilNextDay = (dayOfWeek - fromDate.weekday + 7) % 7;
    if (daysUntilNextDay == 0) {
      daysUntilNextDay = 7; // 현재 날짜를 포함하지 않도록 설정
    }
    return fromDate.add(Duration(days: daysUntilNextDay));
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
                .map((e) => CalendarDetails.fromJsonWithColor(e))
                .toList()));
      });
    }
  }

  // 선택된 프로필을 로컬 저장소에 저장하는 함수
  Future<void> _saveSelectedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedProfiles', _selectedProfileIds);
  }

  // 선택된 프로필을 로컬 저장소에서 불러오는 함수
  Future<void> _loadSelectedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedProfilesList = prefs.getStringList('selectedProfiles') ?? [];
    setState(() {
      _selectedProfileIds = selectedProfilesList;
      // 불러온 프로필로 이벤트 다시 로드
      if (_selectedProfileIds.isNotEmpty) {
        _onOptionSelected({for (var id in _selectedProfileIds) id: _selectedColor}, _selectedProfileIds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
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
                    setState(() {
                      _focusedDay = focusedDay; // Update the focused day and call setState to update the UI
                      _loadProfileEvents(_selectedProfileIds, _focusedDay);
                    });
                  },
                  eventLoader: _getEventsForDay, // 이벤트 로더 설정
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false, // 달력 외부의 날짜를 숨김
                    cellMargin: const EdgeInsets.all(2.0), // 날짜 셀의 마
                    cellPadding: const EdgeInsets.only(
                        top: 1.0, bottom: 5.0), // 날짜 셀의 패딩을 위쪽으로 설정
                    defaultTextStyle: AppTextStyles.caption3M10, // 기본 텍스트 스타일 적용
                    weekendTextStyle: AppTextStyles.caption3M10, // 주말 텍스트 스타일 적용
                    selectedDecoration: BoxDecoration(
                      color: AppColors.gr150,
                      shape: BoxShape.rectangle, // Circular shape
                      border: Border.all(
                        color: _selectedColor,
                        width: 0.5,
                      ),
                    ),
                    selectedTextStyle: AppTextStyles.caption3M10, // 선택된 날짜 텍스트 스타일 적용
                    todayTextStyle: AppTextStyles.caption3M10.copyWith(
                        color: AppColors.deepTeal), // 오늘 날짜 텍스트 스타일 적용
                    todayDecoration: const BoxDecoration(),
                    holidayTextStyle: AppTextStyles.caption3M10, // 공휴일 텍스트 스타일 적용
                    cellAlignment: Alignment.topCenter, // 셀의 정렬을 위쪽 가운데로 설정
                  ),
                  daysOfWeekHeight: 50, // 요일 행의 높이 설정
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: AppTextStyles.body2M16, // 평일 텍스트 스타일 적용
                    weekendStyle: AppTextStyles.body2M16, // 주말 텍스트 스타일 적용
                    dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date), // 요일 텍스트 형식 설정
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
                          bottom: 10, // Adjust the bottom position to center it below the number
                          left: 0, // Align markers centrally
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Center the markers
                            children: events.map((event) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.75), // Marker spacing
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (event as CalendarDetails).color, // Use the event's color
                                ),
                                width: 8.0,
                                height: 8.0,
                              );
                            }).toList(),
                          ),
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
            color: (event as CalendarDetails).color, // 각 이벤트의 색상 사용
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
                color: event.color, // 이벤트 색상 사용
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
              ...event.intakeTimeList.map((time) {
                return Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (bool? value) {
                        setState(() {
                          // Check if any of the intake times have been taken
                        });
                        _saveEvents();
                      },
                      activeColor: Colors.blue, // 체크박스 색상 설정
                    ),
                    const SizedBox(width: 8.0),
                    Text(time),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class BottomDialog extends StatefulWidget {
  final void Function(Map<String, Color>, List<String>) onOptionSelected;

  const BottomDialog({required this.onOptionSelected, super.key});

  @override
  _BottomDialogState createState() => _BottomDialogState();
}

class _BottomDialogState extends State<BottomDialog> {
  late Map<String, bool> selectedProfiles;
  final APIClient apiClient = APIClient();

  @override
  void initState() {
    super.initState();
    selectedProfiles = {};
    _loadSelectedProfiles(); // 선택된 프로필 로드
  }

  // 선택된 프로필을 로컬 저장소에서 불러오는 함수
  Future<void> _loadSelectedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedProfilesList = prefs.getStringList('selectedProfiles') ?? [];
    setState(() {
      selectedProfiles = {for (var id in selectedProfilesList) id: true};
    });
  }

  void toggleCheck(String profileId) {
    setState(() {
      selectedProfiles[profileId] = !(selectedProfiles[profileId] ?? false);
      if (!selectedProfiles.containsValue(true)) {
        // 모든 프로필이 선택 해제되었을 때 선택 완료
        showSelectedOption();
      }
    });
  }

  void showSelectedOption() {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profiles = profileProvider.profileList;
    Map<String, Color> selectedOptions = {};
    List<String> selectedProfileIds = [];

    for (var profile in profiles) {
      if (selectedProfiles[profile.id] == true) {
        selectedOptions[profile.name] = getColorFromText(profile.color)!;
        selectedProfileIds.add(profile.id);
      }
    }

    String selectedOptionText = selectedOptions.isNotEmpty
        ? '선택된 계정: ${selectedOptions.keys.join(', ')}'
        : '선택된 계정이 없습니다';

    print(selectedOptionText); // 선택된 텍스트들 출력

    widget.onOptionSelected(selectedOptions, selectedProfileIds);

    Navigator.pop(context); // 다이얼로그 닫기
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profiles = profileProvider.profileList;

    return Container(
      width: double.infinity, // 가로를 꽉 채우기
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...profiles.map((profile) {
            bool isChecked = selectedProfiles[profile.id] ?? false;
            return Column(
              children: [
                buildOptionButton(
                  context,
                  profile.name,
                  isChecked,
                      () => toggleCheck(profile.id),
                  getColorFromText(profile.color) ?? Colors.grey,
                ),
                Gaps.h10,
              ],
            );
          }).toList(),
          Gaps.h20,
          buildTextButton(context, '선택 완료', showSelectedOption),
        ],
      ),
    );
  }

  Widget buildOptionButton(BuildContext context, String text, bool isChecked, VoidCallback onPressed, Color color) {
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

  Widget buildTextButton(BuildContext context, String text, VoidCallback onPressed) {
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
