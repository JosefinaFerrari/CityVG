import 'package:city_v_g/pages/welcome1_copy/welcome1_copy_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_v_g/app_state.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Welcome1CopyWidget UI Test', () {
    testWidgets('Verify text and images are present', (tester) async {
      SharedPreferences.setMockInitialValues({});

      final appState = FFAppState();

      await appState.initializePersistedState();

  
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => appState), 
          ],
          child: MaterialApp(
            home: Welcome1CopyWidget(),
          ),
        ),
      );

 
      await tester.pumpAndSettle();

  
      expect(find.text('Your virtual travel buddy'), findsOneWidget);

      final firstImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/Frame_3.png',
      );
      expect(firstImage, findsOneWidget);


      final secondImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/background.png',
      );
      expect(secondImage, findsOneWidget);
    });
  });
}
