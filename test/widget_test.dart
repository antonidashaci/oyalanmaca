import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nobrainer/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NoBrainerApp());

    // Verify app title is present
    expect(find.text('NOBRAINER'), findsOneWidget);
  });
}
