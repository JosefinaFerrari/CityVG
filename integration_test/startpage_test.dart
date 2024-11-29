import 'package:city_v_g/pages/start/start_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('StartWidget UI Test', () {
    testWidgets('Verify text, images, and navigation behavior', (tester) async {
  
      SharedPreferences.setMockInitialValues({});

      final appState = FFAppState();

      await appState.initializePersistedState();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState), 
          ],
          child: MaterialApp(
            home: StartWidget(),
          ),
        ),
      );

      // Allow the widget tree to settle
      await tester.pumpAndSettle();

      // Verify the main question text
      expect(find.text('Are you the planner or the lucky friend?'),
          findsOneWidget);

      // Verify "Leader" text and image
      expect(find.text('Leader'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/images/Rectangle_84.png',
        ),
        findsOneWidget,
      );

      // Verify "Follower" text and image
      expect(find.text('Follower'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/images/Rectangle_86.png',
        ),
        findsOneWidget,
      );

      // Tap on "Leader" and verify navigation to FindPage
      await tester.tap(find.text('Leader'));
      await tester.pumpAndSettle();
      // Verify navigation occurred (check for a unique element from FindPage)
      expect(find.text('Find Page Content'), findsOneWidget); // Update as necessary

      // Go back to the Start page
      Navigator.pop(tester.element(find.byType(MaterialApp)));
      await tester.pumpAndSettle();

      // Tap on "Follower" and verify navigation to LoadPage
      await tester.tap(find.text('Follower'));
      await tester.pumpAndSettle();
      // Verify navigation occurred (check for a unique element from LoadPage)
      expect(find.text('Load Page Content'), findsOneWidget); // Update as necessary
    });
  });
}
