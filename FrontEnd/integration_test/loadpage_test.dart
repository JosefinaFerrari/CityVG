import 'package:city_v_g/pages/load_page/load_page_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('LoadPageWidget UI Test', () {
    testWidgets('Verify UI elements and interaction', (tester) async {
      // Pump the LoadPageWidget
      await tester.pumpWidget(
        MaterialApp(
          home: LoadPageWidget(),
        ),
      );

      // Allow the widget tree to settle
      await tester.pumpAndSettle();

      // Verify the "Load an existing itinerary" text is displayed
      expect(find.text('Load an existing \nitinerary'), findsOneWidget);

      // Verify the "Insert trip code" label is displayed
      expect(find.text('Insert trip code'), findsOneWidget);

      // Verify the "Load" button is displayed
      expect(find.text('Load'), findsOneWidget);

      // Enter text into the input field
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'ABC123');

      // Verify that the text was entered correctly
      expect(find.text('ABC123'), findsOneWidget);

      // Tap the "Load" button
      final loadButton = find.text('Load');
      await tester.tap(loadButton);
      await tester.pumpAndSettle();

      // Verify navigation to the next page (if applicable)
      // Replace 'top5' with unique text or widget from the next page
      print('Load button tapped successfully.');
    });
  });
}
