

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/main.dart';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';

void main() {
  testWidgets('Splash screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the splash screen appears with the correct background color
    final scaffoldFinder = find.byType(Scaffold);
    expect(scaffoldFinder, findsOneWidget);

    final scaffold = tester.widget<Scaffold>(scaffoldFinder);
    expect(scaffold.backgroundColor, equals(const Color(0xFF85C1E5)));

    // Verify that the splash screen contains a centered image
    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Fast-forward time to trigger the navigation
    await tester.pump(const Duration(seconds: 5));

    // Rebuild the widget tree after navigation
    await tester.pumpAndSettle();

    // Verify that we've navigated to the signup page
    expect(find.byType(Mainsignup), findsOneWidget);
  });
}