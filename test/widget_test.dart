// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_clinical_app/main.dart';

void main() {
  testWidgets('Login Screen loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(); // Wait for navigation

    // Verify that the login screen text appears (using RichText finder)
    expect(find.byType(RichText), findsWidgets);

    // Verify Sign In button is present
    expect(find.text('Sign In'), findsOneWidget);
  });
}
