import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';

void main() {
  testWidgets('BudgetDetails displays all essential UI elements correctly', (WidgetTester tester) async {
    // Build the BudgetDetails widget
    await tester.pumpWidget(MaterialApp(
      home: BudgetDetails(
        budgetName: "Test Budget",
        budgetAmount: "50000",
        budgetDate: "2023-05-01",
        budgetId: "123",
      ),
    ));

    await tester.pumpAndSettle(); // Wait for all animations to complete

    // Verify the budget name text is displayed
    expect(find.text("Budget For Test Budget"), findsOneWidget);

    // Verify the budget date text is displayed
    expect(find.text("2023-05-01"), findsOneWidget);

    // Verify the accumulated balance text is displayed
    expect(find.text("LKR 50,000"), findsOneWidget);

    // Verify the circular progress indicator for remaining percentage is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify the "Add Transaction" Floating Action Button is displayed
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify the "Recent Activity" section header is displayed
    expect(find.text("Recent Activity"), findsOneWidget);
  });

  testWidgets('Tap on the "+" button opens the add transaction dialog', (WidgetTester tester) async {
    // Build the BudgetDetails widget
    await tester.pumpWidget(MaterialApp(
      home: BudgetDetails(
        budgetName: "Test Budget",
        budgetAmount: "50000",
        budgetDate: "2023-05-01",
        budgetId: "123",
      ),
    ));

    await tester.pumpAndSettle(); // Wait for all animations to complete

    // Tap the floating action button (plus button)
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Look for Dialog instead of AlertDialog since your component uses Dialog
    expect(find.byType(Dialog), findsOneWidget);

    // Verify content of the dialog
    expect(find.text("Add Expense"), findsOneWidget);
  });
}
