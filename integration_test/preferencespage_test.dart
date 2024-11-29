import 'package:city_v_g/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';
import 'package:city_v_g/user_selection/preferences_page/preferences_page_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesPageWidget UI Test', () {
    testWidgets('Verify text, preferences selection, and NEXT button behavior',
        (tester) async {
      SharedPreferences.setMockInitialValues({});

      final appState = FFAppState();

      await appState.initializePersistedState();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState), 
          ],
          child: MaterialApp(
            home: PreferencesPageWidget(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the static text elements
      expect(find.text('Preferences'), findsOneWidget);
      expect(
          find.text(
              'Select your preferences to generate a perfect trip for you  (max 5 elements)'),
          findsOneWidget);

      // Verify the presence of the preference buttons
      final preferences = FFAppConstants.listOfPreferences;
      for (final preference in preferences) {
        expect(find.text(preference), findsOneWidget);
      }

      // Verify that "NEXT" button is initially disabled
      final nextButton = find.text('NEXT');
      expect(nextButton, findsOneWidget);
      expect(
          tester.widget<ElevatedButton>(nextButton), isA<ElevatedButton>().having(
              (button) => button.onPressed, 'onPressed', isNull));

      // Select a few preferences
      await tester.tap(find.text(preferences[0]));
      await tester.pumpAndSettle();

      // Verify "NEXT" button is now enabled
      expect(
          tester.widget<ElevatedButton>(nextButton), isA<ElevatedButton>().having(
              (button) => button.onPressed, 'onPressed', isNotNull));

      // Select additional preferences until the limit
      for (var i = 1; i < 5; i++) {
        await tester.tap(find.text(preferences[i]));
        await tester.pumpAndSettle();
      }

      // Verify selecting more than 5 preferences shows the error
      await tester.tap(find.text(preferences[5]));
      await tester.pumpAndSettle();
      expect(find.text('Error Message'), findsOneWidget);
      expect(find.text('Max 5 elements'), findsOneWidget);

      // Dismiss the error dialog
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      // Deselect a preference and verify the "NEXT" button is still enabled
      await tester.tap(find.text(preferences[0]));
      await tester.pumpAndSettle();
      expect(
          tester.widget<ElevatedButton>(nextButton), isA<ElevatedButton>().having(
              (button) => button.onPressed, 'onPressed', isNotNull));
    });
  });
}
