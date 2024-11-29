import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:city_v_g/summary_page/summary_page_widget.dart';

void main() {
  testWidgets('SummaryPageWidget UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SummaryPageWidget(),
      ),
    );

    // Allow the widget tree to settle
    await tester.pumpAndSettle();

    
    // Verify the title "Summary" is displayed
    expect(find.text('Summary'), findsOneWidget);

    // Verify "Destination" section exists
    expect(find.text('Destination'), findsOneWidget);

    // Verify "Days" section exists
    expect(find.text('Days'), findsOneWidget);

    // Verify "Scope" section exists
    expect(find.text('Scope'), findsOneWidget);

    // Verify "Participants" section exists
    expect(find.text('Partecipants'), findsOneWidget);

    // Verify "Selected attractions" section exists
    expect(find.text('Selected attractions'), findsOneWidget);

    // Verify "Preferences" section exists
    expect(find.text('Preferences'), findsOneWidget);

    // Verify "Budget" section exists
    expect(find.text('Budget'), findsOneWidget);

    // Verify the "CONFIRM" button is present
    expect(find.text('CONFIRM'), findsOneWidget);

    // Tap the "CONFIRM" button and allow the widget tree to settle
    await tester.tap(find.text('CONFIRM'));
    await tester.pumpAndSettle();
  });
}
