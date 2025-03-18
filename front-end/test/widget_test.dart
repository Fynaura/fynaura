import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/main.dart';  // Import your app entry point

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Ensure the counter starts at 0.
    expect(find.text('0'), findsOneWidget);  // Verify that the initial counter is 0
    expect(find.text('1'), findsNothing);    // Ensure that the counter doesn't start at 1

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));  // Tap the '+' icon
    await tester.pump();  // Rebuild the widget after the tap

    // Verify that the counter has incremented to 1.
    expect(find.text('0'), findsNothing);  // 0 should not be visible anymore
    expect(find.text('1'), findsOneWidget);  // 1 should now be visible
  });
}
