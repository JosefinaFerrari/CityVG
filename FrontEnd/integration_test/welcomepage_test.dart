import 'package:city_v_g/pages/welcome/welcome_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('WelcomeWidget UI Test', () {
    testWidgets('Verify text, buttons, and navigation', (tester) async {
   
      SharedPreferences.setMockInitialValues({});

      final appState = FFAppState();

      await appState.initializePersistedState();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState), 
          ],
          child: MaterialApp(
            home: WelcomeWidget(),
          ),
        ),
      );


      await tester.pumpAndSettle();

      // Verify static text
      expect(find.text('Ready to explore the best a city has to offer?'),
          findsOneWidget);

      // Verify the "START PLANNING" button is present
      final startPlanningButton = find.text('START PLANNING');
      expect(startPlanningButton, findsOneWidget);

      // Verify the close button is present
      final closeButton = find.byIcon(Icons.close_sharp);
      expect(closeButton, findsOneWidget);

      // Simulate tapping "START PLANNING" and verify navigation
      await tester.tap(startPlanningButton);
      await tester.pumpAndSettle();

      // Verify navigation to the "start" page (adjust based on your routing logic)
      // For instance, check for a widget unique to the "start" page
      expect(find.text('Start Planning Page'), findsOneWidget);

      // Go back to the Welcome page
      Navigator.pop(tester.element(find.byType(MaterialApp)));
      await tester.pumpAndSettle();

      // Simulate tapping the close button and verify navigation
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Verify navigation to the "MainPage" (adjust based on your routing logic)
      expect(find.text('Main Page'), findsOneWidget);
    });
  });
}
