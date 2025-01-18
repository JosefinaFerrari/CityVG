import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:city_v_g/top5/top5_widget.dart';

void main() {
  testWidgets('Top5Widget UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Top5Widget(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the title "Top 5" is displayed
    expect(find.textContaining('Top 5'), findsOneWidget);

    // Verify the "DONE" button is present
    expect(find.text('DONE'), findsOneWidget);

    // Tap the "DONE" button
    await tester.tap(find.text('DONE'));

    // Allow the widget tree to settle after the tap
    await tester.pumpAndSettle();

    
  });
}
