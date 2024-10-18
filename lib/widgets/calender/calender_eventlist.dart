import 'package:flutter/material.dart';
import 'package:sopf_front/constans/text_styles.dart';
import 'package:sopf_front/screens/calendar/calenderPage.dart';

class EventList extends StatelessWidget {
  final List<CalendarDetails> events;
  final Function() saveEvents;

  const EventList({required this.events, required this.saveEvents, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
                width: 5.0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        saveEvents();
                      },
                      activeColor: Colors.blue,
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
