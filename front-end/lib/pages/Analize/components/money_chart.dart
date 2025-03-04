import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoneyChart extends StatefulWidget {
  const MoneyChart({super.key});

  @override
  State<MoneyChart> createState() => _MoneyChartState();
}

class _MoneyChartState extends State<MoneyChart> {
  LineChartData data = LineChartData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 250,
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
      ),
      child: LineChart(data),
    );
  }
}
