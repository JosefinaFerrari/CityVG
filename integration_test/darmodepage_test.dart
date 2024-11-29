import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:city_v_g/settings/dark_mode2/dark_mode2_widget.dart';


void main() {
  testWidgets('DarkMode2Widget UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DarkMode2Widget(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the title "Appearance" exists
    expect(find.text('Appearance'), findsOneWidget);

    // Verify the "Dark Mode" text exists
    expect(find.text('Dark Mode'), findsOneWidget);

    // Verify the "Enable dark theme" text exists
    expect(find.text('Enable dark theme'), findsOneWidget);

    // Verify the dark mode toggle switch exists and is ON
    final Switch darkModeSwitch =
        tester.widget<Switch>(find.byType(Switch).first);
    expect(darkModeSwitch.value, true);

    // Toggle the dark mode switch to OFF
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(darkModeSwitch.value, false);

    // Verify the "Color accents" section exists
    expect(find.text('Color accents'), findsOneWidget);

    // Verify the color circles are displayed
    expect(find.byType(Container), findsWidgets); // Includes colored containers

    // Verify the "Font Size" section exists
    expect(find.text('Font Size'), findsOneWidget);

    // Interact with the Font Size slider
    final Slider fontSizeSlider =
        tester.widget<Slider>(find.byType(Slider).at(0));
    expect(fontSizeSlider.value, 1.0); // Default value
    await tester.drag(find.byType(Slider).at(0), const Offset(50.0, 0.0));
    await tester.pumpAndSettle();
    expect(fontSizeSlider.value > 1.0, true);

    // Verify the "Font Weight" section exists
    expect(find.text('Font Weight'), findsOneWidget);

    // Interact with the Font Weight slider
    final Slider fontWeightSlider =
        tester.widget<Slider>(find.byType(Slider).at(1));
    expect(fontWeightSlider.value, 500.0); // Default value
    await tester.drag(find.byType(Slider).at(1), const Offset(-50.0, 0.0));
    await tester.pumpAndSettle();
    expect(fontWeightSlider.value < 500.0, true);

    // Verify the "Save Changes" button exists
    expect(find.text('Save Changes'), findsOneWidget);

    // Test the "Save Changes" button functionality
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    // Note: Replace the above with actual save logic verification if available.

    // Verify the back button exists and is tappable
    expect(find.byType(InkWell), findsWidgets); // Includes the back button
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    // Ensure navigation back logic works, depending on your app's behavior
  });
}
