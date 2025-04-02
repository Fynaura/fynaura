import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/TransactionModel.dart';
import 'package:intl/intl.dart';

class FinancialTrackerCharts extends StatelessWidget {
  final List<Transaction> transactions;
  final String selectedFilter;

  const FinancialTrackerCharts({
    super.key,
    required this.transactions,
    required this.selectedFilter,
  });

  // Get maximum Y value for chart scaling
  double get maxY {
    if (transactions.isEmpty) return 1000; // Default if no transactions
    
    double maxIncome = 0;
    double maxExpense = 0;
    
    final groupedData = _getGroupedData();
    
    for (var data in groupedData) {
      if (data.income > maxIncome) maxIncome = data.income;
      if (data.expense > maxExpense) maxExpense = data.expense;
    }
    
    return (maxIncome > maxExpense ? maxIncome : maxExpense) * 1.2; // 20% margin
  }

  // Get current data based on selected filter
  List<FinancialData> _getGroupedData() {
    if (transactions.isEmpty) {
      return _getEmptyData();
    }

    // Group transactions by day, week, or month based on selectedFilter
    if (selectedFilter == 'Today') {
      return _getHourlyData();
    } else if (selectedFilter == 'This Week') {
      return _getDailyData();
    } else { // This Month
      return _getWeeklyData();
    }
  }

  // Return empty data when no transactions are available
  List<FinancialData> _getEmptyData() {
    if (selectedFilter == 'Today') {
      // For today, show hourly data (6 hour intervals)
      return [
        FinancialData(label: '00:00', income: 0, expense: 0),
        FinancialData(label: '06:00', income: 0, expense: 0),
        FinancialData(label: '12:00', income: 0, expense: 0),
        FinancialData(label: '18:00', income: 0, expense: 0),
      ];
    } else if (selectedFilter == 'This Week') {
      // For week, show daily data
      return [
        FinancialData(label: 'Mon', income: 0, expense: 0),
        FinancialData(label: 'Tue', income: 0, expense: 0),
        FinancialData(label: 'Wed', income: 0, expense: 0),
        FinancialData(label: 'Thu', income: 0, expense: 0),
        FinancialData(label: 'Fri', income: 0, expense: 0),
        FinancialData(label: 'Sat', income: 0, expense: 0),
        FinancialData(label: 'Sun', income: 0, expense: 0),
      ];
    } else {
      // For month, show weekly data
      return [
        FinancialData(label: 'Week 1', income: 0, expense: 0),
        FinancialData(label: 'Week 2', income: 0, expense: 0),
        FinancialData(label: 'Week 3', income: 0, expense: 0),
        FinancialData(label: 'Week 4', income: 0, expense: 0),
      ];
    }
  }

  // Group transactions by hour for today's view
  List<FinancialData> _getHourlyData() {
    // Create 4 time slots for the day (6-hour intervals)
    Map<String, FinancialData> hourlyData = {
      '00:00': FinancialData(label: '00:00', income: 0, expense: 0),
      '06:00': FinancialData(label: '06:00', income: 0, expense: 0),
      '12:00': FinancialData(label: '12:00', income: 0, expense: 0),
      '18:00': FinancialData(label: '18:00', income: 0, expense: 0),
    };

    for (var transaction in transactions) {
      String timeSlot;
      final hour = transaction.date.hour;
      
      if (hour >= 0 && hour < 6) {
        timeSlot = '00:00';
      } else if (hour >= 6 && hour < 12) {
        timeSlot = '06:00';
      } else if (hour >= 12 && hour < 18) {
        timeSlot = '12:00';
      } else {
        timeSlot = '18:00';
      }

      if (transaction.type == 'income') {
        hourlyData[timeSlot]!.income += transaction.amount;
      } else {
        hourlyData[timeSlot]!.expense += transaction.amount;
      }
    }

    return hourlyData.values.toList();
  }

  // Group transactions by day for weekly view
  List<FinancialData> _getDailyData() {
    // Initialize data for each day of the week
    final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    Map<String, FinancialData> dailyData = {};
    
    for (int i = 0; i < 7; i++) {
      dailyData[weekdayNames[i]] = FinancialData(
        label: weekdayNames[i],
        income: 0,
        expense: 0,
      );
    }

    for (var transaction in transactions) {
      final weekday = weekdayNames[transaction.date.weekday - 1]; // 1-7 to 0-6
      
      if (transaction.type == 'income') {
        dailyData[weekday]!.income += transaction.amount;
      } else {
        dailyData[weekday]!.expense += transaction.amount;
      }
    }

    return weekdayNames.map((day) => dailyData[day]!).toList();
  }

  // Group transactions by week for monthly view
  List<FinancialData> _getWeeklyData() {
    Map<int, FinancialData> weeklyData = {
      1: FinancialData(label: 'Week 1', income: 0, expense: 0),
      2: FinancialData(label: 'Week 2', income: 0, expense: 0),
      3: FinancialData(label: 'Week 3', income: 0, expense: 0),
      4: FinancialData(label: 'Week 4', income: 0, expense: 0),
    };

    DateTime now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    for (var transaction in transactions) {
      // Calculate which week of the month this transaction belongs to
      final dayDifference = transaction.date.difference(firstDayOfMonth).inDays;
      final weekOfMonth = (dayDifference / 7).floor() + 1;
      
      // Cap at week 4 (for simplicity)
      final week = weekOfMonth > 4 ? 4 : weekOfMonth;
      
      if (transaction.type == 'income') {
        weeklyData[week]!.income += transaction.amount;
      } else {
        weeklyData[week]!.expense += transaction.amount;
      }
    }

    return [1, 2, 3, 4].map((week) => weeklyData[week]!).toList();
  }

  // Get total income for current period
  double get totalIncome {
    return transactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Get total expense for current period
  double get totalExpense {
    return transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _getGroupedData();
    
    return Column(
      children: [
        // Summary cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  "Total Income",
                  totalIncome,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  "Total Expenses",
                  totalExpense,
                  Colors.red,
                ),
              ),
            ],
          ),
        ),
        
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.greenAccent, 'Income'),
              const SizedBox(width: 24),
              _buildLegendItem(Colors.redAccent, 'Expense'),
            ],
          ),
        ),
        
        // Bar Chart
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceEvenly,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final data = currentData[group.x.toInt()];
                      final value = rodIndex == 0 ? data.income : data.expense;
                      final type = rodIndex == 0 ? "Income" : "Expense";
                      return BarTooltipItem(
                        '${data.label}\n',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '$type: LKR ${value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: rodIndex == 0 ? Colors.greenAccent : Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                barGroups: _buildBarGroups(currentData),
                borderData: FlBorderData(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black.withOpacity(0.3),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.black.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  drawHorizontalLine: true,
                  horizontalInterval: maxY / 5,
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < currentData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              currentData[index].label,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 5,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'LKR ${value.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Build bar groups for the chart
  List<BarChartGroupData> _buildBarGroups(List<FinancialData> data) {
    return List.generate(data.length, (index) {
      final item = data[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.income,
            width: 16,
            gradient: const LinearGradient(
              colors: [Colors.greenAccent, Colors.green],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          BarChartRodData(
            toY: item.expense,
            width: 16,
            gradient: const LinearGradient(
              colors: [Colors.redAccent, Colors.red],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ],
      );
    });
  }

  // Build summary card
  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'LKR ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build legend item
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}

// Financial Data Model
class FinancialData {
  final String label; // Time period label (hour, day, week, month)
  double income;
  double expense;

  FinancialData({
    required this.label,
    required this.income,
    required this.expense,
  });
}