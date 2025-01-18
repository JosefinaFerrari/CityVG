import 'package:city_v_g/pages/main_page_copy/main_page_copy_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MainPageCopyWidget UI Test', () {
    testWidgets('Verify UI elements and interactions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MainPageCopyWidget(),
        ),
      );


      await tester.pumpAndSettle();

      expect(find.text('Current itinerary'), findsOneWidget);

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == 'assets/images/empty.png',
        ),
        findsOneWidget,
      );

      // Verify "You have no active itineraries" text is displayed
      expect(
        find.text('You have no active \nitineraries at the moment'),
        findsOneWidget,
      );

      // Verify "CREATE OR JOIN A TRIP" button is present and clickable
      final createTripButton = find.text('CREATE OR JOIN A TRIP ');
      expect(createTripButton, findsOneWidget);

      // Simulate a tap on the button
      await tester.tap(createTripButton);
      await tester.pumpAndSettle();

      // Verify that navigation or further actions can happen (this is a placeholder)
      // Replace with appropriate checks based on navigation or button functionality
      print('CREATE OR JOIN A TRIP button tapped successfully.');
    });
  });
}
