import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sopf_front/screens/calendar/calenderPage.dart';

class EventMarker extends StatelessWidget {
  final DateTime day;
  final List<CalendarDetails> events;

  const EventMarker({
    Key? key,
    required this.day,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: events
          .map((event) => Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: event.color,
        ),
      ))
          .toList(),
    );
  }
}
