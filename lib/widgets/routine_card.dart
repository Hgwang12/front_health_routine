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

            final key = _dayKey(selectedDay);

            // 메모 목록 다이얼로그 호출 (추가/수정/삭제 콜백 연결)
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

          // 메모 개수 로딩(점 표시용)
          eventLoader: _getEventsForDay,

          // 날짜 아래 점(메모 수 만큼, 최대 3개)
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return null;
              final count = events.length.clamp(0, 3);
              return Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    count,
                        (_) => Container(
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
