// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:fynaura/main.dart';  // Import the main entry point of your app
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build the app and trigger a frame.
//     await tester.pumpWidget(const MyApp());
//
//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // Ensure the '+' icon is found in the widget tree.
//     expect(find.byIcon(Icons.add), findsOneWidget);
//
//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));  // Tap the '+' icon
//     await tester.pump();  // Rebuild the widget after the tap
//
//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);  // Ensure '0' is no longer visible
//     expect(find.text('1'), findsOneWidget);  // Ensure '1' is now visible
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/main.dart'; // Import the main entry point of your app

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());  // This will trigger the build of your app

    // Ensure the counter starts at 0.
    expect(find.text('0'), findsOneWidget);  // Expect the initial value to be 0
    expect(find.text('1'), findsNothing);    // Expect '1' not to be in the widget tree initially

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));  // Tap the '+' icon
    await tester.pump();  // Rebuild the widget after the tap

    // Verify that the counter has incremented to 1.
    expect(find.text('0'), findsNothing);  // '0' should not be there anymore
    expect(find.text('1'), findsOneWidget);  // '1' should now be visible
  });
}

