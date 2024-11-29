import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:city_v_g/top10/top10_widget.dart'; // Adjust the import path if necessary

void main() {
  testWidgets('Top10Widget displays attractions and NEXT button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Top10Widget(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify "Top 10" title exists
    expect(find.textContaining('Top 10'), findsOneWidget);

    // Verify at least 10 attraction cards are present
    expect(find.byType(Material), findsWidgets); // Adjust if a specific card widget is used
    expect(find.byType(Material).evaluate().length >= 10, isTrue);

    // Verify the "NEXT" button exists
    expect(find.text('NEXT'), findsOneWidget);

    // Tap the "NEXT" button
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

  });
}
