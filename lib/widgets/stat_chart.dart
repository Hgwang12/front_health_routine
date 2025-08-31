import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatChart extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final List<List<FlSpot>> data;

  const StatChart({
    Key? key,
    required this.selectedIndex,
    required this.labels,
    required this.data,
  }) : super(key: key);

  Color _getColor(int index) {
    switch (index) {
      case 0: return Colors.red;
      case 1: return Colors.green;
      case 2: return Colors.orange;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minY: 20,
          maxY: data[selectedIndex]
              .map((e) => e.y)
              .reduce((a, b) => a > b ? a : b) + 40,
          gridData: const FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
          ),
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
              axisNameWidget: const Text('중량(kg)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              axisNameSize: 28,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: 20,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}주차',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data[selectedIndex],
              isCurved: true,
              color: _getColor(selectedIndex),
              barWidth: 4,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 6,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: _getColor(selectedIndex),
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getColor(selectedIndex).withOpacity(0.3),
                    _getColor(selectedIndex).withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}