import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';
import 'package:city_v_g/user_selection/find_page/find_page_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FindPageWidget UI Test', () {
    testWidgets('Verify "SEARCH" and "Find your city" texts', (tester) async {
      SharedPreferences.setMockInitialValues({});

      final appState = FFAppState();

  
      await appState.initializePersistedState();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState),
          ],
          child: MaterialApp(
            home: FindPageWidget(),
          ),
        ),
      );

      // Allow the widget tree to settle
      await tester.pumpAndSettle();

      // Verify the presence of "SEARCH" text
      expect(find.text('SEARCH'), findsOneWidget);

      // Verify the presence of "Find your city" text
      expect(find.text('Find\nyour city'), findsOneWidget);
    });
  });
}
