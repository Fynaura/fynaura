// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class MoneyChart extends StatefulWidget {
//   final List<Map<String, dynamic>> hourlyBalanceData;

//   const MoneyChart({super.key, required this.hourlyBalanceData});

//   @override
//   State<MoneyChart> createState() => _MoneyChartState();
// }

// class _MoneyChartState extends State<MoneyChart> {
//   LineChartData data = LineChartData();
//   List<FlSpot> flSpots = [];

//   @override
//   void initState() {
//     super.initState();
//     setChartData(); // Initialize chart data
//   }

//   void setChartData() {
//     flSpots = widget.hourlyBalanceData.map((item) {
//       final hour = DateTime.parse(item['timestamp']).hour.toDouble();
//       final balance = item['balance'].toDouble();
//       return FlSpot(hour, balance);
//     }).toList();

//     // Force minY to always be 0
//     double minY = 0;

//     double maxY = flSpots.isEmpty
//         ? 10000
//         : flSpots.reduce((a, b) => a.y > b.y ? a : b).y; // Get max Y value

//     // Adjust maxY to have some margin but not too much
//     maxY = maxY + (maxY * 0.1); // Add a 10% margin above the highest point

//     data = LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: const Color.fromARGB(255, 209, 209, 209),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: const Color.fromARGB(255, 209, 209, 209),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             reservedSize: 40,
//             showTitles: true,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         topTitles: AxisTitles(
//             sideTitles: SideTitles(
//           showTitles: false,
//         )),
//         rightTitles: AxisTitles(
//             sideTitles: SideTitles(
//           showTitles: false, // Hide the right Y-axis labels
//           reservedSize: 30, // Set space for right Y axis labels (30 units)
//         )),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 40, // Space for left Y axis labels
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: Colors.black, width: 1),
//       ),
//       minX: 0,
//       maxX: 23, // Display data for 24 hours
//       minY: minY, // Fixed minY value set to 0
//       maxY: maxY, // Adjusted dynamic Y range
//       lineBarsData: [
//         LineChartBarData(
//           isCurved: true,
//           spots: flSpots,
//           isStrokeCapRound: true,
//           dotData: FlDotData(show: false),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [Colors.blue, Colors.green],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               tileMode: TileMode.clamp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     final hour = value.toInt();
//     return SideTitleWidget(
//       meta: meta,
//       child: Text(
//         '$hour:00',
//         style: TextStyle(
//           color: Colors.grey,
//           fontWeight: FontWeight.bold,
//           fontSize: 8,
//         ),
//       ),
//     );
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     return SideTitleWidget(
//       meta: meta,
//       child: Text(
//         value.toStringAsFixed(0), // Adjust the Y value to string with fixed decimals
//         style: TextStyle(
//           color: Colors.grey,
//           fontWeight: FontWeight.bold,
//           fontSize: 8, // Adjust the font size for the Y-axis labels here
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       height: 250,
//       padding: EdgeInsets.only(top: 10, right: 20),
//       child: LineChart(data),
//     );
//   }
// }
