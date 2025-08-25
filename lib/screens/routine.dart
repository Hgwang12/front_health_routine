import 'package:flutter/material.dart';
import '../widgets/routine_card.dart';

class Routine extends StatelessWidget {
  const Routine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('루틴 화면')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            RoutineCard(),
            SizedBox(height: 20),
            // 운동 기록 리스트, 버튼 등 추가 가능
          ],
        ),
      ),
    );
  }
}
