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

  // 날짜별 메모 목록
  final Map<DateTime, List<String>> _notes = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  // 날짜 키 정규화(시/분/초 제거)
  DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  // 해당 날짜의 메모 목록
  List<String> _getEventsForDay(DateTime day) {
    return _notes[_dayKey(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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

            final key = _dayKey(selectedDay);

            NoteDialog.showList(
              context,
              day: selectedDay,
              notes: _getEventsForDay(selectedDay),
              onAdd: (text) {
                setState(() {
                  _notes.putIfAbsent(key, () => []);
                  _notes[key]!.add(text);
                });
              },
              onEdit: (index, newText) {
                setState(() {
                  final list = _notes[key];
                  if (list != null && index >= 0 && index < list.length) {
                    list[index] = newText;
                  }
                });
              },
              onDelete: (index) {
                setState(() {
                  final list = _notes[key];
                  if (list != null && index >= 0 && index < list.length) {
                    list.removeAt(index);
                    if (list.isEmpty) {
                      _notes.remove(key);
                    }
                  }
                });
              },
            );
          },

          eventLoader: _getEventsForDay,

          // UI 개선
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black54),
            rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black54),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.redAccent),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return null;
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent.withOpacity(0.8),
                  ),
                  width: 7,
                  height: 7,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
