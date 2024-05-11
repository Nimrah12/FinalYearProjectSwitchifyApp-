// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

import 'package:firebasebutton/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebasebutton/main.dart';
import 'package:firebasebutton/pointer.dart';
import 'package:firebasebutton/analytics.dart';
import 'package:firebasebutton/aboutus.dart';

void main() {
  testWidgets('Navigation Drawer Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyApp()));
    // Find the menu icon in the app bar and tap it to open the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify that the drawer is open
    expect(find.text('Switch Analysis'), findsOneWidget);
    expect(find.text('Graph Analysis for Switches'), findsOneWidget);
    expect(find.text('About Us'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);

    await tester.tap(find.text('Switch Analysis'));
    await tester.pumpAndSettle();
    expect(find.byType(Pointer), findsOneWidget);

    await tester.tap(find.text('Graph Analysis for Switches'));
    await tester.pumpAndSettle();
    expect(find.byType(Analytics), findsOneWidget);

    await tester.tap(find.text('About Us'));
    await tester.pumpAndSettle();
    expect(find.byType(Aboutus), findsOneWidget);
    //Tap on "Sign Out" and verify the sign-out functionality
    //(This part of the test depends on your authentication logic)
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
