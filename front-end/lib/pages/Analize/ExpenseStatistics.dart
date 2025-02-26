import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

void main() {
  runApp(ExpenseStatisticsApp());
}

class ExpenseStatisticsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseStatisticsScreen(),
    );
  }
}

class ExpenseStatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Data for the pie chart
    final Map<String, double> dataMap = {


      "Food": 30,
      "Bill Expense": 15,
      "Grocery": 20,
      "Others": 35,
    };

    // Colors for each section of the pie chart
    final List<Color> colorList = [
      Colors.blueGrey,
      Colors.orange,
      Colors.pink,
      Colors.blue,
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Expense Statistics"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Expense Statistics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                PieChart(
                  dataMap: dataMap,
                  chartType: ChartType.ring, // Donut-style chart
                  colorList: colorList,
                  chartRadius: MediaQuery.of(context).size.width / 2.5,
                  ringStrokeWidth: 32,
                  animationDuration: Duration(milliseconds: 800),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    decimalPlaces: 0,
                    showChartValuesOutside: false,
                  ),
                  legendOptions: LegendOptions(
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    legendPosition: LegendPosition.bottom,
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
