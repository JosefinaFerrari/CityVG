import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';
import 'package:city_v_g/user_selection/people_page/people_page_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PeoplePageWidget Integration Tests', () {
    testWidgets('Verify all UI elements and interactions', (tester) async {

      SharedPreferences.setMockInitialValues({});

      final appState = FFAppState();

      await appState.initializePersistedState();

    
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState),
          ],
          child: MaterialApp(
            home: PeoplePageWidget(),
          ),
        ),
      );

      // Allow the widget tree to settle
      await tester.pumpAndSettle();

      // Verify the presence of static text elements
      expect(find.text('Who is going?'), findsOneWidget);
      expect(find.text('Select the number of people in the trip'), findsOneWidget);
      expect(find.text('Seniors\n(65 or above)'), findsOneWidget);
      expect(find.text('Adults\n(25-64 years)'), findsOneWidget);
      expect(find.text('Youth\n(13-24 years)'), findsOneWidget);
      expect(find.text('Children\n(0-12 years)'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);

      // Verify the presence of increment and decrement buttons
      expect(find.byIcon(Icons.add_rounded), findsNWidgets(4));
      expect(find.byIcon(Icons.remove_rounded), findsNWidgets(4));

      // Verify initial state of counters (all at 0)
      expect(find.text('0'), findsNWidgets(4));

      // Interact with counters for "Seniors"
      await tester.tap(find.byIcon(Icons.add_rounded).at(0)); // Increment Seniors
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget); // Verify counter incremented

      await tester.tap(find.byIcon(Icons.remove_rounded).at(0)); // Decrement Seniors
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget); // Verify counter decremented

      // Interact with counters for "Adults"
      await tester.tap(find.byIcon(Icons.add_rounded).at(1)); // Increment Adults
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets); // Verify counter incremented (1 for Adults)

      // Interact with counters for "Youth"
      await tester.tap(find.byIcon(Icons.add_rounded).at(2)); // Increment Youth
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets); // Verify counter incremented (1 for Youth)

      // Interact with counters for "Children"
      await tester.tap(find.byIcon(Icons.add_rounded).at(3)); // Increment Children
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets); // Verify counter incremented (1 for Children)

      // Test disabling the "NEXT" button when no selection is made
      await tester.tap(find.byIcon(Icons.remove_rounded).at(1)); // Reset Adults
      await tester.tap(find.byIcon(Icons.remove_rounded).at(2)); // Reset Youth
      await tester.tap(find.byIcon(Icons.remove_rounded).at(3)); // Reset Children
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton, skipOffstage: false), findsWidgets); // Ensure button exists
      final nextButton = tester.widget<ElevatedButton>(find.text('NEXT').first);
      expect(nextButton.enabled, false); // Verify "NEXT" is disabled when no selection is made

      // Test enabling the "NEXT" button when a selection is made
      await tester.tap(find.byIcon(Icons.add_rounded).at(0)); // Increment Seniors
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets); // Verify increment

      final enabledNextButton = tester.widget<ElevatedButton>(find.text('NEXT').first);
      expect(enabledNextButton.enabled, true); // Verify "NEXT" is enabled
    });
  });
}
