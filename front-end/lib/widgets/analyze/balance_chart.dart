// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class BalanceChart extends StatelessWidget {
//   final List<Map<String, dynamic>> balanceData; // Hourly balance data
//   final String selectedFilter; // To differentiate between Today, Week, and Month
//
//   const BalanceChart({super.key, required this.balanceData, required this.selectedFilter});
//
//   @override
//   Widget build(BuildContext context) {
//     List<FlSpot> flSpots = balanceData.map((item) {
//       final xValue = DateTime.parse(item['timestamp']).hour.toDouble(); // Default to hour
//       final balance = item['balance'].toDouble();
//       return FlSpot(xValue, balance);
//     }).toList();
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       height: 250,
//       padding: EdgeInsets.only(top: 10, right: 20),
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(
//             show: true,
//             drawVerticalLine: true,
//             getDrawingHorizontalLine: (value) {
//               return FlLine(
//                 color: const Color.fromARGB(255, 209, 209, 209),
//                 strokeWidth: 1,
//               );
//             },
//             getDrawingVerticalLine: (value) {
//               return FlLine(
//                 color: const Color.fromARGB(255, 209, 209, 209),
//                 strokeWidth: 1,
//               );
//             },
//           ),
//           titlesData: FlTitlesData(
//             show: true,
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 reservedSize: 40,
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   if (selectedFilter == 'Today') {
//                     // Show hours for Today
//                     final hour = value.toInt();
//                     return SideTitleWidget(
//                       meta: meta,
//                       child: Text(
//                         '$hour:00',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 8,
//                         ),
//                       ),
//                     );
//                   } else if (selectedFilter == 'This Week') {
//                     // Show weekdays for This Week
//                     List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//                     final dayOfWeek = value.toInt();
//                     return SideTitleWidget(
//                       meta: meta,
//                       child: Text(
//                         weekdays[dayOfWeek],
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 8,
//                         ),
//                       ),
//                     );
//                   } else if (selectedFilter == 'This Month') {
//                     // Show days of the month for This Month
//                     final dayOfMonth = value.toInt();
//                     return SideTitleWidget(
//                       meta: meta,
//                       child: Text(
//                         '$dayOfMonth',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 8,
//                         ),
//                       ),
//                     );
//                   }
//                   return const SizedBox();
//                 },
//               ),
//             ),
//             topTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: false,
//               ),
//             ),
//             rightTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: false, // Hide the right Y-axis labels
//                 reservedSize: 30,
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   return SideTitleWidget(
//                     meta: meta,
//                     child: Text(
//                       value.toStringAsFixed(0),
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 8,
//                       ),
//                     ),
//                   );
//                 },
//                 reservedSize: 40,
//               ),
//             ),
//           ),
//           borderData: FlBorderData(
//             show: true,
//             border: Border.all(color: Colors.black, width: 1),
//           ),
//           minX: 0,
//           maxX: selectedFilter == 'Today' ? 23 : (selectedFilter == 'This Week' ? 6 : 31), // Max for Today is 23 hours, Week is 6 days, Month is 31 days
//           minY: 0,
//           maxY: flSpots.isEmpty ? 10000 : flSpots.reduce((a, b) => a.y > b.y ? a : b).y + 100, // Dynamic Y range
//           lineBarsData: [
//             LineChartBarData(
//               isCurved: true,
//               spots: flSpots,
//               isStrokeCapRound: true,
//               dotData: FlDotData(show: false),
//               belowBarData: BarAreaData(
//                 show: true,
//                 gradient: LinearGradient(
//                   colors: [Colors.blue, Colors.green],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   tileMode: TileMode.clamp,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
