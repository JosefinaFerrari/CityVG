import 'package:city_v_g/flutter_flow/flutter_flow_google_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';
import 'package:city_v_g/user_selection/scope_page/scope_page_widget.dart';



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ScopePageWidget UI Test', () {
    testWidgets('Verify text, map, slider, and NEXT button behavior',
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
            home: ScopePageWidget(),
          ),
        ),
      );

      // Allow the widget tree to settle
      await tester.pumpAndSettle();

      // Verify static text elements
      expect(find.text(appState.dataSelected.placeSelected.city), findsOneWidget);
      expect(find.text(appState.dataSelected.placeSelected.country),
          findsOneWidget);

      // Verify Google Map is present
      final map = find.byType(FlutterFlowGoogleMap);
      expect(map, findsOneWidget);

      // Verify the slider is present and interact with it
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Check initial slider value
      Slider sliderWidget = tester.widget(slider);
      expect(sliderWidget.value, equals(200.0));

      // Simulate sliding to a new value
      await tester.drag(slider, const Offset(50.0, 0.0)); // Slide right
      await tester.pumpAndSettle();

      // Check updated slider value (it might depend on your widget's implementation)
      sliderWidget = tester.widget(slider);
      expect(sliderWidget.value, greaterThan(200.0));

      // Verify the "NEXT" button is present and enabled
      final nextButton = find.text('NEXT');
      expect(nextButton, findsOneWidget);
      expect(
          tester.widget<ElevatedButton>(nextButton), isA<ElevatedButton>().having(
              (button) => button.onPressed, 'onPressed', isNotNull));

      // Tap the "NEXT" button and verify navigation
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Check that navigation occurred (depending on how you handle navigation)
      // For example, you can check if a specific widget from the new page is present
      expect(find.text('When are you going?'), findsOneWidget); // DaypickerPage text
    });
  });
}
