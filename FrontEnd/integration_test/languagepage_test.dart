import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:city_v_g/settings/languages/languages_widget.dart'; 

void main() {
  testWidgets('LanguagesWidget UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LanguagesWidget(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the "Languages" title is displayed
    expect(find.text('Languages'), findsOneWidget);

    // Verify the "Select your preferred language" text is displayed
    expect(find.text('Select your preferred language'), findsOneWidget);

    // Verify language options are displayed
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Português'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);
    expect(find.text('Français'), findsOneWidget);
    expect(find.text('Svenska'), findsOneWidget);
    expect(find.text('Crnogorski'), findsOneWidget);
    expect(find.text('Italiano'), findsOneWidget);
    expect(find.text('Shqip'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);

    // Verify the "Save Changes" button exists
    expect(find.text('Save Changes'), findsOneWidget);
  });
}
