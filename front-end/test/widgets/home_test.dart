import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/pages/home/home.dart';


void main() {
  testWidgets('DashboardScreen displays title and refreshes on pull', (WidgetTester tester) async {
    // Arrange
    const displayName = 'John Doe';
    const email = 'john.doe@example.com';

    // Build the DashboardScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          displayName: displayName,
          email: email,
        ),
      ),
    );

    // Act
    // Verify that the title 'Welcome John Doe!' is displayed
    expect(find.text('Welcome John Doe!'), findsOneWidget);

    // Swipe down to trigger refresh
    await tester.fling(find.byType(RefreshIndicator), Offset(0, 200), 1000);
    await tester.pumpAndSettle();

    // Assert
    // Verify that the RefreshIndicator is still present after the pull
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });
}
