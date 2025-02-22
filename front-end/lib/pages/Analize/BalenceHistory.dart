import "package:fl_chart/fl_chart.dart";
import 'package:flutter/material.dart' show AppBar, Border, BorderRadius, BuildContext, Card, Colors, Column, CrossAxisAlignment, EdgeInsets, Expanded, FontWeight, MaterialApp, Padding, RoundedRectangleBorder, Scaffold, SizedBox, StatelessWidget, Text, TextStyle, Widget, runApp;

void main() {
  runApp(BalanceHistoryApp());
}

class BalanceHistoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BalanceHistoryScreen(),
    );
  }
}

class BalanceHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Balance History"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Balance History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 200000,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine: (value) => FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 48,
                          getTextStyles: (context, value) => const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          getTitles: (value) {
                            if (value == 0) {
                              return '0';
                            } else if (value == 200000) {
                              return '200,000';
                            } else if (value == 400000) {
                              return '400,000';
                            } else if (value == 600000) {
                              return '600,000';
                            } else if (value == 800000) {
                              return '800,000';
                            }
                            return '';
                          },
                          margin: 8,
                        ),
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTextStyles: (context, value) => const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          getTitles: (value) {
                            if (value == 6) {
                              return '06:00';
                            } else if (value == 9) {
                              return '09:00';
                            } else if (value == 12) {
                              return '12:00';
                            } else if (value == 15) {
                              return '15:00';
                            } else if (value == 18) {
                              return '18:00';
                            } else if (value == 21) {
                              return '21:00';
                            } else if (value == 24) {
                              return '00:00';
                            }
                            return '';
                          },
                          margin: 8,
                        ),
                        rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      minX: 6,
                      maxX: 24,
                      minY: 0,
                      maxY: 800000,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(6, 300000),
                            FlSpot(9, 700000),
                            FlSpot(12, 500000),
                            FlSpot(15, 800000),
                            FlSpot(18, 600000),
                            FlSpot(21, 700000),
                            FlSpot(24, 500000),
                          ],
                          isCurved: true,
                          colors: [Colors.blue],
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(
                            show: true,
                            colors: [
                              Colors.blue.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
