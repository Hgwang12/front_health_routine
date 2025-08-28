import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 0;

  final List<String> _labels = ['벤치프레스', '스쿼트', '데드리프트'];

  final List<List<FlSpot>> _mockData = [
    [FlSpot(1, 60), FlSpot(2, 65), FlSpot(3, 70), FlSpot(4, 75)],
    [FlSpot(1, 80), FlSpot(2, 85), FlSpot(3, 90), FlSpot(4, 95)],
    [FlSpot(1, 100), FlSpot(2, 105), FlSpot(3, 110), FlSpot(4, 115)],
  ];

  int get _maxBench => _mockData[0].map((e) => e.y.toInt()).reduce((a, b) => a > b ? a : b);
  int get _maxSquat => _mockData[1].map((e) => e.y.toInt()).reduce((a, b) => a > b ? a : b);
  int get _maxDeadlift => _mockData[2].map((e) => e.y.toInt()).reduce((a, b) => a > b ? a : b);
  int get _total => _maxBench + _maxSquat + _maxDeadlift;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('설정 화면'), // 상단바 텍스트 추가
        backgroundColor: Colors.white,  // 원하는 색상 적용 가능
        elevation: 2,
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
          // 차트 영역 (상단바 아래로)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    minY: 20,
                    maxY: _mockData[_selectedIndex]
                        .map((e) => e.y)
                        .reduce((a, b) => a > b ? a : b) + 40,
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26),
                        top: BorderSide(color: Colors.transparent),
                        right: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        axisNameWidget: const Text('중량(kg)'),
                        axisNameSize: 24,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 10,
                          getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text('주차'),
                        axisNameSize: 24,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: 1,
                          getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // 삭제
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // 삭제
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _mockData[_selectedIndex],
                        isCurved: true,
                        color: _selectedIndex == 0
                            ? Colors.red
                            : _selectedIndex == 1
                            ? Colors.green
                            : Colors.orange,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
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
