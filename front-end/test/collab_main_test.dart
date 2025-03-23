import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fynaura/pages/collab-budgeting/budgetDetails.dart';
import 'package:fynaura/pages/collab-budgeting/collab-main.dart';
import 'package:fynaura/services/budget_service.dart';

// Mock BudgetService
class MockBudgetService extends Mock implements BudgetService {}

void main() {
  late MockBudgetService mockService;

  setUp(() {
    mockService = MockBudgetService();
  });

  testWidgets('BudgetDetails UI Tests - displays budget details correctly', (WidgetTester tester) async {
    when(mockService.getTransactions(any<String>())).thenAnswer((_) async => [
      {
        "addedBy": "Test User",
        "description": "Test transaction",
        "amount": 1000,
        "isExpense": true,
      }
    ]);

    await tester.pumpWidget(MaterialApp(
      home: BudgetDetails(
        budgetName: 'Test Budget',
        budgetAmount: '50000',
        budgetDate: '2024-03-20',
        budgetId: '12345',
      ),
    ));

    expect(find.text('Budget For Test Budget'), findsOneWidget);
    expect(find.text('LKR 50,000'), findsOneWidget);
  });

  testWidgets('BudgetDetails UI Tests - opens add transaction dialog', (WidgetTester tester) async {
    when(mockService.getTransactions(any<String>())).thenAnswer((_) async => [
      {
        "addedBy": "Test User",
        "description": "Test transaction",
        "amount": 1000,
        "isExpense": true,
      }
    ]);

    await tester.pumpWidget(MaterialApp(
      home: BudgetDetails(
        budgetName: 'Test Budget',
        budgetAmount: '50000',
        budgetDate: '2024-03-20',
        budgetId: '12345',
      ),
    ));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add Expense'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
  });

  testWidgets('CollabMain UI Tests - displays created budgets correctly', (WidgetTester tester) async {
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

    expect(find.text('Created Plans'), findsOneWidget);
    expect(find.text('Test Budget'), findsOneWidget);
    expect(find.text('LKR 50000'), findsOneWidget);
  });

  testWidgets('CollabMain UI Tests - opens create budget popup', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CollabMain(),
    ));

    await tester.tap(find.text('Create a New Budget'));
    await tester.pumpAndSettle();

    expect(find.text('Create Budget'), findsOneWidget);
  });
}
