// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fynaura/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.


    await tester.pumpWidget(const MyApp());



    // Verify that our counter starts at 0.
https://github.com/Fynaura/fynaura/pull/13/conflict?name=front-end%252Ftest%252Fwidget_test.dart&ancestor_oid=0b62addcff7c95b368e69de33da622e351dd3655&base_oid=c601d4daffd9eb0c48aba1182ca93877a4d0a645&head_oid=dbec84f598a268ce0fa03e208d4224872f0a35ed    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
