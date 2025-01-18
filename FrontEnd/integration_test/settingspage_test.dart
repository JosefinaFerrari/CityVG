import 'package:city_v_g/settings/settings/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SettingsWidget UI test', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsWidget(),
      ),
    );

    // Allow the widget to settle
    await tester.pumpAndSettle();

    // Verify the AppBar with the title "Settings" exists
    expect(find.text('Settings'), findsOneWidget);

    // Verify the "Preferences" section header is displayed
    expect(find.text('Preferences'), findsOneWidget);

    // Verify the "Language" option exists
    expect(find.text('Language'), findsOneWidget);
    expect(find.byIcon(Icons.language_sharp), findsOneWidget);

    // Verify the "Appearance" option exists
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.byIcon(Icons.mode_night_rounded), findsOneWidget);

    // Verify the "Extra Informations" section header is displayed
    expect(find.text('Extra Informations'), findsOneWidget);

    // Verify the "About us" option exists
    expect(find.text('About us'), findsOneWidget);
    expect(find.byIcon(Icons.emoji_people), findsOneWidget);

    // Verify the "Report a bug" option exists
    expect(find.text('Report a bug'), findsOneWidget);
    expect(find.byIcon(Icons.bug_report_outlined), findsOneWidget);

    // Verify the "Suggest a new feature" option exists
    expect(find.text('Suggest a new feature'), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);

  });
}
