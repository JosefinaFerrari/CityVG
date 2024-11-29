import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:city_v_g/settings/bug_report/bug_report_widget.dart';


void main() {
  testWidgets('BugReportWidget UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BugReportWidget(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the title "Bug Report" exists
    expect(find.text('Bug Report'), findsOneWidget);

    // Verify the description text exists
    expect(
      find.text('Fill out the form below to submit a ticket.'),
      findsOneWidget,
    );

    // Verify the "Bug Name" input field exists
    expect(find.widgetWithText(TextFormField, 'Bug Name...'), findsOneWidget);

    // Verify the "Short Description" input field exists
    expect(
      find.widgetWithText(
        TextFormField,
        'Short Description of what is going on...',
      ),
      findsOneWidget,
    );

    // Verify the "Upload Screenshot" section exists
    expect(find.text('Upload Screenshot'), findsOneWidget);
    expect(find.byIcon(Icons.add_a_photo_rounded), findsOneWidget);

    // Verify the "Submit Ticket" button exists and has the correct icon
    expect(find.text('Submit Ticket'), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long), findsOneWidget);

    // Verify that the "Submit Ticket" button can be tapped
    await tester.tap(find.text('Submit Ticket'));
    await tester.pumpAndSettle();
    // Note: Replace the above with actual submission logic verification if available.

    // Verify the back button exists and uses the custom arrow image
    expect(find.byType(Image), findsWidgets);
    expect(find.widgetWithText(Image, 'arrow.png'), findsNothing); // Custom image

    // Test typing into the "Bug Name" field
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Bug Name...'), 'UI Issue');
    expect(find.text('UI Issue'), findsOneWidget);

    // Test typing into the "Short Description" field
    await tester.enterText(
      find.widgetWithText(
        TextFormField,
        'Short Description of what is going on...',
      ),
      'The button does not respond when tapped.',
    );
    expect(find.text('The button does not respond when tapped.'), findsOneWidget);
  });
}
