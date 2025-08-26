import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/theme.dart';
import 'note_dialog.dart';

class RoutineCard extends StatefulWidget {
  const RoutineCard({Key? key}) : super(key: key);

  @override
  _RoutineCardState createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  // 날짜별 메모 다중 저장
  Map<DateTime, List<String>> _notes = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  List<String> _getEventsForDay(DateTime day) {
    return _notes[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar<String>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            // 선택 날짜의 메모 목록 팝업
            NoteDialog.showList(
              context,
              day: selectedDay,
              notes: _getEventsForDay(selectedDay),
              onAdd: (text) {
                setState(() {
                  final key = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                  if (_notes[key] == null) {
                    _notes[key] = [text];
                  } else {
                    _notes[key]!.add(text);
                  }
                });
              },
            );
          },
          eventLoader: _getEventsForDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      events.length.clamp(0, 3), // 최대 3개 점까지만 표시
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.purple, // 점 색상
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(color: Colors.white),
            selectedTextStyle: const TextStyle(color: Colors.white),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
        ),
      ),
    );
  }
}
