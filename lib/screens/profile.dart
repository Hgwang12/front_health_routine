import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/stat_chart.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 0;

  static const List<String> _labels = ['벤치프레스', '스쿼트', '데드리프트'];

  static const List<List<FlSpot>> _mockData = [
    [FlSpot(1, 60), FlSpot(2, 65), FlSpot(3, 70), FlSpot(4, 75)],
    [FlSpot(1, 80), FlSpot(2, 85), FlSpot(3, 90), FlSpot(4, 95)],
    [FlSpot(1, 100), FlSpot(2, 105), FlSpot(3, 110), FlSpot(4, 115)],
  ];

  late final int _maxBench;
  late final int _maxSquat;
  late final int _maxDeadlift;
  late final int _total;

  @override
  void initState() {
    super.initState();
    _maxBench = _mockData[0].map((e) => e.y.toInt()).reduce((a, b) => a > b ? a : b);
    _maxSquat = _mockData[1].map((e) => e.y.toInt()).reduce((a, b) => a > b ? a : b);
    _maxDeadlift = _mockData[2].map((e) => e.y.toInt()).reduce((a, b) => a > b ? a : b);
    _total = _maxBench + _maxSquat + _maxDeadlift;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.bar_chart, color: Colors.blue, size: 20),
                  SizedBox(width: 6),
                  Text('차트', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.grey),
              iconSize: 22,
              onPressed: () {
                // 설정 페이지로 이동 또는 설정 메뉴 표시
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // 운동 선택
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_labels.length, (index) {
              Color color;
              if (index == 0) color = Colors.red;
              else if (index == 1) color = Colors.green;
              else color = Colors.orange;

              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Column(
                  children: [
                    Text(
                      _labels[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedIndex == index ? color : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 3,
                      width: 60,
                      color: _selectedIndex == index ? color : Colors.transparent,
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          // 차트 영역
          Expanded(
            child: StatChart(
              selectedIndex: _selectedIndex,
              labels: _labels,
              data: _mockData,
            ),
          ),
          // 하단 최고기록 고정
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('벤치프레스'),
                    Text('$_maxBench kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text('스쿼트'),
                    Text('$_maxSquat kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text('데드리프트'),
                    Text('$_maxDeadlift kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text('3대 중량'),
                    Text('$_total kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
