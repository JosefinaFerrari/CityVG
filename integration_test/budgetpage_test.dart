import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/user_selection/budget_page/budget_page_widget.dart';
import 'package:city_v_g/app_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BudgetPageWidget Integration Tests', () {
    testWidgets("Verify budget names and selection behavior", (tester) async {
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
            home: BudgetPageWidget(),
          ),
        ),
      );

      // Allow the widget tree to settle
      await tester.pumpAndSettle();

      // Verify initial state (budget names are visible)
      expect(find.text('Cheap \$'), findsOneWidget);
      expect(find.text('Balanced \$\$'), findsOneWidget);
      expect(find.text('Luxury \$\$\$'), findsOneWidget);
      expect(find.text('Flexible'), findsOneWidget);

      // Interact with each budget option and verify the state
      // Tap "Cheap"
      await tester.tap(find.text('Cheap \$'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Container, 'Cheap \$'), findsOneWidget);

      // Tap "Balanced"
      await tester.tap(find.text('Balanced \$\$'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Container, 'Balanced \$\$'), findsOneWidget);

      // Tap "Luxury"
      await tester.tap(find.text('Luxury \$\$\$'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Container, 'Luxury \$\$\$'), findsOneWidget);

      // Tap "Flexible"
      await tester.tap(find.text('Flexible'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Container, 'Flexible'), findsOneWidget);
    });
  });
}
