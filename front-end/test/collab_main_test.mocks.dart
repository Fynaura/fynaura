import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fynaura/pages/collab-budgeting/collabMain.dart';
import 'package:fynaura/services/budget_service.dart';

// Generate mock for BudgetService
@GenerateMocks([BudgetService])
import 'collab_main_test.mocks.dart';

void main() {
  late MockBudgetService mockBudgetService;

  setUp(() {
    mockBudgetService = MockBudgetService();
  });

  testWidgets('CollabMain shows loading state correctly', (WidgetTester tester) async {
    // Setup the mock service to return a delayed Future
    when(mockBudgetService.getBudgets()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    });

    // Create a widget to test
    final widget = MaterialApp(
      home: Builder(
        builder: (context) {
          // Inject the mock service
          final collabMain = CollabMain(key: UniqueKey());
          (collabMain.createState() as CollabMainState)._budgetService = mockBudgetService;
          return collabMain;
        },
      ),
    );

    // Build the widget
    await tester.pumpWidget(widget);

    // Verify that loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow the Future to complete
    await tester.pumpAndSettle();

    // Verify that loading indicator is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // Verify that "No budgets created yet" message is shown
    expect(find.text('No budgets created yet'), findsOneWidget);
  });

  testWidgets('CollabMain displays budgets correctly', (WidgetTester tester) async {
    // Mock data
    final mockBudgets = [
      {
        'id': '1',
        'name': 'Test Budget 1',
        'amount': 1000.0,
        'date': '2025-03-20',
      },
      {
        'id': '2',
        'name': 'Test Budget 2',
        'amount': 2000.0,
        'date': '2025-04-20',
      },
    ];

    // Setup the mock service
    when(mockBudgetService.getBudgets()).thenAnswer((_) async => mockBudgets);

    // Create a widget to test
    final widget = MaterialApp(
      home: Builder(
        builder: (context) {
          // Inject the mock service
          final collabMain = CollabMain(key: UniqueKey());
          (collabMain.createState() as CollabMainState)._budgetService = mockBudgetService;
          return collabMain;
        },
      ),
    );

    // Build the widget
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Verify that budgets are displayed
    expect(find.text('Test Budget 1'), findsOneWidget);
    expect(find.text('Test Budget 2'), findsOneWidget);
    expect(find.text('LKR 1000.0'), findsOneWidget);
    expect(find.text('LKR 2000.0'), findsOneWidget);
  });

  testWidgets('CollabMain shows error message when loading fails', (WidgetTester tester) async {
    // Setup the mock service to throw an error
    when(mockBudgetService.getBudgets()).thenThrow(Exception('Test error'));

    // Create a widget to test
    final widget = MaterialApp(
      home: Builder(
        builder: (context) {
          // Inject the mock service
          final collabMain = CollabMain(key: UniqueKey());
          (collabMain.createState() as CollabMainState)._budgetService = mockBudgetService;
          return collabMain;
        },
      ),
    );

    // Build the widget
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Verify that error message is shown
    expect(find.textContaining('Failed to load budgets'), findsOneWidget);
  });

  testWidgets('Create budget button shows popup', (WidgetTester tester) async {
    // Setup the mock service
    when(mockBudgetService.getBudgets()).thenAnswer((_) async => []);

    // Create a widget to test
    final widget = MaterialApp(
      home: Builder(
        builder: (context) {
          // Inject the mock service
          final collabMain = CollabMain(key: UniqueKey());
          (collabMain.createState() as CollabMainState)._budgetService = mockBudgetService;
          return collabMain;
        },
      ),
    );

    // Build the widget
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Tap the create budget button
    await tester.tap(find.text('Create a New Budget'));
    await tester.pumpAndSettle();

    // Verify that the popup is shown
    expect(find.byType(CustomPopup), findsOneWidget);
  });

  testWidgets('Budget dismissible works correctly', (WidgetTester tester) async {
    // Mock data
    final mockBudgets = [
      {
        'id': '1',
        'name': 'Test Budget 1',
        'amount': 1000.0,
        'date': '2025-03-20',
      },
    ];

    // Setup the mock service
    when(mockBudgetService.getBudgets()).thenAnswer((_) async => mockBudgets);
    when(mockBudgetService.deleteBudget('1')).thenAnswer((_) async => true);

    // Create a widget to test
    final widget = MaterialApp(
      home: Builder(
        builder: (context) {
          // Inject the mock service
          final collabMain = CollabMain(key: UniqueKey());
          (collabMain.createState() as CollabMainState)._budgetService = mockBudgetService;
          return collabMain;
        },
      ),
    );

    // Build the widget
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Find the dismissible widget
    final dismissible = find.byType(Dismissible);
    expect(dismissible, findsOneWidget);

    // Perform a dismiss action
    await tester.drag(dismissible, const Offset(-500, 0));
    await tester.pumpAndSettle();

    // Verify that the confirmation dialog is shown
    expect(find.text('Are you sure you want to delete this budget?'), findsOneWidget);

    // Tap the delete button
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify that the delete method was called
    verify(mockBudgetService.deleteBudget('1')).called(1);
  });

  testWidgets('CollabMain navigates to BudgetDetails when budget is tapped',
          (WidgetTester tester) async {
        // Mock data
        final mockBudgets = [
          {
            'id': '1',
            'name': 'Test Budget 1',
            'amount': 1000.0,
            'date': '2025-03-20',
          },
        ];

        // Setup the mock service
        when(mockBudgetService.getBudgets()).thenAnswer((_) async => mockBudgets);

        // Create a widget to test
        final widget = MaterialApp(
          home: Builder(
            builder: (context) {
              // Inject the mock service
              final collabMain = CollabMain(key: UniqueKey());
              (collabMain.createState() as CollabMainState)._budgetService = mockBudgetService;
              return collabMain;
            },
          ),
        );

        // Build the widget
        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Find the budget card
        final budgetCard = find.text('Test Budget 1');
        expect(budgetCard, findsOneWidget);

        // Tap on the budget card
        await tester.tap(budgetCard);
        await tester.pumpAndSettle();

        // Verify that navigation to BudgetDetails occurred
        expect(find.byType(BudgetDetails), findsOneWidget);
      });

  testWidgets('CollabMain refreshes budgets when pulled down', (WidgetTester tester) async {
    // Setup the mock service
    when(mockBudgetService.getBudgets()).thenAnswer((_) async => []);

    // Create a widget to test
    final widget = MaterialApp(
      home: Builder(
        builder: (context) {
          // Inject the mock service
          final collabMain = CollabMain(key: UniqueKey());
          (collabMain.createState() as CollabMainState)._budgetService = mockBudgetService;
          return collabMain;
        },
      ),
    );

    // Build the widget
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Verify that getBudgets was called once during initialization
    verify(mockBudgetService.getBudgets()).called(1);

    // Simulate a pull to refresh
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
    await tester.pumpAndSettle();

    // Verify that getBudgets was called again
    verify(mockBudgetService.getBudgets()).called(1);
  });
}