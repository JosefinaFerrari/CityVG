import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';
import 'package:city_v_g/user_selection/daypicker_page/daypicker_page_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DaypickerPageWidget UI Test', () {
    testWidgets('Verify text elements only', (tester) async {
      // Mock SharedPreferences before initializing FFAppState
      SharedPreferences.setMockInitialValues({});

      // Create an instance of FFAppState to pass to the provider
      final appState = FFAppState();

      // Wait for initialization of SharedPreferences in FFAppState
      await appState.initializePersistedState();

      // Set up the test environment
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState), // Provide FFAppState
          ],
          child: MaterialApp(
            home: DaypickerPageWidget(),
          ),
        ),
      );

      // Allow the widget tree to settle
      await tester.pumpAndSettle();

      // Verify text elements are present
      expect(find.text('When are you going?'), findsOneWidget);
      expect(find.text('Choose your return date and hours'), findsOneWidget);
    });
  });
}
