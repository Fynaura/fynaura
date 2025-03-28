import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/testana/line_tiles.dart';

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Fixed Y-Axis Labels
        SizedBox(
          width: 40,
          height: 300,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 0,
              minY: 0,
              maxY: 6,
              
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 1:
                          return Text(
                            '10k',
                            style: TextStyle(
                              color: Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          );
                        case 3:
                          return Text(
                            '30k',
                            style: TextStyle(
                              color: Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          );
                        case 5:
                          return Text(
                            '50k',
                            style: TextStyle(
                              color: Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          );
                        default:
                          return Text('');
                      }
                    },
                    interval: 1,
                  ),
                ),
              ),
              
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              
              lineBarsData: [], // No actual line data
            ),
          ),
        ),
        
        // Scrollable Chart
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 800, // Adjust width to accommodate all data points
              height: 300,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: 6,
                  
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text(
                                'JAN',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 1:
                              return Text(
                                'FEB',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 2:
                              return Text(
                                'MAR',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 3:
                              return Text(
                                'APR',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 4:
                              return Text(
                                'MAY',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 5:
                              return Text(
                                'JUN',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 6:
                              return Text(
                                'JUL',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 7:
                              return Text(
                                'AUG',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 8:
                              return Text(
                                'SEP',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 9:
                              return Text(
                                'OCT',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 10:
                              return Text(
                                'NOV',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            case 11:
                              return Text(
                                'DEC',
                                style: TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              );
                            default:
                              return Text('');
                          }
                        },
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xff37434d),
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: true,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: const Color(0xff37434d),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1.6, 2),
                        FlSpot(2.9, 5),
                        FlSpot(3.8, 2.5),
                        FlSpot(4, 4),
                        FlSpot(5.5, 3),
                        FlSpot(6, 4),
                        FlSpot(7, 3),
                        FlSpot(8.6, 2),
                        FlSpot(9.9, 5),
                        FlSpot(10.8, 2.5),
                        FlSpot(11, 4),
                      ],
                      isCurved: true,
                      barWidth: 5,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                    ),
                  ],
                  
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '${barSpot.y.toStringAsFixed(2)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}