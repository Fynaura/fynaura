import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/pages/collab-budgeting/collab-main.dart';
import 'package:fynaura/widgets/CustomPopup.dart'; // Assuming this is where the popup is defined

void main() {
  testWidgets('CollabMain page displays basic UI elements correctly', (WidgetTester tester) async {
    // Build the CollabMain widget
    await tester.pumpWidget(MaterialApp(home: CollabMain()));

    // Verify if the "Budget Plan" header is displayed
    expect(find.text("Budget Plan"), findsOneWidget);

    // Verify if the "Create a New Budget" button is displayed
    expect(find.text("Create a New Budget"), findsOneWidget);

    // Verify if the "Pinned Plans" section is displayed (even if no plans are pinned)
    expect(find.text("Pinned Plans"), findsOneWidget);

    // Verify if the "Created Plans" section is displayed (even if no plans are created yet)
    expect(find.text("Created Plans"), findsOneWidget);
  });

  testWidgets('Tap on "Create a New Budget" button shows popup', (WidgetTester tester) async {
    // Build the CollabMain widget
    await tester.pumpWidget(MaterialApp(home: CollabMain()));

    // Tap the "Create a New Budget" button
    await tester.tap(find.text("Create a New Budget"));
    await tester.pumpAndSettle(); // Wait for the popup to appear

    // Verify if the popup is displayed
    expect(find.byType(CustomPopup), findsOneWidget);
  });
}
