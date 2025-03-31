import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/Analize/TransactionModel.dart';

class PieChartSample2 extends StatefulWidget {
  final List<Transaction> transactions;

  const PieChartSample2({super.key, required this.transactions});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  // This method will calculate the total amounts per category
  Map<String, double> _getCategoryAmounts() {
    Map<String, double> categoryAmounts = {};
    for (var transaction in widget.transactions) {
      if (transaction.type == 'expense') {
        if (categoryAmounts.containsKey(transaction.category)) {
          categoryAmounts[transaction.category] =
              categoryAmounts[transaction.category]! + transaction.amount;
        } else {
          categoryAmounts[transaction.category] = transaction.amount;
        }
      }
    }
    return categoryAmounts;
  }

  @override
  Widget build(BuildContext context) {
    // Get category amounts to be used in the pie chart
    Map<String, double> categoryAmounts = _getCategoryAmounts();
    
    // Check if there are any expenses
    if (categoryAmounts.isEmpty) {
      return Center(
        child: Text(
          'No expense data available for this period',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    
    // Create pie sections
    List<PieChartSectionData> sections = _createSections(categoryAmounts);
    
    // Calculate total expenses
    double totalExpenses = categoryAmounts.values.fold(0, (sum, amount) => sum + amount);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Total Expenses: LKR ${totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2, // Small gap between sections
                      centerSpaceRadius: 50,
                      sections: sections,
                      startDegreeOffset: 270, // Start from the top
                    ),
                  ),
                  // Center text showing selected category or "Tap for details"
                  Center(
                    child: touchedIndex >= 0 && touchedIndex < sections.length
                        ? _buildCenterInfo(categoryAmounts, touchedIndex)
                        : Text(
                            'Tap for\ndetails',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Legend section with scrollable view
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10),
              child: _buildLegend(categoryAmounts),
            ),
          ),
        ],
      ),
    );
  }

  // Build center info widget when a section is selected
  Widget _buildCenterInfo(Map<String, double> categoryAmounts, int index) {
    String category = categoryAmounts.keys.elementAt(index);
    double amount = categoryAmounts.values.elementAt(index);
    double totalAmount = categoryAmounts.values.fold(0, (sum, amount) => sum + amount);
    double percentage = (amount / totalAmount) * 100;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getCategoryColor(category),
          ),
        ),
        Text(
          'LKR ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Create pie chart sections dynamically based on category amounts
  List<PieChartSectionData> _createSections(Map<String, double> categoryAmounts) {
    List<PieChartSectionData> sections = [];
    double totalAmount = categoryAmounts.values.fold(0, (sum, amount) => sum + amount);
    int index = 0;
    
    categoryAmounts.forEach((category, amount) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 16;
      final double radius = isTouched ? 65 : 55;
      final double percentage = (amount / totalAmount) * 100;
      Color sectionColor = _getCategoryColor(category);
      
      sections.add(
        PieChartSectionData(
          color: sectionColor,
          value: percentage,
          title: percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '', // Only show percentage for larger sections
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 4)
            ],
          ),
          badgeWidget: percentage < 5 ? null : null, // No badge for now
          badgePositionPercentageOffset: 1.1,
        ),
      );
      index++;
    });

    return sections;
  }

  // Build legend with category information
  Widget _buildLegend(Map<String, double> categoryAmounts) {
    // Sort categories by amount (descending)
    var sortedEntries = categoryAmounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: sortedEntries.map((entry) {
              String category = entry.key;
              double amount = entry.value;
              double totalAmount = categoryAmounts.values.fold(0, (sum, a) => sum + a);
              double percentage = (amount / totalAmount) * 100;
              
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Helper function to return a color based on the category
  Color _getCategoryColor(String category) {
    // Define a more visually pleasing color palette
    final Map<String, Color> colorMap = {
      'grocery': Color(0xFFFF6B8B),      // Soft pink
      'food': Color(0xFF5271FF),         // Bright blue
      'entertainment': Color(0xFFFF9E40), // Orange
      'transport': Color(0xFFB067FF),     // Purple
      'utilities': Color(0xFF4ECDC4),     // Teal
      'shopping': Color(0xFF2ECC71),      // Green
      'education': Color(0xFFF4D03F),     // Yellow
      'health': Color(0xFF1ABC9C),        // Sea green
      'subscriptions': Color(0xFFFFD166), // Amber
      'salary': Color(0xFF607D8B),        // Blue grey
      'rent': Color(0xFF8D6E63),          // Brown
    };
    
    return colorMap[category.toLowerCase()] ?? Color(0xFF95A5A6); // Default to a neutral grey
  }
}