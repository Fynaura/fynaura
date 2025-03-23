// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:fynaura/pages/Analize/TransactionModel.dart';
//
// class PieChartSample2 extends StatefulWidget {
//   final List<Transaction> transactions; // Store transactions passed to the widget
//
//   const PieChartSample2({super.key, required this.transactions});
//
//   @override
//   State<StatefulWidget> createState() => PieChart2State();
// }
//
// class PieChart2State extends State<PieChartSample2> {
//   int touchedIndex = -1;
//
//   // This method will calculate the total amounts per category
//   Map<String, double> _getCategoryAmounts() {
//     Map<String, double> categoryAmounts = {};
//     for (var transaction in widget.transactions) {
//       if (transaction.type == 'expense') {
//         if (categoryAmounts.containsKey(transaction.category)) {
//           categoryAmounts[transaction.category] =
//               categoryAmounts[transaction.category]! + transaction.amount;
//         } else {
//           categoryAmounts[transaction.category] = transaction.amount;
//         }
//       }
//     }
//     return categoryAmounts;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Get category amounts to be used in the pie chart
//     Map<String, double> categoryAmounts = _getCategoryAmounts();
//     List<PieChartSectionData> sections = _createSections(categoryAmounts);
//
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Column(
//         children: [
//           const SizedBox(height: 18),
//           Expanded(
//             flex: 2,
//             child: AspectRatio(
//               aspectRatio: 1,
//               child: PieChart(
//                 PieChartData(
//                   pieTouchData: PieTouchData(
//                     touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                       setState(() {
//                         if (!event.isInterestedForInteractions ||
//                             pieTouchResponse == null ||
//                             pieTouchResponse.touchedSection == null) {
//                           touchedIndex = -1;
//                           return;
//                         }
//                         touchedIndex =
//                             pieTouchResponse.touchedSection!.touchedSectionIndex;
//                       });
//                     },
//                   ),
//                   borderData: FlBorderData(show: false),
//                   sectionsSpace: 0,
//                   centerSpaceRadius: 50,
//                   sections: sections,
//                 ),
//               ),
//             ),
//           ),
//           // Scrollable labels section below the pie chart
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 15.0, bottom: 10),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: _buildCategoryLabels(categoryAmounts),
//               ),
//             ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Create pie chart sections dynamically based on category amounts
//   List<PieChartSectionData> _createSections(Map<String, double> categoryAmounts) {
//     List<PieChartSectionData> sections = [];
//     double totalAmount = categoryAmounts.values.fold(0, (sum, amount) => sum + amount);
//
//     categoryAmounts.forEach((category, amount) {
//       double percentage = (amount / totalAmount) * 100;
//       Color sectionColor = _getCategoryColor(category);
//
//
//       sections.add(
//         PieChartSectionData(
//           color: sectionColor,
//           value: percentage,
//           title: '${percentage.toStringAsFixed(1)}%',
//           radius: 55,
//           titleStyle: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             shadows: [
//               Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 4)
//             ],
//
//           ),
//
//         ),
//
//       );
//     });
//
//     return sections;
//   }
//
//   // Helper function to return a color based on the category
//   Color _getCategoryColor(String category) {
//     switch (category.toLowerCase()) {
//       case 'grocery':
//         return Colors.pinkAccent;
//       case 'food':
//         return Colors.blueAccent;
//       case 'entertainment':
//         return Colors.deepOrangeAccent;
//       case 'transport':
//         return Colors.purpleAccent;
//       case 'utilities':
//         return Colors.cyanAccent;
//       case 'shopping':
//         return Colors.greenAccent;
//       case 'education':
//         return Colors.yellowAccent;
//       case 'health':
//         return Colors.tealAccent;
//       case 'subscriptions':
//         return Colors.amberAccent;
//       case 'salary':
//         return Colors.blueGrey;
//       case 'rent':
//         return Colors.brown;
//       default:
//         return Colors.grey;
//     }
//   }
//
//
//   // Helper function to build category labels below the chart
//   List<Widget> _buildCategoryLabels(Map<String, double> categoryAmounts) {
//     List<Widget> labels = [];
//     categoryAmounts.forEach((category, amount) {
//       labels.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//           child: Row(
//             children: [
//               Container(
//                 height: 25,
//                 width: 25,
//                 color: _getCategoryColor(category),
//               ),
//               SizedBox(width: 15),
//               Text(
//                 "$category: LKR ${amount.toStringAsFixed(2)}",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//     return labels;
//   }
// }
