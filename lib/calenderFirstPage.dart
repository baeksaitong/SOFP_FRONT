import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MaterialApp(
    title: 'Calendar App',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: CalendarPage(),
  ));
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<String>> _events = {
    DateTime(2024, 3, 15): ['Event 1', 'Event 2'],
    DateTime(2024, 3, 22): ['Event 3'],
    // Add more events here
  };

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_focusedDay.year}년 ${_focusedDay.month}월'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay);
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index]),
          leading: Icon(Icons.event),
        );
      },
    );
  }
}
