import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import 'package:fynaura/pages/forgot-password/forgotPwFirst.dart';
import 'package:fynaura/pages/sign-up/mainSignUp.dart';
import 'package:fynaura/widgets/customInput.dart';
import 'package:mocktail/mocktail.dart'; // Using mocktail instead of mockito
import 'package:http/http.dart' as http;

// Mock classes
class MockHttpClient extends Mock implements http.Client {}
class MockResponse extends Mock implements http.Response {}

void main() {
  // Tests that don't require HTTP mocking
  group('UI Tests', () {
    testWidgets('Mainlogin displays all UI elements correctly', (WidgetTester tester) async {
      // Build the Mainlogin widget
      await tester.pumpWidget(MaterialApp(home: Mainlogin()));

      // Verify the app logo is displayed
      expect(find.byType(Image), findsOneWidget);

      // Verify welcome texts are displayed
      expect(find.text("Welcome back!"), findsOneWidget);
      expect(find.text("Enter your email and password to login"), findsOneWidget);

      // Verify input fields are present
      expect(find.byType(CustomInputField), findsAtLeastNWidgets(2));

      // Verify buttons and links
      expect(find.text("Login"), findsOneWidget);
      expect(find.text("Forgot Password?"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text("Sign up"), findsOneWidget);
    });

    testWidgets('Shows validation errors when form is submitted with empty fields', (WidgetTester tester) async {
      // Build the Mainlogin widget
      await tester.pumpWidget(MaterialApp(home: Mainlogin()));

      // Find the login button and tap it without entering any data
      final loginButton = find.text("Login");
      await tester.tap(loginButton);
      await tester.pump();

      // Verify error messages are displayed
      expect(find.text("Email is required"), findsOneWidget);
      expect(find.text("Password is required"), findsOneWidget);
    });

    testWidgets('Shows validation error for invalid email format', (WidgetTester tester) async {
      // Build the Mainlogin widget
      await tester.pumpWidget(MaterialApp(home: Mainlogin()));

      // Find input fields
      final emailField = find.byWidgetPredicate((widget) =>
      widget is CustomInputField && widget.hintText == "Enter your email");
      final passwordField = find.byWidgetPredicate((widget) =>
      widget is CustomInputField && widget.hintText == "Enter your password");

      // Enter invalid email and a password
      await tester.enterText(emailField, "invalid-email");
      await tester.enterText(passwordField, "password123");

      // Tap the login button
      await tester.tap(find.text("Login"));
      await tester.pump();

      // Verify error message for invalid email is displayed
      expect(find.text("Please enter a valid email address"), findsOneWidget);
    });

    testWidgets('Navigates to ForgotPwFirst screen when Forgot Password is tapped', (WidgetTester tester) async {
      // Build the Mainlogin widget with a MaterialApp for navigation
      await tester.pumpWidget(MaterialApp(
        home: Mainlogin(),
        routes: {
          '/forgotPassword': (context) => ForgotPwFirst(),
        },
      ));

      // Tap the Forgot Password button
      await tester.tap(find.text("Forgot Password?"));
      await tester.pumpAndSettle();

      // Verify navigation to ForgotPwFirst
      expect(find.byType(ForgotPwFirst), findsOneWidget);
    });

    testWidgets('Navigates to Mainsignup screen when Sign up is tapped', (WidgetTester tester) async {
      // Build the Mainlogin widget with a MaterialApp for navigation
      await tester.pumpWidget(MaterialApp(
        home: Mainlogin(),
      ));

      // Ensure the widget is fully rendered by setting a larger screen size
      tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpAndSettle();

      // Scroll to make sure the Sign up button is visible
      await tester.dragUntilVisible(
          find.text("Sign up"),
          find.byType(SingleChildScrollView),
          Offset(0, -500) // Scroll up
      );
      await tester.pumpAndSettle();

      // Now tap the Sign up button
      await tester.tap(find.text("Sign up"));
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify navigation to Mainsignup by checking for specific elements
      // Since we might have issues with the direct widget type check,
      // check for elements unique to the Mainsignup screen
      expect(find.text("Register"), findsOneWidget); // Assuming this text is on the signup screen
      // Or another unique element on the Mainsignup screen
    });
    testWidgets('Back button returns to previous screen', (WidgetTester tester) async {
      // Create a key to identify the previous screen
      final Key previousScreenKey = Key('previousScreen');

      // Build a widget tree with a previous screen and the login screen
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: previousScreenKey,
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Mainlogin()),
                ),
                child: Text('Go to Login'),
              ),
            ),
          ),
        ),
      );

      // Navigate to login screen
      await tester.tap(find.text('Go to Login'));
      await tester.pumpAndSettle();

      // Verify we're on the login screen
      expect(find.byType(Mainlogin), findsOneWidget);

      // Tap the back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we returned to the previous screen
      expect(find.byKey(previousScreenKey), findsOneWidget);
      expect(find.byType(Mainlogin), findsNothing);
    });
  });
}