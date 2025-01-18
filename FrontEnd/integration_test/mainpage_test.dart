import 'package:city_v_g/pages/main_page/main_page_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MainPageWidget Basic UI Test', () {
    testWidgets('Verify UI elements for MainPageWidget', (tester) async {

      SharedPreferences.setMockInitialValues({});

      final appState = FFAppState();
      await appState.initializePersistedState();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState),
          ],
          child: MaterialApp(
            home: MainPageWidget(),
          ),
        ),
      );


      await tester.pumpAndSettle();

      // Verify "Current itinerary" text is visible
      expect(find.text('Current itinerary'), findsOneWidget);

      // Verify navigation button is visible
      final createTripButton = find.text('CREATE OR JOIN A TRIP');
      expect(createTripButton, findsOneWidget);

      // Tap on the "CREATE OR JOIN A TRIP" button
      await tester.tap(createTripButton);
      await tester.pumpAndSettle();

      // Verify that navigation occurs to the expected screen
      expect(find.text('Are you the planner or the lucky friend?'),
          findsOneWidget);
    });
  });
}
