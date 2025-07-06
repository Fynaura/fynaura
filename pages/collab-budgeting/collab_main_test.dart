import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
import 'package:fynaura/pages/collab-budgeting/collab-main.dart';
import 'package:fynaura/services/budget_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Mock the BudgetService
class MockBudgetService extends Mock implements BudgetService {}

void main() {
  group('BudgetDetails UI Tests', () {
    testWidgets('displays budget details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BudgetDetails(
          budgetName: 'Test Budget',
          budgetAmount: '50000',
          budgetDate: '2024-03-20',
          budgetId: '12345',
        ),
      ));

      // Verify UI elements are displayed
      expect(find.text('Budget For Test Budget'), findsOneWidget);
      expect(find.text('LKR 50,000'), findsOneWidget);
      expect(find.text('Accumulated Balance'), findsOneWidget);
      expect(find.text('Recent Activity'), findsOneWidget);
    });

    testWidgets('opens add transaction dialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BudgetDetails(
          budgetName: 'Test Budget',
          budgetAmount: '50000',
          budgetDate: '2024-03-20',
          budgetId: '12345',
        ),
      ));

      // Tap the floating action button to open the add transaction dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.text('Add Expense'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });
  });

  group('CollabMain UI Tests', () {
    testWidgets('displays created budgets correctly', (WidgetTester tester) async {
      MockBudgetService mockService = MockBudgetService();

      // Mock budget data
      when(mockService.getBudgets()).thenAnswer((_) async => [
        {
          'name': 'Test Budget',
          'amount': 50000,
          'date': '2024-03-20',
          'id': '12345',
        }
      ]);

      await tester.pumpWidget(MaterialApp(
        home: CollabMain(),
      ));

      await tester.pumpAndSettle();

      // Verify the budget is displayed
      expect(find.text('Created Plans'), findsOneWidget);
      expect(find.text('Test Budget'), findsOneWidget);
      expect(find.text('LKR 50000'), findsOneWidget);
    });

    testWidgets('opens create budget popup', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CollabMain(),
      ));

      // Tap the create budget button
      await tester.tap(find.text('Create a New Budget'));
      await tester.pumpAndSettle();

      // Verify popup is displayed
      expect(find.text('Create Budget'), findsOneWidget);
    });
  });
}
